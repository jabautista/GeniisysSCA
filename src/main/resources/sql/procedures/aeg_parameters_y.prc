DROP PROCEDURE CPI.AEG_PARAMETERS_Y;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_y (
   aeg_tran_id                   giac_acctrans.tran_id%TYPE,
   aeg_module_nm                 giac_modules.module_name%TYPE,
   p_item_no               OUT   NUMBER,
   p_msg_alert             OUT   VARCHAR2,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
)
IS
   CURSOR pr_cur
   IS
/*
     SELECT c.b140_iss_cd iss_cd      , c.collection_amt,
           c.b140_prem_seq_no bill_no, a.line_cd       ,
      d.assd_no                 , a.type_cd
      FROM gipi_polbasic a,
           gipi_invoice  b,
           giac_direct_prem_collns c,
           gipi_parlist d --added by jeannette 09072000
     WHERE a.policy_id    = b.policy_id
       AND b.iss_cd       = c.b140_iss_cd
       AND b.prem_seq_no  = c.b140_prem_seq_no
       AND a.par_id       = d.par_id
       AND c.gacc_tran_id = aeg_tran_id;
*/
      SELECT   c.b140_iss_cd iss_cd, SUM (c.collection_amt) collection_amt,
               c.b140_prem_seq_no bill_no, a.line_cd, d.assd_no, a.type_cd
          FROM gipi_polbasic a,
               gipi_invoice b,
               giac_direct_prem_collns c,
               gipi_parlist d                    --added by jeannette 09072000
         WHERE a.policy_id = b.policy_id
           AND b.iss_cd = c.b140_iss_cd
           AND b.prem_seq_no = c.b140_prem_seq_no
           AND a.par_id = d.par_id
           AND c.gacc_tran_id = aeg_tran_id
      GROUP BY c.b140_iss_cd,
               c.b140_prem_seq_no,
               a.line_cd,
               d.assd_no,
               a.type_cd;

   CURSOR evat_cur (
      p_iss_cd    gipi_invoice.iss_cd%TYPE,
      p_bill_no   gipi_invoice.prem_seq_no%TYPE
   )
   IS
/*
    SELECT d.tax_amt   tax_amt
      FROM gipi_inv_tax d
       where d.iss_cd = p_iss_cd
       and d.prem_seq_no = p_bill_no
       AND d.tax_cd = variables.evat;
*/

      /*
    SELECT tax_amt
      FROM giac_tax_collns
     WHERE b160_iss_cd = p_iss_cd
       AND b160_prem_seq_no = p_bill_no
       AND gacc_tran_id = aeg_tran_id
       AND b160_tax_cd = variables.evat;
*/
      SELECT   SUM (tax_amt) tax_amt, b160_iss_cd, b160_prem_seq_no
          FROM giac_tax_collns
         WHERE b160_iss_cd = p_iss_cd
           AND b160_prem_seq_no = p_bill_no
           AND gacc_tran_id = aeg_tran_id
           AND b160_tax_cd = giacp.n ('EVAT')
      GROUP BY b160_iss_cd, b160_prem_seq_no
        HAVING NVL (SUM (tax_amt), 0) <> 0;
            --Vincent 03062006: added so as not to generate 0 amt acct entries

   v_module_id   giac_modules.module_id%TYPE;
   v_gen_type    giac_modules.generation_type%TYPE;
BEGIN
   BEGIN
      SELECT module_id, generation_type
        INTO v_module_id, v_gen_type
        FROM giac_modules
       WHERE module_name = aeg_module_nm;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert := ('No data found in GIAC MODULES.');
   END;

   giac_acct_entries_pkg.aeg_delete_acct_entries_y (aeg_tran_id,
                                                    aeg_module_nm,
                                                    v_module_id,
                                                    v_gen_type
                                                    /* Commented out by MJ 12/28/2012. P_MSG_ALERT is not an argument in GIAC_ACCT_ENTRIES.AEG_DELETE_ACCT_ENTRIES_Y
                                                    , p_msg_alert
                                                    */
                                                   );

   --
   --
   FOR pr_rec IN pr_cur
   LOOP
      /*
      ** Call the accounting entry generation procedure.
      */
      --
      --
      aeg_create_acct_entries_y (pr_rec.assd_no,
                                 v_module_id,
                                 p_item_no,
                                 pr_rec.iss_cd,
                                 pr_rec.bill_no,
                                 pr_rec.line_cd,
                                 pr_rec.type_cd,
                                 pr_rec.collection_amt,
                                 v_gen_type,
                                 p_msg_alert,
                                 p_giop_gacc_branch_cd,
                                 p_giop_gacc_fund_cd,
                                 aeg_tran_id
                                );

      FOR evat_rec IN evat_cur (pr_rec.iss_cd, pr_rec.bill_no)
      LOOP
         IF NVL (giacp.v ('OUTPUT_VAT_COLLN_ENTRY'), 'N') = 'Y'
         THEN
            /* from giac_taxes
            AEG_Create_Acct_Entries_tax_N(VARIABLES.evat, EVAT_rec.tax_amt,
                                         VARIABLES.gen_type);
            */

            /* item_no 7 - deferred output vat*/
            aeg_create_acct_entries_y (NULL,
                                       v_module_id,
                                       7,
                                       pr_rec.iss_cd,
                                       pr_rec.bill_no,
                                       pr_rec.line_cd,
                                       pr_rec.type_cd,
                                       evat_rec.tax_amt,
                                       v_gen_type,
                                       p_msg_alert,
                                       p_giop_gacc_branch_cd,
                                       p_giop_gacc_fund_cd,
                                       aeg_tran_id
                                      );
            /* item_no 6 - output vat payable*/
            aeg_create_acct_entries_y (NULL,
                                       v_module_id,
                                       6,
                                       pr_rec.iss_cd,
                                       pr_rec.bill_no,
                                       pr_rec.line_cd,
                                       pr_rec.type_cd,
                                       evat_rec.tax_amt,
                                       v_gen_type,
                                       p_msg_alert,
                                       p_giop_gacc_branch_cd,
                                       p_giop_gacc_fund_cd,
                                       aeg_tran_id
                                      );
         END IF;
      END LOOP;
   END LOOP;
END;
/



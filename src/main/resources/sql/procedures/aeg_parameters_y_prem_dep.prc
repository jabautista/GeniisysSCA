DROP PROCEDURE CPI.AEG_PARAMETERS_Y_PREM_DEP;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_y_prem_dep (
   aeg_tran_id                   giac_acctrans.tran_id%TYPE,
   aeg_module_nm                 giac_modules.module_name%TYPE,
   p_item_no               OUT   INTEGER,
   p_msg_alert             OUT   VARCHAR2,
   p_giop_gacc_branch_cd         giac_acct_entries.gacc_gibr_branch_cd%TYPE,
   p_giop_gacc_fund_cd           giac_acct_entries.gacc_gfun_fund_cd%TYPE
)
IS
   CURSOR pr_cur
   IS
      SELECT c.b140_iss_cd iss_cd, c.collection_amt,
             c.b140_prem_seq_no bill_no, a.line_cd, d.assd_no, a.type_cd,
             c.inst_no
        FROM gipi_polbasic a,
             gipi_invoice b,
             giac_direct_prem_collns c,
             gipi_parlist d
       WHERE a.policy_id = b.policy_id
         AND b.iss_cd = c.b140_iss_cd
         AND b.prem_seq_no = c.b140_prem_seq_no
         AND a.par_id = d.par_id
         AND c.gacc_tran_id = aeg_tran_id
         AND EXISTS (
                SELECT '1'
                  FROM giac_advanced_payt
                 WHERE iss_cd = c.b140_iss_cd
                   AND prem_seq_no = c.b140_prem_seq_no
                   AND inst_no = c.inst_no
                   AND gacc_tran_id = aeg_tran_id);

   CURSOR pd_cur (
      p_iss_cd    gipi_invoice.iss_cd%TYPE,
      p_bill_no   gipi_invoice.prem_seq_no%TYPE,
      p_inst_no   giac_direct_prem_collns.inst_no%TYPE
   )
   IS
      SELECT   SUM (a.tax_amt) tax_amt, a.b160_iss_cd iss_cd,
               a.b160_prem_seq_no bill_no
          FROM giac_tax_collns a, giac_direct_prem_collns b
         WHERE a.b160_prem_seq_no = b.b140_prem_seq_no
           AND a.inst_no = b.inst_no
           AND a.b160_iss_cd = p_iss_cd
           AND a.b160_prem_seq_no = p_bill_no
           AND a.gacc_tran_id = aeg_tran_id
           AND a.b160_tax_cd = giacp.n ('EVAT')
           AND a.inst_no = p_inst_no
           AND EXISTS (
                  SELECT '1'
                    FROM giac_advanced_payt
                   WHERE iss_cd = b.b140_iss_cd
                     AND prem_seq_no = b.b140_prem_seq_no
                     AND inst_no = b.inst_no
                     AND gacc_tran_id = b.gacc_tran_id)
      GROUP BY a.b160_iss_cd, a.b160_prem_seq_no
        HAVING NVL (SUM (a.tax_amt), 0) <> 0;

   v_module_id   giac_modules.module_id%TYPE;
   v_gen_type    giac_modules.generation_type%TYPE;
BEGIN
   --
   --
   FOR pr_rec IN pr_cur
   LOOP
      /*
      ** Call the accounting entry generation procedure.
      */
      --
      --
      BEGIN
         SELECT module_id, generation_type
           INTO v_module_id, v_gen_type
           FROM giac_modules
          WHERE module_name = aeg_module_nm;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert := 'No data found in GIAC MODULES.';
      END;

      p_item_no := 5;
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

      FOR vat_rec IN pd_cur (pr_rec.iss_cd, pr_rec.bill_no, pr_rec.inst_no)
      LOOP
         IF NVL (giacp.v ('EVAT_ENTRY_ON_PREM_COLLN'), 'A') = 'B'
         THEN
            -- item_no 8 - vat premium deposits
            aeg_create_acct_entries_y (NULL,
                                       v_module_id,
                                       8,
                                       pr_rec.iss_cd,
                                       pr_rec.bill_no,
                                       pr_rec.line_cd,
                                       pr_rec.type_cd,
                                       vat_rec.tax_amt,
                                       v_gen_type,
                                       p_msg_alert,
                                       p_giop_gacc_branch_cd,
                                       p_giop_gacc_fund_cd,
                                       aeg_tran_id
                                      );
            -- item_no 9 - vat payable
            aeg_create_acct_entries_y (NULL,
                                       v_module_id,
                                       9,
                                       pr_rec.iss_cd,
                                       pr_rec.bill_no,
                                       pr_rec.line_cd,
                                       pr_rec.type_cd,
                                       vat_rec.tax_amt,
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



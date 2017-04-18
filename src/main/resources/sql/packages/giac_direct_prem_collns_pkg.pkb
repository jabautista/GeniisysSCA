CREATE OR REPLACE PACKAGE BODY CPI.giac_direct_prem_collns_pkg
AS
   FUNCTION get_direct_prem_inv_listing (
      p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE
   )
      RETURN giac_direct_prem_collns_tab PIPELINED
   IS
      v_inv         giac_direct_prem_collns_type;
      v_intm_no     giis_intermediary.intm_no%TYPE;
      v_intm_name   giis_intermediary.intm_name%TYPE;

      CURSOR A
      IS
         SELECT   A.iss_cd, A.prem_seq_no, A.inst_no,
                  A.balance_amt_due collection_amt,
                  A.prem_balance_due premium_amt, A.tax_balance_due tax_amt,
                  A.balance_amt_due collection_amt1,
                  A.prem_balance_due premium_amt1,
                  A.tax_balance_due tax_amt1, b.ref_inv_no, c.policy_id,
                  c.line_cd pol_line_cd, c.subline_cd pol_subline_cd,
                  c.iss_cd pol_iss_cd, c.issue_yy pol_issue_yy,
                  c.pol_seq_no pol_seq_no, c.renew_no pol_renew_no,
                  DECODE (c.endt_seq_no, 0, NULL, c.endt_iss_cd) endt_iss_cd,
                  DECODE (c.endt_seq_no, 0, NULL, c.endt_yy) endt_yy,
                  DECODE (c.endt_seq_no, 0, NULL, c.endt_seq_no) endt_seq_no,
                  DECODE (c.endt_seq_no, 0, NULL, c.endt_type) endt_type,
                  c.ref_pol_no, c.assd_no, d.assd_name, b.currency_rt,
                  get_policy_no (c.policy_id) policy_no,
                                                  --added by alfie 12.15.2010
                  b.currency_cd
             FROM gipi_parlist E,
                  giis_assured d,
                  gipi_polbasic c,
                  gipi_invoice b,
                  giac_aging_soa_details A
            WHERE 1 = 1
              AND NOT EXISTS (
                     SELECT 'X'
                       FROM giac_cancelled_policies_v
                      WHERE line_cd = c.line_cd
                        AND subline_cd = c.subline_cd
                        AND iss_cd = c.iss_cd
                        AND issue_yy = c.issue_yy
                        AND pol_seq_no = c.pol_seq_no
                        AND renew_no = c.renew_no)
              AND E.assd_no = d.assd_no
              AND c.par_id = E.par_id
              AND A.policy_id = c.policy_id
              AND A.prem_seq_no = b.prem_seq_no
              AND A.iss_cd = b.iss_cd
              AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
              --AND a.prem_seq_no = NVL(p_prem_seq_no, a.prem_seq_no)
              AND A.prem_seq_no =
                     DECODE
                           (p_prem_seq_no,
                            0, A.prem_seq_no,
                            p_prem_seq_no
                           )              --NVL (p_prem_seq_no, a.prem_seq_no)
              AND (   (balance_amt_due > 0 AND p_transaction_type = 1)
                   OR (balance_amt_due < 0 AND p_transaction_type = 3)
                  )
         ORDER BY A.iss_cd, A.prem_seq_no, A.inst_no;

      CURSOR b
      IS
         SELECT DISTINCT 
               f.tran_id, 
               a.b140_iss_cd iss_cd, 
                    a.b140_prem_seq_no prem_seq_no, 
                a.inst_no, 
                SUM(a.collection_amt) collection_amt, 
                SUM(a.premium_amt) premium_amt, 
                SUM(a.tax_amt) tax_amt, 
                    (-1)*SUM(a.collection_amt) collection_amt1, 
                    (-1)*SUM(a.premium_amt) premium_amt1, 
                    (-1)*SUM(a.tax_amt) tax_amt1,       
                    b.ref_inv_no, 
                    get_ref_no(f.tran_id) payt_ref_no, --jason 02/26/2009
                    c.policy_id, 
                    c.ref_pol_no, 
                    c.line_cd pol_line_cd,
                    c.subline_cd pol_subline_cd,
                    c.iss_cd pol_iss_cd,
                    c.issue_yy pol_issue_yy,
                    c.pol_seq_no pol_seq_no, 
                    c.renew_no pol_renew_no,
                    decode(c.endt_seq_no,0,NULL,c.endt_iss_cd) endt_iss_cd,
                    decode(c.endt_seq_no,0,NULL,c.endt_yy) endt_yy,
                    decode(c.endt_seq_no,0,NULL,c.endt_seq_no) endt_seq_no,
                    decode(c.endt_seq_no,0,NULL,c.endt_type) endt_type,
                    d.assd_no, 
                    d.assd_name,
                 a.or_print_tag,
                 b.currency_cd,
                 b.currency_rt
               --     h.intm_no,  --commented by jason 08042009
               --     h.intm_name  --commented by jason 08042009
              FROM giis_intermediary h,
                   gipi_comm_invoice g,
                   giac_acctrans f,
                   gipi_parlist e,                    
                   giis_assured d, 
                    gipi_polbasic c,                                    
                    gipi_invoice b,
                    giac_direct_prem_collns a                    
            WHERE 1=1
             --Vincent 05102006: added this condition to exclude flat cancelled policies
             AND NOT EXISTS (SELECT 'X' 
                                             FROM giac_cancelled_policies_v
                        WHERE line_cd = c.line_cd
                          AND subline_cd = c.subline_cd
                          AND iss_cd = c.iss_cd
                          AND issue_yy = c.issue_yy
                          AND pol_seq_no = c.pol_seq_no
                          AND renew_no = c.renew_no)          
             --vfm--
             AND h.intm_no = g.intrmdry_intm_no 
                AND g.iss_cd = b.iss_cd
               AND g.prem_seq_no = b.prem_seq_no          
               AND e.assd_no = d.assd_no 
               AND c.par_id = e.par_id 
               AND b.policy_id = c.policy_id 
               AND a.gacc_tran_id = f.tran_id
                AND a.b140_iss_cd = b.iss_cd
               AND a.b140_prem_seq_no = b.prem_seq_no
               AND NOT EXISTS(SELECT 'x' 
                               FROM giac_reversals g,
                                          giac_acctrans h 
                                            WHERE g.reversing_tran_id = h.tran_id 
                                                  AND g.gacc_tran_id = a.gacc_tran_id 
                                                  AND h.tran_flag <> 'D') 
               AND f.tran_flag <> 'D'
            AND a.b140_iss_cd LIKE nvl(p_iss_cd, a.b140_iss_cd) 
            AND a.b140_prem_seq_no =
                     DECODE
                           (p_prem_seq_no,
                            0, a.b140_prem_seq_no,
                            p_prem_seq_no
                           )  
            --AND a.b140_prem_seq_no = nvl(p_prem_seq_no, a.b140_prem_seq_no)
       --AND a.inst_no = nvl(variables.v_inst_no, a.inst_no)                        
            GROUP BY f.tran_id, 
             a.b140_iss_cd, 
                    a.b140_prem_seq_no, 
                      a.inst_no,
                  b.ref_inv_no, 
                  get_ref_no(f.tran_id),
                    c.policy_id, 
                    c.ref_pol_no, 
                    c.line_cd,
                    c.subline_cd,
                    c.iss_cd,
                    c.issue_yy,
                    c.pol_seq_no, 
                    c.renew_no,
                    c.endt_iss_cd,
                    c.endt_yy,
                    c.endt_seq_no,
                     c.endt_type,
                    d.assd_no, 
                    d.assd_name,
                 a.or_print_tag,
                 b.currency_cd,
                 b.currency_rt
        HAVING ((SUM(a.collection_amt) > 0 AND p_transaction_type = 2) OR
                (SUM(a.collection_amt) < 0 AND p_transaction_type = 4))
        ORDER BY A.b140_iss_cd, A.b140_prem_seq_no, A.inst_no;
   BEGIN
      DBMS_OUTPUT.put_line ('tranType: ' || p_transaction_type);

      IF p_transaction_type IN (1, 3)
      THEN
         FOR a_rec IN A
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = a_rec.iss_cd
                                AND b.prem_seq_no = a_rec.prem_seq_no)
            LOOP
               DBMS_OUTPUT.put_line (   'isscd and premseqno: '
                                     || a_rec.iss_cd
                                     || ' '
                                     || a_rec.prem_seq_no
                                    );

               IF intm_rec.num = 1
               THEN
                  DBMS_OUTPUT.put_line ('IN');
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  DBMS_OUTPUT.put_line ('OUT');
                  v_intm_no := intm_rec.intm_no;
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.b140_iss_cd := a_rec.iss_cd;
            v_inv.b140_prem_seq_no := a_rec.prem_seq_no;
            v_inv.inst_no := a_rec.inst_no;
            v_inv.ref_inv_no := a_rec.ref_inv_no;
            v_inv.policy_id := a_rec.policy_id;
            v_inv.line_cd := a_rec.pol_line_cd;
            v_inv.subline_cd := a_rec.pol_subline_cd;
            v_inv.pol_iss_cd := a_rec.pol_iss_cd;
            v_inv.issue_yy := a_rec.pol_issue_yy;
            v_inv.pol_seq_no := a_rec.pol_seq_no;
            v_inv.pol_renew_no := a_rec.pol_renew_no;
            v_inv.endt_iss_cd := a_rec.endt_iss_cd;
            v_inv.endt_yy := a_rec.endt_yy;
            --v_inv.endt_seq_no := a_rec.endt_seq_no;
            --v_inv.endt_type := a_rec.endt_type;
            v_inv.ref_pol_no := a_rec.ref_pol_no;
            v_inv.assd_no := a_rec.assd_no;
            v_inv.assd_name := a_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := a_rec.collection_amt;
            v_inv.premium_amt := a_rec.premium_amt;
            v_inv.tax_amt := a_rec.tax_amt;
            v_inv.collection_amt1 := a_rec.collection_amt1;
            v_inv.premium_amt1 := a_rec.premium_amt1;
            v_inv.tax_amt1 := a_rec.tax_amt1;
            v_inv.currency_rt := a_rec.currency_rt;
            v_inv.policy_no := a_rec.policy_no;
            v_inv.currency_cd := a_rec.currency_cd;
            PIPE ROW (v_inv);
         END LOOP;

         RETURN;
      ELSIF p_transaction_type IN (2, 4)
      THEN
         FOR b_rec IN b
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = b_rec.iss_cd
                                AND b.prem_seq_no = b_rec.prem_seq_no)
            LOOP
               IF intm_rec.num = 1
               THEN
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_no := v_intm_no || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.tran_id := b_rec.tran_id;
            v_inv.b140_iss_cd := b_rec.iss_cd;
            v_inv.b140_prem_seq_no := b_rec.prem_seq_no;
            v_inv.inst_no := b_rec.inst_no;
            v_inv.ref_inv_no := b_rec.ref_inv_no;
            v_inv.payt_ref_no := b_rec.payt_ref_no;
            v_inv.policy_id := b_rec.policy_id; 
            v_inv.line_cd := b_rec.pol_line_cd;
            v_inv.subline_cd := b_rec.pol_subline_cd;
            v_inv.pol_iss_cd := b_rec.pol_iss_cd;
            v_inv.issue_yy := b_rec.pol_issue_yy;
            v_inv.pol_seq_no := b_rec.pol_seq_no;
            v_inv.pol_renew_no := b_rec.pol_renew_no;
            v_inv.endt_iss_cd := b_rec.endt_iss_cd;
            v_inv.endt_yy := b_rec.endt_yy;
            v_inv.endt_seq_no := b_rec.endt_seq_no;
            --v_inv.endt_type := b_rec.endt_type;
            v_inv.ref_pol_no := b_rec.ref_pol_no;
            v_inv.assd_no := b_rec.assd_no;
            v_inv.assd_name := b_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := b_rec.collection_amt;
            v_inv.premium_amt := b_rec.premium_amt;
            v_inv.tax_amt := b_rec.tax_amt;
            v_inv.collection_amt1 := b_rec.collection_amt1;
            v_inv.premium_amt1 := b_rec.premium_amt1;
            v_inv.tax_amt1 := b_rec.tax_amt1;
            v_inv.currency_rt := b_rec.currency_rt;
            v_inv.policy_no := get_policy_no(b_rec.policy_id);
            v_inv.currency_cd := b_rec.currency_cd;
            v_inv.or_print_tag := b_rec.or_print_tag;
            PIPE ROW (v_inv);
         END LOOP;

         RETURN;
      END IF;
   END get_direct_prem_inv_listing;

   PROCEDURE save_acct_dtls (
      p_gacc_tran_id              giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type          giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no          giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                   giac_direct_prem_collns.inst_no%TYPE,
      p_fund_cd                   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_param_premium_amt         giac_direct_prem_collns.premium_amt%TYPE,
      p_collection_amt            giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt         OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt             OUT   giac_direct_prem_collns.tax_amt%TYPE,
      p_sum_tax_amt               giac_direct_prem_collns.tax_amt%TYPE,
      p_msg_alert           OUT   VARCHAR2
   )
   IS
      v_check_flag            VARCHAR2 (5);
      v_record_no             NUMBER;
      v_exists                VARCHAR2 (1);
      v_tax_alloc             VARCHAR2 (1);
      v_total_tax             NUMBER;
      v_last_rec              NUMBER;
      ctr                     NUMBER                                     := 0;
      isvalid                 BOOLEAN                                 := TRUE;
      v_giac_tax_collns_cur   giac_tax_collns_pkg.rc_giac_tax_collns_cur;
      v_prem_vat_exempt       giac_direct_prem_collns.prem_vat_exempt%TYPE := 0;
   BEGIN
      BEGIN
         SELECT SUM (tax_amt)
           INTO v_total_tax
           FROM giac_tax_collns
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_total_tax := 0;
      END;

      IF NVL (v_total_tax, 0) = 0 AND NVL (p_sum_tax_amt, 0) <> 0
      THEN
         IF p_transaction_type = 1
         THEN
            tax_default_value_type1
                           (p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         ELSIF p_transaction_type = 2
         THEN
            tax_default_value_type2
                           (p_gacc_tran_id,
                            p_gacc_tran_id, --temporary lang to
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         ELSIF p_transaction_type = 3
         THEN
            tax_default_value_type3
                           (p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         ELSIF p_transaction_type = 4
         THEN
            tax_default_value_type4
                           (p_gacc_tran_id,
                            p_gacc_tran_id, --temporary lang to
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         END IF;
      END IF;

      IF p_sum_tax_amt <> p_tax_amt
      THEN
         p_msg_alert :=
                   'Tax amount is not equal with total tax amount breakdown.';
         isvalid := FALSE;
      END IF;

      IF (p_tax_amt + p_premium_amt) <> p_collection_amt
      THEN
         p_msg_alert :=
            'Total premium amount plus total tax amount is not equal with the total collection amount.';
         isvalid := FALSE;
      END IF;
   END;

   PROCEDURE save_direct_prem_collns_dtls (
      p_gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_direct_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt            giac_direct_prem_collns.tax_amt%TYPE,
      p_or_print_tag       giac_direct_prem_collns.or_print_tag%TYPE,
      p_particulars        giac_direct_prem_collns.particulars%TYPE,
      p_currency_cd        giac_direct_prem_collns.currency_cd%TYPE,
      p_convert_rate       giac_direct_prem_collns.convert_rate%TYPE,
      p_foreign_curr_amt   giac_direct_prem_collns.foreign_curr_amt%TYPE,
      p_prem_vatable       giac_direct_prem_collns.prem_vatable%TYPE,
      p_prem_vat_exempt    giac_direct_prem_collns.prem_vat_exempt%TYPE,
      p_prem_zero_rated    giac_direct_prem_collns.prem_zero_rated%TYPE,
      p_rev_gacc_tran_id   giac_direct_prem_collns.rev_gacc_tran_id%TYPE
   )
   IS
   BEGIN
      /*
         INSERT INTO giac_direct_prem_collns
                     (gacc_tran_id, transaction_type, b140_iss_cd,
                      b140_prem_seq_no, inst_no, collection_amt,
                      premium_amt, tax_amt, or_print_tag, particulars,
                      currency_cd, convert_rate, foreign_curr_amt, user_id,
                      last_update
                     )
              VALUES (p_gacc_tran_id, p_transaction_type, p_b140_iss_cd,
                      p_b140_prem_seq_no, p_inst_no, p_collection_amt,
                      p_premium_amt, p_tax_amt, p_or_print_tag, p_particulars,
                      p_currency_cd, p_convert_rate, p_foreign_curr_amt, USER,
                      SYSDATE
                     );*/
      --preinsert 
      IF p_transaction_type IN (2,4) THEN
        UPDATE giac_direct_prem_collns
           SET rev_gacc_tran_id = p_gacc_tran_id
         WHERE gacc_tran_id     = p_rev_gacc_tran_id
           AND b140_iss_cd      = p_b140_iss_cd
           AND b140_prem_seq_no = p_b140_prem_seq_no
           AND inst_no          = p_inst_no;
      END IF;               
                     
      MERGE INTO giac_direct_prem_collns
         USING DUAL
         ON (    gacc_tran_id = p_gacc_tran_id
             AND b140_iss_cd = p_b140_iss_cd
             AND b140_prem_seq_no = p_b140_prem_seq_no
             AND inst_no = p_inst_no)
         WHEN NOT MATCHED THEN
            INSERT (gacc_tran_id, transaction_type, b140_iss_cd,
                    b140_prem_seq_no, inst_no, collection_amt, premium_amt,
                    tax_amt, or_print_tag, particulars, currency_cd,
                    convert_rate, foreign_curr_amt, prem_vatable,
                    prem_vat_exempt, prem_zero_rated, 
                    user_id, last_update)
            VALUES (p_gacc_tran_id, p_transaction_type, p_b140_iss_cd,
                    p_b140_prem_seq_no, p_inst_no, p_collection_amt,
                    p_premium_amt, p_tax_amt, p_or_print_tag, p_particulars,
                    p_currency_cd, p_convert_rate, p_foreign_curr_amt, 
                    p_prem_vatable, p_prem_vat_exempt, p_prem_zero_rated,
                    NVL(giis_users_pkg.app_user,USER), SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET collection_amt = p_collection_amt,
                   premium_amt = p_premium_amt, tax_amt = p_tax_amt,
                   or_print_tag = p_or_print_tag, particulars = p_particulars,
                   currency_cd = p_currency_cd, convert_rate = p_convert_rate,
                   foreign_curr_amt = p_foreign_curr_amt, user_id = NVL(giis_users_pkg.app_user,USER),
                   prem_vatable = p_prem_vatable, prem_vat_exempt = p_prem_vat_exempt,
                   prem_zero_rated = p_prem_zero_rated, last_update = SYSDATE;
   END save_direct_prem_collns_dtls;

   FUNCTION get_direct_prem_collns_dtls (
      p_gacc_tran_id   giac_direct_prem_collns.gacc_tran_id%TYPE
   )
      RETURN giac_direct_prem_collns_tab2 PIPELINED
   IS
      v_prem        giac_direct_prem_collns_type2;
      v_assd_name   giis_assured.assd_name%TYPE;
   BEGIN
      FOR i IN (SELECT gacc_tran_id, transaction_type, b140_iss_cd,
                       b140_prem_seq_no, inst_no, collection_amt,
                       premium_amt, tax_amt, or_print_tag, particulars,
                       currency_cd, convert_rate, foreign_curr_amt,
                       prem_vatable, prem_vat_exempt, prem_zero_rated,
                       rev_gacc_tran_id
                  FROM giac_direct_prem_collns
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         v_prem.gacc_tran_id := i.gacc_tran_id;
         v_prem.transaction_type := i.transaction_type;
         v_prem.b140_iss_cd := i.b140_iss_cd;
         v_prem.b140_prem_seq_no := i.b140_prem_seq_no;

         BEGIN
            FOR j IN
               (SELECT    RTRIM (b250.line_cd)
                       || '-'
                       || RTRIM (b250.subline_cd)
                       || '-'
                       || RTRIM (b250.iss_cd)
                       || '-'
                       || LTRIM (TO_CHAR (b250.issue_yy, '99'))
                       || '-'
                       || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
                       || DECODE (b250.endt_seq_no,
                                  0, NULL,
                                     '-'
                                  || b250.endt_iss_cd
                                  || '-'
                                  || LTRIM (TO_CHAR (b250.endt_yy, '09'))
                                  || '-'
                                  || LTRIM (TO_CHAR (b250.endt_seq_no,
                                                     '099999'
                                                    )
                                           )
                                  || ' '
                                  || RTRIM (b250.endt_type)
                                 )
                       || '-'
                       || LTRIM (TO_CHAR (b250.renew_no, '09'))
                       --Vincent 02062006: added ltrim for renew_no
                       || DECODE (b250.pol_flag,
                                  '4', ' (Cancelled Policy)',
                                  '5', ' (Spoiled Policy)',
                                  NULL
                                 ) policy_no,
                       b250.policy_id, b250.line_cd, b250.subline_cd,
                       b250.iss_cd pol_iss_cd, b250.issue_yy,
                       b250.pol_seq_no, b250.endt_seq_no, b250.endt_type,
                       b250.assd_no, a020.assd_name
                  FROM giis_assured a020,
                       gipi_parlist b240,
                       gipi_polbasic b250,
                       gipi_invoice b140
                 WHERE b140.iss_cd = i.b140_iss_cd
                   AND b140.prem_seq_no = i.b140_prem_seq_no
                   AND b140.policy_id = b250.policy_id
                   AND b250.par_id = b240.par_id
                   AND NVL (b250.assd_no, b240.assd_no) = a020.assd_no)
            LOOP
               v_prem.assd_name := j.assd_name;
               v_prem.assd_no := j.assd_no;
               v_prem.policy_id := j.policy_id;
               v_prem.line_cd := j.line_cd;
               v_prem.subline_cd := j.subline_cd;
               v_prem.pol_iss_cd := j.pol_iss_cd;
               v_prem.issue_yy := j.issue_yy;
               v_prem.pol_seq_no := j.pol_seq_no;
               v_prem.endt_seq_no := j.endt_seq_no;
               v_prem.endt_type := j.endt_type;
               v_prem.policy_no := get_policy_no (j.policy_id);
            END LOOP;
         END;
   
         BEGIN
            FOR k IN (SELECT balance_amt_due, prem_balance_due, total_amount_due FROM giac_aging_soa_details 
                       WHERE prem_seq_no = i.b140_prem_seq_no 
                AND iss_cd = i.b140_iss_cd) LOOP
                v_prem.balance_amt_due  := k.balance_amt_due;
                v_prem.prem_balance_due := k.prem_balance_due;
                v_prem.max_colln_amt    := k.total_amount_due;
            END LOOP;
         END;

         v_prem.inst_no := i.inst_no;
         v_prem.collection_amt := i.collection_amt;
         v_prem.premium_amt := i.premium_amt;
         v_prem.tax_amt := i.tax_amt;
         v_prem.or_print_tag := i.or_print_tag;
         v_prem.particulars := i.particulars;
         v_prem.currency_cd := i.currency_cd;
         v_prem.convert_rate := i.convert_rate;
         v_prem.foreign_curr_amt := i.foreign_curr_amt;
         
         v_prem.prem_vatable := i.prem_vatable;
         v_prem.prem_zero_rated := i.prem_zero_rated;
         v_prem.prem_vat_exempt := i.prem_vat_exempt;
         v_prem.rev_gacc_tran_id := i.rev_gacc_tran_id;
         
         v_prem.inc_tag := 'N';
		 
         FOR l IN (SELECT '1'
                            FROM giac_advanced_payt
                            where gacc_tran_id = p_gacc_tran_id
                            AND iss_cd       = i.b140_iss_cd
                            AND prem_seq_no  = i.b140_prem_seq_no
                            AND inst_no      = i.inst_no)            
         LOOP          
            v_prem.inc_tag := 'Y';
            EXIT;            
         END LOOP;
         v_prem.comm_payt_sw := 0;
         FOR m IN (
            SELECT 1 comm_sw FROM giac_comm_payts
             WHERE gacc_tran_id = p_gacc_tran_id
               AND iss_cd       = i.b140_iss_cd
               AND prem_seq_no  = i.b140_prem_seq_no
         ) LOOP
            v_prem.comm_payt_sw := m.comm_sw;
         END LOOP;
         
         PIPE ROW (v_prem);
      END LOOP;

   END get_direct_prem_collns_dtls;

   PROCEDURE delete_direct_prem_collns_dtls (
      p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd        giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_direct_prem_collns.inst_no%TYPE,
      p_gacc_tran_id       giac_direct_prem_collns.gacc_tran_id%TYPE
   )
   IS
   BEGIN
      --pre_delete
      DELETE FROM GIAC_TAX_COLLNS
       WHERE B160_ISS_CD      = p_b140_iss_cd 
         and B160_PREM_SEQ_NO = p_b140_prem_seq_no 
         and INST_NO          = p_inst_no
         and GACC_TRAN_ID     = p_gacc_tran_id;
  
      IF p_transaction_type IN (2,4) THEN
        UPDATE giac_direct_prem_collns
           SET rev_gacc_tran_id = NULL
         WHERE rev_gacc_tran_id = p_gacc_tran_id
           AND b140_iss_cd      = p_b140_iss_cd
           AND b140_prem_seq_no = p_b140_prem_seq_no
           AND inst_no          = p_inst_no;
           
      END IF;
      -- /pre_delete
      DELETE FROM giac_direct_prem_collns
            WHERE gacc_tran_id = p_gacc_tran_id
              AND transaction_type = p_transaction_type
              AND b140_iss_cd = p_b140_iss_cd
              AND b140_prem_seq_no = p_b140_prem_seq_no
              AND inst_no = p_inst_no;
              
   END delete_direct_prem_collns_dtls;

   PROCEDURE generate_tax_defaults (
      p_gacc_tran_id              giac_direct_prem_collns.gacc_tran_id%TYPE,
      p_transaction_type          giac_direct_prem_collns.transaction_type%TYPE,
      p_b140_iss_cd               giac_direct_prem_collns.b140_iss_cd%TYPE,
      p_b140_prem_seq_no          giac_direct_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no                   giac_direct_prem_collns.inst_no%TYPE,
      p_fund_cd                   giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
      p_param_premium_amt         giac_direct_prem_collns.premium_amt%TYPE,
      p_collection_amt            giac_direct_prem_collns.collection_amt%TYPE,
      p_premium_amt         OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_tax_amt             OUT   giac_direct_prem_collns.tax_amt%TYPE,
      p_sum_tax_amt               giac_direct_prem_collns.tax_amt%TYPE,
      p_rev_gacc_tran_id          giac_direct_prem_collns.gacc_tran_id%TYPE
   --p_msg_alert           OUT   VARCHAR2
   )
   IS
      v_check_flag            VARCHAR2 (5);
      v_record_no             NUMBER;
      v_exists                VARCHAR2 (1);
      v_tax_alloc             VARCHAR2 (1);
      v_total_tax             NUMBER;
      v_last_rec              NUMBER;
      ctr                     NUMBER                                     := 0;
      isvalid                 BOOLEAN                                 := TRUE;
      v_giac_tax_collns_cur   giac_tax_collns_pkg.rc_giac_tax_collns_cur;
      v_tran_type NUMBER;
      v_sm NUMBER;
      v_prem_vat_exempt       giac_direct_prem_collns.prem_vat_exempt%TYPE := 0;
   BEGIN
      v_tran_type := p_transaction_type;
      v_sm := NVL(p_sum_tax_amt,0);

      BEGIN
         SELECT SUM (tax_amt)
           INTO v_total_tax
           FROM giac_tax_collns
          WHERE gacc_tran_id = p_gacc_tran_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_total_tax := 0;
      END;
      
      --IF NVL (v_total_tax, 0) = 0 AND NVL (p_sum_tax_amt, 0) != 0 THEN
      IF NVL (p_sum_tax_amt, 0) != 0 THEN  --d.alcantara, 09-02-2012, hindi applicable yung unang condition sa web, hindi kasi mase-save yung
                                           --giac_tax_collns ng mga succedding the direct prem
         IF p_transaction_type = 1
         THEN
            tax_default_value_type1
                           (p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         ELSIF p_transaction_type = 2
         THEN
            /*tax_default_value_type2
                           (p_gacc_tran_id,
                            p_rev_gacc_tran_id,--p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );*/ 
                           
            --replaced by: Nica 06.22.2012 GEN-2012-202_GIACS007_V01_04192012
            REVERSE_TRAN_TYPE_1_OR_3(p_gacc_tran_id,
                                     p_rev_gacc_tran_id,--p_gacc_tran_id, 
                                     p_transaction_type,
                                     p_b140_iss_cd,
                                     p_b140_prem_seq_no,
                                     p_inst_no,
                                     p_fund_cd,
                                     p_collection_amt,
                                     v_prem_vat_exempt,
                                     v_giac_tax_collns_cur --added by alfie: 10.24.2010
                                    );
         ELSIF p_transaction_type = 3
         THEN
            tax_default_value_type3
                           (p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );
         ELSIF p_transaction_type = 4
         THEN
            /*tax_default_value_type4
                           (p_gacc_tran_id,
                            p_rev_gacc_tran_id,--p_gacc_tran_id,
                            p_transaction_type,
                            p_b140_iss_cd,
                            p_b140_prem_seq_no,
                            p_inst_no,
                            p_fund_cd,
                            p_param_premium_amt,
                            p_collection_amt,
                            p_premium_amt,
                            p_tax_amt,
                            v_prem_vat_exempt,
                            v_giac_tax_collns_cur --added by alfie: 10.24.2010
                           );*/
            
            --replaced by: Nica 06.22.2012 GEN-2012-202_GIACS007_V01_04192012
            REVERSE_TRAN_TYPE_1_OR_3(p_gacc_tran_id,
                                     p_rev_gacc_tran_id,--p_gacc_tran_id, 
                                     p_transaction_type,
                                     p_b140_iss_cd,
                                     p_b140_prem_seq_no,
                                     p_inst_no,
                                     p_fund_cd,
                                     p_collection_amt,
                                     v_prem_vat_exempt,
                                     v_giac_tax_collns_cur --added by alfie: 10.24.2010
                                    );
         END IF;
      END IF;
/*
      IF p_sum_tax_amt <> p_tax_amt
      THEN
         p_msg_alert :=
                   'Tax amount is not equal with total tax amount breakdown.';
         isvalid := FALSE;
      END IF;

      IF (p_tax_amt + p_premium_amt) <> p_collection_amt
      THEN
         p_msg_alert :=
            'Total premium amount plus total tax amount is not equal with the total collection amount.';
         isvalid := FALSE;
      END IF;
*/
   END generate_tax_defaults;

   FUNCTION get_related_prem_collns(p_iss_cd        GIPI_INVOICE.iss_cd%TYPE,
                                    p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE)

    RETURN giac_related_prem_collns_tab PIPELINED

   IS v_prem_collns giac_related_prem_collns_type;

    v_ref_no VARCHAR2(50);

   BEGIN

      FOR i IN (SELECT a.premium_amt,a.tax_amt,a.collection_amt,
                       a.gacc_tran_id,a.transaction_type,a.b140_iss_cd,
                       a.b140_prem_seq_no,a.inst_no,a.particulars,
                       a.user_id,a.last_update,b.tran_date,b.tran_flag,
                       b.tran_year,b.tran_month,b.tran_seq_no,
                       b.tran_class,b.tran_class_no,b.jv_no,
                       TO_CHAR(a.last_update, 'MM-DD-RRRR HH:MI:SS AM') last_update2, --added by reymon 11112013
                       TO_CHAR(b.tran_date, 'MM-DD-RRRR') tran_date2 --added by reymon 11112013
                  FROM GIAC_DIRECT_PREM_COLLNS a,GIAC_ACCTRANS b
                 WHERE a.gacc_tran_id IN (SELECT tran_id
                                            FROM GIAC_ACCTRANS
                                           WHERE tran_flag <> 'D')
                   AND a.gacc_tran_id NOT IN (SELECT gr.gacc_tran_id
                                                FROM GIAC_REVERSALS gr, GIAC_ACCTRANS ga
                                               WHERE gr.reversing_tran_id = ga.tran_id)
                   AND a.gacc_tran_id = b.tran_id
                   AND a.b140_iss_cd = NVL(p_iss_cd,a.b140_iss_cd)
                   AND a.b140_prem_seq_no = NVL(p_prem_seq_no,a.b140_prem_seq_no))
      LOOP


         v_prem_collns.premium_amt            :=         i.premium_amt;
         v_prem_collns.tax_amt                :=         i.tax_amt;
         v_prem_collns.collection_amt         :=         i.collection_amt;
         v_prem_collns.gacc_tran_id           :=         i.gacc_tran_id;
         v_prem_collns.user_id                :=         i.user_id;
         v_prem_collns.particulars            :=         i.particulars;
         v_prem_collns.last_update            :=         i.last_update;
         v_prem_collns.transaction_type       :=         i.transaction_type;
         v_prem_collns.inst_no                :=         i.inst_no;
         v_prem_collns.b140_iss_cd            :=         i.b140_iss_cd;
         v_prem_collns.b140_prem_seq_no       :=         i.b140_prem_seq_no;
         v_prem_collns.last_update2           :=         i.last_update2; --added by reymon 11112013

         IF i.tran_class = 'COL' THEN

             SELECT or_pref_suf||'-'||TO_CHAR(or_no)
               INTO v_ref_no
               FROM GIAC_ORDER_OF_PAYTS
              WHERE gacc_tran_id = i.gacc_tran_id;

         ELSIF i.tran_class = 'DV' THEN

             BEGIN

                 SELECT dv_pref||'-'||TO_CHAR(dv_no)
                   INTO v_ref_no
                   FROM GIAC_DISB_VOUCHERS
                  WHERE gacc_tran_id = i.gacc_tran_id;

             EXCEPTION WHEN NO_DATA_FOUND THEN

                 SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)||'-'||TO_CHAR(doc_seq_no)
                   INTO v_ref_no
                   FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                  WHERE a.ref_id = b.gprq_ref_id
                    AND tran_id = i.gacc_tran_id;

             END;

         ELSIF  i.tran_class = 'JV' THEN

                 v_ref_no := '-'||TO_CHAR(i.jv_no);

         END IF;

         v_prem_collns.ref_no                 :=         i.tran_class||' '||v_ref_no;
         v_prem_collns.tran_date              :=         i.tran_date;
         v_prem_collns.tran_date2             :=         i.tran_date2; --added by reymon 11112013

         PIPE ROW (v_prem_collns);

      END LOOP;

  END get_related_prem_collns;                     --MOSES 03252011

    
  FUNCTION get_direct_prem_inv_listing2 (
    p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
    p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
    p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE
  ) RETURN giac_direct_prem_collns_tab PIPELINED
    IS
        v_inv         giac_direct_prem_collns_type;
        v_intm_no     giis_intermediary.intm_no%TYPE;
        v_intm_name   giis_intermediary.intm_name%TYPE;
    BEGIN
      
        IF p_transaction_type IN (1, 3) THEN
            FOR a_rec IN (
                SELECT   A.iss_cd, A.prem_seq_no, A.inst_no,
                      A.balance_amt_due collection_amt,
                      A.prem_balance_due premium_amt, A.tax_balance_due tax_amt,
                      A.balance_amt_due collection_amt1,
                      A.prem_balance_due premium_amt1,
                      A.tax_balance_due tax_amt1, b.ref_inv_no, c.policy_id,
                      c.line_cd pol_line_cd, c.subline_cd pol_subline_cd,
                      c.iss_cd pol_iss_cd, c.issue_yy pol_issue_yy,
                      c.pol_seq_no pol_seq_no, c.renew_no pol_renew_no,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_iss_cd) endt_iss_cd,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_yy) endt_yy,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_seq_no) endt_seq_no,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_type) endt_type,
                      c.ref_pol_no, c.assd_no, d.assd_name, b.currency_rt,
                      get_policy_no (c.policy_id) policy_no,
                      b.currency_cd
                 FROM gipi_parlist E,
                      giis_assured d,
                      gipi_polbasic c,
                      gipi_invoice b,
                      giac_aging_soa_details A
                WHERE 1 = 1
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM giac_cancelled_policies_v
                          WHERE line_cd = c.line_cd
                            AND subline_cd = c.subline_cd
                            AND iss_cd = c.iss_cd
                            AND issue_yy = c.issue_yy
                            AND pol_seq_no = c.pol_seq_no
                            AND renew_no = c.renew_no)
                  AND E.assd_no = d.assd_no
                  AND c.par_id = E.par_id
                  AND A.policy_id = c.policy_id
                  AND A.prem_seq_no = b.prem_seq_no
                  AND A.iss_cd = b.iss_cd
                  AND A.iss_cd = NVL (p_iss_cd, A.iss_cd)
                  AND A.prem_seq_no =
                         DECODE
                               (p_prem_seq_no,
                                0, A.prem_seq_no,
                                p_prem_seq_no
                               )              --NVL (p_prem_seq_no, a.prem_seq_no)
                  AND (   (balance_amt_due > 0 AND p_transaction_type = 1)
                       OR (balance_amt_due < 0 AND p_transaction_type = 3)
                      )
                ORDER BY A.iss_cd, A.prem_seq_no, A.inst_no
            ) LOOP
                v_intm_no := NULL;
                v_intm_name := NULL;
            
                FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                                       FROM giis_intermediary A, gipi_comm_invoice b
                                      WHERE A.intm_no = b.intrmdry_intm_no
                                        AND b.iss_cd = a_rec.iss_cd
                                        AND b.prem_seq_no = a_rec.prem_seq_no)
                LOOP
                   IF intm_rec.num = 1
                   THEN
                      --DBMS_OUTPUT.put_line ('IN');
                      v_intm_no := intm_rec.intm_no;
                      v_intm_name := intm_rec.intm_name;
                   ELSE
                      --DBMS_OUTPUT.put_line ('OUT');
                      v_intm_no := intm_rec.intm_no;
                      --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                      v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
                   END IF;
                END LOOP;
                
                v_inv.b140_iss_cd := a_rec.iss_cd;
                v_inv.b140_prem_seq_no := a_rec.prem_seq_no;
                v_inv.inst_no := a_rec.inst_no;
                v_inv.ref_inv_no := a_rec.ref_inv_no;
                v_inv.policy_id := a_rec.policy_id;
                v_inv.line_cd := a_rec.pol_line_cd;
                v_inv.subline_cd := a_rec.pol_subline_cd;
                v_inv.pol_iss_cd := a_rec.pol_iss_cd;
                v_inv.issue_yy := a_rec.pol_issue_yy;
                v_inv.pol_seq_no := a_rec.pol_seq_no;
                v_inv.pol_renew_no := a_rec.pol_renew_no;
                v_inv.endt_iss_cd := a_rec.endt_iss_cd;
                v_inv.endt_yy := a_rec.endt_yy;
                --v_inv.endt_seq_no := a_rec.endt_seq_no;
                --v_inv.endt_type := a_rec.endt_type;
                v_inv.ref_pol_no := a_rec.ref_pol_no;
                v_inv.assd_no := a_rec.assd_no;
                v_inv.assd_name := a_rec.assd_name;
                v_inv.intm_no := v_intm_no;
                v_inv.intm_name := v_intm_name;
                v_inv.collection_amt := a_rec.collection_amt;
                v_inv.premium_amt := a_rec.premium_amt;
                v_inv.tax_amt := a_rec.tax_amt;
                v_inv.collection_amt1 := a_rec.collection_amt1;
                v_inv.premium_amt1 := a_rec.premium_amt1;
                v_inv.tax_amt1 := a_rec.tax_amt1;
                v_inv.currency_rt := a_rec.currency_rt;
                v_inv.policy_no := a_rec.policy_no;
                v_inv.currency_cd := a_rec.currency_cd;
                PIPE ROW (v_inv);
            END LOOP;
            RETURN;
        ELSIF p_transaction_type IN (2, 4)
        THEN
            FOR b_rec IN (
                SELECT   f.tran_id, A.b140_iss_cd iss_cd,
                      A.b140_prem_seq_no prem_seq_no, A.inst_no,
                      SUM (A.collection_amt) collection_amt,
                      SUM (A.premium_amt) premium_amt, SUM (A.tax_amt) tax_amt,
                      (-1) * SUM (A.collection_amt) collection_amt1,
                      (-1) * SUM (A.premium_amt) premium_amt1,
                      (-1) * SUM (A.tax_amt) tax_amt1, b.ref_inv_no,
                      get_ref_no (f.tran_id) payt_ref_no, c.policy_id,
                      c.ref_pol_no, c.line_cd pol_line_cd,
                      c.subline_cd pol_subline_cd, c.iss_cd pol_iss_cd,
                      c.issue_yy pol_issue_yy, c.pol_seq_no pol_seq_no,
                      c.renew_no pol_renew_no,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_iss_cd) endt_iss_cd,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_yy) endt_yy,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_seq_no) endt_seq_no,
                      DECODE (c.endt_seq_no, 0, NULL, c.endt_type) endt_type,
                      d.assd_no, d.assd_name, b.currency_rt,
                      get_policy_no (c.policy_id) policy_no,
                      b.currency_cd, A.or_print_tag
                 FROM giac_acctrans f,
                      gipi_parlist E,
                      giis_assured d,
                      gipi_polbasic c,
                      gipi_invoice b,
                      giac_direct_prem_collns A
                WHERE 1 = 1
                  AND NOT EXISTS (
                         SELECT 'X'
                           FROM giac_cancelled_policies_v
                          WHERE line_cd = c.line_cd
                            AND subline_cd = c.subline_cd
                            AND iss_cd = c.iss_cd
                            AND issue_yy = c.issue_yy
                            AND pol_seq_no = c.pol_seq_no
                            AND renew_no = c.renew_no)
                  AND E.assd_no = d.assd_no
                  AND c.par_id = E.par_id
                  AND b.policy_id = c.policy_id
                  AND A.gacc_tran_id = f.tran_id
                  AND A.b140_iss_cd = b.iss_cd
                  AND A.b140_prem_seq_no = b.prem_seq_no
                  AND NOT EXISTS (
                         SELECT 'x'
                           FROM giac_reversals G, giac_acctrans h
                          WHERE G.reversing_tran_id = h.tran_id
                            AND G.gacc_tran_id = A.gacc_tran_id
                            AND h.tran_flag <> 'D')
                  AND f.tran_flag <> 'D'
                  AND A.b140_iss_cd = NVL (p_iss_cd, A.b140_iss_cd)
                  AND A.b140_prem_seq_no =
                         DECODE
                            (p_prem_seq_no,
                             0, A.b140_prem_seq_no,
                             p_prem_seq_no
                            )            --NVL (p_prem_seq_no, a.b140_prem_seq_no)
                GROUP BY f.tran_id,
                      A.b140_iss_cd,
                      A.b140_prem_seq_no,
                      A.inst_no,
                      b.ref_inv_no,
                      get_ref_no (f.tran_id),
                      c.policy_id,
                      c.ref_pol_no,
                      c.line_cd,
                      c.subline_cd,
                      c.iss_cd,
                      c.issue_yy,
                      c.pol_seq_no,
                      c.renew_no,
                      c.endt_iss_cd,
                      c.endt_yy,
                      c.endt_seq_no,
                      c.endt_type,
                      d.assd_no,
                      d.assd_name,
                      b.currency_rt,
                      get_policy_no(c.policy_id), --added by alfie 04/28/2011
                      b.currency_cd
                HAVING (   (SUM (A.collection_amt) > 0 AND p_transaction_type = 2)
                       OR (SUM (A.collection_amt) < 0 AND p_transaction_type = 4)
                      )
                ORDER BY A.b140_iss_cd, A.b140_prem_seq_no, A.inst_no
            ) LOOP
                v_intm_no := NULL;
                v_intm_name := NULL;

                FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                                   FROM giis_intermediary A, gipi_comm_invoice b
                                  WHERE A.intm_no = b.intrmdry_intm_no
                                    AND b.iss_cd = b_rec.iss_cd
                                    AND b.prem_seq_no = b_rec.prem_seq_no)
                LOOP
                   IF intm_rec.num = 1
                   THEN
                      v_intm_no := intm_rec.intm_no;
                      v_intm_name := intm_rec.intm_name;
                   ELSE
                      --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                      v_intm_no := v_intm_no || intm_rec.intm_no;
                      v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
                   END IF;
                END LOOP;

                v_inv.tran_id := b_rec.tran_id;
                v_inv.b140_iss_cd := b_rec.iss_cd;
                v_inv.b140_prem_seq_no := b_rec.prem_seq_no;
                v_inv.inst_no := b_rec.inst_no;
                v_inv.ref_inv_no := b_rec.ref_inv_no;
                v_inv.payt_ref_no := b_rec.payt_ref_no;
                v_inv.policy_id := b_rec.policy_id;
                v_inv.line_cd := b_rec.pol_line_cd;
                v_inv.subline_cd := b_rec.pol_subline_cd;
                v_inv.pol_iss_cd := b_rec.pol_iss_cd;
                v_inv.issue_yy := b_rec.pol_issue_yy;
                v_inv.pol_seq_no := b_rec.pol_seq_no;
                v_inv.pol_renew_no := b_rec.pol_renew_no;
                v_inv.endt_iss_cd := b_rec.endt_iss_cd;
                v_inv.endt_yy := b_rec.endt_yy;
                v_inv.endt_seq_no := b_rec.endt_seq_no;
                --v_inv.endt_type := b_rec.endt_type;
                v_inv.ref_pol_no := b_rec.ref_pol_no;
                v_inv.assd_no := b_rec.assd_no;
                v_inv.assd_name := b_rec.assd_name;
                v_inv.intm_no := v_intm_no;
                v_inv.intm_name := v_intm_name;
                v_inv.collection_amt := b_rec.collection_amt;
                v_inv.premium_amt := b_rec.premium_amt;
                v_inv.tax_amt := b_rec.tax_amt;
                v_inv.collection_amt1 := b_rec.collection_amt1;
                v_inv.premium_amt1 := b_rec.premium_amt1;
                v_inv.tax_amt1 := b_rec.tax_amt1;
                v_inv.currency_rt := b_rec.currency_rt;
                v_inv.policy_no := b_rec.policy_no;
                v_inv.currency_cd := b_rec.currency_cd;
                v_inv.or_print_tag := b_rec.or_print_tag;
                PIPE ROW (v_inv);
            END LOOP;    
            RETURN;
        END IF;
    END get_direct_prem_inv_listing2; 
    
   /*
   **  Created by   :  D.Alcantara
   **  Date Created :  02.24.2012
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description  : Retrieve invoice of policy
   */
    FUNCTION get_inv_from_policy (
        p_line_cd      gipi_polbasic.line_cd%TYPE,
        p_subline_cd   gipi_polbasic.subline_cd%TYPE,
        p_iss_cd       gipi_polbasic.iss_cd%TYPE,
        p_issue_year   gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no     gipi_polbasic.renew_no%TYPE,
        p_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE,
        p_due_tag      VARCHAR2
    ) RETURN giac_direct_prem_collns_tab PIPELINED IS
        v_inv         giac_direct_prem_collns_type; 
        CURSOR cur_prem IS (SELECT * 
            FROM TABLE(giac_aging_soa_details_pkg.get_policy_details(p_line_cd, p_subline_cd, p_iss_cd, 
                                    p_issue_year, p_pol_seq_no, p_renew_no, p_ref_pol_no, p_due_tag)));
                    
    BEGIN
        FOR a IN cur_prem LOOP
            FOR b IN (
                SELECT * FROM 
                 TABLE(giac_direct_prem_collns_pkg.get_gdcp_invoice_listing(
                           a.iss_cd, a.prem_seq_no, a.tran_type, a.inst_no))
                 ORDER BY a.tran_type, a.iss_cd, a.prem_seq_no, a.inst_no 
            ) LOOP
                v_inv.tran_id := b.tran_id;
                v_inv.b140_iss_cd := b.b140_iss_cd;
                v_inv.b140_prem_seq_no := b.b140_prem_seq_no;
                v_inv.inst_no := b.inst_no;
                v_inv.ref_inv_no := b.ref_inv_no;
                v_inv.payt_ref_no := b.payt_ref_no;
                v_inv.policy_id := b.policy_id;
                v_inv.line_cd := b.line_cd;
                v_inv.subline_cd := b.subline_cd;
                v_inv.pol_iss_cd := b.pol_iss_cd;
                v_inv.issue_yy := b.issue_yy;
                v_inv.pol_seq_no := b.pol_seq_no;
                v_inv.pol_renew_no := b.pol_renew_no;
                v_inv.endt_iss_cd := b.endt_iss_cd;
                v_inv.endt_yy := b.endt_yy;
                v_inv.endt_seq_no := b.endt_seq_no;
                v_inv.ref_pol_no := b.ref_pol_no;
                v_inv.assd_no := b.assd_no;
                v_inv.assd_name := b.assd_name;
                v_inv.intm_no := b.intm_no;
                v_inv.intm_name := b.intm_name;
                v_inv.collection_amt := b.collection_amt;
                v_inv.premium_amt := b.premium_amt;
                v_inv.tax_amt := b.tax_amt;
                v_inv.collection_amt1 := b.collection_amt1;
                v_inv.premium_amt1 := b.premium_amt1;
                v_inv.tax_amt1 := b.tax_amt1;
                v_inv.currency_rt := b.currency_rt;
                v_inv.policy_no := b.policy_no;
                v_inv.currency_cd := b.currency_cd;
                v_inv.transaction_type := a.tran_type;
                --v_inv.or_print_tag := a.or_print_tag;
                
                PIPE ROW(v_inv);
            END LOOP;
        END LOOP;
    END get_inv_from_policy;  
    
    /*
  **  Created by   :  D.Alcantara
  **  Date Created :  04.02.2012
  **  Reference By : GIACS007 - SET_PREMTAX_TRAN_TYPE(program unit)
  */ 
    PROCEDURE set_premtax_tran_type (
        p_iss_cd             IN giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_transaction_type   IN giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            IN giac_direct_prem_collns.inst_no%TYPE, 
        p_premium_amt		 IN giac_direct_prem_collns.premium_amt%TYPE,
        p_prem_vatable       OUT NUMBER,
        p_prem_vat_exempt 	 OUT NUMBER,
        p_prem_zero_rated    OUT NUMBER,
        p_max_prem_vatable   OUT NUMBER
    )  IS
        v_prem_vatable_due NUMBER;
        v_prem_vat_exempt_due  NUMBER;
        v_prem_zero_rated_due NUMBER;

        v_paid_prem_vatable NUMBER;
        v_paid_prem_vat_exempt NUMBER;
        v_paid_prem_zero_rated NUMBER;

        v_bal_prem_vatable NUMBER;
        v_bal_prem_vat_exempt NUMBER;
        v_bal_prem_zero_rated NUMBER;

        v_num_of_installments NUMBER;
        v_tax    VARCHAR2(50) := giacp.n('EVAT');
    BEGIN
        BEGIN
            SELECT MAX(INST_NO)
                INTO v_num_of_installments
                FROM GIPI_INSTALLMENT
            WHERE prem_seq_no = p_prem_seq_no
                AND iss_cd = p_iss_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_num_of_installments := 1;
        END;
  
        IF p_transaction_type IN (1,3) THEN
            BEGIN
                 
            SELECT (taxable_prem_amt * currency_rt) / v_num_of_installments    taxable_prem_amt,   
                   (taxexempt_prem_amt * currency_rt) / v_num_of_installments  taxexempt_prem_amt, 
                    zerorated_prem_amt * currency_rt / v_num_of_installments    zerorated_prem_amt  
              INTO v_prem_vatable_due,
                   v_prem_vat_exempt_due,
                   v_prem_zero_rated_due
            FROM gipi_inv_tax a, gipi_invoice b
            WHERE a.iss_cd = p_iss_cd
             AND a.prem_seq_no = p_prem_seq_no
             AND tax_cd = v_tax
             AND b.iss_cd = a.iss_cd
             AND b.prem_seq_no = a.prem_seq_no;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_prem_vatable_due    := 0;
              v_prem_vat_exempt_due := p_premium_amt;
              v_prem_zero_rated_due := 0;
        END; --due
    
        IF p_transaction_type = 1 THEN
            BEGIN
                SELECT SUM(prem_vatable) prem_vatable, 
                   SUM(prem_vat_exempt) prem_vat_exempt, 
                   SUM(prem_zero_rated) prem_zero_rated  
                  INTO v_paid_prem_vatable,
                       v_paid_prem_vat_exempt,
                       v_paid_prem_zero_rated
                  FROM giac_direct_prem_collns a,
                        giac_acctrans b
                 WHERE NOT EXISTS(SELECT 'x'
                                FROM giac_reversals aa, 
                                     giac_acctrans  bb
                               WHERE aa.reversing_tran_id = bb.tran_id 
                                 AND bb.tran_flag        != 'D'
                                 AND aa.gacc_tran_id      = b.tran_id)
                  AND a.gacc_tran_id   = b.tran_id
                  AND b.tran_flag     != 'D'                                
                  AND inst_no          = p_inst_no 
                  AND b140_prem_seq_no = p_prem_seq_no 
                  AND b140_iss_cd      = p_iss_cd
                GROUP BY b140_iss_cd, b140_prem_seq_no, inst_no
               HAVING SUM(collection_amt) > 0;    
          
            EXCEPTION    
                WHEN NO_DATA_FOUND THEN
                  v_paid_prem_vatable    := 0;
                  v_paid_prem_vat_exempt := 0;
                  v_paid_prem_zero_rated := 0;
        
            END;
        END IF;

        IF p_transaction_type = 3 THEN
          BEGIN
                SELECT SUM(prem_vatable) prem_vatable, 
                       SUM(prem_vat_exempt) prem_vat_exempt, 
                       SUM(prem_zero_rated) prem_zero_rated  
                  INTO v_paid_prem_vatable,
                        v_paid_prem_vat_exempt,
                        v_paid_prem_zero_rated
                  FROM giac_direct_prem_collns a,
                        giac_acctrans b
                 WHERE NOT EXISTS(SELECT 'x'
                                FROM giac_reversals aa, 
                                     giac_acctrans  bb
                               WHERE aa.reversing_tran_id = bb.tran_id 
                                 AND bb.tran_flag        != 'D'
                                 AND aa.gacc_tran_id      = b.tran_id)
                   AND a.gacc_tran_id   = b.tran_id
                   AND b.tran_flag     != 'D'                                
                   AND inst_no          = p_inst_no 
                   AND b140_prem_seq_no = p_prem_seq_no 
                   AND b140_iss_cd      = p_iss_cd
                 GROUP BY b140_iss_cd, b140_prem_seq_no, inst_no
                HAVING SUM(collection_amt) < 0;    
          EXCEPTION    
            WHEN NO_DATA_FOUND THEN
              v_paid_prem_vatable    := 0;
              v_paid_prem_vat_exempt := 0;
              v_paid_prem_zero_rated := 0;
          END; 
        END IF;
            v_bal_prem_vatable    := v_prem_vatable_due - v_paid_prem_vatable;
            v_bal_prem_vat_exempt := v_prem_vat_exempt_due - v_paid_prem_vat_exempt;
            v_bal_prem_zero_rated := v_prem_zero_rated_due - v_paid_prem_zero_rated;  
                 
            p_prem_vatable    := v_bal_prem_vatable;
            p_prem_vat_exempt := v_bal_prem_vat_exempt;
            p_prem_zero_rated := v_bal_prem_zero_rated;
            p_max_prem_vatable := p_prem_vatable;
        END IF; -- if transaction type
    END set_premtax_tran_type;
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  05.14.2012
    **  Reference By : modified listing for LOV in giacs007
    */ 
    FUNCTION get_gdcp_invoice_listing (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    ) RETURN giac_direct_prem_collns_tab PIPELINED IS
        v_inv           giac_direct_prem_collns_type;
        v_intm_no       VARCHAR2(50);
        v_intm_name     VARCHAR2(4000);
        
        CURSOR a IS
			SELECT iss_cd, prem_seq_no, inst_no, collection_amt, premium_amt, tax_amt,
			       collection_amt1, premium_amt1, tax_amt1, ref_inv_no, policy_id,
			       pol_line_cd, pol_subline_cd, pol_iss_cd, pol_issue_yy, pol_seq_no,
			       pol_renew_no, endt_iss_cd, endt_yy, endt_seq_no, endt_type, ref_pol_no,
			       assd_no, assd_name, currency_rt, currency_cd
			  FROM giac_invoice_list_v1
			 WHERE p_transaction_type = 1
			   AND iss_cd = NVL (p_iss_cd, iss_cd)
			   AND ((p_prem_seq_no IS NULL AND 1 = 1)
			        OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = prem_seq_no)
			       )
			   AND inst_no = nvl(p_inst_no, inst_no)
			   AND collection_amt > 0
			UNION
			SELECT iss_cd, prem_seq_no, inst_no, collection_amt, premium_amt, tax_amt,
			       collection_amt1, premium_amt1, tax_amt1, ref_inv_no, policy_id,
			       pol_line_cd, pol_subline_cd, pol_iss_cd, pol_issue_yy, pol_seq_no,
			       pol_renew_no, endt_iss_cd, endt_yy, endt_seq_no, endt_type, ref_pol_no,
			       assd_no, assd_name, currency_rt, currency_cd
			  FROM giac_invoice_list_v1
			 WHERE p_transaction_type = 3
			   AND iss_cd = NVL (p_iss_cd, iss_cd)
			   AND ((p_prem_seq_no IS NULL AND 1 = 1)
			        OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = prem_seq_no)
			       )
			   AND inst_no = nvl(p_inst_no, inst_no)
			   AND collection_amt < 0;
               
        CURSOR b IS    
            SELECT tran_id, iss_cd, prem_seq_no, inst_no, collection_amt, premium_amt,
                   tax_amt, collection_amt1, premium_amt1, tax_amt1, ref_inv_no,
                   payt_ref_no, policy_id, ref_pol_no, pol_line_cd, pol_subline_cd,
                   pol_iss_cd, pol_issue_yy, pol_seq_no, pol_renew_no, endt_iss_cd,
                   endt_yy, endt_seq_no, endt_type, assd_no, assd_name,
                   prem_vatable, prem_vat_exempt, prem_zero_rated, rev_gacc_tran_id,
                   currency_rt, currency_cd
              FROM giac_invoice_list_web_v2
             WHERE p_transaction_type = 2
               AND iss_cd = nvl(p_iss_cd, iss_cd) 
               AND ((p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = prem_seq_no)
                   )
               AND inst_no = nvl(p_inst_no, inst_no)
               AND collection_amt > 0
            UNION
            SELECT tran_id, iss_cd, prem_seq_no, inst_no, collection_amt, premium_amt,
                   tax_amt, collection_amt1, premium_amt1, tax_amt1, ref_inv_no,
                   payt_ref_no, policy_id, ref_pol_no, pol_line_cd, pol_subline_cd,
                   pol_iss_cd, pol_issue_yy, pol_seq_no, pol_renew_no, endt_iss_cd,
                   endt_yy, endt_seq_no, endt_type, assd_no, assd_name,
                   prem_vatable, prem_vat_exempt, prem_zero_rated, rev_gacc_tran_id,
                   currency_rt, currency_cd
              FROM giac_invoice_list_web_v2
             WHERE p_transaction_type = 4
               AND iss_cd = nvl(p_iss_cd, iss_cd) 
               AND ((p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = prem_seq_no)
                   )
			   AND inst_no = nvl(p_inst_no, inst_no)
               AND collection_amt < 0;   
    BEGIN
      IF p_transaction_type IN (1, 3) THEN
         FOR a_rec IN A
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = a_rec.iss_cd
                                AND b.prem_seq_no = a_rec.prem_seq_no)
            LOOP
               DBMS_OUTPUT.put_line (   'isscd and premseqno: '
                                     || a_rec.iss_cd
                                     || ' '
                                     || a_rec.prem_seq_no
                                    );

               IF intm_rec.num = 1
               THEN
                  DBMS_OUTPUT.put_line ('IN');
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  DBMS_OUTPUT.put_line ('OUT');
                  v_intm_no := intm_rec.intm_no;
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.b140_iss_cd := a_rec.iss_cd;
            v_inv.b140_prem_seq_no := a_rec.prem_seq_no;
            v_inv.inst_no := a_rec.inst_no;
            v_inv.ref_inv_no := a_rec.ref_inv_no;
            v_inv.policy_id := a_rec.policy_id;
            v_inv.line_cd := a_rec.pol_line_cd;
            v_inv.subline_cd := a_rec.pol_subline_cd;
            v_inv.pol_iss_cd := a_rec.pol_iss_cd;
            v_inv.issue_yy := a_rec.pol_issue_yy;
            v_inv.pol_seq_no := a_rec.pol_seq_no;
            v_inv.pol_renew_no := a_rec.pol_renew_no;
            v_inv.endt_iss_cd := a_rec.endt_iss_cd;
            v_inv.endt_yy := a_rec.endt_yy;
            v_inv.endt_seq_no := a_rec.endt_seq_no; --uncommented by robert test
            --v_inv.endt_type := a_rec.endt_type;
            v_inv.ref_pol_no := a_rec.ref_pol_no;
            v_inv.assd_no := a_rec.assd_no;
            v_inv.assd_name := a_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := a_rec.collection_amt;
            v_inv.premium_amt := a_rec.premium_amt;
            v_inv.tax_amt := a_rec.tax_amt;
            v_inv.collection_amt1 := a_rec.collection_amt1;
            v_inv.premium_amt1 := a_rec.premium_amt1;
            v_inv.tax_amt1 := a_rec.tax_amt1;
            v_inv.currency_rt := a_rec.currency_rt;    -- uncommented by d.alcantara, 07-31-2012 (a)
            v_inv.policy_no := get_policy_no(a_rec.policy_id);
            v_inv.currency_cd := a_rec.currency_cd;    -- (a)       
            PIPE ROW (v_inv);
         END LOOP;

         RETURN;
      ELSIF p_transaction_type IN (2, 4)
      THEN
         FOR b_rec IN b
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = b_rec.iss_cd
                                AND b.prem_seq_no = b_rec.prem_seq_no)
            LOOP
               IF intm_rec.num = 1
               THEN
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_no := v_intm_no || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.tran_id := b_rec.tran_id;
            v_inv.b140_iss_cd := b_rec.iss_cd;
            v_inv.b140_prem_seq_no := b_rec.prem_seq_no;
            v_inv.inst_no := b_rec.inst_no;
            v_inv.ref_inv_no := b_rec.ref_inv_no;
            v_inv.payt_ref_no := b_rec.payt_ref_no;
            v_inv.policy_id := b_rec.policy_id;
            v_inv.line_cd := b_rec.pol_line_cd;
            v_inv.subline_cd := b_rec.pol_subline_cd;
            v_inv.pol_iss_cd := b_rec.pol_iss_cd;
            v_inv.issue_yy := b_rec.pol_issue_yy;
            v_inv.pol_seq_no := b_rec.pol_seq_no;
            v_inv.pol_renew_no := b_rec.pol_renew_no;
            v_inv.endt_iss_cd := b_rec.endt_iss_cd;
            v_inv.endt_yy := b_rec.endt_yy;
            v_inv.endt_seq_no := b_rec.endt_seq_no;
            --v_inv.endt_type := b_rec.endt_type;
            v_inv.ref_pol_no := b_rec.ref_pol_no;
            v_inv.assd_no := b_rec.assd_no;
            v_inv.assd_name := b_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := b_rec.collection_amt;
            v_inv.premium_amt := b_rec.premium_amt;
            v_inv.tax_amt := b_rec.tax_amt;
            v_inv.collection_amt1 := b_rec.collection_amt1;
            v_inv.premium_amt1 := b_rec.premium_amt1;
            v_inv.tax_amt1 := b_rec.tax_amt1;
            v_inv.prem_vatable := b_rec.prem_vatable;
            v_inv.prem_vat_exempt := b_rec.prem_vat_exempt;
            v_inv.prem_zero_rated := b_rec.prem_zero_rated;
            v_inv.rev_gacc_tran_id := b_rec.tran_id;
            
            v_inv.currency_rt := b_rec.currency_rt;   -- (a)
            v_inv.policy_no := get_policy_no(b_rec.policy_id);
            v_inv.currency_cd := b_rec.currency_cd;   -- (a)
            --v_inv.or_print_tag := b_rec.or_print_tag;
            PIPE ROW (v_inv);
         END LOOP;

         RETURN;
      END IF;
    END get_gdcp_invoice_listing;
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  05.14.2012
    **  Reference By : (GIACS007 -  Direct Premium Collections)
    **  Description  : prem seq no when validate trigger
    */
    PROCEDURE validate_giacs007_prem_seq_no (
        p_gacc_tran_id            IN  giac_acctrans.tran_id%TYPE,
        p_prem_seq_no             IN  giac_aging_soa_details.prem_seq_no%TYPE,
        p_iss_cd                  IN  giac_aging_soa_details.iss_cd%TYPE,
        p_transaction_type          IN  giac_direct_prem_collns.transaction_type%TYPE,
        p_mesg                    OUT VARCHAR2,
        p_alert_msg               OUT VARCHAR2
    ) IS
        v_exists                        VARCHAR2(1);
        v_alert_button                  NUMBER;
        --v_timer_id                      timer;
        v_balance_amt_due              NUMBER := 0; 
        v_bill_no                      VARCHAR2(1000);  
        v_policy_id                  gipi_invoice.policy_id%type;  
        v_param_paytUnpd             VARCHAR2(1);                   
        v_balance_amt_due_endt       NUMBER := 0;                  
        v_endt_bill_no               VARCHAR2(1000);            
        v_bill_nos   				 VARCHAR2(2000);
        v_ref_nos    				 VARCHAR2(2000);
        v_check_tax                  VARCHAR2(1) := 'Y';                 
        v_check_back                 VARCHAR2(1) := 'N';
        v_check_tax                  VARCHAR2(1) := 'Y';                 
        v_check_back                 VARCHAR2(1) := 'N';
    BEGIN
        FOR i IN (SELECT taxable_prem_amt, taxexempt_prem_amt, zerorated_prem_amt
                    FROM gipi_inv_tax
                   WHERE iss_cd = p_iss_cd
                     AND prem_seq_no = p_prem_seq_no
                     AND tax_cd = giacp.n('EVAT'))
        LOOP
        
            IF i.taxable_prem_amt IS NULL
               OR i.taxexempt_prem_amt IS NULL
               OR i.zerorated_prem_amt IS NULL THEN
                
                p_mesg := 'There is no premium in GIPI_INV_TAX table for this bill. Please coordinate with your IT to resolve this problem.';
                RETURN;
            END IF;  
        END LOOP;
        
        IF ((   p_transaction_type = 2
           OR p_transaction_type = 4)
          AND p_transaction_type IS NOT NULL
          AND p_iss_cd      IS NOT NULL
          AND p_prem_seq_no IS NOT NULL) THEN
            
            check_comm_payts(p_transaction_type, p_iss_cd, p_prem_seq_no, v_bill_nos, v_ref_nos);
                    
            IF v_bill_nos IS NOT NULL THEN
                --p_mesg := 'The commission of bill no. '||v_bill_nos||' is already settled. Please cancel the commission payment first before using this bill.'||CHR(13)||CHR(13)||
                --          'Reference No.: '||CHR(13)||v_ref_nos,'I',TRUE);
                p_mesg := 'The commission of bill no. '||v_bill_nos||' is already settled. Please cancel the commission payment first before using this bill.'||
                          'Reference No.: '||v_ref_nos;
                RETURN;          
            END IF;
        END IF;
        
        IF p_iss_cd IS NOT NULL AND p_prem_seq_no IS NOT NULL THEN
            BEGIN  
                SELECT policy_id INTO v_policy_id
                  FROM gipi_invoice
                 WHERE iss_cd = p_iss_cd 
                   AND prem_seq_no = p_prem_seq_no ;    
                          
                -- POPULATE_SOA(v_policy_id);
            EXCEPTION    
                    WHEN NO_DATA_FOUND THEN   
                       p_mesg := 'This Issuing Source, Bill No. does not exist.'; --robert 01.23.2013
                       -- p_mesg := 'This Bill No. is invalid for transaction type '||p_transaction_type||'.';
                       RETURN;
            END;
        END IF;
        
        --pina-add ni sir jm, 09.19.2012, sya na lang tanungin nyo pag hindi makapagadd dahil dito :P
        --na QA pass to ni sansy
        /*FOR i IN (
            SELECT a.iss_cd, a.prem_seq_no
              FROM giac_aging_soa_details a, gipi_inv_tax b, gipi_polbasic c
             WHERE 1 = 1
               AND a.iss_cd = b.iss_cd
               AND a.prem_seq_no = b.prem_seq_no
               AND a.total_amount_due = a.balance_amt_due
               AND a.policy_id = c.policy_id
               AND b.tax_cd = giacp.n ('EVAT')
               AND b.tax_allocation = 'F'
               AND c.pol_flag <> '5'
               AND NVL (c.reg_policy_sw, 'Y') = 'Y'
               AND a.total_amount_due <> 0
               AND EXISTS (SELECT   'X'
                               FROM gipi_installment x, giac_aging_soa_details y
                              WHERE x.iss_cd = y.iss_cd 
                                AND x.prem_seq_no = y.prem_seq_no
                             HAVING COUNT (*) > 1
                           GROUP BY x.iss_cd, x.prem_seq_no)  
               AND a.iss_cd = p_iss_cd
               AND a.prem_seq_no = p_prem_seq_no
        ) LOOP
            v_check_tax := 'N';
            EXIT;
        END LOOP;
        
        FOR i IN (
            SELECT iss_cd, prem_seq_no
              FROM gipi_inst_bakup_sr
             WHERE iss_cd = p_iss_cd
                   AND prem_seq_no = p_prem_seq_no
        ) LOOP
            v_check_back := 'Y';
            EXIT;
        END LOOP;*/
        
        /*IF v_check_tax = 'N' AND v_check_back = 'N' THEN
             p_mesg := 'Please change VAT setup to spread in Change Payment Mode.'; -- approved by sansy
             GIPI_INV_TAX_PKG.update_for_change_payment(p_iss_cd, p_prem_seq_no);
             RETURN;
        END IF;*/
               
        v_param_paytUnpd := UPPER(NVL(giacp.v('ALLOW_PAYT_OF_UNPD_PART_PAID_POL'), 'P'));
        
        FOR rec IN (
            SELECT   a1.policy_id, a1.iss_cd||' - '||a1.prem_seq_no bill_no,
                     b1.endt_seq_no, b1.reg_policy_sw --added by CarloR SR 5548 07.05.2016
                FROM gipi_invoice a1,
                     gipi_polbasic b1,
                     (SELECT a2.policy_id,
                             b2.line_cd,
                             b2.subline_cd,
                             b2.iss_cd,
                             b2.issue_yy,
                             b2.pol_seq_no,
                             b2.renew_no
                        FROM gipi_invoice a2, gipi_polbasic b2
                       WHERE a2.iss_cd = p_iss_cd
                         AND a2.prem_seq_no =p_prem_seq_no
                         AND b2.policy_id = a2.policy_id) c
               WHERE b1.policy_id = a1.policy_id
                 AND b1.line_cd = c.line_cd
                 AND b1.subline_cd = c.subline_cd
                 AND b1.iss_cd = c.iss_cd
                 AND b1.issue_yy = c.issue_yy
                 AND b1.pol_seq_no = c.pol_seq_no
                 AND b1.renew_no = c.renew_no
                 AND a1.policy_id < c.policy_id
            ORDER BY 2
        ) LOOP
        	IF NVL(rec.reg_policy_sw, 'Y') = 'Y' THEN --added by CarloR SR 5548 07.05.2016
	            FOR i IN (
	                SELECT BALANCE_AMT_DUE, iss_cd||' - '||prem_seq_no ||' - ' ||inst_no bill_no  
	                  FROM GIAC_AGING_SOA_DETAILS
	                 WHERE POLICY_ID = rec.policy_id    )
	            LOOP
	                IF v_param_paytUnpd = 'P' THEN   -- a
	                    IF rec.endt_seq_no = 0 THEN    -- b 
	                        v_balance_amt_due := v_balance_amt_due + i.balance_amt_due;
	                        IF i.balance_amt_due <> 0 THEN
	                            v_bill_no := v_bill_no||i.bill_no||', ';
	                        END IF;
	                    ELSE                               
	                        v_balance_amt_due_endt := v_balance_amt_due_endt + i.balance_amt_due;
	                        IF i.balance_amt_due <> 0 THEN
	                            v_endt_bill_no := v_endt_bill_no||i.bill_no||', ';
	                        END IF;
	                    END IF ;                      -- b
	                ELSIF v_param_paytUnpd <> 'P' THEN 
	                    v_balance_amt_due := v_balance_amt_due + i.balance_amt_due;
	                    IF i.balance_amt_due <> 0 THEN
	                        v_bill_no := v_bill_no||i.bill_no||', ';
	                    END IF;
	                END IF;           -- end of a 
	            END LOOP;
	        END IF; --END
        END LOOP;
        
        v_bill_no := RTRIM(v_bill_no, ', ');
        
        IF v_balance_amt_due <> 0 THEN
            IF v_param_paytUnpd = 'N' THEN                  -- 12.16.2011 jhing modified condition  for NO checking since earlier condition is incorrect 
                --SET_ALERT_PROPERTY('balance_amt_due',ALERT_MESSAGE_TEXT,'Bill Number/s '||v_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?');
                --v_alert_button := show_alert('balance_amt_due');
                p_alert_msg := 'balance_amt_due';
                p_mesg := 'Bill Number/s '||v_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?';
                RETURN;
            END IF;
            
            IF v_param_paytUnpd = 'P' OR v_param_paytUnpd = 'E' THEN   -- 11.25.2011 jhing modified condition 
                --msg_alert('Bill Number/s '||v_bill_no||' is/are not yet fully paid. Settle it first before processing the payment for this endorsement','W',FALSE);
                p_mesg := 'Bill Number/s '||v_bill_no||' is/are not yet fully paid. Settle it first before processing the payment for this endorsement.';
                RETURN;
            END IF;
        END IF;
        
        IF v_balance_amt_due = 0 AND v_param_paytUnpd = 'P' AND     v_balance_amt_due_endt <> 0  THEN 
            --SET_ALERT_PROPERTY('balance_amt_due',ALERT_MESSAGE_TEXT,'Bill Number/s '||v_endt_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?');
            --v_alert_button := show_alert('balance_amt_due');
            p_alert_msg := 'balance_amt_due';
            p_mesg := 'Bill Number/s '||v_endt_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?';
            RETURN;
        END IF;   
        
        check_premium_payt_for_special(p_iss_cd, p_prem_seq_no, p_mesg);
        IF p_mesg LIKE 'This is a Special Policy.' THEN
            p_alert_msg := 'special';
			RETURN;
        ELSIF p_mesg LIKE 'Premium payment for Special Policy is not allowed.' THEN --robert 12.18.12 added condition
            p_alert_msg := 'special2';
			RETURN;
        END IF;
        
        validate_open_policy(p_prem_seq_no, p_iss_cd, p_mesg);
        IF p_mesg LIKE 'This is an Open Policy.' THEN
            p_alert_msg := 'special';
			RETURN;
        END IF;
    
    END validate_giacs007_prem_seq_no;   
    
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  06.26.2012
    **  Reference By : (GIACS007 -  Direct Premium Collections)
    **  Description  : checks if the installment exists
    */
     FUNCTION check_existing_installment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    ) RETURN VARCHAR2 IS
		v_message   VARCHAR2(120);
        v_temp      NUMBER(12,2);
        v_continue  VARCHAR2(1) := 'N';
        v_sign      NUMBER(1);
    BEGIN
    	BEGIN
          SELECT SIGN (prem_amt + NVL (tax_amt, 0))
            INTO v_sign
            FROM gipi_invoice
           WHERE iss_cd = p_iss_cd 
             AND prem_seq_no = p_prem_seq_no;

          IF v_sign = 1 AND p_transaction_type IN (1, 2) THEN
             v_continue := 'Y';
          ELSIF v_sign = -1 AND p_transaction_type IN (3, 4) THEN
             v_continue := 'Y';
          ELSIF v_sign = 0 THEN
             v_continue := 'Y';
          ELSE
             v_message :=
                   'This Bill No. '
                || p_iss_cd
                || '-'
                || p_prem_seq_no
                || ' is invalid for transaction type '
                || TO_CHAR (p_transaction_type)
                || '. ';
          END IF;
        END;
        
        IF v_continue = 'Y' THEN
        	IF p_transaction_type = 1 THEN
	            BEGIN
	                SELECT 1 INTO v_temp
	                  FROM giac_aging_soa_details 
	                       WHERE balance_amt_due > 0
	                         AND inst_no         = p_inst_no 
	                         AND prem_seq_no     = p_prem_seq_no 
	                         AND iss_cd          = p_iss_cd ;
	            EXCEPTION
	                WHEN NO_DATA_FOUND THEN
	                    v_message := 'This installment '||p_iss_cd||'-'||TO_CHAR(p_prem_seq_no)||'-'||TO_CHAR(p_inst_no)||' is already settled.';   
	                WHEN TOO_MANY_ROWS THEN
	                    null; 
	            END;
	        ELSIF p_transaction_type = 2 THEN
	            BEGIN
	                SELECT SUM(collection_amt) INTO v_temp
	                  FROM giac_direct_prem_collns a,
	                         giac_acctrans b           
	                   WHERE NOT EXISTS(SELECT 'x'
	                                      FROM giac_reversals aa, 
	                                           giac_acctrans  bb
	                                     WHERE aa.reversing_tran_id = bb.tran_id 
	                                       AND bb.tran_flag        != 'D'
	                               AND aa.gacc_tran_id      = b.tran_id)
	                     AND a.gacc_tran_id   = b.tran_id
	                     AND b.tran_flag     != 'D'                                
	                       AND inst_no          = p_inst_no 
	                     AND b140_prem_seq_no = p_prem_seq_no 
	                     AND b140_iss_cd      = p_iss_cd 
	                     --AND b.tran_id        = NVL(variables.v_inv_tran_id, b.tran_id)   --romved for now :)
	                     AND a.rev_gacc_tran_id IS NULL
	                   GROUP BY b140_iss_cd, b140_prem_seq_no, inst_no
	                           ,tran_id 
	                  HAVING SUM(collection_amt) > 0;
	            EXCEPTION
	                WHEN NO_DATA_FOUND THEN
	                    v_message := 'This Installment No. does not exist.'; 
	                WHEN TOO_MANY_ROWS THEN
	                    null;  
	            END;
	        ELSIF p_transaction_type = 3 THEN
	            BEGIN
	                SELECT 1 INTO v_temp
	                  FROM giac_aging_soa_details 
	                       WHERE balance_amt_due < 0
	                         AND inst_no         = p_inst_no 
	                         AND prem_seq_no     = p_prem_seq_no 
	                         AND iss_cd          = p_iss_cd ;
	            EXCEPTION
	                WHEN NO_DATA_FOUND THEN
	                    v_message := 'This installment '||p_iss_cd||'-'||TO_CHAR(p_prem_seq_no)||'-'||TO_CHAR(p_inst_no)||' is already settled.'; 
	                WHEN TOO_MANY_ROWS THEN
	                    null;          
	            END;
	        ELSIF p_transaction_type = 4 THEN
	            BEGIN
	                SELECT SUM(collection_amt) INTO v_temp
	                  FROM giac_direct_prem_collns a,
	                         giac_acctrans b           
	                 WHERE NOT EXISTS(SELECT 'x'
	                                  FROM giac_reversals aa, 
	                                           giac_acctrans  bb
	                                     WHERE aa.reversing_tran_id = bb.tran_id 
	                                       AND bb.tran_flag        != 'D'
	                                   AND aa.gacc_tran_id      = b.tran_id)
	                   AND a.gacc_tran_id   = b.tran_id
	                   AND b.tran_flag     != 'D'                                
	                   AND inst_no          = p_inst_no 
	                   AND b140_prem_seq_no = p_prem_seq_no 
	                   AND b140_iss_cd      = p_iss_cd 
	                  -- AND b.tran_id        = NVL(variables.v_inv_tran_id, b.tran_id)  --jason 03032009
	                   AND rev_gacc_tran_id IS NULL
	                 GROUP BY b140_iss_cd, b140_prem_seq_no, inst_no
	                           ,tran_id --jason 03032009
	                  HAVING SUM(collection_amt) < 0;
	            EXCEPTION
	                WHEN NO_DATA_FOUND THEN
	                    v_message := 'This Installment No. does not exist.'; 
	                WHEN TOO_MANY_ROWS THEN
	                    null;  
	            END;
	        END IF;
        END IF;
    
        RETURN v_message;
    END check_existing_installment;
    

     /*
    **  Created by   :  D.Alcantara
    **  Date Created :  09.19.2012
    **  Reference By : (GIACS007 -  Direct Premium Collections)
    **  Description  : to identify if bill 
    */
--	FUNCTION check_special_bill (
--		p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
--		p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE             
--	) RETURN VARCHAR2 IS
--		v_spcl_bill          VARCHAR2(1) := 'N';
--	BEGIN
--		BEGIN
--			SELECT 'Y'
--			  INTO v_spcl_bill
--			  FROM gipi_inst_bakup_sr
--			 WHERE iss_cd = p_iss_cd
--			   AND prem_seq_no = p_prem_seq_no;
--		EXCEPTION 
--			 WHEN no_data_found THEN
--			 NULL;
--		END;
--		
--		RETURN v_spcl_bill;
--	END check_special_bill;
    
   /*
   **  Created by   :  Robert Virrey
   **  Date Created :  08.24.2012
   **  Reference By : (GIACS007 - DIRECT PREMIUM COLLECTIONS)
   **  Description  : Retrieves listing of tax collections
   */
    FUNCTION get_prem_collns_listing (
       p_iss_cd         giac_direct_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    giac_direct_prem_collns.b140_prem_seq_no%TYPE
    )
       RETURN giac_prem_collns_tab PIPELINED
    IS
       v_prems   giac_prem_collns_type;

       CURSOR cursor_prem
       IS
          SELECT a.peril_cd, c.peril_name,
                 ROUND (e.currency_rt * a.prem_amt, 2) prem_amt,
                 a.prem_seq_no, a.iss_cd--, b.gacc_tran_id
            FROM gipi_invperil a,
                 --giac_direct_prem_collns b,
                 giis_peril c,
                 gipi_polbasic d,
                 gipi_invoice e
            WHERE a.iss_cd = p_iss_cd
             AND a.prem_seq_no = p_prem_seq_no
             AND c.line_cd = d.line_cd
             AND c.peril_cd = a.peril_cd
             AND d.policy_id = e.policy_id
             AND e.prem_seq_no = a.prem_seq_no
             AND e.iss_cd = a.iss_cd;
    BEGIN
       FOR loop_prems IN cursor_prem
       LOOP
          v_prems.dsp_peril_cd := loop_prems.peril_cd;
          v_prems.dsp_peril_name := loop_prems.peril_name;
          v_prems.dsp_prem_amt := loop_prems.prem_amt;
          v_prems.b140_prem_seq_no := loop_prems.prem_seq_no;
          v_prems.b140_iss_cd := loop_prems.iss_cd;
          PIPE ROW (v_prems);
       END LOOP;
    END get_prem_collns_listing;
	
	PROCEDURE get_direct_prem_collns_sum (
   		p_gacc_tran_id            IN  giac_acctrans.tran_id%TYPE,
		p_total_collection		  OUT NUMBER,
		p_total_premium		      OUT NUMBER,
		p_total_tax				  OUT NUMBER
    ) IS
		
	BEGIN
		SELECT sum(collection_amt), sum(premium_amt), sum(tax_amt)
		  INTO p_total_collection, p_total_premium, p_total_tax
		  FROM giac_direct_prem_collns
		 WHERE gacc_tran_id = p_gacc_tran_id;
	EXCEPTION 
		WHEN NO_DATA_FOUND THEN
			p_total_collection := 0;
			p_total_premium := 0;
			p_total_tax := 0;
	END;
    
    /*
    **  Created by   :  Robert John Virrey
    **  Date Created :  01.10.2013
    **  Reference By : listing for LOV in giacs007 in query mode
    */ 
    FUNCTION get_gdcp_invoice_listing2 (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE, 
        p_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE,        
        p_filter_ref_inv_no  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692 
        p_filter_payt_ref_no VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_coll_amt    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_prem_amt    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_tax_amt     NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_assd_name   VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_intm_name   VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_ref_pol_no  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_endt_yy     NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_endt_seq_no NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_endt_iss_cd VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_issue_yy    NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_line_cd     VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_pol_seq_no  NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_filter_subline_cd  VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_order_by           VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_asc_desc_flag      VARCHAR2,      --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_first_row          NUMBER,        --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        p_last_row           NUMBER         --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692

    ) RETURN giac_direct_prem_collns_tab PIPELINED IS
        v_inv           giac_direct_prem_collns_type;
        v_intm_no       VARCHAR2(50);
        v_intm_name     VARCHAR2(4000);
        v_sql     VARCHAR2(32767);          --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        TYPE      cur_type IS REF CURSOR;   --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692
        c         cur_type;                 --added by pjsantos @pcic 09/27/2016, for optimization GENQA 5692

        
        /*CURSOR a IS
            SELECT a.iss_cd, a.prem_seq_no, a.inst_no, a.collection_amt, a.premium_amt,
                   a.tax_amt, a.collection_amt1, a.premium_amt1, a.tax_amt1, a.ref_inv_no,
                   a.policy_id, a.pol_line_cd, a.pol_subline_cd, a.pol_iss_cd,
                   a.pol_issue_yy, a.pol_seq_no, a.pol_renew_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.endt_type, a.ref_pol_no, a.assd_no, a.assd_name,
                   a.currency_rt, a.currency_cd
              FROM giac_invoice_list_v1 a, giis_intermediary b, gipi_comm_invoice c
             WHERE p_transaction_type = 1
               AND b.intm_no(+) = c.intrmdry_intm_no
               AND c.iss_cd(+) = a.iss_cd
               AND c.prem_seq_no(+) = a.prem_seq_no
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND (   (p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = a.prem_seq_no)
                   )
               AND a.inst_no = NVL (p_inst_no, a.inst_no)
               AND a.collection_amt > 0
            UNION
            SELECT a.iss_cd, a.prem_seq_no, a.inst_no, a.collection_amt, a.premium_amt,
                   a.tax_amt, a.collection_amt1, a.premium_amt1, a.tax_amt1, a.ref_inv_no,
                   a.policy_id, a.pol_line_cd, a.pol_subline_cd, a.pol_iss_cd,
                   a.pol_issue_yy, a.pol_seq_no, a.pol_renew_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.endt_type, a.ref_pol_no, a.assd_no, a.assd_name,
                   a.currency_rt, a.currency_cd
              FROM giac_invoice_list_v1 a, giis_intermediary b, gipi_comm_invoice c
             WHERE p_transaction_type = 3
               AND b.intm_no(+) = c.intrmdry_intm_no
               AND c.iss_cd(+) = a.iss_cd
               AND c.prem_seq_no(+) = a.prem_seq_no
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND (   (p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = a.prem_seq_no)
                   )
               AND a.inst_no = NVL (p_inst_no, a.inst_no)
               AND collection_amt < 0;
               
        CURSOR b IS    
            SELECT a.tran_id, a.iss_cd, a.prem_seq_no, a.inst_no, a.collection_amt, a.premium_amt,
                   a.tax_amt, a.collection_amt1, a.premium_amt1, a.tax_amt1, a.ref_inv_no,
                   a.payt_ref_no, a.policy_id, a.pol_line_cd, a.pol_subline_cd, a.pol_iss_cd,
                   a.pol_issue_yy, a.pol_seq_no, a.pol_renew_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.endt_type, a.ref_pol_no, a.assd_no, a.assd_name,
                   a.prem_vatable, a.prem_vat_exempt, a.prem_zero_rated, a.rev_gacc_tran_id,
                   a.currency_rt, a.currency_cd
              FROM giac_invoice_list_web_v2 a, giis_intermediary b, gipi_comm_invoice c
             WHERE p_transaction_type = 2
               AND b.intm_no(+) = c.intrmdry_intm_no
               AND c.iss_cd(+) = a.iss_cd
               AND c.prem_seq_no(+) = a.prem_seq_no
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND (   (p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = a.prem_seq_no)
                   )
               AND a.inst_no = NVL (p_inst_no, a.inst_no)
               AND a.collection_amt > 0
            UNION
            SELECT a.tran_id, a.iss_cd, a.prem_seq_no, a.inst_no, a.collection_amt, a.premium_amt,
                   a.tax_amt, a.collection_amt1, a.premium_amt1, a.tax_amt1, a.ref_inv_no,
                   a.payt_ref_no, a.policy_id, a.pol_line_cd, a.pol_subline_cd, a.pol_iss_cd,
                   a.pol_issue_yy, a.pol_seq_no, a.pol_renew_no, a.endt_iss_cd, a.endt_yy,
                   a.endt_seq_no, a.endt_type, a.ref_pol_no, a.assd_no, a.assd_name,
                   a.prem_vatable, a.prem_vat_exempt, a.prem_zero_rated, a.rev_gacc_tran_id,
                   a.currency_rt, a.currency_cd
              FROM giac_invoice_list_web_v2 a, giis_intermediary b, gipi_comm_invoice c
             WHERE p_transaction_type = 4
               AND b.intm_no(+) = c.intrmdry_intm_no
               AND c.iss_cd(+) = a.iss_cd
               AND c.prem_seq_no(+) = a.prem_seq_no
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND (   (p_prem_seq_no IS NULL AND 1 = 1)
                    OR (p_prem_seq_no IS NOT NULL AND p_prem_seq_no = a.prem_seq_no)
                   )
               AND a.inst_no = NVL (p_inst_no, a.inst_no)
               AND collection_amt < 0;*/
    BEGIN
      IF p_transaction_type IN (1, 3) THEN     
        /* FOR a_rec IN A
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = a_rec.iss_cd
                                AND b.prem_seq_no = a_rec.prem_seq_no)
            LOOP
               DBMS_OUTPUT.put_line (   'isscd and premseqno: '
                                     || a_rec.iss_cd
                                     || ' '
                                     || a_rec.prem_seq_no
                                    );

               IF intm_rec.num = 1
               THEN
                  DBMS_OUTPUT.put_line ('IN');
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  DBMS_OUTPUT.put_line ('OUT');
                  v_intm_no := intm_rec.intm_no;
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.b140_iss_cd := a_rec.iss_cd;
            v_inv.b140_prem_seq_no := a_rec.prem_seq_no;
            v_inv.inst_no := a_rec.inst_no;
            v_inv.ref_inv_no := a_rec.ref_inv_no;
            v_inv.policy_id := a_rec.policy_id;
            v_inv.line_cd := a_rec.pol_line_cd;
            v_inv.subline_cd := a_rec.pol_subline_cd;
            v_inv.pol_iss_cd := a_rec.pol_iss_cd;
            v_inv.issue_yy := a_rec.pol_issue_yy;
            v_inv.pol_seq_no := a_rec.pol_seq_no;
            v_inv.pol_renew_no := a_rec.pol_renew_no;
            v_inv.endt_iss_cd := a_rec.endt_iss_cd;
            v_inv.endt_yy := a_rec.endt_yy;
            v_inv.endt_seq_no := a_rec.endt_seq_no; --uncommented by robert test
            --v_inv.endt_type := a_rec.endt_type;
            v_inv.ref_pol_no := a_rec.ref_pol_no;
            v_inv.assd_no := a_rec.assd_no;
            v_inv.assd_name := a_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := a_rec.collection_amt;
            v_inv.premium_amt := a_rec.premium_amt;
            v_inv.tax_amt := a_rec.tax_amt;
            v_inv.collection_amt1 := a_rec.collection_amt1;
            v_inv.premium_amt1 := a_rec.premium_amt1;
            v_inv.tax_amt1 := a_rec.tax_amt1;
            v_inv.currency_rt := a_rec.currency_rt;    -- uncommented by d.alcantara, 07-31-2012 (a)
            v_inv.policy_no := get_policy_no(a_rec.policy_id);
            v_inv.currency_cd := a_rec.currency_cd;    -- (a)       
            PIPE ROW (v_inv);
         END LOOP;*/
         v_sql := v_sql || 'SELECT mainsql.*
  FROM (SELECT COUNT (1) OVER () count_, outersql.*
          FROM (SELECT ROWNUM rownum_, innersql.*
                  FROM (SELECT  *
                                FROM 
                       (SELECT a.iss_cd,
                               a.prem_seq_no,
                               a.inst_no,
                               a.collection_amt,
                               a.premium_amt,
                               a.tax_amt,
                               a.collection_amt1,
                               a.premium_amt1,
                               a.tax_amt1,
                               a.ref_inv_no,
                               a.policy_id,
                               a.pol_line_cd,
                               a.pol_subline_cd, 
                               a.pol_iss_cd,
                               a.pol_issue_yy,
                               a.pol_seq_no,
                               a.pol_renew_no,
                               a.endt_iss_cd,
                               a.endt_yy,
                               a.endt_seq_no,
                               a.endt_type,
                               a.ref_pol_no,
                               a.assd_no,
                               a.assd_name,
                               a.currency_rt,
                               a.currency_cd,
                               (SELECT    line_cd || ''-'' || subline_cd || ''-'' || iss_cd || ''-'' || LTRIM (TO_CHAR (issue_yy, ''09''))
                                       || ''-'' || LTRIM (TO_CHAR (pol_seq_no, ''0999999'')) || ''-'' || LTRIM (TO_CHAR (renew_no, ''09''))
                                       || DECODE ( NVL (endt_seq_no, 0),0, '''','' / '' || endt_iss_cd || ''-''|| LTRIM (TO_CHAR (endt_yy, ''09''))
                                       || ''-'' || LTRIM (TO_CHAR (endt_seq_no, ''0999999''))) policy
                                  FROM gipi_polbasic
                                 WHERE policy_id = a.policy_id) policy_no,
                               (SELECT c.intm_no FROM giis_intermediary c, gipi_comm_invoice b WHERE     c.intm_no = b.intrmdry_intm_no
                                    AND b.iss_cd = A.iss_cd
                                    AND b.prem_seq_no = A.prem_seq_no  
                                    AND ROWNUM = 1) intm_no,
                               (SELECT c.intm_name FROM giis_intermediary c, gipi_comm_invoice b WHERE     c.intm_no = b.intrmdry_intm_no
                                    AND b.iss_cd = A.iss_cd
                                    AND b.prem_seq_no = A.prem_seq_no  
                                    AND ROWNUM = 1) intm_name            
                           FROM giac_invoice_list_v1 a                             
                         WHERE   1=1
                               AND a.iss_cd = NVL (:p_iss_cd, a.iss_cd)
                               AND (   (:p_prem_seq_no IS NULL AND 1 = 1)
                                    OR (    :p_prem_seq_no IS NOT NULL
                                        AND :p_prem_seq_no = a.prem_seq_no))
                               AND a.inst_no = NVL (:p_inst_no, a.inst_no)';            
         
           IF p_transaction_type = 1
              THEN 
                 v_sql := v_sql ||' AND a.collection_amt > 0';
          ELSIF p_transaction_type = 3
              THEN 
                 v_sql := v_sql ||' AND a.collection_amt < 0';
          END IF;


          v_sql := v_sql ||     ') WHERE  1=1 ';
          IF p_filter_ref_inv_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(ref_inv_no) LIKE UPPER('||p_filter_ref_inv_no||')';
          END IF;
          IF p_filter_coll_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND collection_amt ='|| p_filter_coll_amt;
          END IF;
          IF p_filter_prem_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND premium_amt = '||p_filter_prem_amt;
          END IF;
          IF p_filter_tax_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND tax_amt = '||p_filter_tax_amt;
          END IF;
          IF p_filter_assd_name IS NOT NULL
            THEN            
              v_sql := v_sql ||' AND UPPER(assd_name) LIKE UPPER('''||  REPLACE(p_filter_assd_name, '''', '''''') ||''')';         
          END IF;
          IF p_filter_intm_name IS NOT NULL 
            THEN
              v_sql := v_sql || ' AND UPPER(intm_name) LIKE UPPER('''|| REPLACE(p_filter_intm_name, '''', '''''')  ||''')';
          END IF;
          IF p_filter_ref_pol_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(ref_pol_no) = UPPER(' || p_filter_ref_pol_no ||')';
          END IF;
          IF p_filter_endt_yy IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_yy) = '|| UPPER(p_filter_endt_yy);
          END IF;
          IF p_filter_endt_seq_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_seq_no) = '|| UPPER(p_filter_endt_seq_no);
          END IF;
          IF p_filter_endt_iss_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_iss_cd) = UPPER('''||p_filter_endt_iss_cd||''')';
          END IF;
          IF p_filter_issue_yy IS NOT NULL
            THEN
              v_sql := v_sql || ' AND pol_issue_yy = '|| p_filter_issue_yy;
          END IF;
          IF p_filter_line_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_line_cd) = UPPER('''||p_filter_line_cd||''')';
          END IF;
          IF p_filter_pol_seq_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_seq_no) = '|| UPPER(p_filter_pol_seq_no);
          END IF;
          IF p_filter_subline_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_subline_cd) = UPPER('''||p_filter_subline_cd||''')';
          END IF;       
          
          IF p_order_by IS NOT NULL
            THEN 
                IF p_order_by = 'issCd premSeqNo'  
                THEN        
                 v_sql := v_sql || ' ORDER BY  prem_seq_no ';                 
                ELSIF  p_order_by = 'instNo'
                THEN
                  v_sql := v_sql || ' ORDER BY inst_no ';
                ELSIF  p_order_by = 'refInvNo'
                THEN
                  v_sql := v_sql || ' ORDER BY ref_inv_no ';
                ELSIF  p_order_by = 'collAmt'
                 THEN
                  v_sql := v_sql || ' ORDER BY collection_amt ';
                ELSIF  p_order_by = 'premAmt'
                 THEN
                 v_sql := v_sql || ' ORDER BY premium_amt '; 
                ELSIF  p_order_by = 'taxAmt'
                 THEN
                 v_sql := v_sql || ' ORDER BY tax_amt ';                        
           END IF;
        
            IF p_asc_desc_flag IS NOT NULL
                THEN
                v_sql := v_sql || p_asc_desc_flag;
            ELSE
                v_sql := v_sql || ' ASC ';
            END IF; 
             IF p_order_by = 'issCd premSeqNo' 
                THEN  
                  v_sql := v_sql || ', inst_no asc ';
             ELSE                 
                  v_sql := v_sql || ', prem_seq_no asc ';
             END IF; 
          ELSE
          v_sql := v_sql || ' ORDER BY prem_seq_no DESC ';
            
          END IF;               
          
          v_sql := v_sql || ') innersql) outersql) mainsql '; 
          IF p_first_row IS NOT NULL AND p_last_row IS NOT NULL--Modified by pjsantos 10/19/2016,added condition to prevent missing expression error in dated checks GENQA 5787
           THEN 
          v_sql := v_sql || ' WHERE rownum_ BETWEEN ' || p_first_row ||' AND ' || p_last_row;
          END IF;
          
         
          OPEN C FOR v_sql USING    p_iss_cd, p_prem_seq_no, p_prem_seq_no, p_prem_seq_no, p_inst_no;
            LOOP
                FETCH c INTO 
                v_inv.count_, 
                v_inv.rownum_,                               
                v_inv.b140_iss_cd,
                v_inv.b140_prem_seq_no,
                v_inv.inst_no,
                v_inv.collection_amt,
                v_inv.premium_amt,
                v_inv.tax_amt,
                v_inv.collection_amt1,
                v_inv.premium_amt1,
                v_inv.tax_amt1,
                v_inv.ref_inv_no,
                v_inv.policy_id,
                v_inv.line_cd,
                v_inv.subline_cd,
                v_inv.pol_iss_cd,
                v_inv.issue_yy,
                v_inv.pol_seq_no,
                v_inv.pol_renew_no,
                v_inv.endt_iss_cd,
                v_inv.endt_yy,
                v_inv.endt_seq_no,
                v_inv.endt_type,
                v_inv.ref_pol_no,
                v_inv.assd_no,
                v_inv.assd_name,
                v_inv.currency_rt,
                v_inv.currency_cd,
                v_inv.policy_no,
                v_inv.intm_no,
                v_inv.intm_name;                
               
                EXIT WHEN c%NOTFOUND;              
                PIPE ROW (v_inv);
            END LOOP;      
            CLOSE c; 
            RETURN;
      ELSIF p_transaction_type IN (2, 4)
      THEN
        /* FOR b_rec IN b
         LOOP
            v_intm_no := NULL;
            v_intm_name := NULL;

            FOR intm_rec IN (SELECT A.intm_no, A.intm_name, ROWNUM num
                               FROM giis_intermediary A, gipi_comm_invoice b
                              WHERE A.intm_no = b.intrmdry_intm_no
                                AND b.iss_cd = b_rec.iss_cd
                                AND b.prem_seq_no = b_rec.prem_seq_no)
            LOOP
               IF intm_rec.num = 1
               THEN
                  v_intm_no := intm_rec.intm_no;
                  v_intm_name := intm_rec.intm_name;
               ELSE
                  --v_intm_no := v_intm_no || ' / ' || intm_rec.intm_no;
                  v_intm_no := v_intm_no || intm_rec.intm_no;
                  v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
               END IF;
            END LOOP;

            v_inv.tran_id := b_rec.tran_id;
            v_inv.b140_iss_cd := b_rec.iss_cd;
            v_inv.b140_prem_seq_no := b_rec.prem_seq_no;
            v_inv.inst_no := b_rec.inst_no;
            v_inv.ref_inv_no := b_rec.ref_inv_no;
            v_inv.payt_ref_no := b_rec.payt_ref_no;
            v_inv.policy_id := b_rec.policy_id;
            v_inv.line_cd := b_rec.pol_line_cd;
            v_inv.subline_cd := b_rec.pol_subline_cd;
            v_inv.pol_iss_cd := b_rec.pol_iss_cd;
            v_inv.issue_yy := b_rec.pol_issue_yy;
            v_inv.pol_seq_no := b_rec.pol_seq_no;
            v_inv.pol_renew_no := b_rec.pol_renew_no;
            v_inv.endt_iss_cd := b_rec.endt_iss_cd;
            v_inv.endt_yy := b_rec.endt_yy;
            v_inv.endt_seq_no := b_rec.endt_seq_no;
            --v_inv.endt_type := b_rec.endt_type;
            v_inv.ref_pol_no := b_rec.ref_pol_no;
            v_inv.assd_no := b_rec.assd_no;
            v_inv.assd_name := b_rec.assd_name;
            v_inv.intm_no := v_intm_no;
            v_inv.intm_name := v_intm_name;
            v_inv.collection_amt := b_rec.collection_amt;
            v_inv.premium_amt := b_rec.premium_amt;
            v_inv.tax_amt := b_rec.tax_amt;
            v_inv.collection_amt1 := b_rec.collection_amt1;
            v_inv.premium_amt1 := b_rec.premium_amt1;
            v_inv.tax_amt1 := b_rec.tax_amt1;
            v_inv.prem_vatable := b_rec.prem_vatable;
            v_inv.prem_vat_exempt := b_rec.prem_vat_exempt;
            v_inv.prem_zero_rated := b_rec.prem_zero_rated;
            v_inv.rev_gacc_tran_id := b_rec.tran_id;
            
            v_inv.currency_rt := b_rec.currency_rt;   -- (a)
            v_inv.policy_no := get_policy_no(b_rec.policy_id);
            v_inv.currency_cd := b_rec.currency_cd;   -- (a)
            --v_inv.or_print_tag := b_rec.or_print_tag;
            PIPE ROW (v_inv);
         END LOOP;*/
         v_sql := v_sql || 'SELECT mainsql.*
  FROM (SELECT ROWNUM ROWNUM_, outersql.*
          FROM (SELECT  COUNT (1) OVER () count_, innersql.*
                  FROM (SELECT  *
                          FROM (SELECT a.tran_id,
                                       a.iss_cd,
                                       a.prem_seq_no,
                                       a.inst_no,
                                       a.collection_amt,
                                       a.premium_amt,
                                       a.tax_amt,
                                       a.collection_amt1,
                                       a.premium_amt1,
                                       a.tax_amt1,
                                       a.ref_inv_no,
                                       a.payt_ref_no,
                                       a.policy_id,
                                       a.pol_line_cd,
                                       a.pol_subline_cd,
                                       a.pol_iss_cd,
                                       a.pol_issue_yy,
                                       a.pol_seq_no,
                                       a.pol_renew_no,
                                       a.endt_iss_cd,
                                       a.endt_yy,
                                       a.endt_seq_no,
                                       a.endt_type,
                                       a.ref_pol_no,
                                       a.assd_no,
                                       a.assd_name,
                                       a.prem_vatable,
                                       a.prem_vat_exempt,
                                       a.prem_zero_rated,
                                       a.rev_gacc_tran_id,
                                       a.currency_rt,
                                       a.currency_cd,
                                       (SELECT    line_cd || ''-'' || subline_cd || ''-'' || iss_cd || ''-'' || LTRIM (TO_CHAR (issue_yy, ''09''))
                                       || ''-'' || LTRIM (TO_CHAR (pol_seq_no, ''0999999'')) || ''-'' || LTRIM (TO_CHAR (renew_no, ''09''))
                                       || DECODE ( NVL (endt_seq_no, 0),0, '''','' / '' || endt_iss_cd || ''-''|| LTRIM (TO_CHAR (endt_yy, ''09''))
                                       || ''-'' || LTRIM (TO_CHAR (endt_seq_no, ''0999999''))) policy
                                  FROM gipi_polbasic
                                 WHERE policy_id = a.policy_id) policy_no,
                               (SELECT c.intm_no FROM giis_intermediary c, gipi_comm_invoice b WHERE     c.intm_no = b.intrmdry_intm_no
                                    AND b.iss_cd = A.iss_cd
                                    AND b.prem_seq_no = A.prem_seq_no                                                                     
                                    AND ROWNUM = 1) intm_no,
                               (SELECT c.intm_name FROM giis_intermediary c, gipi_comm_invoice b WHERE     c.intm_no = b.intrmdry_intm_no
                                    AND b.iss_cd = A.iss_cd
                                    AND b.prem_seq_no = A.prem_seq_no  
                                    AND ROWNUM = 1) intm_name         
                                  FROM giac_invoice_list_web_v2 a   
                                 WHERE 1=1                                  
                                       AND a.iss_cd =
                                              NVL (:p_iss_cd, a.iss_cd)
                                       AND (   (    :p_prem_seq_no IS NULL
                                                AND 1 = 1)
                                            OR (    :p_prem_seq_no
                                                       IS NOT NULL
                                                AND :p_prem_seq_no =
                                                       a.prem_seq_no))
                                       AND a.inst_no =
                                              NVL (:p_inst_no, a.inst_no)';
                     
          IF p_transaction_type = 2
              THEN 
                 v_sql := v_sql ||' AND a.collection_amt > 0';
          ELSIF p_transaction_type = 4
              THEN 
                 v_sql := v_sql ||' AND a.collection_amt < 0';
          END IF;          
                                    
                                       
      v_sql := v_sql ||     ') WHERE  1=1 ';
          IF p_filter_ref_inv_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(ref_inv_no) LIKE UPPER('||p_filter_ref_inv_no||')';
          END IF;
          IF p_filter_coll_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND collection_amt ='|| p_filter_coll_amt;
          END IF;
          IF p_filter_prem_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND premium_amt = '||p_filter_prem_amt;
          END IF;
          IF p_filter_tax_amt IS NOT NULL
            THEN
              v_sql := v_sql || ' AND tax_amt = '||p_filter_tax_amt;
          END IF;
          IF p_filter_assd_name IS NOT NULL
            THEN            
              v_sql := v_sql ||' AND UPPER(assd_name) LIKE UPPER('''||  REPLACE(p_filter_assd_name, '''', '''''') ||''')';         
          END IF;
          IF p_filter_intm_name IS NOT NULL 
            THEN 
              v_sql := v_sql || ' AND UPPER(intm_name) LIKE UPPER('''|| REPLACE(p_filter_intm_name, '''', '''''')  ||''')';
          END IF;
          IF p_filter_ref_pol_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(ref_pol_no) = UPPER(' || p_filter_ref_pol_no ||')';
          END IF;
          IF p_filter_endt_yy IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_yy) = '|| UPPER(p_filter_endt_yy);
          END IF;
          IF p_filter_endt_seq_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_seq_no) = '|| UPPER(p_filter_endt_seq_no);
          END IF;
          IF p_filter_endt_iss_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(endt_iss_cd) = UPPER('''||p_filter_endt_iss_cd||''')';
          END IF;
          IF p_filter_issue_yy IS NOT NULL
            THEN
              v_sql := v_sql || ' AND pol_issue_yy = '|| p_filter_issue_yy;
          END IF;
          IF p_filter_line_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_line_cd) = UPPER('''||p_filter_line_cd||''')';
          END IF;
          IF p_filter_pol_seq_no IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_seq_no) = '|| UPPER(p_filter_pol_seq_no);
          END IF;
          IF p_filter_subline_cd IS NOT NULL
            THEN
              v_sql := v_sql || ' AND UPPER(pol_subline_cd) = UPPER('''||p_filter_subline_cd||''')';
          END IF;       

          IF p_order_by IS NOT NULL
            THEN 
                IF p_order_by = 'issCd premSeqNo'  
                THEN        
                 v_sql := v_sql || ' ORDER BY  prem_seq_no ';                 
                ELSIF  p_order_by = 'instNo'
                THEN
                  v_sql := v_sql || ' ORDER BY inst_no ';
                ELSIF  p_order_by = 'refInvNo'
                THEN
                  v_sql := v_sql || ' ORDER BY ref_inv_no ';
                  
                ELSIF  p_order_by = 'collAmt'
                 THEN
                  v_sql := v_sql || ' ORDER BY collection_amt ';
                ELSIF  p_order_by = 'premAmt'
                 THEN
                 v_sql := v_sql || ' ORDER BY premium_amt '; 
                ELSIF  p_order_by = 'taxAmt'
                 THEN
                 v_sql := v_sql || ' ORDER BY tax_amt '; 
                ELSIF p_order_by = 'paytRefNo'
                 THEN
                 v_sql := v_sql || ' ORDER BY payt_ref_no ';                                       
                END IF;
        
            IF p_asc_desc_flag IS NOT NULL
                THEN
                v_sql := v_sql || p_asc_desc_flag;
            ELSE
                v_sql := v_sql || ' ASC ';
            END IF; 
             IF p_order_by = 'issCd premSeqNo' 
                THEN  
                  v_sql := v_sql || ', inst_no asc ';
             ELSE                 
                  v_sql := v_sql || ', prem_seq_no asc ';
             END IF; 
          ELSE
          
            v_sql := v_sql || ' ORDER BY prem_seq_no DESC ';  
          
          END IF;        
          
          v_sql := v_sql || ') innersql) outersql) mainsql '; 
          IF p_first_row IS NOT NULL AND p_last_row IS NOT NULL--Modified by pjsantos 10/19/2016,added condition to prevent missing expression error in dated checks GENQA 5787
           THEN  
          v_sql := v_sql || ' WHERE rownum_ BETWEEN ' || p_first_row ||' AND ' || p_last_row;
          END IF; 
          
           OPEN C FOR v_sql USING    p_iss_cd, p_prem_seq_no, p_prem_seq_no, p_prem_seq_no, p_inst_no;  
            LOOP
                FETCH c INTO 
                v_inv.rownum_,
                v_inv.count_,
                v_inv.tran_id,
                v_inv.b140_iss_cd,
                v_inv.b140_prem_seq_no,
                v_inv.inst_no,
                v_inv.collection_amt,
                v_inv.premium_amt,
                v_inv.tax_amt,
                v_inv.collection_amt1,
                v_inv.premium_amt1,
                v_inv.tax_amt1,
                v_inv.ref_inv_no,
                v_inv.payt_ref_no,
                v_inv.policy_id,
                v_inv.line_cd,
                v_inv.subline_cd,
                v_inv.pol_iss_cd,
                v_inv.issue_yy,
                v_inv.pol_seq_no,
                v_inv.pol_renew_no,
                v_inv.endt_iss_cd,
                v_inv.endt_yy,
                v_inv.endt_seq_no,
                v_inv.endt_type,
                v_inv.ref_pol_no,
                v_inv.assd_no,
                v_inv.assd_name,
                v_inv.prem_vatable,
                v_inv.prem_vat_exempt,
                v_inv.prem_zero_rated,
                v_inv.rev_gacc_tran_id,
                v_inv.currency_rt,
                v_inv.currency_cd,
                v_inv.policy_no,
                v_inv.intm_no,
                v_inv.intm_name;    
              
                EXIT WHEN c%NOTFOUND;              
                PIPE ROW (v_inv);
            END LOOP;      
            CLOSE c; 
            
         RETURN;
      END IF;
    END get_gdcp_invoice_listing2;
  
   --marco - 09.16.2014
   PROCEDURE validate_policy(
      p_line_cd         IN    gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN    gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN    gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN    gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no      IN    gipi_polbasic.ref_pol_no%TYPE,
      p_check_due       IN    VARCHAR2,
      p_endt_message    OUT   VARCHAR2,
      p_special_message OUT   VARCHAR2,
      p_open_message    OUT   VARCHAR2,
      p_endt_proceed    OUT   VARCHAR2,
      p_special_proceed OUT   VARCHAR2,
      p_open_proceed    OUT   VARCHAR2
   )
   IS
      v_payt_unpd             giac_parameters.param_value_v%TYPE := NVL(giacp.v('ALLOW_PAYT_OF_UNPD_PART_PAID_POL'), 'P');
      v_balance_amt_due       NUMBER := 0;
      v_balance_amt_due_endt  NUMBER := 0; 
      v_bill_no               VARCHAR2(1000);
      v_endt_bill_no          VARCHAR2(1000);     
   BEGIN
      FOR pol IN(SELECT DISTINCT c.iss_cd, c.prem_seq_no, c.inst_no, 
                        c.balance_amt_due,
                        c.prem_balance_due,
                        c.tax_balance_due
                   FROM gipi_polbasic a,
                        gipi_invoice b,
                        giac_aging_soa_details c,
                        gipi_installment d
                  WHERE a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no
                    AND NVL(a.ref_pol_no, '%') = NVL(p_ref_pol_no, '%')
                    AND a.policy_id = b.policy_id
                    AND b.iss_cd = c.iss_cd
                    AND b.prem_seq_no = c.prem_seq_no
                    AND c.iss_cd = d.iss_cd
                    AND c.prem_seq_no = d.prem_seq_no
                    AND c.inst_no = d.inst_no
                    AND d.due_date <= DECODE(p_check_due, 'N' , SYSDATE, d.due_date))  
                    --AND c.balance_amt_due <> 0)
      LOOP
         FOR rec IN(SELECT a1.policy_id, a1.iss_cd||' - '||a1.prem_seq_no bill_no, b1.endt_seq_no
                      FROM gipi_invoice a1,
                           gipi_polbasic b1,
                           (SELECT a2.policy_id,
                                   b2.line_cd,
                                   b2.subline_cd,
                                   b2.iss_cd,
                                   b2.issue_yy,
                                   b2.pol_seq_no,
                                   b2.renew_no
                              FROM gipi_invoice a2,
                                   gipi_polbasic b2
                             WHERE a2.iss_cd = pol.iss_cd
                               AND a2.prem_seq_no = pol.prem_seq_no
                               AND b2.policy_id = a2.policy_id) c
                     WHERE b1.policy_id = a1.policy_id
                       AND b1.line_cd = c.line_cd
                       AND b1.subline_cd = c.subline_cd
                       AND b1.iss_cd = c.iss_cd
                       AND b1.issue_yy = c.issue_yy
                       AND b1.pol_seq_no = c.pol_seq_no
                       AND b1.renew_no = c.renew_no
                       AND a1.policy_id < c.policy_id
                     ORDER BY 2)
         LOOP
            FOR i IN(SELECT balance_amt_due, iss_cd||' - '||prem_seq_no ||' - ' ||inst_no bill_no  
                       FROM giac_aging_soa_details
                      WHERE policy_id = rec.policy_id)
            LOOP
               IF v_payt_unpd = 'P' THEN
                  IF rec.endt_seq_no = 0 THEN 
                     v_balance_amt_due := v_balance_amt_due + i.balance_amt_due;
                     IF i.balance_amt_due <> 0 THEN
                        v_bill_no := v_bill_no||i.bill_no||', ';
                     END IF;
                  ELSE                               
                     v_balance_amt_due_endt := v_balance_amt_due_endt + i.balance_amt_due;
                     IF i.balance_amt_due <> 0 THEN
                        v_endt_bill_no := v_endt_bill_no||i.bill_no||', ';
                     END IF;
                  END IF;
               ELSIF v_payt_unpd <> 'P' THEN 
                    v_balance_amt_due := v_balance_amt_due + i.balance_amt_due;
                    IF i.balance_amt_due <> 0 THEN
                        v_bill_no := v_bill_no||i.bill_no||', ';
                    END IF;
               END IF; 
            END LOOP;
         END LOOP;
        
         v_bill_no := RTRIM(v_bill_no, ', ');
        
         IF v_balance_amt_due <> 0 THEN
            IF v_payt_unpd = 'N' THEN
               p_endt_message := 'Bill Number/s '||v_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?';
               p_endt_proceed := 'Y';
            ELSIF v_payt_unpd = 'P' OR v_payt_unpd = 'E' THEN 
               p_endt_message := 'Bill Number/s '||v_bill_no||' is/are not yet fully paid. Settle it first before processing the payment for this endorsement.';
               p_endt_proceed := 'N';
            END IF;
         END IF;
        
         IF v_balance_amt_due = 0 AND v_payt_unpd = 'P' AND v_balance_amt_due_endt <> 0  THEN 
            p_endt_message := 'Bill Number/s '||v_endt_bill_no||' is/are not yet fully paid. Would you like to continue the endorsement''s payment?';
            p_endt_proceed := 'Y';
         END IF;
         
         check_premium_payt_for_special(pol.iss_cd, pol.prem_seq_no, p_special_message);
         IF p_special_message = 'This is a Special Policy.' THEN
            p_special_proceed := 'Y';
         ELSIF p_special_message = 'Premium payment for Special Policy is not allowed.' THEN
            p_special_proceed := 'N';
         END IF;
         
         validate_open_policy(pol.prem_seq_no, pol.iss_cd, p_open_message);
         IF p_open_message = 'This is an Open Policy.' THEN
            p_open_proceed := 'Y';
         ELSIF p_open_message = 'Premium payment for Open Policy is not allowed.' THEN
            p_open_proceed := 'N';
         END IF;
      END LOOP;
   END;
   
   /*
    **  Created by   :  Robert Virrey
    **  Date Created :  09.09.2014
    **  Reference By : (GIACS007 -  Direct Premium Collections)
    **  Description  : checks if the installment exists
    */
    FUNCTION check_previous_installment (
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    ) RETURN VARCHAR2 IS
        v_valid VARCHAR2(1) := 'Y';
		v_param giac_parameters.param_value_v%TYPE := NVL(giacp.v('ALLOW_NONSEQ_PAYT_INST'), 'Y');
	BEGIN
	   IF v_param = 'N' AND p_inst_no > 1
	   THEN
		  BEGIN
			 SELECT DISTINCT 'Y'
						INTO v_valid
						FROM giac_direct_prem_collns a, giac_acctrans b
					   WHERE 1 = 1
						 AND a.gacc_tran_id = b.tran_id
						 AND a.b140_iss_cd = p_iss_cd
						 AND a.b140_prem_seq_no = p_prem_seq_no
					  HAVING EXISTS (
								SELECT 1
								  FROM gipi_installment x, gipi_invoice y
								 WHERE x.iss_cd = y.iss_cd
								   AND x.prem_seq_no = y.prem_seq_no
								   AND x.iss_cd = a.b140_iss_cd
								   AND x.prem_seq_no = a.b140_prem_seq_no
								   AND x.inst_no = a.inst_no
								   AND (  (NVL (x.prem_amt, 0) * y.currency_rt)
										+ (NVL (x.tax_amt, 0) * y.currency_rt)
									   ) = SUM (NVL (a.collection_amt, 0)))
						 AND MAX (inst_no) + 1 = p_inst_no
					GROUP BY a.b140_iss_cd, a.b140_prem_seq_no, a.inst_no;
		  EXCEPTION
			 WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
			 THEN
				v_valid := 'N';
		  END;
	   END IF;
       RETURN v_valid;
    END check_previous_installment;
    
    PROCEDURE check_total_payments(
        p_iss_cd             giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            giac_direct_prem_collns.inst_no%TYPE
    )
    IS
    BEGIN
        UPDATE giac_aging_soa_details
           SET prem_balance_due = 0,
               tax_balance_due = 0
         WHERE iss_cd = p_iss_cd
           AND prem_seq_no = p_prem_seq_no
           AND inst_no = p_inst_no
           AND total_amount_due = total_payments
           AND (prem_balance_due != 0 OR tax_balance_due != 0);
    END;
FUNCTION get_intm(p_check NUMBER, p_iss_cd VARCHAR, p_prem_seq_no NUMBER)
RETURN VARCHAR2
AS
v_intm_no    VARCHAR2(12);
v_intm_name  VARCHAR2(4000);
BEGIN
   FOR intm_rec
      IN (SELECT A.intm_no, A.intm_name, ROWNUM num
            FROM giis_intermediary A, gipi_comm_invoice b
           WHERE     A.intm_no = b.intrmdry_intm_no
                 AND b.iss_cd = p_iss_cd
                 AND b.prem_seq_no = p_prem_seq_no)
   LOOP
      DBMS_OUTPUT.put_line (
         'isscd and premseqno: ' || p_iss_cd || ' ' || p_prem_seq_no);

      IF intm_rec.num = 1
      THEN
         DBMS_OUTPUT.put_line ('IN'); 
         v_intm_no := intm_rec.intm_no;
         v_intm_name := intm_rec.intm_name;
      ELSE
         DBMS_OUTPUT.put_line ('OUT');
         v_intm_no := intm_rec.intm_no;
         v_intm_name := v_intm_name || ' / ' || intm_rec.intm_name;
      END IF;      
   END LOOP;
   
   IF p_check = 1
    THEN
     RETURN v_intm_no;
   ELSIF p_check = 2
    THEN
     RETURN v_intm_name;
   END IF;
    
   
END;
END giac_direct_prem_collns_pkg;
/



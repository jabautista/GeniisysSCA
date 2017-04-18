CREATE OR REPLACE PACKAGE BODY CPI.giac_aging_soa_details_pkg
AS
   /*
   **  Created by    : Mark JM
   **  Date Created  : 05.28.2010
   **  Reference By  : (GIPIS031 - Endt Basic Information)
   **  Description   : This function checks the payment for the policy and return a confirmation message to user
   **             : in able to cancel the endt
   */
   FUNCTION check_policy_payment (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_paid_amt   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT SUM (c.total_payments) paid_amt
                  FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.pol_flag IN ('1', '2', '3', 'X')
                   AND a.policy_id = b.policy_id
                   AND b.iss_cd = c.iss_cd
                   AND b.prem_seq_no = c.prem_seq_no)
      LOOP
         v_paid_amt := NVL (a.paid_amt, 0);
      END LOOP;

      RETURN v_paid_amt;
   END check_policy_payment;

/********************************** FUNCTION 1 ************************************
  MODULE:  GIACS008
  RECORD GROUP NAME: LOV_INSTNO
***********************************************************************************/
   FUNCTION get_instno_list
      RETURN instno_list_tab PIPELINED
   IS
      v_instno   instno_list_type;
   BEGIN
      FOR i IN (SELECT   b.inst_no, b.prem_seq_no, a.iss_cd, b.a180_ri_cd
                    FROM gipi_invoice a, giac_aging_ri_soa_details b
                   WHERE a.prem_seq_no = b.prem_seq_no
                   --AND b.prem_seq_no = NVL (:gifc.b140_prem_seq_no, b.prem_seq_no)
                --AND b.a180_ri_cd = NVL (:gifc.a180_ri_cd, b.a180_ri_cd)
                --AND a.iss_cd = :gifc.b140_iss_cd
                ORDER BY b.inst_no)
      LOOP
         v_instno.inst_no := i.inst_no;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.iss_cd := i.iss_cd;
         v_instno.a180_ri_cd := i.a180_ri_cd;
         PIPE ROW (v_instno);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_instno_list_inwfacul (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_transaction_type   giac_inwfacul_prem_collns.transaction_type%TYPE,
      p_b140_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE
   )
      RETURN instno_list_inwfacul_tab PIPELINED
   IS
      v_instno   instno_list_inwfacul_type;

      CURSOR c1_inst_no (
         v_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
         v_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
         v_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE
      )
      IS
         SELECT NVL (balance_due, 0) collection_amt, NVL (prem_balance_due, 0) premium_amt
                                                                                          /* UPDATED BY BEM 1/24/00*/
                ,
                NVL (prem_balance_due + tax_amount, 0) prem_tax, NVL (wholding_tax_bal, 0) wholding_tax,
                NVL (comm_balance_due, 0) comm_amt, NVL (tax_amount, 0) tax_amount, NVL (comm_vat, 0) comm_vat --Vincent 01112006
           FROM giac_aging_ri_soa_details
          WHERE a180_ri_cd = v_a180_ri_cd AND prem_seq_no = v_b140_prem_seq_no AND inst_no = v_inst_no;

      CURSOR c2_inst_no (
         v_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
         v_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
         v_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE
      )
      IS
         SELECT NVL (SUM (NVL (-1 * a.collection_amt, 0)), 0) collection_amt,
                NVL (SUM (NVL (-1 * a.premium_amt, 0)), 0) premium_amt,
                NVL (SUM (NVL (-1 * (a.premium_amt + a.tax_amount), 0)), 0) prem_tax,
                NVL (SUM (NVL (-1 * a.wholding_tax, 0)), 0) wholding_tax, NVL (SUM (NVL (-1 * a.comm_amt, 0)), 0) comm_amt,
                NVL (SUM (NVL (-1 * a.foreign_curr_amt, 0)), 0) foreign_curr_amt,
                NVL (SUM (NVL (-1 * a.tax_amount, 0)), 0) tax_amount, NVL (SUM (NVL (-1 * a.comm_vat, 0)), 0) comm_vat
           --Vincent 01112006
         FROM   giac_inwfacul_prem_collns a, giac_acctrans b, giac_aging_ri_soa_details c
          WHERE a.a180_ri_cd = v_a180_ri_cd
            AND a.gacc_tran_id = b.tran_id
            AND b.tran_flag <> 'D'
            AND b140_prem_seq_no = v_b140_prem_seq_no
            AND b140_prem_seq_no = c.prem_seq_no
            AND a.inst_no = v_inst_no
            AND (a.transaction_type IN (1, 2) OR a.transaction_type IN (3, 4))
            AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                         FROM giac_reversals c, giac_acctrans d
                                        WHERE c.reversing_tran_id = d.tran_id AND d.tran_flag <> 'D');
   BEGIN
      FOR i IN (SELECT   b.inst_no, b.prem_seq_no, a.iss_cd, b.a180_ri_cd
                    FROM gipi_invoice a, giac_aging_ri_soa_details b
                   WHERE a.prem_seq_no = b.prem_seq_no
                     AND b.prem_seq_no = NVL (p_b140_prem_seq_no, b.prem_seq_no)
                     AND b.a180_ri_cd = NVL (p_a180_ri_cd, b.a180_ri_cd)
                     AND a.iss_cd = p_b140_iss_cd
                ORDER BY b.inst_no)
      LOOP
         v_instno.inst_no := i.inst_no;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.iss_cd := i.iss_cd;
         v_instno.a180_ri_cd := i.a180_ri_cd;

         IF p_transaction_type IN (1, 3)
         THEN
            FOR a IN c1_inst_no (i.a180_ri_cd, i.prem_seq_no, i.inst_no)
            LOOP
               v_instno.collection_amt := a.collection_amt;
               v_instno.premium_amt := a.premium_amt;
               v_instno.prem_tax := a.prem_tax;
               v_instno.wholding_tax := a.wholding_tax;
               v_instno.comm_amt := a.comm_amt;
               v_instno.tax_amount := a.tax_amount;
               v_instno.comm_vat := a.comm_vat;
            --v_instno.foreign_curr_amt := ROUND(NVL(a.collection_amt,0)/NVL(a.currency_rt,1),2);
            END LOOP;
         ELSIF p_transaction_type IN (2, 4)
         THEN
            FOR a IN c2_inst_no (i.a180_ri_cd, i.prem_seq_no, i.inst_no)
            LOOP
               v_instno.collection_amt := a.collection_amt;
               v_instno.premium_amt := a.premium_amt;
               v_instno.prem_tax := a.prem_tax;
               v_instno.wholding_tax := a.wholding_tax;
               v_instno.comm_amt := a.comm_amt;
               v_instno.foreign_curr_amt := a.foreign_curr_amt;
               v_instno.tax_amount := a.tax_amount;
               v_instno.comm_vat := a.comm_vat;
            END LOOP;
         END IF;

         PIPE ROW (v_instno);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by    : Anthony Santos
   **  Date Created  : 08.16.2010
   **  Reference By  : GIACS007
   **  Description   : Gets GDPC_INST_NO LOV DETAILs
   */
   FUNCTION get_instno_details (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE
   )
      RETURN instno_detail_tab PIPELINED
   IS
      v_instno   instno_detail_type;
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt, prem_balance_due premium_amt,
                       tax_balance_due tax_amt, balance_amt_due collection_amt1, prem_balance_due premium_amt1,
                       tax_balance_due tax_amt1
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND balance_amt_due > 0)
      LOOP
         v_instno.iss_cd := i.iss_cd;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.inst_no := i.inst_no;
         v_instno.balance_amt_due := i.collection_amt;
         v_instno.prem_balance_due := i.premium_amt;
         v_instno.tax_balance_due := i.tax_amt;
         PIPE ROW (v_instno);
      END LOOP;

      RETURN;
   END get_instno_details;

   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 11.3.2011
   **  Reference By  : GIACS090
   **  Description   : Function to retrieve the installment records from giac_aging_soa_details
   */
   FUNCTION get_instno_details2 (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN instno_detail_tab PIPELINED
   IS
      v_instno   instno_detail_type;
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt, prem_balance_due premium_amt,
                       tax_balance_due tax_amt
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND ABS(balance_amt_due) > 0) --koks 20358 add ABS
                 
      LOOP
         v_instno.iss_cd := i.iss_cd;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.inst_no := i.inst_no;
         v_instno.balance_amt_due := i.collection_amt;
         v_instno.prem_balance_due := i.premium_amt;
         v_instno.tax_balance_due := i.tax_amt;
         
         --marco - UCPB SR 20856
         FOR b IN (SELECT currency_cd, currency_rt
                     FROM gipi_invoice
                    WHERE iss_cd = p_iss_cd
                      AND prem_seq_no = p_prem_seq_no)
          LOOP
             v_instno.currency_cd := b.currency_cd;
             v_instno.currency_rt := b.currency_rt;
             EXIT;
          END LOOP;
          
          PIPE ROW (v_instno);
      END LOOP;

      RETURN;
   END get_instno_details2;
   
   -- bonok :: 3.15.2016 :: UCPB SR 21681
   FUNCTION get_instno_details3 ( 
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_find_text     VARCHAR2
   )
      RETURN instno_detail_tab PIPELINED
   IS
      v_instno   instno_detail_type;
      v_prem           NUMBER;
      v_tax            NUMBER;
      v_total_amt      NUMBER;
      v_colln_amt      NUMBER;
      v_colln_amt_or   NUMBER;
      v_bal_due        NUMBER;
      v_count          NUMBER;
      v_exist          VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt, prem_balance_due premium_amt,
                       tax_balance_due tax_amt
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND ABS(balance_amt_due) > 0) --koks 20358 add ABS
                 
      LOOP
         v_instno.iss_cd := i.iss_cd;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.inst_no := i.inst_no;
         v_instno.balance_amt_due := i.collection_amt;
         v_instno.prem_balance_due := i.premium_amt;
         v_instno.tax_balance_due := i.tax_amt;
         
         --marco - UCPB SR 20856
         FOR b IN (SELECT currency_cd, currency_rt
                     FROM gipi_invoice
                    WHERE iss_cd = p_iss_cd
                      AND prem_seq_no = p_prem_seq_no)
         LOOP
            v_instno.currency_cd := b.currency_cd;
            v_instno.currency_rt := b.currency_rt;
            EXIT;
         END LOOP;
         
         v_colln_amt := 0;
          
         SELECT COUNT (*)
           INTO v_count
           FROM giac_aging_soa_details z
          WHERE z.iss_cd = p_iss_cd AND z.prem_seq_no = p_prem_seq_no;

         FOR b IN (SELECT prem_amt, tax_amt, currency_cd, currency_rt
                     FROM gipi_invoice
                    WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            v_prem := b.prem_amt;
            v_tax := b.tax_amt;
            v_instno.currency_cd := b.currency_cd;
            v_instno.currency_rt := b.currency_rt;   
            
            FOR c IN (SELECT prem_amt, tax_amt
                        FROM gipi_installment
                       WHERE iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND inst_no = i.inst_no)
            LOOP
               v_total_amt := (c.prem_amt + c.tax_amt) * b.currency_rt;
            END LOOP;      
         END LOOP;

         FOR d IN (SELECT b.collection_amt, b.iss_cd, b.prem_seq_no, b.inst_no, b.pdc_id
                     FROM giac_apdc_payt_dtl a, giac_pdc_prem_colln b
                    WHERE a.pdc_id = b.pdc_id AND a.check_flag <> 'C' AND b.iss_cd = p_iss_cd AND b.prem_seq_no = p_prem_seq_no AND b.inst_no = i.inst_no)
         LOOP
            FOR e IN (SELECT a.collection_amt
                        FROM giac_direct_prem_collns a, giac_acctrans b, giac_collection_dtl c
                       WHERE a.gacc_tran_id = b.tran_id
                         AND a.gacc_tran_id = c.gacc_tran_id
                         AND b.tran_id = c.gacc_tran_id
                         AND b.tran_flag <> 'D'
                         AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                                 FROM giac_reversals c
                                                WHERE c.gacc_tran_id = b.tran_id)
                         AND a.b140_iss_cd = d.iss_cd
                         AND a.b140_prem_seq_no = d.prem_seq_no
                         AND a.inst_no = d.inst_no
                         AND c.pdc_id = d.pdc_id)
            LOOP
               IF d.collection_amt = e.collection_amt THEN
                  v_exist := 'Y';
               END IF;
            END LOOP;
            
            IF v_exist <> 'Y' THEN
               v_colln_amt := v_colln_amt + d.collection_amt;
            END IF;
            
            v_exist := 'N';
         END LOOP;      

         /*added by mikel 01.19.11
         **to check the amount of total collected amount*/
         FOR e IN (SELECT SUM (NVL (a.collection_amt, 0)) colln_amt_or
                     FROM giac_direct_prem_collns a, giac_acctrans b
                    WHERE a.gacc_tran_id = b.tran_id
                      AND b.tran_flag <> 'D'
                      AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                              FROM giac_reversals c
                                             WHERE c.gacc_tran_id = b.tran_id)
                      AND b140_iss_cd = p_iss_cd
                      AND b140_prem_seq_no = p_prem_seq_no
                      AND a.inst_no = i.inst_no)
         LOOP
            IF e.colln_amt_or IS NOT NULL THEN
               v_colln_amt_or := e.colln_amt_or;
            ELSE
               v_colln_amt_or := 0;
            END IF;
         END LOOP;
  
         v_bal_due := v_total_amt - (v_colln_amt + v_colln_amt_or);

         IF v_bal_due <> 0 THEN
            v_instno.balance_amt_due := v_bal_due;
         ELSIF v_bal_due = 0 THEN
            IF v_count = 1 THEN
               v_instno.balance_amt_due := NULL;
            END IF; 
         END IF;
          
         PIPE ROW (v_instno);
      END LOOP;

      RETURN;
   END get_instno_details3;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.08.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : subt_ri_soa_details PROGRAM UNIT
   */
   PROCEDURE subt_ri_soa_details (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      p_tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE
   )
   IS
   BEGIN
      UPDATE giac_aging_ri_soa_details
         SET total_payments = total_payments + p_collection_amt,
             temp_payments = temp_payments + p_collection_amt,
             balance_due = balance_due - p_collection_amt,
             prem_balance_due = prem_balance_due - p_premium_amt,
             comm_balance_due = comm_balance_due - p_comm_amt,
             wholding_tax_bal = wholding_tax_bal - p_wholding_tax,
             tax_amount = tax_amount - p_tax_amount,
             comm_vat = NVL (comm_vat, 0) - p_comm_vat
       WHERE a180_ri_cd = p_a180_ri_cd AND prem_seq_no = p_b140_prem_seq_no AND inst_no = p_inst_no;
   END;

   /*
   **  Created by   :  Jerome Orio
   **  Date Created :  09.08.2010
   **  Reference By : (GIACS008 - Inward Facultative Premium Collections)
   **  Description  : add_ri_soa_details PROGRAM UNIT
   */
   PROCEDURE add_ri_soa_details (
      p_a180_ri_cd         giac_inwfacul_prem_collns.a180_ri_cd%TYPE,
      p_b140_prem_seq_no   giac_inwfacul_prem_collns.b140_prem_seq_no%TYPE,
      p_inst_no            giac_inwfacul_prem_collns.inst_no%TYPE,
      p_collection_amt     giac_inwfacul_prem_collns.collection_amt%TYPE,
      p_premium_amt        giac_inwfacul_prem_collns.premium_amt%TYPE,
      p_comm_amt           giac_inwfacul_prem_collns.comm_amt%TYPE,
      p_wholding_tax       giac_inwfacul_prem_collns.wholding_tax%TYPE,
      p_tax_amount         giac_inwfacul_prem_collns.tax_amount%TYPE,
      p_comm_vat           giac_inwfacul_prem_collns.comm_vat%TYPE
   )
   IS
   BEGIN
      UPDATE giac_aging_ri_soa_details
         SET total_payments = total_payments - p_collection_amt,
             temp_payments = temp_payments - p_collection_amt,
             balance_due = balance_due + p_collection_amt,
             prem_balance_due = prem_balance_due + p_premium_amt,
             comm_balance_due = comm_balance_due + p_comm_amt,
             wholding_tax_bal = wholding_tax_bal + p_wholding_tax,
             tax_amount = tax_amount + p_tax_amount,
             comm_vat = NVL (comm_vat, 0) + p_comm_vat
       WHERE a180_ri_cd = p_a180_ri_cd AND prem_seq_no = p_b140_prem_seq_no AND inst_no = p_inst_no;
   END;

   /*
   **  Created by   :  ANTHONY SANTOS
   **  Date Created :  09.13.2010
   **  Reference By : (GIACS007 -  Direct Premium Collections)
   **  Description  : Policy canvass
   */
   FUNCTION get_policy_details (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       gipi_polbasic.iss_cd%TYPE,
      p_issue_year   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no   gipi_polbasic.ref_pol_no%TYPE,
      p_due_tag      VARCHAR2
   )
      RETURN policy_detail_tab PIPELINED
   IS
      v_policy             policy_detail_type;
      v_chk_tag            VARCHAR2 (1);
      v_msg_alert          VARCHAR2 (30000);
      v_transaction_type   NUMBER;
   BEGIN
      FOR i IN (SELECT DISTINCT c.iss_cd, c.prem_seq_no, c.inst_no, c.balance_amt_due, c.prem_balance_due, a.line_cd,
                                a.subline_cd,                                                                    --added by alfie
                                             c.tax_balance_due
                           FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c, gipi_installment d
                          WHERE a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = p_iss_cd
                            AND a.issue_yy = p_issue_year
                            AND a.pol_seq_no = p_pol_seq_no
                            AND a.renew_no = p_renew_no
                            AND NVL (a.ref_pol_no, 0) = NVL (p_ref_pol_no, 0)
                            AND a.policy_id = b.policy_id
                            AND b.iss_cd = c.iss_cd
                            AND b.prem_seq_no = c.prem_seq_no
                            AND c.iss_cd = d.iss_cd
                            AND c.prem_seq_no = d.prem_seq_no
                            AND c.inst_no = d.inst_no
                            AND d.due_date <= DECODE (p_due_tag, 'N', SYSDATE, d.due_date)
                            AND c.balance_amt_due <> 0
                       ORDER BY c.iss_cd, c.prem_seq_no, c.inst_no)
      LOOP
         check_premium_payt_for_special (i.iss_cd, i.prem_seq_no,
                                         --  'TRUE',      commented in by alfie 12.22.2010
                                         --  v_chk_tag,
                                         v_msg_alert);

         IF i.balance_amt_due > 0
         THEN
            v_policy.tran_type := 1;
         ELSE
            v_policy.tran_type := 3;
         END IF;

         v_policy.iss_cd := i.iss_cd;
         v_policy.prem_seq_no := i.prem_seq_no;
         v_policy.inst_no := i.inst_no;
         v_policy.balance_amt_due := i.balance_amt_due;
         v_policy.prem_balance_due := i.prem_balance_due;
         v_policy.tax_balance_due := i.tax_balance_due;
         v_policy.chk_tag := v_chk_tag;
         v_policy.msg_alert := v_msg_alert;
         v_policy.line_cd := i.line_cd;
         v_policy.subline_cd := i.subline_cd;
         PIPE ROW (v_policy);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by    : Emman
   **  Date Created  : 11.04.2010
   **  Reference By  : (GIACS026 - Direct Trans Premium Deposit)
   **  Description   : Gets the records for LOV GIPD_B140_ISS_CD
   */
   FUNCTION get_aging_soa_details (p_keyword VARCHAR2, p_iss_cd giac_aging_soa_details.iss_cd%TYPE)
      RETURN aging_soa_details_tab PIPELINED
   IS
      v_rec   aging_soa_details_type;
   BEGIN
      FOR i IN (SELECT   iss_cd, prem_seq_no, inst_no, a150_line_cd, total_amount_due, total_payments, temp_payments,
                         balance_amt_due, a020_assd_no
                    FROM giac_aging_soa_details
                   WHERE iss_cd = NVL (p_iss_cd, iss_cd)
                     AND (   iss_cd LIKE '%' || p_keyword || '%'
                          OR prem_seq_no LIKE '%' || p_keyword || '%'
                          OR inst_no LIKE '%' || p_keyword || '%'
                         )
                ORDER BY iss_cd ASC, prem_seq_no ASC, inst_no ASC)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.prem_seq_no := i.prem_seq_no;
         v_rec.inst_no := i.inst_no;
         v_rec.a150_line_cd := i.a150_line_cd;
         v_rec.total_amount_due := i.total_amount_due;
         v_rec.total_payments := i.total_payments;
         v_rec.temp_payments := i.temp_payments;
         v_rec.balance_amt_due := i.balance_amt_due;
         v_rec.a020_assd_no := i.a020_assd_no;
         PIPE ROW (v_rec);
      END LOOP;
   END get_aging_soa_details;

   /*
   **  Created by    : Emman
   **  Date Created  : 11.22.2010
   **  Reference By  : (GIPIS031A - Endt Basic Information)
   **  Description   : This function checks the payment for the policy and return a confirmation message to user
   **             : in able to cancel the endt
   */
   FUNCTION check_pack_policy_payment (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_paid_amt   NUMBER := 0;
   BEGIN
      FOR a IN (SELECT SUM (c.total_payments) paid_amt
                  FROM gipi_polbasic d, gipi_pack_polbasic a, gipi_invoice b, giac_aging_soa_details c
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no
                   AND a.pol_flag IN ('1', '2', '3', 'X')
                   AND a.pack_policy_id = d.pack_policy_id
                   AND d.policy_id = b.policy_id
                   AND b.iss_cd = c.iss_cd
                   AND b.prem_seq_no = c.prem_seq_no)
      LOOP
         v_paid_amt := a.paid_amt;
      END LOOP;

      RETURN v_paid_amt;
   END check_pack_policy_payment;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  11.3.2011
   **  Reference By : (GIACS090 - Acknowledgement Receipt)
   **  Description  : Function to retrieve bill no list of values
   */
   FUNCTION get_bill_no_lov (p_iss_cd giac_aging_soa_details.iss_cd%TYPE,
                             p_tran_type NUMBER, --kenneth SR 20856 12.02.2015 
                             p_find_text VARCHAR2)
      RETURN bill_no_lov_tab PIPELINED
   IS
      v_bill   bill_no_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, a.prem_seq_no, b.property, b.ref_inv_no, c.policy_id,
                                   RTRIM (c.line_cd)
                                || '-'
                                || RTRIM (c.subline_cd)
                                || '-'
                                || RTRIM (c.iss_cd)
                                || '-'
                                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                                || DECODE (c.endt_seq_no,
                                           0, NULL,
                                              '-'
                                           || c.endt_iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_seq_no, '099999'))
                                           || '-'
                                           || RTRIM (c.endt_type)
                                          )
                                || '-'
                                || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                c.ref_pol_no, c.assd_no, d.assd_name
                           FROM giis_assured d, gipi_parlist e, gipi_polbasic c, gipi_invoice b, giac_aging_soa_details a
                          WHERE 1 = 1
                            AND a.iss_cd = p_iss_cd
                            AND e.assd_no = d.assd_no
                            AND c.par_id = e.par_id
                            AND a.policy_id = c.policy_id
                            AND a.prem_seq_no = b.prem_seq_no
                            AND a.iss_cd = b.iss_cd
                            --AND a.balance_amt_due > 0 Kenneth 12.02.2015 sr#20856
                            AND ((p_tran_type = 1 AND a.balance_amt_due > 0) OR (p_tran_type = 3 AND a.balance_amt_due < 0))
                            AND (   a.prem_seq_no LIKE NVL (p_find_text, '%')
                                 OR UPPER (d.assd_name) LIKE UPPER (NVL (p_find_text, '%'))
                                 OR RTRIM (c.line_cd)
                                || '-'
                                || RTRIM (c.subline_cd)
                                || '-'
                                || RTRIM (c.iss_cd)
                                || '-'
                                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                                || DECODE (c.endt_seq_no,
                                           0, NULL,
                                              '-'
                                           || c.endt_iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_seq_no, '099999'))
                                           || '-'
                                           || RTRIM (c.endt_type)
                                          )
                                || '-'
                                || LTRIM (TO_CHAR (c.renew_no, '09')) LIKE UPPER(NVL(p_find_text, '%')) --marco - 04.15.2013 - added for filter
                                ))
      LOOP
         v_bill.iss_cd := i.iss_cd;
         v_bill.prem_seq_no := i.prem_seq_no;
         v_bill.property := i.property;
         v_bill.ref_inv_no := i.ref_inv_no;
         v_bill.policy_id := i.policy_id;
         v_bill.policy_no := i.policy_no;
         v_bill.ref_pol_no := i.ref_pol_no;
         v_bill.assd_no := i.assd_no;
         v_bill.assd_name := i.assd_name;
         PIPE ROW (v_bill);
      END LOOP;

      RETURN;
   END get_bill_no_lov;

   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  11.15.2011
   **  Reference By : (GIACS090 - Acknowledgement Receipt)
   **  Description  : Function to retrieve bill info based on issd_cd and prem_seq_no
   */
   FUNCTION get_bill_info(p_iss_cd      GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
                          p_prem_seq_no GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
                          p_tran_type NUMBER) --kenneth SR 20856 12.02.2015
      RETURN bill_no_lov_tab PIPELINED
   IS
      v_bill   bill_no_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, a.prem_seq_no, b.property, b.ref_inv_no, c.policy_id,
                                   RTRIM (c.line_cd)
                                || '-'
                                || RTRIM (c.subline_cd)
                                || '-'
                                || RTRIM (c.iss_cd)
                                || '-'
                                || LTRIM (TO_CHAR (c.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (c.pol_seq_no, '0999999'))
                                || DECODE (c.endt_seq_no,
                                           0, NULL,
                                              '-'
                                           || c.endt_iss_cd
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (c.endt_seq_no, '099999'))
                                           || '-'
                                           || RTRIM (c.endt_type)
                                          )
                                || '-'
                                || LTRIM (TO_CHAR (c.renew_no, '09')) policy_no,
                                c.ref_pol_no, c.assd_no, d.assd_name,
                                (SELECT COUNT (*)
                                   FROM giac_aging_soa_details z
                                  WHERE z.iss_cd = p_iss_cd AND z.prem_seq_no = p_prem_seq_no) inst_count
                           FROM giis_assured d, gipi_parlist e, gipi_polbasic c, gipi_invoice b, giac_aging_soa_details a
                          WHERE 1 = 1
                            AND a.iss_cd = p_iss_cd
                            AND a.prem_seq_no = p_prem_seq_no
                            AND e.assd_no = d.assd_no
                            AND c.par_id = e.par_id
                            AND a.policy_id = c.policy_id
                            AND a.prem_seq_no = b.prem_seq_no
                            AND a.iss_cd = b.iss_cd
                            --AND a.balance_amt_due > 0 Kenneth 12.02.2015 sr#20856
                            AND ((p_tran_type = 1 AND a.balance_amt_due > 0) OR (p_tran_type = 3 AND a.balance_amt_due < 0))
              )
      LOOP
         v_bill.iss_cd := i.iss_cd;
         v_bill.prem_seq_no := i.prem_seq_no;
         v_bill.property := i.property;
         v_bill.ref_inv_no := i.ref_inv_no;
         v_bill.policy_id := i.policy_id;
         v_bill.policy_no := i.policy_no;
         v_bill.ref_pol_no := i.ref_pol_no;
         v_bill.assd_no := i.assd_no;
         v_bill.assd_name := i.assd_name;
         v_bill.inst_count := i.inst_count;

         IF i.inst_count = 1
         THEN
            SELECT inst_no
              INTO v_bill.dflt_inst_no
              FROM giac_aging_soa_details
             WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;
         END IF;

         SELECT SUM (balance_amt_due)
           INTO v_bill.total_bal_amt_due
           FROM giac_aging_soa_details
          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no;

         PIPE ROW (v_bill);
      END LOOP;

      RETURN;
   END get_bill_info;

   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 11.15.2011
   **  Reference By  : GIACS090
   **  Description   : Function to retrieve the installment info based on iss_cd, prem_seq_no and inst_no
   */
   FUNCTION get_inst_info (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_inst_no       giac_aging_soa_details.inst_no%TYPE
   )
      RETURN instno_detail_tab PIPELINED
   IS
      v_instno         instno_detail_type;
      v_prem           NUMBER;
      v_tax            NUMBER;
      v_total_amt      NUMBER;
      v_colln_amt      NUMBER;
      v_check_amt      NUMBER;
      v_colln_amt_or   NUMBER;
      v_bal_due        NUMBER;
      v_count          NUMBER;
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt, prem_balance_due premium_amt,
                       tax_balance_due tax_amt
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND inst_no = p_inst_no AND ABS(balance_amt_due) > 0) --koks 20358 add ABS
      LOOP
         v_instno.iss_cd := i.iss_cd;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.inst_no := i.inst_no;
         v_instno.balance_amt_due := i.collection_amt;
         v_instno.prem_balance_due := i.premium_amt;
         v_instno.tax_balance_due := i.tax_amt;         
      END LOOP;

      SELECT COUNT (*)
        INTO v_count
        FROM giac_aging_soa_details z
       WHERE z.iss_cd = p_iss_cd AND z.prem_seq_no = p_prem_seq_no;

      FOR b IN (SELECT prem_amt, tax_amt, currency_cd, currency_rt
                  FROM gipi_invoice
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
      LOOP
         v_prem := b.prem_amt;
         v_tax := b.tax_amt;
         --marco - UCPB SR 20856
         v_total_amt := (v_prem + v_tax) * b.currency_rt;
         v_instno.currency_cd := b.currency_cd;
         v_instno.currency_rt := b.currency_rt;         
      END LOOP;

      FOR d IN (SELECT SUM (NVL (b.collection_amt, 0)) colln_amt
                  FROM giac_apdc_payt_dtl a, giac_pdc_prem_colln b
                 WHERE a.pdc_id = b.pdc_id AND a.check_flag <> 'C' AND b.iss_cd = p_iss_cd AND b.prem_seq_no = p_prem_seq_no)
      LOOP
         IF d.colln_amt IS NOT NULL
         THEN
            v_colln_amt := d.colln_amt;
         ELSE
            v_colln_amt := 0;                                                                      --issa 05.06.2005, comment-out
         END IF;
      END LOOP;                                                                                                         -- U mikel

      /*added by mikel 01.19.11
      **to check the amount of pdc applied*/
      FOR a IN (SELECT SUM (NVL (b.premium_amt, 0)) + SUM (NVL (b.tax_amt, 0)) check_amt
                  FROM giac_apdc_payt_dtl a, giac_pdc_prem_colln b
                 WHERE a.pdc_id = b.pdc_id AND a.check_flag = 'A' AND b.iss_cd = p_iss_cd AND b.prem_seq_no = p_prem_seq_no)
      LOOP
         IF a.check_amt IS NOT NULL
         THEN
            v_check_amt := a.check_amt;
         ELSE
            v_check_amt := 0;
         END IF;
      END LOOP;

      /*added by mikel 01.19.11
      **to check the amount of total collected amount*/
      FOR e IN (SELECT SUM (NVL (a.collection_amt, 0)) colln_amt_or
                  FROM giac_direct_prem_collns a, giac_acctrans b
                 WHERE a.gacc_tran_id = b.tran_id
                   AND b.tran_flag <> 'D'
                   AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                           FROM giac_reversals c
                                          WHERE c.gacc_tran_id = b.tran_id)
                   AND b140_iss_cd = p_iss_cd
                   AND b140_prem_seq_no = p_prem_seq_no)
      LOOP
         IF e.colln_amt_or IS NOT NULL
         THEN
            v_colln_amt_or := e.colln_amt_or;
         ELSE
            v_colln_amt_or := 0;
         END IF;

         v_bal_due := v_total_amt - v_colln_amt + (v_check_amt - v_colln_amt_or);

         IF v_bal_due <> 0
         THEN
            IF v_count = 1
            THEN
               v_instno.balance_amt_due := v_bal_due;
            ELSE
               FOR e IN (SELECT balance_amt_due
                           FROM giac_aging_soa_details
                          WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND inst_no = p_inst_no)
               LOOP
                  v_instno.balance_amt_due := e.balance_amt_due;
               END LOOP;
            END IF;
         ELSIF v_bal_due = 0 THEN
            IF v_count = 1
            THEN
               v_instno.balance_amt_due := NULL;
            END IF; 
         END IF;
      END LOOP;
      
      PIPE ROW (v_instno);
      RETURN;
   END get_inst_info;  
   
   -- bonok :: 4.8.2016 :: UCPB SR 21681   
   FUNCTION get_inst_info2 (
      p_iss_cd        giac_aging_soa_details.iss_cd%TYPE,
      p_prem_seq_no   giac_aging_soa_details.prem_seq_no%TYPE,
      p_inst_no       giac_aging_soa_details.inst_no%TYPE
   )
      RETURN instno_detail_tab PIPELINED
   IS
      v_instno         instno_detail_type;
      v_prem           NUMBER;
      v_tax            NUMBER;
      v_total_amt      NUMBER;
      v_colln_amt      NUMBER;
      v_check_amt      NUMBER;
      v_colln_amt_or   NUMBER;
      v_bal_due        NUMBER;
      v_count          NUMBER;
      v_exist          VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN (SELECT iss_cd, prem_seq_no, inst_no, balance_amt_due collection_amt, prem_balance_due premium_amt,
                       tax_balance_due tax_amt
                  FROM giac_aging_soa_details
                 WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no AND inst_no = p_inst_no AND ABS(balance_amt_due) > 0) --koks 20358 add ABS
      LOOP
         v_instno.iss_cd := i.iss_cd;
         v_instno.prem_seq_no := i.prem_seq_no;
         v_instno.inst_no := i.inst_no;
         v_instno.balance_amt_due := i.collection_amt;
         v_instno.prem_balance_due := i.premium_amt;
         v_instno.tax_balance_due := i.tax_amt;         
      

         v_colln_amt := 0;
          
         SELECT COUNT (*)
           INTO v_count
           FROM giac_aging_soa_details z
          WHERE z.iss_cd = p_iss_cd AND z.prem_seq_no = p_prem_seq_no;

         FOR b IN (SELECT prem_amt, tax_amt, currency_cd, currency_rt
                     FROM gipi_invoice
                    WHERE iss_cd = p_iss_cd AND prem_seq_no = p_prem_seq_no)
         LOOP
            v_prem := b.prem_amt;
            v_tax := b.tax_amt;
            v_instno.currency_cd := b.currency_cd;
            v_instno.currency_rt := b.currency_rt;   
            
            FOR c IN (SELECT prem_amt, tax_amt
                        FROM gipi_installment
                       WHERE iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND inst_no = i.inst_no)
            LOOP
               v_total_amt := (c.prem_amt + c.tax_amt) * b.currency_rt;
            END LOOP;      
         END LOOP;                                                                                                     -- U mikel

         FOR d IN (SELECT b.collection_amt, b.iss_cd, b.prem_seq_no, b.inst_no, b.pdc_id
                     FROM giac_apdc_payt_dtl a, giac_pdc_prem_colln b
                    WHERE a.pdc_id = b.pdc_id AND a.check_flag <> 'C' AND b.iss_cd = p_iss_cd AND b.prem_seq_no = p_prem_seq_no AND b.inst_no = i.inst_no)
         LOOP
            FOR e IN (SELECT a.collection_amt
                        FROM giac_direct_prem_collns a, giac_acctrans b, giac_collection_dtl c
                       WHERE a.gacc_tran_id = b.tran_id
                         AND a.gacc_tran_id = c.gacc_tran_id
                         AND b.tran_id = c.gacc_tran_id
                         AND b.tran_flag <> 'D'
                         AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                                 FROM giac_reversals c
                                                WHERE c.gacc_tran_id = b.tran_id)
                         AND a.b140_iss_cd = d.iss_cd
                         AND a.b140_prem_seq_no = d.prem_seq_no
                         AND a.inst_no = d.inst_no
                         AND c.pdc_id = d.pdc_id)
            LOOP
               IF d.collection_amt = e.collection_amt THEN
                  v_exist := 'Y';
               END IF;
            END LOOP;
            
            IF v_exist <> 'Y' THEN
               v_colln_amt := v_colln_amt + d.collection_amt;
            END IF;
            
            v_exist := 'N';
         END LOOP;      

         /*added by mikel 01.19.11
         **to check the amount of total collected amount*/
         FOR e IN (SELECT SUM (NVL (a.collection_amt, 0)) colln_amt_or
                     FROM giac_direct_prem_collns a, giac_acctrans b
                    WHERE a.gacc_tran_id = b.tran_id
                      AND b.tran_flag <> 'D'
                      AND b.tran_id NOT IN (SELECT c.gacc_tran_id
                                              FROM giac_reversals c
                                             WHERE c.gacc_tran_id = b.tran_id)
                      AND b140_iss_cd = p_iss_cd
                      AND b140_prem_seq_no = p_prem_seq_no
                      AND a.inst_no = i.inst_no)
         LOOP
            IF e.colln_amt_or IS NOT NULL THEN
               v_colln_amt_or := e.colln_amt_or;
            ELSE
               v_colln_amt_or := 0;
            END IF;
         END LOOP;
 
         v_bal_due := v_total_amt - (v_colln_amt + v_colln_amt_or);

         IF v_bal_due <> 0 THEN
            v_instno.balance_amt_due := v_bal_due;
         ELSIF v_bal_due = 0 THEN
            IF v_count = 1 THEN
               v_instno.balance_amt_due := NULL;
            END IF; 
         END IF;
          
         PIPE ROW (v_instno);
      END LOOP;
      
      RETURN;

   END get_inst_info2;  
   
   /*
   **  Created by    : Robert Virrey
   **  Date Created  : 09.04.2012
   **  Reference By  : GIACS007
   **  Description   : retrieve the details based on the policy
   */
   PROCEDURE get_policy_details (
       p_line_cd            IN       gipi_polbasic.line_cd%TYPE,
       p_subline_cd         IN       gipi_polbasic.subline_cd%TYPE,
       p_iss_cd             IN       gipi_polbasic.iss_cd%TYPE,
       p_issue_yy           IN       gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no         IN       gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no           IN       gipi_polbasic.renew_no%TYPE,
       p_ref_pol_no         IN       VARCHAR2,
       p_nbt_due            IN       VARCHAR2,
       p_new_iss_cd         OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_prem_seq_no        OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_inst_no            OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_balance_amt_due    OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_prem_balance_due   OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_tax_balance_due    OUT      giac_aging_soa_details.iss_cd%TYPE,
       p_currency_cd        OUT      gipi_invoice.currency_cd%TYPE,
       p_convert_rate       OUT      gipi_invoice.currency_rt%TYPE,
       p_nbt_currency_desc  OUT      giis_currency.currency_desc%TYPE,
       p_transaction_type   OUT      giac_direct_prem_collns.transaction_type%TYPE,
       p_msg_alert          OUT      VARCHAR2
    )
    IS
    BEGIN
       FOR pol IN (SELECT DISTINCT c.iss_cd, c.prem_seq_no, c.inst_no,
                                   c.balance_amt_due, c.prem_balance_due,
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
                               AND NVL (a.ref_pol_no, 0) = NVL (p_ref_pol_no, 0)
                               AND a.policy_id = b.policy_id
                               AND b.iss_cd = c.iss_cd
                               AND b.prem_seq_no = c.prem_seq_no
                               AND c.iss_cd = d.iss_cd
                               AND c.prem_seq_no = d.prem_seq_no
                               AND c.inst_no = d.inst_no
                               AND d.due_date <=
                                      DECODE (p_nbt_due,
                                              'N', SYSDATE,
                                              d.due_date
                                             )
                               AND c.balance_amt_due <> 0)
       LOOP
          p_new_iss_cd := pol.iss_cd;
          p_prem_seq_no := pol.prem_seq_no;
          p_inst_no := pol.inst_no;
          p_balance_amt_due := pol.balance_amt_due;
          p_prem_balance_due := pol.prem_balance_due;
          p_tax_balance_due := pol.tax_balance_due;

          FOR c1_rec IN (
              SELECT b.currency_cd, b.currency_rt, c.currency_desc
                FROM gipi_invoice b, giis_currency c
               WHERE b.currency_cd = c.main_currency_cd
                 AND b.iss_cd = pol.iss_cd
                 AND b.prem_seq_no = pol.prem_seq_no)
          LOOP
             p_currency_cd := c1_rec.currency_cd;
             p_convert_rate := c1_rec.currency_rt;
             p_nbt_currency_desc := c1_rec.currency_desc;
             EXIT;
          END LOOP;

          SELECT DECODE (SIGN (pol.balance_amt_due), 1, 1, 2)
            INTO p_transaction_type
            FROM DUAL;
          
          check_premium_payt_for_special (pol.iss_cd, pol.prem_seq_no, p_msg_alert);
       END LOOP;
    END;
    
    FUNCTION get_pack_invoices(
      p_due             VARCHAR2,
      p_line_cd         gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_pack_polbasic.renew_no%TYPE,
      p_user_id         VARCHAR2
   )
    RETURN invoice_listing_tab PIPELINED
   IS
      v_invoice      invoice_listing_type;
   BEGIN
      --raise_application_error(-20001, p_due||'--'|| p_line_cd ||'--'|| p_subline_cd ||'--'|| p_iss_cd ||'--'|| p_issue_yy ||'--'|| p_pol_seq_no ||'--'||p_renew_no);
      IF p_due = 'Y'
       THEN
          FOR y IN
             (SELECT a.line_cd, a.subline_cd, b.iss_cd, b.prem_seq_no, b.inst_no,
                     b.balance_amt_due
                FROM gipi_polbasic a,
                     giac_aging_soa_details b,
                     gipi_pack_polbasic c,
                     gipi_invoice d,
                     gipi_installment e
               WHERE d.policy_id = a.policy_id
                 AND a.pack_policy_id = c.pack_policy_id
                 AND d.iss_cd = e.iss_cd
                 AND d.prem_seq_no = e.prem_seq_no
                 AND e.iss_cd = b.iss_cd
                 AND e.prem_seq_no = b.prem_seq_no
                 AND e.inst_no = b.inst_no
                 AND c.pack_policy_id IN (
                        SELECT pack_policy_id
                          FROM gipi_pack_polbasic
                         WHERE line_cd = p_line_cd
                           AND subline_cd = p_subline_cd
                           AND iss_cd = p_iss_cd
                           AND issue_yy = p_issue_yy
                           AND pol_seq_no = p_pol_seq_no
                           AND renew_no = p_renew_no)
                 AND ABS(b.balance_amt_due) > 0    -- SR-20000 : shan 08.12.2015
                 AND EXISTS (SELECT *
                               FROM TABLE (security_access.get_branch_line ('AC', 'GIACS007', p_user_id))
                              WHERE branch_cd = d.iss_cd))
    --added by totel--8/1/2006--pra nde n sya makita s invoice canvas pag na-settle n sya s GDPC block a.k.a. 'Direct Premium Collection'
          LOOP
             v_invoice.line_cd := y.line_cd;
             v_invoice.subline_cd := y.subline_cd;
             v_invoice.iss_cd := y.iss_cd;
             v_invoice.prem_seq_no := y.prem_seq_no;
             v_invoice.inst_no := y.inst_no;
             v_invoice.balance_amt_due := y.balance_amt_due;
             PIPE ROW (v_invoice);
          END LOOP;
       ELSIF p_due = 'N'
       THEN
          FOR n IN
             (SELECT a.line_cd, a.subline_cd, b.iss_cd, b.prem_seq_no, b.inst_no,
                     b.balance_amt_due
                FROM gipi_polbasic a,
                     giac_aging_soa_details b,
                     gipi_pack_polbasic c,
                     gipi_invoice d,
                     gipi_installment e
               WHERE d.policy_id = a.policy_id
                 AND a.pack_policy_id = c.pack_policy_id
                 AND d.iss_cd = e.iss_cd
                 AND d.prem_seq_no = e.prem_seq_no
                 AND e.iss_cd = b.iss_cd
                 AND e.prem_seq_no = b.prem_seq_no
                 AND e.inst_no = b.inst_no
                 AND c.pack_policy_id IN (
                        SELECT pack_policy_id
                          FROM gipi_pack_polbasic
                         WHERE line_cd = p_line_cd
                           AND subline_cd = p_subline_cd
                           AND iss_cd = p_iss_cd
                           AND issue_yy = p_issue_yy
                           AND pol_seq_no = p_pol_seq_no
                           AND renew_no = p_renew_no)
                 AND e.due_date <= SYSDATE
                 AND ABS(b.balance_amt_due) > 0     -- SR-20000 : shan 08.12.2015
                 AND EXISTS (SELECT *
                               FROM TABLE (security_access.get_branch_line ('AC', 'GIACS007', p_user_id))
                              WHERE branch_cd = d.iss_cd))
    --added by totel--8/1/2006--pra nde n sya makita s invoice canvas pag na-settle n sya s GDPC block a.k.a. 'Direct Premium Collection'
          LOOP
             v_invoice.line_cd := n.line_cd;
             v_invoice.subline_cd := n.subline_cd;
             v_invoice.iss_cd := n.iss_cd;
             v_invoice.prem_seq_no := n.prem_seq_no;
             v_invoice.inst_no := n.inst_no;
             v_invoice.balance_amt_due := n.balance_amt_due;
             PIPE ROW (v_invoice);
          END LOOP;
       END IF;

   END get_pack_invoices;
   
   
   /*
   **  Created by    : Marie Kris Felipe
   **  Date Created  : 09.10.2013
   **  Reference By  : GIPIS137 - View Invoice Information
   **  Description   : Retrieves the soa details based on the given iss_cd and prem_seq_no
   */
   FUNCTION get_soa_details (
        p_iss_Cd            giac_aging_soa_details.iss_Cd%TYPE,
        p_prem_seq_no       giac_aging_soa_details.prem_seq_no%TYPE
   ) RETURN invoice_soa_details_tab PIPELINED
   IS
        v_soa       invoice_soa_details_type;
   BEGIN
   
        FOR rec IN (SELECT iss_cd, prem_seq_no, inst_no, next_age_level_dt,
                           total_amount_due, total_payments, temp_payments, 
                           balance_amt_due, prem_balance_due, tax_balance_due       
                      FROM GIAC_AGING_SOA_DETAILS
                     WHERE iss_cd       = p_iss_cd
                       AND prem_seq_no  = p_prem_seq_no)
        LOOP
            v_soa.iss_cd := rec.iss_Cd;
            v_soa.prem_seq_no := rec.prem_seq_no;
            v_soa.inst_no := rec.inst_no;
            v_soa.next_age_level_dt := TO_CHAR(rec.next_age_level_dt, 'mm-dd-yyyy');
            v_soa.total_amt_due := rec.total_amount_due;
            v_soa.total_payments := rec.total_payments;
            v_soa.temp_payments := rec.temp_payments;
            v_soa.balance_amt_due := rec.balance_amt_due;
            v_soa.prem_balance_due := rec.prem_balance_due;
            v_soa.tax_balance_due := rec.tax_balance_due;
            
            PIPE ROW(v_soa);
        END LOOP;
   
   END get_soa_details;
       
END giac_aging_soa_details_pkg;
/



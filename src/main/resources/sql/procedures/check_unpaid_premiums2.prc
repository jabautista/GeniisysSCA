DROP PROCEDURE CPI.CHECK_UNPAID_PREMIUMS2;

CREATE OR REPLACE PROCEDURE CPI.check_unpaid_premiums2 (
   p_claim_id         IN       gicl_claims.claim_id%TYPE,
   p_eval_id          IN       gicl_mc_evaluation.eval_id%TYPE,
   p_line_cd          IN       gicl_claims.line_cd%TYPE,
   p_subline_cd       IN       gicl_claims.subline_cd%TYPE,
   p_pol_iss_cd       IN       gicl_claims.pol_iss_cd%TYPE,
   p_clm_file_date    IN       gicl_claims.clm_file_date%TYPE,
   p_issue_yy         IN       gicl_claims.issue_yy%TYPE,
   p_pol_seq_no       IN       gicl_claims.pol_seq_no%TYPE,
   p_renew_no         IN       gicl_claims.renew_no%TYPE,
   p_user_id          IN       giis_users.user_id%TYPE,
   p_print_fl         OUT      VARCHAR
)
AS
   --v_print_fl            VARCHAR2(1) := 'N';
   v_param_iss_cd      giac_parameters.param_value_v%TYPE;
   v_balance_amt_due   giac_aging_soa_details.balance_amt_due%TYPE   := 0;
   v_prem_seq_no       gipi_invoice.prem_seq_no%TYPE;
  /*
**  Created by    :  Irwin Tabisora
**  Date Created  : 05.09.2012
**  Reference By  : GICLS070 - MC EVALUATION REPORT
**  Description   : Check if claim has unpaid premium
**                  for printing of LOA or CSL with unpaid premium
*/
BEGIN
   p_print_fl := 'Y';

   BEGIN
      SELECT param_value_v
        INTO v_param_iss_cd
        FROM giac_parameters
       WHERE param_name = 'RI_ISS_CD';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         raise_application_error
            (-20001,
             'Parameter ''RI_ISS_CD'' does not exist in table GIAC_PARAMETERS.'
            );
   END;

   IF p_pol_iss_cd = v_param_iss_cd
   THEN
      FOR i IN (SELECT b.prem_seq_no, d.balance_due
                  FROM giac_aging_ri_soa_details d,
                       gipi_installment a,
                       gipi_invoice b,
                       gipi_polbasic c
                 WHERE d.inst_no = a.inst_no
                   AND d.prem_seq_no = b.prem_seq_no
                   AND a.due_date <= p_clm_file_date
                   AND a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND b.policy_id = c.policy_id
                   AND b.policy_id = c.policy_id
                   AND c.line_cd = p_line_cd
                   AND c.subline_cd = p_subline_cd
                   AND c.iss_cd = p_pol_iss_cd
                   AND c.issue_yy = p_issue_yy
                   AND c.pol_seq_no = p_pol_seq_no
                   AND c.renew_no = p_renew_no)
      LOOP
         v_prem_seq_no := i.prem_seq_no;
         v_balance_amt_due := v_balance_amt_due + i.balance_due;
      END LOOP;
   ELSE                                                          --2nd hndi RI
      FOR i IN (SELECT b.prem_seq_no, d.balance_amt_due
                  FROM giac_aging_soa_details d,
                       gipi_installment a,
                       gipi_invoice b,
                       gipi_polbasic c
                 WHERE d.inst_no = a.inst_no
                   AND d.iss_cd = b.iss_cd
                   AND d.prem_seq_no = b.prem_seq_no
                   AND a.due_date <= p_clm_file_date
                   AND a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND b.policy_id = c.policy_id
                   AND b.policy_id = c.policy_id
                   AND c.line_cd = p_line_cd
                   AND c.subline_cd = p_subline_cd
                   AND c.iss_cd = p_pol_iss_cd
                   AND c.issue_yy = p_issue_yy
                   AND c.pol_seq_no = p_pol_seq_no
                   AND c.renew_no = p_renew_no)
      LOOP
         v_prem_seq_no := i.prem_seq_no;
         v_balance_amt_due := v_balance_amt_due + i.balance_amt_due;
      END LOOP;
   END IF;

   FOR i IN (SELECT collection_amt
               FROM giac_pdc_prem_colln a, giac_apdc_payt_dtl b
              WHERE a.pdc_id = b.pdc_id
                AND iss_cd = p_pol_iss_cd
                AND prem_seq_no = v_prem_seq_no
                AND b.check_flag <> 'C')
   LOOP
      v_balance_amt_due := v_balance_amt_due - i.collection_amt;
   END LOOP;

   IF v_balance_amt_due > 0
   THEN
      p_print_fl := 'N';
   END IF;
   --p_print_fl := 'N'; --testing
END;
/



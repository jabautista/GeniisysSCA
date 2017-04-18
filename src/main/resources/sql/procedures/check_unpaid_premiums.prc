DROP PROCEDURE CPI.CHECK_UNPAID_PREMIUMS;

CREATE OR REPLACE PROCEDURE CPI.CHECK_UNPAID_PREMIUMS
(p_claim_id        IN  GICL_CLAIMS.claim_id%TYPE,
 p_eval_id         IN  GICL_MC_EVALUATION.eval_id%TYPE,
 p_clm_loss_id     IN  GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_payee_class_cd  IN  GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
 p_payee_cd        IN  GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
 p_line_cd         IN  GICL_CLAIMS.line_cd%TYPE,
 p_subline_cd      IN  GICL_CLAIMS.subline_cd%TYPE,
 p_pol_iss_cd      IN  GICL_CLAIMS.pol_iss_cd%TYPE,
 p_clm_file_date   IN  GICL_CLAIMS.clm_file_date%TYPE,
 p_issue_yy        IN  GICL_CLAIMS.issue_yy%TYPE,
 p_pol_seq_no      IN  GICL_CLAIMS.pol_seq_no%TYPE,
 p_renew_no        IN  GICL_CLAIMS.renew_no%TYPE,
 p_user_id         IN  GIIS_USERS.user_id%TYPE,
 p_ovrd_exist      OUT NUMBER,
 p_print_fl        OUT VARCHAR) AS
 
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.03.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Check if claim has unpaid premium  
**                  for printing of LOA or CSL with unpaid premium
*/ 
 
  v_param_iss_cd        GIAC_PARAMETERS.param_value_v%TYPE;
  v_balance_amt_due     GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE := 0;
  v_prem_seq_no         GIPI_INVOICE.prem_seq_no%TYPE;
  v_alert               NUMBER;
  v_ovrd_exist          NUMBER;
  v_print_fl            VARCHAR2(1) := 'N';

BEGIN
  BEGIN
    SELECT param_value_v
      INTO v_param_iss_cd
      FROM GIAC_PARAMETERS
     WHERE param_name = 'RI_ISS_CD';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Parameter ''RI_ISS_CD'' does not exist in table GIAC_PARAMETERS.');
  END;

  IF p_pol_iss_cd = v_param_iss_cd THEN       
     FOR i IN (SELECT b.prem_seq_no, d.balance_due
                FROM GIAC_AGING_RI_SOA_DETAILS d,
                     GIPI_INSTALLMENT a,
                     GIPI_INVOICE b,
                     GIPI_POLBASIC c
                WHERE d.inst_no     = a.inst_no
                  AND d.prem_seq_no = b.prem_seq_no
                  AND a.due_date   <= p_clm_file_date
                  AND a.iss_cd      = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND b.policy_id   = c.policy_id
                  AND b.policy_id   = c.policy_id   
                  AND c.line_cd     = p_line_cd
                  AND c.subline_cd  = p_subline_cd
                  AND c.iss_cd      = p_pol_iss_cd
                  AND c.issue_yy    = p_issue_yy
                  AND c.pol_seq_no  = p_pol_seq_no
                  AND c.renew_no    = p_renew_no)
     LOOP
        v_prem_seq_no      := i.prem_seq_no;
        v_balance_amt_due  := v_balance_amt_due + i.balance_due;
     END LOOP;
    
  ELSE                                            --2nd hndi RI
     FOR i IN (SELECT b.prem_seq_no, d.balance_amt_due
                 FROM GIAC_AGING_SOA_DETAILS d,
                      GIPI_INSTALLMENT a,
                      GIPI_INVOICE b,
                      GIPI_POLBASIC c 
                WHERE d.inst_no     = a.inst_no
                  AND d.iss_cd      = b.iss_cd
                  AND d.prem_seq_no = b.prem_seq_no
                  AND a.due_date   <= p_clm_file_date
                  AND a.iss_cd      = b.iss_cd
                  AND a.prem_seq_no = b.prem_seq_no
                  AND b.policy_id   = c.policy_id
                  AND b.policy_id   = c.policy_id   
                  AND c.line_cd     = p_line_cd
                  AND c.subline_cd  = p_subline_cd
                  AND c.iss_cd      = p_pol_iss_cd
                  AND c.issue_yy    = p_issue_yy
                  AND c.pol_seq_no  = p_pol_seq_no
                  AND c.renew_no    = p_renew_no)
     LOOP
        v_prem_seq_no      := i.prem_seq_no;
        v_balance_amt_due  := v_balance_amt_due + i.balance_amt_due;
     END LOOP;    
  END IF;

  FOR i IN (SELECT collection_amt
              FROM GIAC_PDC_PREM_COLLN a, 
                   GIAC_APDC_PAYT_DTL b
             WHERE a.pdc_id    = b.pdc_Id 
               AND iss_cd      = p_pol_iss_cd
               AND prem_seq_no = v_prem_seq_no
               AND b.check_flag <> 'C')
  LOOP
      v_balance_amt_due := v_balance_amt_due - i.collection_amt;
  END LOOP;                                

  IF v_balance_amt_due > 0 THEN  --policy has an unpaid premium
       
     IF CHECK_PRINT_ALLOWED(p_user_id) = 'N' THEN  --user is not allowed to print LOA or CSL with unpaid premium
        
        -- check if there is an existing override that was approved
        CHECK_REC_EXIST(p_claim_id, p_eval_id, p_clm_loss_id, p_payee_class_cd, p_payee_cd, v_ovrd_exist);   
        
        IF v_ovrd_exist = 4 THEN
           v_print_fl := 'Y'; 
             
        ELSIF v_ovrd_exist = 5 THEN --record exist but the request is not yet approved  --jen.04272007
           v_print_fl := 'N';
           
        ELSE
           v_print_fl := 'N';
            
        END IF;
        
     ELSE --user is allowed for printing LOA or CSL with unpaid premium        
        v_print_fl := 'Y'; 
     END IF;
       
  ELSE --policy has no unpaid premiums
     v_print_fl := 'Y';
              
  END IF;
  
  p_print_fl := v_print_fl;
  p_ovrd_exist := v_ovrd_exist;
    
END;
/



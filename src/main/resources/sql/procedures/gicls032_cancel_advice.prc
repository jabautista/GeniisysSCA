DROP PROCEDURE CPI.GICLS032_CANCEL_ADVICE;

CREATE OR REPLACE PROCEDURE CPI.gicls032_cancel_advice (
   p_claim_id        gicl_advice.claim_id%TYPE,
   p_advice_id       gicl_advice.advice_id%TYPE,
   p_function_code   VARCHAR2
)
IS
/**
  * Created by: Andrew Robes
  * Date created: 03.28.2012
  * Referenced by : (GICLS032 - Generate Advice)
  * Description : Converted procedure from gicls032 - :CONTROL.CANCEL_ADV - WHEN-BUTTON-PRESSED
  */
   v_line_cd      gicl_claims.line_cd%TYPE;
   v_subline_cd   gicl_claims.subline_cd%TYPE;
   v_iss_cd       gicl_claims.iss_cd%TYPE;
   v_clm_yy       gicl_claims.clm_yy%TYPE;
   v_clm_seq_no   gicl_claims.clm_seq_no%TYPE;
BEGIN
   SELECT line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no
     INTO v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, v_clm_seq_no
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   UPDATE gicl_advice
      SET advice_flag = 'N'
    WHERE advice_id = p_advice_id AND claim_id = p_claim_id;

   UPDATE gicl_advice
      SET apprvd_tag = 'N'
    WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

   UPDATE gicl_clm_loss_exp
      SET advice_id = NULL
    WHERE advice_id = p_advice_id AND claim_id = p_claim_id;

   UPDATE gicl_loa
      SET cancel_sw = 'Y'
    WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

   DELETE FROM gicl_acct_entries
         WHERE claim_id = p_claim_id AND advice_id = p_advice_id;

   --added by MAGeamoga 08/23/2011
   --it will delete the existing override requests once cancel button is pressed
   DELETE FROM gicl_function_override
         WHERE line_cd = v_line_cd
           AND iss_cd = v_iss_cd
           AND module_id IN (SELECT module_id
                               FROM giac_modules
                              WHERE module_name = 'GICLS032')
           AND function_cd = p_function_code
           AND display LIKE
                     '%'
                  || 'Claim no. : '
                  || v_line_cd
                  || '-'
                  || v_subline_cd
                  || '-'
                  || v_iss_cd
                  || '-'
                  || LPAD (v_clm_yy, 2, 0)
                  || '-'
                  || LPAD (v_clm_seq_no, 7, 0)
                  || '%';                                                                                  --end of the statement;
END;
/



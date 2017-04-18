CREATE OR REPLACE PROCEDURE CPI.check_policy_for_renewal (p_par_id           IN  GIPI_WPOLNREP.par_id%TYPE,
                                                          p_line_cd          IN  GIPI_POLBASIC.line_cd%TYPE,    --to get the policy_id
                                                          p_subline_cd       IN  GIPI_POLBASIC.subline_cd%TYPE, --to get the policy_id
                                                          p_iss_cd           IN  GIPI_POLBASIC.iss_cd%TYPE,     --to get the policy_id
                                                          p_issue_yy         IN  GIPI_POLBASIC.issue_yy%TYPE,   --to get the policy_id
                                                          p_pol_seq_no       IN  GIPI_POLBASIC.pol_seq_no%TYPE, --to get the policy_id  
                                                          p_renew_no         IN  GIPI_POLBASIC.renew_no%TYPE,   --to get the policy_id
                                                          p_pol_flag         IN  GIPI_POLBASIC.pol_flag%TYPE,   --used for validation
                                                          p_message          OUT VARCHAR2,                      --out the validation message
                                                          p_policy_id        OUT GIPI_POLBASIC.policy_id%TYPE,  --out the policy_id
                                                          p_expiry_date      OUT GIPI_POLBASIC.expiry_date%TYPE)
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  February 03, 2010
**  Reference By : (GIPIS002 - Renewal/Replacement Details)
**  Description : This procedure is used to check the policy to be renewed or replaced.
                  This will return the validation message and the policy_id.
*/                                                         
IS
  
  v_message_flag VARCHAR2(1);
  v_separator    VARCHAR2(2) := '@@';
  v_ongoing      VARCHAR2(1);
  v_pol_flag     VARCHAR2(1);
  v_count        NUMBER(1);
  v_latest       VARCHAR2(1); --added by gab 5.10.2016 SR 21421

BEGIN
  
  p_policy_id := GIPI_POLBASIC_PKG.GET_POLID(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
  
  IF (p_policy_id IS NULL OR p_policy_id = 0) THEN
      p_message := 'Policy entered does not exist, please do the necessary action.';
  ELSE
      v_count    := GIPI_POLNREP_PKG.get_polnrep_count(p_policy_id);
      v_pol_flag := GIPI_POLBASIC_PKG.GET_POL_FLAG(p_policy_id);
      v_ongoing  := GIPI_WPOLNREP_PKG.get_ongoing_wpolnrep(p_policy_id, p_par_id);
      --added condition by jmm for SR-23199
      IF NVL(giisp.v('ALLOW_MULTI_POLNREP'), 'N') = 'Y' THEN
        v_latest := 'N';
      ELSE
        v_latest := GIPI_POLNREP_PKG.get_latest_renew_no (p_policy_id); --added by gab 05.10.2016 SR 21421 
      END IF; 
      --end
      
      BEGIN
        /* SELECT expiry_date INTO p_expiry_date
          FROM gipi_polbasic 
        WHERE policy_id = p_policy_id; */
        -- marco - 07.19.2013 - replaced select statement to retrieve latest expiry_date
        SELECT extract_expiry2(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no)
          INTO p_expiry_date
          FROM DUAL;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            NULL;
      END;
      
      IF (v_pol_flag IN ('1','2','3','4','X') AND p_pol_flag = '3') THEN -- 'X' Added by Jerome Bautista 08.07.2015 SR 19653
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'Policy is not yet spoiled. Cannot replace policy.'; --Modified by Jerome Bautista 08.07.2015 SR 19653
      ELSIF v_ongoing = 'Y' THEN --added by gab 05.10.2016 SR 21421
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'An ongoing PAR is already renewing/replacing this policy.';
      ELSIF v_latest = 'Y' THEN
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'Please enter the latest renewal/replacement number.'; --end
      ELSIF (GICL_CLAIMS_PKG.POLICY_HAS_CLAIMS(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no)) THEN
          IF NVL(giisp.v('ALLOW_MANUAL_RENEW_WITH_CLM'),'N') = 'Y' THEN 
              --check parameter if user will be allowed to continue processing manual renewal with existing claim by MAC 03/21/2013.
              v_message_flag := '4';
              p_message := v_message_flag || v_separator || 'Policy has claim(s). Would you like to continue?';
          ELSE
              v_message_flag := '0';
              p_message := v_message_flag || v_separator || 'The policy has claims.';
          END IF;
      ELSIF (v_pol_flag IN ('4','5') AND p_pol_flag = '2') THEN -- Added by Jerome Bautista 08.07.2015 SR 19653
          v_message_flag := '3';
          p_message := v_message_flag || v_separator || 'Policy is already cancelled/spoiled. Cannot renew the policy.';
      ELSE    
--      modified to check v_ongoing first before checking for claims by gab 05.10.2016 SR 21421    
--        IF v_ongoing = 'Y' THEN
--          v_message_flag := '0';
--          p_message := v_message_flag || v_separator || 'An ongoing PAR is already renewing/replacing this policy.';        
        IF v_count > 0 THEN
          v_message_flag := '1';
          p_message := v_message_flag || v_separator || TO_CHAR(p_policy_id) || v_separator || TO_CHAR(v_count);
        ELSE 
          v_message_flag := '2';
          p_message := v_message_flag || v_separator || TO_CHAR(p_policy_id);                   
        END IF;     
        
      END IF;
  END IF;
END check_policy_for_renewal;
/



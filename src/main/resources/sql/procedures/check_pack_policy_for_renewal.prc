CREATE OR REPLACE PROCEDURE CPI.check_pack_policy_for_renewal 
( p_pack_par_id      IN  GIPI_PACK_WPOLNREP.pack_par_id%TYPE,
  p_line_cd          IN  GIPI_PACK_POLBASIC.line_cd%TYPE,   
  p_subline_cd       IN  GIPI_PACK_POLBASIC.subline_cd%TYPE,
  p_iss_cd           IN  GIPI_PACK_POLBASIC.iss_cd%TYPE,    
  p_issue_yy         IN  GIPI_PACK_POLBASIC.issue_yy%TYPE,  
  p_pol_seq_no       IN  GIPI_PACK_POLBASIC.pol_seq_no%TYPE, 
  p_renew_no         IN  GIPI_PACK_POLBASIC.renew_no%TYPE, 
  p_pol_flag         IN  GIPI_PACK_POLBASIC.pol_flag%TYPE, 
  p_message          OUT VARCHAR2,                    
  p_pack_policy_id   OUT GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
  p_expiry_date      OUT VARCHAR2)--GIPI_POLBASIC.expiry_date%TYPE)  --modified by John Daniel 06.01.2016, not included in SR task; javascript does not recognize oracle date format as a valid date 
                                                            		 --thus converting the date to a readable/convertible format before passing to the jsp is necessary  

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 09, 2011
**  Reference By : (GIPIS002A - Package PAR Renewal/Replacement Details)
**  Description :  This procedure is used to check the policy to be renewed or replaced.
**                 This will return the validation message and the pack_policy_id.
*/                                                         
IS
  
  v_message_flag VARCHAR2(1);
  v_separator    VARCHAR2(2) := '@@';
  v_ongoing      VARCHAR2(1);
  v_pol_flag     VARCHAR2(1);
  v_count        NUMBER(1);

BEGIN
  
  p_pack_policy_id := GIPI_PACK_POLBASIC_PKG.get_pack_policy_id(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);
  
  IF (p_pack_policy_id IS NULL OR p_pack_policy_id = 0) THEN
      v_message_flag := '0';
      p_message := v_message_flag || v_separator ||  'Policy entered does not exist, please do the necessary action.';
  ELSE
      v_count    := GIPI_PACK_POLNREP_PKG.get_pack_polnrep_count(p_pack_policy_id);
      v_pol_flag := GIPI_PACK_POLBASIC_PKG.get_pol_flag(p_pack_policy_id);
      v_ongoing  := GIPI_PACK_WPOLNREP_PKG.get_ongoing_pack_wpolnrep(p_pack_policy_id, p_pack_par_id); 
      
      BEGIN
        SELECT TO_CHAR(expiry_date, 'MM/DD/YYYY') INTO p_expiry_date --modified by John Daniel, 06.01.2016
          FROM gipi_pack_polbasic 
         WHERE pack_policy_id = p_pack_policy_id;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            NULL;
      END;
      
      IF (v_pol_flag IN ('1','2','3') AND p_pol_flag = '3') THEN
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'Policy is not yet cancelled/spoiled/expired, cannot replace policy.';
      ELSIF (GICL_CLAIMS_PKG.POLICY_HAS_CLAIMS(p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no)) THEN
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'The policy has claims.';
      ELSE       
        IF v_ongoing = 'Y' THEN
          v_message_flag := '0';
          p_message := v_message_flag || v_separator || 'An ongoing PAR is already renewing/replacing this policy.';        
               
        ELSIF v_count > 0 THEN
          v_message_flag := '1';
          p_message := v_message_flag || v_separator || TO_CHAR(p_pack_policy_id) || v_separator || TO_CHAR(v_count);
        ELSE 
          v_message_flag := '2';
          p_message := v_message_flag || v_separator || TO_CHAR(p_pack_policy_id);                   
        END IF;     
        
      END IF;
  END IF;
END check_pack_policy_for_renewal;
/



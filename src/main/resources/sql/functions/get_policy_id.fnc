DROP FUNCTION CPI.GET_POLICY_ID;

CREATE OR REPLACE FUNCTION CPI.GET_POLICY_ID(p_line_cd      GIPI_POLBASIC.line_cd%TYPE,
                                         p_subline_cd   GIPI_POLBASIC.subline_cd%TYPE,
                                         p_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
                                         p_issue_yy     GIPI_POLBASIC.issue_yy%TYPE,
                                         p_pol_seq_no   GIPI_POLBASIC.pol_seq_no%TYPE,
                                         p_renew_no     GIPI_POLBASIC.renew_no%TYPE) 
  RETURN GIPI_POLBASIC.policy_id%TYPE IS
/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : June 7, 2010
**  Reference By  : (GIPIS058 - Endorsement par list)
**  Description   : Function that will return the policy_id. 
*/ 
  
  v_policy_id GIPI_POLBASIC.policy_id%TYPE;
  
BEGIN
  FOR i IN (
    SELECT policy_id
      FROM GIPI_POLBASIC
     WHERE line_cd      =  p_line_cd
       AND subline_cd   =  p_subline_cd
       AND iss_cd       =  p_iss_cd
       AND issue_yy     =  p_issue_yy
       AND pol_seq_no   =  p_pol_seq_no
       AND renew_no     =  p_renew_no)
  LOOP
    v_policy_id := i.policy_id;
    EXIT;
  END LOOP;    
  RETURN v_policy_id;
END GET_POLICY_ID;
/



DROP PROCEDURE CPI.GIAC026_ISS_CD_TRIGGER;

CREATE OR REPLACE PROCEDURE CPI.GIAC026_ISS_CD_TRIGGER(
   p_b140_iss_cd				 IN     GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
   p_b140_prem_seq_no			 IN     GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
   p_inst_no					 IN     GIAC_AGING_SOA_DETAILS.inst_no%TYPE,
   p_line_cd					 IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
   p_subline_cd					 IN OUT GIAC_PREM_DEPOSIT.subline_cd%TYPE,
   p_iss_cd					 	 IN OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
   p_issue_yy					 IN OUT GIAC_PREM_DEPOSIT.issue_yy%TYPE,
   p_pol_seq_no					 IN OUT GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
   p_renew_no					 IN OUT GIAC_PREM_DEPOSIT.renew_no%TYPE
 )
IS
   /*
  **  Created by   :  Emman
  **  Date Created :  08.09.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Executes the procedure ISS_CD_TRIGGER of GIACS026 and gets the updated fields
  */ 
BEGIN
  DECLARE
    v_policy_id   giac_aging_soa_details.policy_id%type;

    CURSOR A IS SELECT policy_id 
                FROM giac_aging_soa_details gagd
                WHERE gagd.iss_cd = p_b140_iss_cd
                AND GAGD.PREM_SEQ_NO  = p_b140_prem_seq_no
                AND GAGD.INST_NO   = p_inst_no;

  BEGIN
    OPEN A;
    FETCH A INTO v_policy_id;
    CLOSE A;
	
    SELECT a.line_cd, a.subline_cd, a.iss_cd,
           a.issue_yy, a.pol_seq_no, a.renew_no
      INTO p_line_cd, p_subline_cd , p_iss_cd ,
           p_issue_yy , p_pol_seq_no , p_renew_no 
      FROM gipi_polbasic a
      WHERE a.policy_id = v_policy_id;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN null;
    WHEN TOO_MANY_ROWS THEN 
      p_line_cd := null;
	  p_subline_cd := null;
	  p_iss_cd := null;
	  p_issue_yy := null;
	  p_pol_seq_no := null;
	  p_renew_no := null;
  END;
END;
/



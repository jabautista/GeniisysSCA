DROP PROCEDURE CPI.CHECK_PACK_POLICY_FOR_SPOILAGE;

CREATE OR REPLACE PROCEDURE CPI.CHECK_PACK_POLICY_FOR_SPOILAGE(
		    p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
			p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
			p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
			p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
			p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
			p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE,
			p_msg_alert		OUT VARCHAR2
		  )
AS
  /*
	**  Created by		: Emman
	**  Date Created 	: 11.22.2010
	**  Reference By 	: (GIPIS031A - Pack Endt Basic Information)
	**  Description 	: This procedure is used for checking if the policy_no entered is already spoiled
	*/
	
  v_spld   VARCHAR2(1) := 'N';
  v_spld1  VARCHAR2(1) := 'N';
BEGIN
  FOR tag IN (
    SELECT spld_flag
      FROM gipi_pack_polbasic
     WHERE line_cd    = p_line_cd
       AND subline_cd = p_subline_cd
       AND iss_cd     = p_iss_cd
       AND issue_yy   = p_issue_yy
       AND pol_seq_no = p_pol_seq_no
       AND renew_no   = p_renew_no
     ORDER BY eff_date desc)
  LOOP
    IF tag.spld_flag = 2 THEN
       v_spld := 'Y';
       EXIT;
    END IF;
  END LOOP;  

  FOR spld IN (
    SELECT spld_flag
      FROM gipi_pack_polbasic
     WHERE line_cd     = p_line_cd
       AND subline_cd  = p_subline_cd
       AND iss_cd      = p_iss_cd
       AND issue_yy    = p_issue_yy
       AND pol_seq_no  = p_pol_seq_no
       AND renew_no    = p_renew_no
       AND endt_seq_no = 0
	   AND (endt_yy	   = 0 OR endt_yy IS NULL))
  LOOP
    IF spld.spld_flag = 3 THEN
       v_spld1 := 'Y';
       EXIT;
    END IF;
  END LOOP;  

  IF v_spld1 = 'Y' THEN
     p_msg_alert := 'Policy has been spoiled. Cannot endorse a spoiled policy. ';
  ELSIF v_spld = 'Y' THEN
     p_msg_alert := 'Policy / Current endorsement has been tagged for spoilage. '||
               'Please do the necessary action before creating another one.';
  END IF;
END CHECK_PACK_POLICY_FOR_SPOILAGE;
/



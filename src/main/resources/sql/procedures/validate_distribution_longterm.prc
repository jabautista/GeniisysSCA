DROP PROCEDURE CPI.VALIDATE_DISTRIBUTION_LONGTERM;

CREATE OR REPLACE PROCEDURE CPI.Validate_Distribution_Longterm (
	   p_par_id   	  IN	GIPI_WPOLBAS.par_id%TYPE,
	   p_line_cd	  IN	GIPI_WPOLBAS.line_cd%TYPE,
	   p_iss_cd		  IN	GIPI_WPOLBAS.iss_cd%TYPE,
	   p_msg_alert    OUT   VARCHAR2
	   )
	IS
	v_delete_sw		  VARCHAR2(200);
	v_global_enter	  VARCHAR2(200) := 'Y';
	v_msg_alert		  VARCHAR2(3200);
BEGIN 
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : for long term distribution
  */
	  Post_Forms_Commit_B_Gipis002(v_global_enter, p_par_id, p_line_cd, p_iss_cd);
	  Create_Distribution_Longterm(p_par_id,p_line_cd,v_msg_alert);
	  Post_Forms_Commit_C_Gipis002(v_delete_sw, p_par_id);
	  
	  p_msg_alert := NVL(v_msg_alert,'SUCCESS');
END;
/



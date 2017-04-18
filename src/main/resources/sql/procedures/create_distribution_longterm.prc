DROP PROCEDURE CPI.CREATE_DISTRIBUTION_LONGTERM;

CREATE OR REPLACE PROCEDURE CPI.Create_Distribution_Longterm(
	   p_par_id	   IN  GIPI_WPOLBAS.par_id%TYPE,
	   p_line_cd   IN  GIPI_WPOLBAS.line_cd%TYPE,
	   p_msg_alert OUT VARCHAR2)
 IS
	v_exists NUMBER;
BEGIN	
	/*	Reference CREATE_DISTRIBUTION_LONGTERM program unit in GIPIS002
	**	Jerome Orio
	*/
  Create_Dist_Long_A_Gipis002(p_par_id);	 
  BEGIN
  	SELECT 1
  		INTO v_exists
  	  FROM GIPI_WINVOICE
  	 WHERE par_id = p_par_id;
  	IF SQL%FOUND THEN
  		Create_Giuw_Pol_Dist(p_par_id ,p_line_cd, p_msg_alert);
  	END IF;	 
  EXCEPTION 
  	WHEN NO_DATA_FOUND THEN  	  
  		NULL;
  	WHEN TOO_MANY_ROWS THEN
  		Create_Giuw_Pol_Dist(p_par_id ,p_line_cd, p_msg_alert);
  END;
END;
/



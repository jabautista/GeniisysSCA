DROP FUNCTION CPI.CHANGE_INCLUDE_PACK_VALUE;

CREATE OR REPLACE FUNCTION CPI.CHANGE_INCLUDE_PACK_VALUE(
	p_line_cd	giis_line.line_cd%TYPE
)
RETURN VARCHAR
AS
	is_package_line NUMBER := 0;
	v_inc_pack_val	VARCHAR2(1) := 'Y';
BEGIN
	SELECT 1
  	  INTO is_package_line
  	  FROM giis_line
  	 WHERE 1 = 1
  	   AND pack_pol_flag = 'Y'
  	   AND line_cd = p_line_cd;
	   
	IF is_package_line = 1 THEN 
  		v_inc_pack_val := 'Y';
  	ELSE
  		v_inc_pack_val := 'N';
  	END IF;
	
	RETURN v_inc_pack_val;
	
EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	  	RETURN 'N';	  
	WHEN TOO_MANY_ROWS THEN
		RETURN 'Y'; 
END;
/



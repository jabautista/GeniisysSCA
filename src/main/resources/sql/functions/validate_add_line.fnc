DROP FUNCTION CPI.VALIDATE_ADD_LINE;

CREATE OR REPLACE FUNCTION CPI.validate_add_line (p_line_cd VARCHAR2)
   RETURN VARCHAR2
IS
   v_line_cd     VARCHAR2 (2);
BEGIN
     SELECT( SELECT '0'
      		   FROM GIIS_LINE
	 		   WHERE LOWER (line_cd) LIKE LOWER (p_line_cd)
			)
	   INTO v_line_cd
	 FROM DUAL;

   IF v_line_cd IS NOT NULL
   THEN
      RETURN v_line_cd;
  END IF;
   
   RETURN '1';
END;
/



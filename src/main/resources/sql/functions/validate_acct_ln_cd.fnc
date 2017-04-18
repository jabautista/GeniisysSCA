DROP FUNCTION CPI.VALIDATE_ACCT_LN_CD;

CREATE OR REPLACE FUNCTION CPI.validate_acct_ln_cd (p_acct_ln_cd NUMBER)
   RETURN VARCHAR2
IS
   v_acct_line_cd     VARCHAR2 (2);
BEGIN
     SELECT( SELECT '0'
      		   FROM GIIS_LINE
	 		   WHERE acct_line_cd = p_acct_ln_cd
			)
	   INTO v_acct_line_cd
	 FROM DUAL;

   IF v_acct_line_cd IS NOT NULL
   THEN
      RETURN v_acct_line_cd;
  END IF;
   
   RETURN '1';
END;
/



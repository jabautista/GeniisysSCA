DROP FUNCTION CPI.GET_ACCT_CODE;

CREATE OR REPLACE FUNCTION CPI.get_acct_code(p_accd_id NUMBER)
RETURN VARCHAR2 AS
  v_acct_cd  VARCHAR2(500);
BEGIN
  FOR rec IN (
   SELECT TO_CHAR(gl_acct_category)||LTRIM(TO_CHAR(gl_control_acct,'09'))||LTRIM(TO_CHAR(gl_sub_acct_1,'09'))
          ||LTRIM(TO_CHAR(gl_sub_acct_2,'09'))||LTRIM(TO_CHAR(gl_sub_acct_3,'09'))||LTRIM(TO_CHAR(gl_sub_acct_4,'09'))
	      ||LTRIM(TO_CHAR(gl_sub_acct_5,'09'))||LTRIM(TO_CHAR(gl_sub_acct_6,'09'))||LTRIM(TO_CHAR(gl_sub_acct_7,'09')) acct_code
     FROM giac_chart_of_accts
    WHERE gl_acct_id = p_accd_id)
  LOOP
    v_acct_cd := rec.acct_code;
    EXIT;
  END LOOP;
  RETURN (v_acct_cd);
END;
/



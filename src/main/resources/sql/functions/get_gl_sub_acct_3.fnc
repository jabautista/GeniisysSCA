DROP FUNCTION CPI.GET_GL_SUB_ACCT_3;

CREATE OR REPLACE FUNCTION CPI.get_gl_sub_acct_3(p_accd_id NUMBER)
RETURN NUMBER AS
  v_gl_sub_acct_3  giac_chart_of_accts.gl_sub_acct_3%TYPE;
BEGIN
  FOR rec IN (
   SELECT gl_sub_acct_3
     FROM giac_chart_of_accts
    WHERE gl_acct_id = p_accd_id)
  LOOP
    v_gl_sub_acct_3 := rec.gl_sub_acct_3;
    EXIT;
  END LOOP;
  RETURN (v_gl_sub_acct_3);
END;
/



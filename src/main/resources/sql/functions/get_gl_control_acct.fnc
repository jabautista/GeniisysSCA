DROP FUNCTION CPI.GET_GL_CONTROL_ACCT;

CREATE OR REPLACE FUNCTION CPI.get_gl_control_acct(p_accd_id NUMBER)
RETURN NUMBER AS
  v_gl_control_acct  giac_chart_of_accts.gl_control_acct%TYPE;
BEGIN
  FOR rec IN (
   SELECT gl_control_acct
     FROM giac_chart_of_accts
    WHERE gl_acct_id = p_accd_id)
  LOOP
    v_gl_control_acct := rec.gl_control_acct;
    EXIT;
  END LOOP;
  RETURN (v_gl_control_acct);
END;
/



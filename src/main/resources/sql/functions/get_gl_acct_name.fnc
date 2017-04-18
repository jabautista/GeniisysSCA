DROP FUNCTION CPI.GET_GL_ACCT_NAME;

CREATE OR REPLACE FUNCTION CPI.get_gl_acct_name(p_accd_id NUMBER)
RETURN VARCHAR2 AS
  v_acct_name giac_chart_of_accts.gl_acct_name%TYPE;
BEGIN
  FOR rec IN (
   SELECT gl_acct_name
     FROM giac_chart_of_accts
    WHERE gl_acct_id = p_accd_id)
  LOOP
    v_acct_name := rec.gl_acct_name;
    EXIT;
  END LOOP;
  RETURN (v_acct_name);
END;
/



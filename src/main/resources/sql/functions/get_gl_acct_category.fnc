DROP FUNCTION CPI.GET_GL_ACCT_CATEGORY;

CREATE OR REPLACE FUNCTION CPI.get_gl_acct_category(p_accd_id NUMBER)
RETURN NUMBER AS
  v_acct_cat  giac_chart_of_accts.gl_acct_category%TYPE;
BEGIN
  FOR rec IN (
   SELECT gl_acct_category
     FROM giac_chart_of_accts
    WHERE gl_acct_id = p_accd_id)
  LOOP
    v_acct_cat := rec.gl_acct_category;
    EXIT;
  END LOOP;
  RETURN (v_acct_cat);
END;
/



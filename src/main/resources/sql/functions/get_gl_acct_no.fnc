DROP FUNCTION CPI.GET_GL_ACCT_NO;

CREATE OR REPLACE FUNCTION CPI.get_gl_acct_no (
   v_gl_acct_id   giac_chart_of_accts.gl_acct_id%TYPE)
/*
||  Author: Terrence To
||  Overview: returns gl_acct_no
||  Major Modifications(when, who, what):
||  06/04/2002 - TRN - Create function
*/
RETURN VARCHAR2 IS
   v_gl_acct_no   VARCHAR2 (30) := NULL;
   CURSOR gl (v_gl_acct_id giac_chart_of_accts.gl_acct_id%TYPE)   IS
 SELECT TO_CHAR(gl_acct_category)||'-'||
LTRIM(TO_CHAR(gl_control_acct,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_1,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_2,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_3,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_4,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_5,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_6,'09'))||'-'||
LTRIM(TO_CHAR(gl_sub_acct_7,'09')) gl_acct_no
FROM giac_chart_of_accts
WHERE gl_acct_id = v_gl_acct_id;
BEGIN
   FOR rec IN gl (v_gl_acct_id)
   LOOP
      v_gl_acct_no := rec.gl_acct_no;
      EXIT;
   END LOOP rec;
   RETURN (v_gl_acct_no);
END get_gl_acct_no;
/



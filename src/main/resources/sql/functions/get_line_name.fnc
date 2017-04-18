DROP FUNCTION CPI.GET_LINE_NAME;

CREATE OR REPLACE FUNCTION CPI.GET_LINE_NAME (p_line_cd   IN giis_line.line_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_line_cd   IN giis_line.line_cd%TYPE) IS
   SELECT line_name
     FROM giis_line
    WHERE line_cd  = p_line_cd;
 p_line_name         giis_line.line_name%TYPE;
BEGIN
  OPEN c1 (p_line_cd);
  FETCH c1 INTO p_line_name;
  IF c1%FOUND THEN
    close c1;
    RETURN p_line_name;
  ELSE
    close c1;
    RETURN NULL;
  END IF;
END;
/



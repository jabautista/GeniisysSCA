DROP FUNCTION CPI.GET_SUBLINE_NAME;

CREATE OR REPLACE FUNCTION CPI.get_subline_name (p_subline_cd   IN giis_line.line_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_subline_cd   IN giis_subline.subline_cd%TYPE) IS
   SELECT subline_name
     FROM giis_subline
    WHERE subline_cd  = p_subline_cd;
 p_subline_name         giis_subline.subline_name%TYPE;
BEGIN
  OPEN c1 (p_subline_cd);
  FETCH c1 INTO p_subline_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_subline_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



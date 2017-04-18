DROP FUNCTION CPI.GET_PERIL_NAME;

CREATE OR REPLACE FUNCTION CPI.GET_PERIL_NAME (p_line_cd   IN giis_line.line_cd%TYPE,
        p_peril_cd  IN giis_peril.peril_cd%TYPE)
                  RETURN VARCHAR2 AS
CURSOR c1 (p_line_cd   IN giis_line.line_cd%TYPE,
           p_peril_cd  IN giis_peril.peril_cd%TYPE) IS
   SELECT a170.peril_name
     FROM giis_peril a170
    WHERE a170.line_cd  = p_line_cd
      AND a170.peril_cd = p_peril_cd;
 p_peril_name         giis_peril.peril_name%TYPE;
BEGIN
  OPEN c1 (p_line_cd, p_peril_cd);
  FETCH c1 INTO p_peril_name;
  IF c1%FOUND THEN
    close c1;
    RETURN p_peril_name;
  ELSE
    close c1;
    RETURN NULL;
  END IF;
END;
/



DROP FUNCTION CPI.GET_ISS_NAME;

CREATE OR REPLACE FUNCTION CPI.GET_ISS_NAME (p_iss_cd   IN giis_issource.iss_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_iss_cd   IN giis_issource.iss_cd%TYPE) IS
   SELECT iss_name
     FROM giis_issource
    WHERE iss_cd  = p_iss_cd;
 p_iss_name         giis_issource.iss_name%TYPE;
BEGIN
  OPEN c1 (p_iss_cd);
  FETCH c1 INTO p_iss_name;
  IF c1%FOUND THEN
    close c1;
    RETURN p_iss_name;
  ELSE
    close c1;
    RETURN NULL;
  END IF;
END;
/



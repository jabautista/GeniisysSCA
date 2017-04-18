DROP FUNCTION CPI.GET_RI_NAME;

CREATE OR REPLACE FUNCTION CPI.get_ri_name (p_ri_cd   IN giis_reinsurer.ri_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_ri_cd   IN giis_reinsurer.ri_cd%TYPE) IS
   SELECT ri_name
     FROM giis_reinsurer
    WHERE ri_cd  = p_ri_cd;
 p_ri_name         giis_reinsurer.ri_name%TYPE;
BEGIN
  OPEN c1 (p_ri_cd);
  FETCH c1 INTO p_ri_name;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_ri_name;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



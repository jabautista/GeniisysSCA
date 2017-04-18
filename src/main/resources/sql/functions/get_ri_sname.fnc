DROP FUNCTION CPI.GET_RI_SNAME;

CREATE OR REPLACE FUNCTION CPI.Get_Ri_SName (p_ri_cd   IN giis_reinsurer.ri_cd%TYPE)
         RETURN VARCHAR2 AS
CURSOR c1 (p_ri_cd   IN giis_reinsurer.ri_cd%TYPE) IS
   SELECT ri_sname
     FROM giis_reinsurer
    WHERE ri_cd  = p_ri_cd;
 p_ri_sname         giis_reinsurer.ri_sname%TYPE;
BEGIN
  OPEN c1 (p_ri_cd);
  FETCH c1 INTO p_ri_sname;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_ri_sname;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



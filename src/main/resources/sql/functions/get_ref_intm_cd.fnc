DROP FUNCTION CPI.GET_REF_INTM_CD;

CREATE OR REPLACE FUNCTION CPI.get_ref_intm_cd
                (p_intm_no  IN giis_intermediary.intm_no%TYPE)
          RETURN VARCHAR2 AS
CURSOR c1 (p_intm_no  IN giis_intermediary.intm_no%TYPE) IS
   SELECT ref_intm_cd
     FROM giis_intermediary
    WHERE intm_no = p_intm_no;
p_intm_ref  giis_intermediary.ref_intm_cd%TYPE;
BEGIN
  OPEN c1 (p_intm_no);
  FETCH c1 INTO p_intm_ref;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_intm_ref;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



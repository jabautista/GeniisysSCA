DROP FUNCTION CPI.GET_INTM_TYPE;

CREATE OR REPLACE FUNCTION CPI.get_intm_type
                (p_intm_no  IN giis_intermediary.intm_no%TYPE)
          RETURN VARCHAR2 AS
CURSOR c1 (p_intm_no  IN giis_intermediary.intm_no%TYPE) IS
   SELECT intm_type
     FROM giis_intermediary
    WHERE intm_no = p_intm_no;
p_intm_type  giis_intermediary.intm_name%TYPE;
BEGIN
  OPEN c1 (p_intm_no);
  FETCH c1 INTO p_intm_type;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_intm_type;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



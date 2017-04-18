DROP FUNCTION CPI.GET_INTM_TYPE_DESC;

CREATE OR REPLACE FUNCTION CPI.get_intm_type_desc
                (p_intm_type  IN giis_intm_type.intm_type%TYPE)
          RETURN VARCHAR2 AS
CURSOR c1 (p_intm_type  IN giis_intm_type.intm_type%TYPE) IS
   SELECT intm_desc
     FROM giis_intm_type
    WHERE intm_type = p_intm_type;
p_intm_type_desc  giis_intm_type.intm_desc%TYPE;
BEGIN
  OPEN c1 (p_intm_type);
  FETCH c1 INTO p_intm_type_desc;
  IF c1%FOUND THEN
    CLOSE c1;
    RETURN p_intm_type_desc;
  ELSE
    CLOSE c1;
    RETURN NULL;
  END IF;
END;
/



DROP FUNCTION CPI.GET_CORPORATE_NAME;

CREATE OR REPLACE FUNCTION CPI.get_corporate_name
(p_assd_no IN gipi_parlist.assd_no%TYPE)
RETURN VARCHAR2 AS
CURSOR assured (p_assd_no IN gipi_parlist.assd_no%TYPE) IS
  SELECT assd_name
    FROM giis_assured
   WHERE assd_no = p_assd_no;
v_assd_name     giis_assured.assd_name%TYPE;
BEGIN
  OPEN assured(p_assd_no);
  FETCH assured
   INTO v_assd_name;
  IF assured%FOUND THEN
    CLOSE assured;
    RETURN v_assd_name;
  ELSE
    CLOSE assured;
    RETURN NULL;
  END IF;
END;
/



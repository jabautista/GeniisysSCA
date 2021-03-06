DROP FUNCTION CPI.GET_ASSD_NAME;

CREATE OR REPLACE FUNCTION CPI.get_assd_name(p_assd_no VARCHAR2)
RETURN VARCHAR2 AS
  v_assd_name  giis_assured.assd_name%TYPE;
BEGIN
  FOR rec IN (SELECT assd_name
         FROM giis_assured
        WHERE assd_no = p_assd_no)
  LOOP
    v_assd_name := rec.assd_name;
    EXIT;
  END LOOP;
  RETURN (v_assd_name);
END;
/



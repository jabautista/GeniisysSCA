DROP FUNCTION CPI.GET_REP_DATE_FORMAT;

CREATE OR REPLACE FUNCTION CPI.GET_REP_DATE_FORMAT
RETURN VARCHAR2 AS
v_date_format VARCHAR2(20);
/* created by jonan used to return the format mask */ 
BEGIN
   BEGIN
    SELECT PARAM_VALUE_V 
    INTO v_date_format
    FROM GIIS_PARAMETERS
    WHERE PARAM_NAME = 'REP_DATE_FORMAT';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_date_format:='MM/DD/RRRR';
   END;
 RETURN (v_date_format);
END;
/



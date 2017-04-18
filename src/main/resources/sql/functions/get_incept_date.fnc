DROP FUNCTION CPI.GET_INCEPT_DATE;

CREATE OR REPLACE FUNCTION CPI.get_incept_date (p_policy_id VARCHAR2)
RETURN VARCHAR2 AS
  v_incept_date  gipi_polbasic.incept_date%TYPE;
BEGIN
  FOR rec IN (SELECT incept_date
         FROM gipi_polbasic
        WHERE policy_id = p_policy_id)
  LOOP
    v_incept_date := rec.incept_date;
    EXIT;
  END LOOP;
  RETURN (v_incept_date);
END;
/



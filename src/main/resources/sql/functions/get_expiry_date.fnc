DROP FUNCTION CPI.GET_EXPIRY_DATE;

CREATE OR REPLACE FUNCTION CPI.get_expiry_date (p_policy_id VARCHAR2)
RETURN VARCHAR2 AS
  v_expiry_date  gipi_polbasic.expiry_date%TYPE;
BEGIN
  FOR rec IN (SELECT expiry_date
         FROM gipi_polbasic
        WHERE policy_id = p_policy_id)
  LOOP
    v_expiry_date := rec.expiry_date;
    EXIT;
  END LOOP;
  RETURN (v_expiry_date);
END;
/



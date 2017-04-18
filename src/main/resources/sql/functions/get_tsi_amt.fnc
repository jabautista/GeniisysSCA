DROP FUNCTION CPI.GET_TSI_AMT;

CREATE OR REPLACE FUNCTION CPI.get_tsi_amt (p_policy_id VARCHAR2)
RETURN VARCHAR2 AS
  v_tsi_amt  gipi_polbasic.tsi_amt%TYPE;
BEGIN
  FOR rec IN (SELECT tsi_amt
         FROM gipi_polbasic
        WHERE policy_id = p_policy_id)
  LOOP
    v_tsi_amt := rec.tsi_amt;
    EXIT;
  END LOOP;
  RETURN (v_tsi_amt);
END;
/



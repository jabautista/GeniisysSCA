DROP FUNCTION CPI.GET_LATE_PERCENTAGE;

CREATE OR REPLACE FUNCTION CPI.Get_Late_Percentage (p_late_prem_amt NUMBER,
                                                p_renewable_prem_amt NUMBER)
RETURN NUMBER AS
p_return_value NUMBER;
BEGIN
  IF NVL(p_late_prem_amt,0) <> 0 AND NVL(p_renewable_prem_amt,0) <> 0 THEN
    p_return_value := 1;
    RETURN p_return_value;
  ELSE
    p_return_value := 0;
    RETURN p_return_value;
  END IF;
END;
/



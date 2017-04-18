DROP FUNCTION CPI.GET_LATE_AMT;

CREATE OR REPLACE FUNCTION CPI.get_late_amt(p_expiry_year NUMBER,
                                          p_expiry_month NUMBER,
										  p_renewal_year  NUMBER,
										  p_renewal_month NUMBER)
RETURN NUMBER AS
p_return_value NUMBER;
BEGIN
  IF (p_expiry_year = p_renewal_year AND p_expiry_month < p_renewal_month) OR (p_expiry_year < p_renewal_year) THEN
    p_return_value := 1;
    RETURN p_return_value;
  ELSE
    p_return_value := 0;
    RETURN p_return_value;
  END IF;
END;
/



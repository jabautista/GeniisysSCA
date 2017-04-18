DROP FUNCTION CPI.POWER_FUNC;

CREATE OR REPLACE FUNCTION CPI.power_func
  (p_base IN NUMBER,
   p_exp IN NUMBER)
RETURN NUMBER
AS
   v_result NUMBER := 1;
BEGIN
   IF p_base > 1 THEN
         v_result := v_result * power_func(p_base, p_exp - 1);
   ELSE
         v_result := p_base;
   END IF;
END power_func;
/



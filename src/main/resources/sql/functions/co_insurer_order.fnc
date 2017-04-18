DROP FUNCTION CPI.CO_INSURER_ORDER;

CREATE OR REPLACE FUNCTION CPI.co_insurer_order (V_RI_CD IN giis_reinsurer.ri_cd%TYPE)
   RETURN NUMBER IS
  v_param_value_n   GIIS_PARAMETERS.PARAM_VALUE_N%type;
BEGIN
  FOR co_ri IN (
    SELECT param_value_n
      FROM giis_parameters
     WHERE param_name = 'CO_INSURER_DEFAULT')
  LOOP
     v_param_value_n := co_ri.param_value_n;
  END LOOP;
  IF v_ri_cd = v_param_value_n THEN
     RETURN 1;
  ELSE
     RETURN 2;
  END IF;
END;
/



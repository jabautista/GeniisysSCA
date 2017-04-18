DROP FUNCTION CPI.CHECK_DEDUCTIBLE_TEXT;

CREATE OR REPLACE FUNCTION CPI.check_deductible_text
RETURN VARCHAR2
IS
v_value        giis_parameters.param_value_v%TYPE;

BEGIN
    FOR i IN (SELECT param_value_v
                FROM giis_parameters
               WHERE param_name = 'UPDATE_DED_TEXT')
    LOOP
        v_value := i.param_value_v;
    END LOOP;
	RETURN v_value;
END;
/



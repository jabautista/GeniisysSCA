SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giac_parameters
    WHERE param_name = 'AMLA_CTR_VAL';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
               ('AMLA_CTR_VAL already existing in GIAC_PARAMETERS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_n, user_id,
                   last_update, remarks
                  )
           VALUES ('N', 'AMLA_CTR_VAL', 500000, USER,
                   SYSDATE, 'Transactions with premium amount exceeding parameter value will be included in AMLA Covered Transactions Report.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('AMLA_CTR_VAL inserted.');
END;
/* benjo brito 11.08.2016 SR-5802 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giac_parameters
    WHERE param_type = 'V' AND param_name = 'APDC_SW';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line
                          ('APDC_SW already exists in accounting parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'APDC_SW', 'N',
                   'Y - Apply APDC Enhancement, N - Do not apply APDC Enhancement.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                       ('Successfully added APDC_SW in accounting parameters.');
END;
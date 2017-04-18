SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giac_parameters
    WHERE param_name = 'BATCH_GEN_WTAX';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('BATCH_GEN_WTAX accounting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'BATCH_GEN_WTAX', 'N', USER,
                   SYSDATE,
                   'Y = accounting entries for withholding tax will be generated; N = will not be generated. '
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added BATCH_GEN_WTAX in accounting parameters.');
END;
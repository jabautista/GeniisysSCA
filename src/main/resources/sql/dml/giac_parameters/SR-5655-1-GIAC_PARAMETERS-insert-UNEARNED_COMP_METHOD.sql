SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giac_parameters
              WHERE param_name = 'UNEARNED_COMP_METHOD')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line ('The parameter UNEARNED_COMP_METHOD is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'UNEARNED_COMP_METHOD', '24',
                   '1/365 - default value of Method field is 1/365; 24 - default value of Method field is 24TH METHOD; 40 - default value of Method field is STRAIGHT; other values - default value of Method field is 24TH METHOD'
                  );

      DBMS_OUTPUT.put_line('Successfully added UNEARNED_COMP_METHOD in GIAC_PARAMETERS. ');
      COMMIT;
   END IF;
END;
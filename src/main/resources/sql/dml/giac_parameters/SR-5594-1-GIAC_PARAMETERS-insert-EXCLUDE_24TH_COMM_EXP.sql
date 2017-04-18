SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giac_parameters
              WHERE param_name = 'EXCLUDE_24TH_COMM_EXP')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
         ('Parameter EXCLUDE_24TH_COMM_EXP already exist in GIAC_PARAMETERS.');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'EXCLUDE_24TH_COMM_EXP', 'N',
                      'Y - exclude commission expense from 24th method; '
                   || 'N - include commission expense in 24th method.'
                  );

      DBMS_OUTPUT.put_line
               ('Successfully added EXCLUDE_24TH_COMM_EXP in GIAC_PARAMETERS.');
      COMMIT;
   END IF;
END;
SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'PRINT_BONDS_ENDT_SW')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter PRINT_BONDS_ENDT_SW is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'PRINT_BONDS_ENDT_SW', 'N',
                      'N = Print Default Bonds Endorsement Policy Document ; Y = Print Configured Bonds Endorsement Document.'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added PRINT_BONDS_ENDT_SW in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;
SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'ALLOW_REINSTATE_WCANCELLED_ORIG')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter ALLOW_REINSTATE_WCANCELLED_ORIG is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'ALLOW_REINSTATE_WCANCELLED_ORIG', 'N',
                      'This indicates if the client allows reinstatement of cancelled renewal policy whose original policy has been cancelled/spoiled. Y-Yes; N-No'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added ALLOW_REINSTATE_WCANCELLED_ORIG in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;
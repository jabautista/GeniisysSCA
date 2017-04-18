SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'ALLOW_RENEWAL_OTHER_USER')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter ALLOW_RENEWAL_OTHER_USER is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'ALLOW_RENEWAL_OTHER_USER', 'Y',
                      'This indicates if the client allows renewal processing of policies by other users. Y-Yes; N-No'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added ALLOW_RENEWAL_OTHER_USER in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;
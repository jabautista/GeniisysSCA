SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giac_parameters
              WHERE param_name = 'MAX_MISC_ENTRY')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line ('The parameter MAX_MISC_ENTRY is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_n,
                   remarks
                  )
           VALUES ('N', 'MAX_MISC_ENTRY', -1,
                   'Maximum amount allowed by the system to be placed on the miscellaneous entry GL. If set to -1 then no validation will be done by the system'
                  );

      DBMS_OUTPUT.put_line('Successfully added MAX_MISC_ENTRY in GIAC_PARAMETERS. ');
      COMMIT;
   END IF;
END;
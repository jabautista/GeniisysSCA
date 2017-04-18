SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giac_parameters
              WHERE param_name = 'GIACS008_BUT')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                  ('Parameter GIACS008_BUT already exist in GIAC_PARAMETERS.');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'GIACS008_BUT', 'Y',
                      'Y - show GIACS008 (Inward Facultative Premium Collections)'
                   || ' update button; N - hide update button.'
                  );

      DBMS_OUTPUT.put_line
                        ('Successfully added GIACS008_BUT in GIAC_PARAMETERS.');
      COMMIT;
   END IF;
END;
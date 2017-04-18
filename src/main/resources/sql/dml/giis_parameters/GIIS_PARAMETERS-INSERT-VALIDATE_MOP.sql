/* Created by   : MarkS
 * Date Created : 04-20-2016
 * Remarks      : SR-22084
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'VALIDATE_MOP';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('VALIDATE_MOP underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_n,
                   remarks
                  )
           VALUES ('N', 'VALIDATE_MOP', '1',
                   'Indicates on how the client prefer to validate the ETD/ETA of a cargo. 1 = ETD/ETA is validated against the MRN duration; 2= ETD/ETA is validated against the MOP'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added VALIDATE_MOP in underwriting parameters.');
END;
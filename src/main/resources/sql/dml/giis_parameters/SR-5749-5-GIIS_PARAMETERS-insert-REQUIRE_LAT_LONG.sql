/* benjo brito 01.10.2017 SR-5749 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_parameters
    WHERE param_type = 'V' AND param_name = 'REQUIRE_LAT_LONG';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line('REQUIRE_LAT_LONG already exists in underwriting parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'REQUIRE_LAT_LONG', 'Y',
                   'Y = There should be an information in LAT and LONG fields in the Item Information screen to be able to save or post the PAR. N = No restriction will be imposed on the LAT and LONG fields which means that user can save or post the PAR with blank latitude and longitude info.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line('Successfully added REQUIRE_LAT_LONG in underwriting parameters.');
END;
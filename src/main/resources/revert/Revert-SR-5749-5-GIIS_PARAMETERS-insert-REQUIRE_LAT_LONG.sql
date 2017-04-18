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
      DELETE cpi.giis_parameters
       WHERE param_type = 'V' AND param_name = 'REQUIRE_LAT_LONG';

      COMMIT;
      DBMS_OUTPUT.put_line('Successfully deleted REQUIRE_LAT_LONG in underwriting parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line('REQUIRE_LAT_LONG does not exist in underwriting parameters.');
END;
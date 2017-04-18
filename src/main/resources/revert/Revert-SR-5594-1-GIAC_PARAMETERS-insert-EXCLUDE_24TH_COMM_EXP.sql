SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giac_parameters
    WHERE param_name = 'EXCLUDE_24TH_COMM_EXP';

   IF v_exist = 1
   THEN
      DELETE FROM giac_parameters
            WHERE param_name = 'EXCLUDE_24TH_COMM_EXP' AND param_type = 'V';

      DBMS_OUTPUT.put_line ('EXCLUDE_24TH_COMM_EXP deleted from giac_parameters.');
      COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line ('EXCLUDE_24TH_COMM_EXP not found in giac_parameters.');
END;
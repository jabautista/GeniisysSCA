SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'PRD_POL_CNT';

   IF v_exist = 1 THEN
      DELETE FROM GIIS_PARAMETERS
      WHERE param_name = 'PRD_POL_CNT';
   ELSIF v_exist <> 1 THEN
   	  DBMS_OUTPUT.put_line('No Parameter PRD_POL_CNT in GIIS_PARAMETERS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line('No Parameter PRD_POL_CNT in GIIS_PARAMETERS.');
END;
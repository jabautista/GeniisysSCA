SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_reports
    WHERE report_id = 'GIPIR153';

   IF v_exist = 1 THEN
      DELETE FROM giis_reports
      WHERE report_id = 'GIPIR153';

      DBMS_OUTPUT.put_line ('GIPIR153 deleted from giis_reports.');
      COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.put_line ('GIPIR153 not found in giis_reports.');
END;
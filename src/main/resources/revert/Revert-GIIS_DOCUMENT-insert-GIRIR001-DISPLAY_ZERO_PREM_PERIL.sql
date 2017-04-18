SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   FOR ct
      IN (SELECT 1
            FROM cpi.giis_document
           WHERE report_id = 'GIRIR001' AND title = 'DISPLAY_ZERO_PREM_PERIL')
   LOOP
      v_exist := 1;
      EXIT;
   END LOOP;

   IF v_exist = 1
   THEN
      DELETE FROM cpi.giis_document
            WHERE     report_id = 'GIRIR001'
                  AND title = 'DISPLAY_ZERO_PREM_PERIL';

      DBMS_OUTPUT.put_line (
         'GIRIR001, DISPLAY_ZERO_PREM_PERIL is deleted in GIIS_DOCUMENT.');

      COMMIT;
   ELSE
      DBMS_OUTPUT.put_line (
         'GIRIR001, DISPLAY_ZERO_PREM_PERIL is not existing in GIIS_DOCUMENT.');
   END IF;
END;
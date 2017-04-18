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
      DBMS_OUTPUT.put_line (
         'GIRIR001, DISPLAY_ZERO_PREM_PERIL already exists in GIIS_DOCUMENT.');
   ELSE
      INSERT INTO cpi.giis_document (title,
                                     text,
                                     report_id,
                                     remarks)
           VALUES (
                     'DISPLAY_ZERO_PREM_PERIL',
                     'Y',
                     'GIRIR001',
                     'Y = Display the peril and details even if it''s gross premium is zero (0); N = Hide the peril and details if it''s gross premium is equal to 0');

      COMMIT;
      DBMS_OUTPUT.put_line ('GIRIR001, DISPLAY_ZERO_PREM_PERIL inserted.');
   END IF;
END;
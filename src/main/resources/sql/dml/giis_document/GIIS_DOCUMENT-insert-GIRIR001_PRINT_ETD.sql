SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_document
    WHERE report_id = 'GIRIR001' AND title = 'PRINT_ETD';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('Record already exists in GIIS_DOCUMENT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_document
                  (report_id, title, text, user_id, last_update
                  )
           VALUES ('GIRIR001', 'PRINT_ETD', 'Y', 'CPI', SYSDATE
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('Record inserted.');
END;
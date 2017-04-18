/* Formatted on 2015/08/03 13:41 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_reports
    WHERE report_id = 'GIRIR001D';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIRIR001D already exists in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports
                  (report_id, report_title, destype,
                   desname, desformat, paramform, copies, report_mode
                  )
           VALUES ('GIRIR001D', 'Sample Binder Report', 'PRINTER',
                   'C:\GIRIR002D.TXT', 'long12', 'NO', 1, 'CHARACTER'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIRIR001D inserted.');
END;
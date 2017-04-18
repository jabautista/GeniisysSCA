SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_reports
    WHERE report_id = 'GIACR112A';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIACR112A Already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports (report_id, report_title, user_id, last_update)
           VALUES ('GIACR112A', 'Form 2307 - Certificate of Creditable Tax Withheld at Source (with Form)', 'CPI', SYSDATE);

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACR112A inserted.');
END;
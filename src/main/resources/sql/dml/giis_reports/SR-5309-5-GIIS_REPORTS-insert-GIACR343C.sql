SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_reports
    WHERE report_id = 'GIACR343C';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIACR343C already exists in GIIS_REPORTS');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports
                  (report_id, report_title, add_source
                  )
           VALUES ('GIACR343C', 'Outstanding AP/AR Accounts - Summary Per SL', 'P'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACR343C inserted');
END;
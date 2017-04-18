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
      DELETE FROM giis_report_aging
            WHERE report_id = 'GIACR343C';

      DELETE FROM giis_reports
            WHERE report_id = 'GIACR343C';

      COMMIT;
      DBMS_OUTPUT.put_line
                 ('GIACR343C record is successfully deleted in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
                         ('GIACR343C record is not existing in GIIS_REPORTS.');
END;
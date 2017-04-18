SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_reports
    WHERE report_id = 'GIACR343A';

   IF v_exists = 1
   THEN
      DELETE FROM giis_report_aging
            WHERE report_id = 'GIACR343A';

      DELETE FROM giis_reports
            WHERE report_id = 'GIACR343A';

      COMMIT;
      DBMS_OUTPUT.put_line
                 ('GIACR343A record is successfully deleted in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
                         ('GIACR343A record is not existing in GIIS_REPORTS.');
END;
/* Created by   : Gzelle
 * Date Created : 01-22-2016
 * Remarks        : KB#132 - Accounting - AP/AR Enhancement
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_reports
    WHERE report_id = 'GIACR168A';

   IF v_exist = 1
   THEN
      DELETE FROM giis_report_aging
            WHERE report_id = 'GIACR168A';

      DELETE FROM giis_reports
            WHERE report_id = 'GIACR168A';

      COMMIT;
      DBMS_OUTPUT.put_line
                 ('GIACR168A record is successfully deleted in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
                         ('GIACR168A record is not existing in GIIS_REPORTS.');
END;
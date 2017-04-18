SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.giis_reports
    WHERE report_id = 'GIACR112A';

   IF v_count > 0
   THEN
      DELETE FROM giis_reports
       WHERE report_id = 'GIACR112A';

      DBMS_OUTPUT.PUT_LINE (
         'Successfully deleted record for "GIACR112A" in GIIS_REPORTS.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         'Record for "GIACR112A" does not exists in GIIS_REPORTS table.');
   END IF;
END;
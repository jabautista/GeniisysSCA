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
      DBMS_OUTPUT.put_line ('GIACR168A existing.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports
                  (report_id, report_title, add_source
                  )
           VALUES ('GIACR168A', 'Official Receipts Register by Taxes', 'P'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACR168A inserted.');
END;
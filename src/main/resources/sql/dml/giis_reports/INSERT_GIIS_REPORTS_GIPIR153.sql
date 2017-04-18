SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_reports
    WHERE report_id = 'GIPIR153';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPIR153 already existing in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports
                  (report_id, report_title, doc_type
                  )
           VALUES ('GIPIR153', 'Warranties and Clauses Attachment', 'WARRCLA'
                  );
      COMMIT;
      DBMS_OUTPUT.put_line ('GIPIR153 inserted.');
END;
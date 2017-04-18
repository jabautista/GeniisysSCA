SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_reports
    WHERE report_id = 'GIEXR113';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIEXR113 already exists in GIIS_REPORTS');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_reports
                  (report_id, report_title, add_source, module_tag
                  )
           VALUES ('GIEXR113', 'Expiry List of Direct Business (by Assured)', 'P', 'E'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIEXR113 inserted');
END;
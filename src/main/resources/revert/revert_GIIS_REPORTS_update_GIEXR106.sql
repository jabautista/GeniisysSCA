SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   BEGIN
      SELECT 1
        INTO v_exist
        FROM cpi.giis_reports
       WHERE report_id = 'GIEXR106';

      IF v_exist = 1 THEN
         UPDATE giis_reports
         SET module_tag = 'E',
             remarks = ''
         WHERE report_id = 'GIEXR106';
                
         COMMIT;
         DBMS_OUTPUT.put_line ('GIEXR106 updated.');
         
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         DBMS_OUTPUT.put_line ('GIEXR106 does not exists.');
   END;
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   BEGIN
      SELECT 1
        INTO v_exist
        FROM cpi.giis_reports
       WHERE report_id = 'GIEXR107';

      IF v_exist = 1 THEN
         UPDATE giis_reports
         SET module_tag = '',
             remarks = 'Deleted From GIEXS006'
         WHERE report_id = 'GIEXR107';     
             
         COMMIT;
         DBMS_OUTPUT.put_line ('GIEXR107 updated.');
         
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         DBMS_OUTPUT.put_line ('GIEXR107 does not exists.');
   END;
END;
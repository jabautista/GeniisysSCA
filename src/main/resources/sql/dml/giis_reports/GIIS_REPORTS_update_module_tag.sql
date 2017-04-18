--created by John Daniel SR-21359 04.13.2016; revised 04.18.2016
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   UPDATE giis_reports
   SET module_tag = null
   WHERE report_id IN ('GIEXR004', 'GIEXR106', 'GIEXR107',
                       'GIEXR108', 'GIEXR109', 'GIEXR110',
                       'GIEXR112');                
   COMMIT;
   DBMS_OUTPUT.put_line ('Updated.');
END;
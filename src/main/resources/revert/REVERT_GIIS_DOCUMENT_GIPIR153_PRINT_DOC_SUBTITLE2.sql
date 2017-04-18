SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.GIIS_DOCUMENT
    WHERE report_id = 'GIPIR153'
      AND TITLE = 'PRINT_DOC_SUBTITLE2';

   IF v_exist = 1 THEN
     DELETE FROM cpi.GIIS_DOCUMENT
           WHERE report_id = 'GIPIR153'
             AND TITLE = 'PRINT_DOC_SUBTITLE2';
              
     DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_DOC_SUBTITLE2 Title deleted from GIIS_DOCUMENT.');
     COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_DOC_SUBTITLE2 Title not found in GIIS_DOCUMENT.');
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.GIIS_DOCUMENT
    WHERE report_id = 'GIPIR153'
      AND TITLE = 'DOC_SUBTITLE2';

   IF v_exist = 1 THEN
     DELETE FROM cpi.GIIS_DOCUMENT
           WHERE report_id = 'GIPIR153'
             AND TITLE = 'DOC_SUBTITLE2';
              
     DBMS_OUTPUT.put_line ('GIPIR153 with DOC_SUBTITLE2 Title deleted from GIIS_DOCUMENT.');
     COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.put_line ('GIPIR153 with DOC_SUBTITLE2 not found in GIIS_DOCUMENT.');
END;
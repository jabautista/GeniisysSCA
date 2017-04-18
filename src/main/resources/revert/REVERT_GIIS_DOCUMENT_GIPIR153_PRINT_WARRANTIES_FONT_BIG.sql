SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.GIIS_DOCUMENT
    WHERE report_id = 'GIPIR153'
      AND TITLE = 'PRINT_WARRANTIES_FONT_BIG';

   IF v_exist = 1 THEN
     DELETE FROM cpi.GIIS_DOCUMENT
           WHERE report_id = 'GIPIR153'
             AND TITLE = 'PRINT_WARRANTIES_FONT_BIG';
              
     DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_WARRANTIES_FONT_BIG Title deleted from GIIS_DOCUMENT.');
     COMMIT;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_WARRANTIES_FONT_BIG Title not found in GIIS_DOCUMENT.');
END;
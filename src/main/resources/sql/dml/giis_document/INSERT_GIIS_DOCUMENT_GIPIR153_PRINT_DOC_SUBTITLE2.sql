SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.GIIS_DOCUMENT
    WHERE report_id = 'GIPIR153'
      AND TITLE = 'PRINT_DOC_SUBTITLE2';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_DOC_SUBTITLE2 Title is already existing in GIIS_DOCUMENT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.GIIS_DOCUMENT
                  (title, text, remarks, report_id
                  )
           VALUES ('PRINT_DOC_SUBTITLE2', 'Y', 'Value of TEXT to identify if GIPIR153 Subreport 1 and 2 will be printed or not.', 'GIPIR153'
                  );
      COMMIT;
      DBMS_OUTPUT.put_line ('GIPIR153 with PRINT_DOC_SUBTITLE2 Title inserted in GIIS_DOCUMENT.');
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_document
    WHERE report_id = 'GIPIR130' AND title = 'DISPLAY_PERIL_BREAKDOWN';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
         ('GIPIR130, DISPLAY_PERIL_BREAKDOWN already exists in GIIS_DOCUMENT.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_document
                  (report_id, title, text, line_cd,
                   remarks
                  )
           VALUES ('GIPIR130', 'DISPLAY_PERIL_BREAKDOWN', 'Y', '',
                   'Controls the display of Peril Distribution Per Distribution Group in the Distribution Slip. 
            Y = Display the Peril Distribution , N = Hide the Peril Distribution'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIPIR130, DISPLAY_PERIL_BREAKDOWN inserted.');
END;
SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/
BEGIN
   INSERT INTO giis_reports
               (report_id, report_title, destype)
      SELECT 'GIRIR124', 'INWARD TREATY REGISTER', 'SCREEN'
        FROM DUAL
       WHERE NOT EXISTS (SELECT 1
                           FROM giis_reports
                          WHERE report_id = 'GIRIR124');

   IF SQL%FOUND
   THEN
      COMMIT;
      DBMS_OUTPUT.put_line ('GIRIR124 inserted.');
   ELSE
      DBMS_OUTPUT.put_line ('GIRIR124 is already existing in GIIS_REPORTS.');
   END IF;
END;
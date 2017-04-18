SET SERVEROUTPUT ON
/*
**  Created by   : Benjo Brito
**  Date Created : 08.03.2016
**  Remarks      : GENQA-SR-5512 - Inward Treaty Enhancement
*/

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.giis_reports
    WHERE report_id = 'GIRIR124';

   IF v_count > 0
   THEN
      DELETE FROM cpi.giis_reports
            WHERE report_id = 'GIRIR124';

      DBMS_OUTPUT.put_line
                          ('Successfully deleted GIRIR124 from GIIS_REPORTS.');
   ELSE
      DBMS_OUTPUT.put_line ('GIRIR124 does not exists at GIIS_REPORTS.');
   END IF;

   COMMIT;
END;
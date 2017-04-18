/*  Created by: Dren Niebres
    Created On: 07.22.2016
    Description:This script will update the report_title of GIPIR203
*/

SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   BEGIN
      SELECT 1
        INTO v_exist
        FROM cpi.giis_reports
       WHERE report_id = 'GIPIR203';

      IF v_exist = 1 THEN
         UPDATE giis_reports
         SET report_title = 'Recapitulation Report - Summary'
         WHERE report_id = 'GIPIR203';
                
         COMMIT;
         DBMS_OUTPUT.put_line ('GIPIR203 updated.');
         
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         DBMS_OUTPUT.put_line ('GIPIR203 does not exists.');
   END;
END;
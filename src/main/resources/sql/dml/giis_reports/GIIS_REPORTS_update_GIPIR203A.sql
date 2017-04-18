/*  Created by: Dren Niebres
    Created On: 07.22.2016
    Description:This script will update the report_title of GIPIR203A
*/

SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   BEGIN
      SELECT 1
        INTO v_exist
        FROM cpi.giis_reports
       WHERE report_id = 'GIPIR203A';

      IF v_exist = 1 THEN
         UPDATE giis_reports
         SET report_title = 'Recapitulation Report - Detailed (Premium)'
         WHERE report_id = 'GIPIR203A';
                
         COMMIT;
         DBMS_OUTPUT.put_line ('GIPIR203A updated.');
         
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         
         DBMS_OUTPUT.put_line ('GIPIR203A does not exists.');
   END;
END;
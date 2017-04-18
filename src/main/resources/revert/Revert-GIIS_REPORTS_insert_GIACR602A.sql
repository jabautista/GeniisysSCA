SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM CPI.GIIS_REPORTS 
    WHERE report_id = 'GIACR602A';

   IF v_exists = 1
   THEN
      DELETE FROM CPI.GIIS_REPORTS 
            WHERE report_id = 'GIACR602A';
            
      COMMIT;
      DBMS_OUTPUT.put_line
                 ('GIACR602A record is successfully deleted in GIIS_REPORTS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
                         ('GIACR602A record is not existing in GIIS_REPORTS.');
END;
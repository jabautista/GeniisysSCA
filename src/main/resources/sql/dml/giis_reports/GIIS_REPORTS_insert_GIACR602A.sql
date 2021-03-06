SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.GIIS_REPORTS 
    WHERE report_id = 'GIACR602A';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('GIACR602A existing.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO CPI.GIIS_REPORTS (REPORT_ID,  REPORT_TITLE, DESTYPE, DESFORMAT,  PARAMFORM, REPORT_MODE, ORIENTATION, ADD_SOURCE)
            VALUES ('GIACR602A', 'UPLOADED RECORDS', 'SCREEN', 'LONG20',  'NO', 'CHARACTER', 'DEFAULT', 'P');

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('GIACR602A inserted.');
END;
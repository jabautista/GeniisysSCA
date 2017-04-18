SET SERVEROUTPUT ON

BEGIN
    INSERT INTO GIIS_REPORT_AGING (report_id, column_no, column_title, min_days, max_days, user_id, last_update)
                           VALUES ('GIACR296', 1, 'WITHIN 30 DAYS', 0, 30, USER, SYSDATE);
                           
    INSERT INTO GIIS_REPORT_AGING (report_id, column_no, column_title, min_days, max_days, user_id, last_update)
                           VALUES ('GIACR296', 2, '31 - 60 DAYS', 31, 60, USER, SYSDATE);  
                           
    INSERT INTO GIIS_REPORT_AGING (report_id, column_no, column_title, min_days, max_days, user_id, last_update)
                           VALUES ('GIACR296', 3, '61 - 90 DAYS', 61, 90, USER, SYSDATE); 
                           
    INSERT INTO GIIS_REPORT_AGING (report_id, column_no, column_title, min_days, max_days, user_id, last_update)
                           VALUES ('GIACR296', 4, '91 - 120 DAYS', 91, 120, USER, SYSDATE);  
                           
    INSERT INTO GIIS_REPORT_AGING (report_id, column_no, column_title, min_days, max_days, user_id, last_update)
                           VALUES ('GIACR296', 5, 'OVER 120 DAYS', 121, 99999, USER, SYSDATE);    
    
    COMMIT;      
   DBMS_OUTPUT.PUT_LINE ('GIACR296 inserted');

EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/
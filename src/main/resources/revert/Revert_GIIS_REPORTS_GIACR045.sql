SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN

   SELECT COUNT (1)
     INTO v_count
     FROM cpi.GIIS_REPORTS
    WHERE REPORT_ID = 'GIACR045';

   IF V_COUNT > 0
   THEN
      DELETE FROM GIIS_REPORTS
       WHERE REPORT_ID = 'GIACR045';

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "GIACR045" to GIIS_REPORTS.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"GIACR045" record does not exists at GIIS_REPORTS.');
   END IF;
   COMMIT;
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.GIIS_DOCUMENT
    WHERE report_id = 'GIRIR001'
      AND title = 'BINDER_HDR_REN';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
               ('GIRIR001, BINDER_HDR_REN already exists in GIIS_DOCUMENT.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
    INSERT INTO CPI.GIIS_DOCUMENT
           (title, text, report_id, remarks)
    VALUES ('BINDER_HDR_REN', 'Kindly RENEW your Reinsurance Policy in accordance with our Policy, copy(ies) of which is (are) attached herewith.'  , 'GIRIR001',
            'Default header for binder report (renewal policies).');

    COMMIT;
    DBMS_OUTPUT.put_line ('GIRIR001, BINDER_HDR_REN inserted.');
END;
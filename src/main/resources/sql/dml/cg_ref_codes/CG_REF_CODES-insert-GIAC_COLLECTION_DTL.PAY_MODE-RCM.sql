SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'RCM' AND RV_DOMAIN = 'GIAC_COLLECTION_DTL.PAY_MODE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'RCM',
                     'GIAC_COLLECTION_DTL.PAY_MODE',
                     'Credit Memo for RI Commissions');

      COMMIT;
      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "RCM" rv_low_value with "GIAC_COLLECTION_DTL.PAY_MODE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"RCM" rv_low_value with "GIAC_COLLECTION_DTL.PAY_MODE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
END;
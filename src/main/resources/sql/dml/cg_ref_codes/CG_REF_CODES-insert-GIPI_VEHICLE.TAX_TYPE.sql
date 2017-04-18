SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   -- Tax-Exempt, no VAT, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '0' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     '0',
                     'GIPI_VEHICLE.TAX_TYPE',
                     'Tax-Exempt, no VAT, only DST will be applied');

      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "0" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"0" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- (Default) VATable, VAT and DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '1' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     '1',
                     'GIPI_VEHICLE.TAX_TYPE',
                     '(Default) VATable, VAT and DST will be applied');

      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "1" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"1" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- NONVAT, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '2' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     '2',
                     'GIPI_VEHICLE.TAX_TYPE',
                     'NONVAT, only DST will be applied');

      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "2" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"2" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- Zero-Rated, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '3' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     '3',
                     'GIPI_VEHICLE.TAX_TYPE',
                     'NONVAT, only DST will be applied');

      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "3" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"3" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   COMMIT;
END;
SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   -- Tax-Exempt, no VAT, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '0' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = '0'
         AND rv_domain = 'GIPI_VEHICLE.TAX_TYPE';    
         
      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "0" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"0" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- (Default) VATable, VAT and DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '1' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = '1'
         AND rv_domain = 'GIPI_VEHICLE.TAX_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "1" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"1" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- NONVAT, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '2' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = '2'
         AND rv_domain = 'GIPI_VEHICLE.TAX_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "2" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"2" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- Zero-Rated, only DST will be applied --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = '3' AND RV_DOMAIN = 'GIPI_VEHICLE.TAX_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = '3'
         AND rv_domain = 'GIPI_VEHICLE.TAX_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "3" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"3" rv_low_value with "GIPI_VEHICLE.TAX_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   COMMIT;
END;
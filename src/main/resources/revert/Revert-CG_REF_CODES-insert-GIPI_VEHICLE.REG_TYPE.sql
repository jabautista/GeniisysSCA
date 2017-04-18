SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   -- New --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'N' AND RV_DOMAIN = 'GIPI_VEHICLE.REG_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'N'
         AND rv_domain = 'GIPI_VEHICLE.REG_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "N" rv_low_value with "GIPI_VEHICLE.REG_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"N" rv_low_value with "GIPI_VEHICLE.REG_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- Renewal --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'R' AND RV_DOMAIN = 'GIPI_VEHICLE.REG_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'R'
         AND rv_domain = 'GIPI_VEHICLE.REG_TYPE';   

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "R" rv_low_value with "GIPI_VEHICLE.REG_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"R" rv_low_value with "GIPI_VEHICLE.REG_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   COMMIT;
END;
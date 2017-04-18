SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   -- C --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'C' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'C'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "C" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"C" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- HB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'HB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'HB'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';        

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "HB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"HB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- M --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'M' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'M'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';    
         
      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "M" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"M" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- MO --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'MO' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'MO'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';
         
      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "MO" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"MO" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- MS --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'MS' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'MS'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "MS" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"MS" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- NC --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'NC' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'NC'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "NC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"NC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- NV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'NV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'NV'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "NV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"NV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;

   -- OB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'OB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'OB'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "OB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"OB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;

   -- SB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'SB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'SB'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "SB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"SB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF; 

   -- SV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'SV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'SV'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "SV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"SV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;

   -- TB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'TB'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "TB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;

   -- TC --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TC' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'TC'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "TC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- TK --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TK' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'TK'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "TK" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TK" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- TL --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TL' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'TL'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "TL" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TL" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- UV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'UV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'UV'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "UV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"UV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   -- LE --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'LE' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT > 0
   THEN
      DELETE FROM cg_ref_codes
       WHERE rv_low_value = 'LE'
         AND rv_domain = 'GIPI_VEHICLE.MV_TYPE';       

      DBMS_OUTPUT.PUT_LINE (
         'Successfully reverted "LE" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"LE" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record does not exists at cg_ref_codes table.');
   END IF;
   
   COMMIT;
END;
SET SERVEROUTPUT ON;

DECLARE
   v_count   NUMBER := 0;
BEGIN
   -- C --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'C' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'C',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Car');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "C" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"C" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- HB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'HB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'HB',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Shuttle Bus');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "HB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"HB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- M --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'M' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'M',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Motorcycle without Side Car');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "M" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"M" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- MO --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'MO' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'MO',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Mopeds (0-49 cc)');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "MO" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"MO" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- MS --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'MS' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'MS',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Motorcycle with Side Car');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "MS" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"MS" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- NC --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'NC' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'NC',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Non-Conventional MC (Car)');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "NC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"NC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- NV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'NV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'NV',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Non-Conventional MV (UV)');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "NV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"NV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;

   -- OB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'OB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'OB',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Tourist Bus');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "OB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"OB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;

   -- SB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'SB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'SB',
                     'GIPI_VEHICLE.MV_TYPE',
                     'School Bus');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "SB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"SB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;

   -- SV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'SV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'SV',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Sports Utility Vehicle');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "SV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"SV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;

   -- TB --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TB' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'TB',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Truck Bus');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "TB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TB" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;

   -- TC --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TC' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'TC',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Tricycle');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "TC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TC" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- TK --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TK' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'TK',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Truck');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "TK" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TK" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- TL --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'TL' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'TL',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Trailer');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "TL" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"TL" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- UV --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'UV' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'UV',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Utility Vehicle');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "UV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"UV" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   -- LE --
   
   SELECT COUNT (1)
     INTO v_count
     FROM cpi.cg_ref_codes
    WHERE rv_low_value = 'LE' AND RV_DOMAIN = 'GIPI_VEHICLE.MV_TYPE';

   IF V_COUNT = 0
   THEN
      INSERT INTO cg_ref_codes (rv_low_value, rv_domain, rv_meaning)
           VALUES (
                     'LE',
                     'GIPI_VEHICLE.MV_TYPE',
                     'Light Electric Vehicle');

      DBMS_OUTPUT.PUT_LINE (
         'Successfully added "LE" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain to cg_ref_codes table.');
   ELSE
      DBMS_OUTPUT.PUT_LINE (
         '"LE" rv_low_value with "GIPI_VEHICLE.MV_TYPE" rv_domain record already exists at cg_ref_codes table.');
   END IF;
   
   COMMIT;
END;
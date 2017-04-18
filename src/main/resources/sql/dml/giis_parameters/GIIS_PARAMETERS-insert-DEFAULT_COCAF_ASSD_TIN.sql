DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'DEFAULT_COCAF_ASSD_TIN';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('DEFAULT_COCAF_ASSD_TIN underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'DEFAULT_COCAF_ASSD_TIN', '999-999-999-999', USER,
                   SYSDATE,
                   'Default TIN to use in cocaf automatic authentication when the assured has no TIN.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added DEFAULT_COCAF_ASSD_TIN in underwriting parameters.');
END;
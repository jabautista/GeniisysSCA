DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR cur IN (SELECT 1
                 FROM cpi.giis_parameters
                WHERE param_name = 'AD_HOC_URL')
   LOOP
      v_exists := 'Y';
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'AD_HOC_URL', 'http://localhost:8080/GeniisysAdHocReports',
                   'URL of application where adhoc reports are being called.'
                  );
   END IF;

   COMMIT;
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_SPOILAGE_REC_WRENEWAL';

   IF v_exist = 1 THEN
      DBMS_OUTPUT.put_line ('ALLOW_SPOILAGE_REC_WRENEWAL already existing in giis_parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, param_length,
                   remarks,
                   user_id, last_update
                  )
           VALUES ('V', 'ALLOW_SPOILAGE_REC_WRENEWAL', 'Y', 1,
                   'Indicates if the client allows spoilage of policies that are extracted for renewal processing. Spoiling of records will delete the renewal information. Valid values are: Y=Yes, N=No',
                   'CPI', SYSDATE
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('ALLOW_SPOILAGE_REC_WRENEWAL inserted.');
END;
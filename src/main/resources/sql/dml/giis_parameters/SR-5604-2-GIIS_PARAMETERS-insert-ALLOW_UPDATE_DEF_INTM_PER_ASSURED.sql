/* benjo brito 08.24.2016 SR-5604 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_parameters
    WHERE param_type = 'V'
          AND param_name = 'ALLOW_UPDATE_DEF_INTM_PER_ASSURED';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line
         ('ALLOW_UPDATE_DEF_INTM_PER_ASSURED already exists in underwriting parameters.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'ALLOW_UPDATE_DEF_INTM_PER_ASSURED', 'N',
                   'Indicates if the client will allow the user/s to update the default intermediary per assured. Y=Yes; N=No; O=Override'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully added ALLOW_UPDATE_DEF_INTM_PER_ASSURED in underwriting parameters.'
         );
END;
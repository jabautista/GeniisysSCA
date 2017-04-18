/* benjo brito 08.24.2016 SR-5604 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_parameters
    WHERE param_type = 'V' AND param_name = 'REQUIRE_DEFAULT_INTM_PER_ASSURED';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line
         ('REQUIRE_DEFAULT_INTM_PER_ASSURED already exists in underwriting parameters.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'REQUIRE_DEFAULT_INTM_PER_ASSURED', 'N',
                   'Indicates if the client will require default intermediary for every maintained assured. Y=Yes; N=No'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully added REQUIRE_DEFAULT_INTM_PER_ASSURED in underwriting parameters.'
         );
END;
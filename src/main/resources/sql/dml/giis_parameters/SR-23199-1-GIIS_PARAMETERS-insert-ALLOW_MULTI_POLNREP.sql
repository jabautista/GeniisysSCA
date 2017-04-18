/* John Michael Mabini SR-23199*/
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_parameters
    WHERE param_type = 'V' AND param_name = 'ALLOW_MULTI_POLNREP';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line
         ('ALLOW_MULTI_POLNREP already exists in underwriting parameters.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'ALLOW_MULTI_POLNREP', 'N',
                   'Indicates if the client allows multiple renewal/replace of policy via manual processing. Yes/No'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully added ALLOW_MULTI_POLNREP in underwriting parameters.'
         );
END;
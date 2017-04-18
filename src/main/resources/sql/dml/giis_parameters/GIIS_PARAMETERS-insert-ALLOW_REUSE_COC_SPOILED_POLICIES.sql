SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_REUSE_COC_SPOILED_POLICIES';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('ALLOW_REUSE_COC_SPOILED_POLICIES underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'ALLOW_REUSE_COC_SPOILED_POLICIES', 'N', USER,
                   SYSDATE,
                   'Param value N,This will indicate if the client allows coc serial of spoiled policies to be reused. yes giis_parameters Y = allow, N = No.'|| 
                   'Default value of this parameter if it does not exists or if it is NULL is N.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added ALLOW_REUSE_COC_SPOILED_POLICIES in underwriting parameters.');
END;
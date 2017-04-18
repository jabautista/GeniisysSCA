SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_ALLIED_MORE_THAN_BASIC';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('ALLOW_ALLIED_MORE_THAN_BASIC underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'ALLOW_ALLIED_MORE_THAN_BASIC', 'N', USER,
                   SYSDATE,
                   'Allow allied peril with higher TSI than basic peril if parameter value is "Y", otherwise do not allow it. '|| 
				   'Default value of this parameter if it does not exists or if it is NULL is N.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added ALLOW_ALLIED_MORE_THAN_BASIC in underwriting parameters.');
END;
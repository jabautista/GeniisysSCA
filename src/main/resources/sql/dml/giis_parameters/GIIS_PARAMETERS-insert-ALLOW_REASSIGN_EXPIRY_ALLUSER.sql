SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_REASSIGN_EXPIRY_ALLUSER';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('ALLOW_REASSIGN_EXPIRY_ALLUSER underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'ALLOW_REASSIGN_EXPIRY_ALLUSER', 'N', USER,
                   SYSDATE,
                   'Controls the security switch needed for reassignment of expiry records. '|| 
				   'Y = As long as user has ALL USER SWITCH access, he can reassign expiry record; '||
				   'N = The user needs to have ALL USER SWITCH access and either MIS or MANAGER SWITCH to be able to reassign expiry record. '||
				   'Default value of this parameter if it does not exists or if it is NULL is N.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added ALLOW_REASSIGN_EXPIRY_ALLUSER in underwriting parameters.');
END;
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'PRD_POL_CNT';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('PRD_POL_CNT parameter already exists in GIIS_PARAMETERS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update, remarks
                  )
           VALUES ('V', 'PRD_POL_CNT', '1', USER,
                   SYSDATE,
                   'This will indicate how the client wants to display the policy count for production register (TAB 1) 1 - Policy and Endorsements are counted individually. 2 - Only policy records will be counted 3 - Unique policy records will be counted'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added PRD_POL_CNT in GIIS_PARAMETERS.');
END;
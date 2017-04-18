SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'COPY_REFPOL_FRM_OPEN_POL';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('COPY_REFPOL_FRM_OPEN_POL underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, user_id,
                   last_update,
                   remarks
                  )
           VALUES ('V', 'COPY_REFPOL_FRM_OPEN_POL', 'Y', USER,
                   SYSDATE,
                   'If parameter is Y, then replace the reference no with reference no from open policy, otherwise, do not replace the value of the declaration reference policy no with the reference policy no of the open policy.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added COPY_REFPOL_FRM_OPEN_POL in underwriting parameters.');
END;
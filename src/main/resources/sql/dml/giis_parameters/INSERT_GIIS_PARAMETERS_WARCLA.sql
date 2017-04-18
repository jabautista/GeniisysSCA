SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_PRINT_WARCLA_ATTACHMENT';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('ALLOW_PRINT_WARCLA_ATTACHMENT already existing in GIIS_PARAMETERS.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v, remarks
                  )
           VALUES ('V', 'ALLOW_PRINT_WARCLA_ATTACHMENT', 'N', 'Y= Allow printing of Warranties and Clauses Attachment. N = Not Allowed to print Warranties and Clauses Attachment'
                  );
      COMMIT;
      DBMS_OUTPUT.put_line ('ALLOW_PRINT_WARCLA_ATTACHMENT inserted.');
END;
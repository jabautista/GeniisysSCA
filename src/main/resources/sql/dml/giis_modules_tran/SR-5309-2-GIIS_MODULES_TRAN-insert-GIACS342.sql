SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giis_modules_tran
    WHERE module_id = 'GIACS342';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIACS342 already exists in GIIS_MODULES_TRAN');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_modules_tran
                  (module_id, tran_cd
                  )
           VALUES ('GIACS342', 10
                  );

      COMMIT;
      DBMS_OUTPUT.put_line ('GIACS342 inserted');
END;
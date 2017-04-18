/* Created by   : Gzelle
 * Date Created : 10-26-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO v_exists
     FROM giis_modules
    WHERE module_id = 'GIACS341';

   IF v_exists = 'Y'
   THEN
      DBMS_OUTPUT.put_line
                        ('GIACS341 module_id already exists in GIIS_MODULES.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      BEGIN
         INSERT INTO giis_modules
                     (module_id, module_desc, module_type, web_enabled,
                      user_id, last_update
                     )
              VALUES ('GIACS341', 'GL Control Sub-Account Type', 'M', 'Y',
                      USER, SYSDATE
                     );

         COMMIT;
         DBMS_OUTPUT.put_line ('Successfully added GIACS341 in GIIS_MODULES.');
      END;
END;
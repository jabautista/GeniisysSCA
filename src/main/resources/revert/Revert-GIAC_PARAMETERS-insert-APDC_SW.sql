/* benjo brito 11.08.2016 SR-5802 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exists
     FROM cpi.giac_parameters
    WHERE param_type = 'V' AND param_name = 'APDC_SW';

   IF v_exists = 1
   THEN
      DELETE FROM cpi.giac_parameters
            WHERE param_type = 'V' AND param_name = 'APDC_SW';

      DBMS_OUTPUT.put_line
                    ('Successfully deleted APDC_SW in accounting parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
                         ('APDC_SW does not exists in accounting parameters.');
END;
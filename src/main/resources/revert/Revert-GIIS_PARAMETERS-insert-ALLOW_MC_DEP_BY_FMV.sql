/* Created by   : Dren Niebres
 * Date Created : 06.08.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   SELECT 'Y'
     INTO v_exists
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_MC_DEP_BY_FMV';

   IF v_exists = 'Y'
   THEN
      DELETE FROM cpi.giis_parameters
            WHERE param_name = 'ALLOW_MC_DEP_BY_FMV'
              AND param_type = 'V';      
      COMMIT;

      DBMS_OUTPUT.put_line
         ('Record with param_name = ALLOW_MC_DEP_BY_FMV and param_type = V is successfully deleted.'
         );        
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      DBMS_OUTPUT.put_line
         ('Record with param_name = ALLOW_MC_DEP_BY_FMV and param_type = V is not existing in GIIS_PARAMETERS.'
         );
END;
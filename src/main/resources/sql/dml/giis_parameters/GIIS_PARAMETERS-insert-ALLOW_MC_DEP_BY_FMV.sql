/* Created by   : Dren Niebres
 * Date Created : 06.08.2016
 * Remarks      : SR-5278
 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'ALLOW_MC_DEP_BY_FMV';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('ALLOW_MC_DEP_BY_FMV underwriting parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'ALLOW_MC_DEP_BY_FMV', 'N',
                   'Indicates if the client prefers depreciation of MC policies according to the fair market value of the vehicle.'|| 
               'Y-Yes '||
               'N-No '
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added ALLOW_MC_DEP_BY_FMV in underwriting parameters.');
END;
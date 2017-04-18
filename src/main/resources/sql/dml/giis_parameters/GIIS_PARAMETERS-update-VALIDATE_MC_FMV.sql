/* benjo brito 11.24.2016 SR-5278 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_type = 'V' AND param_name = 'VALIDATE_MC_FMV';

   IF v_exist = 1
   THEN
      UPDATE cpi.giis_parameters
         SET param_value_v = '1',
             remarks =
                   'Indicates if the system will allow MC policy issuance with Sum Insured not within the FMV set-up. '
                || '1- will allow policies to be issued without validating the FMV set-up. (GIIS_MC_FMV). '
                || '2- Will NOT allow policies to be issued if they are not within the FMV set-up. This will also provide the default value for basic perils TSI based from the set-up. If there is no set-up, system will prompt the user and be blocked from issuance. '
                || '3- This will provide the default value for basic perils TSI based from the set-up. If the user changes the default value, system will validate if it is within the range. Otherwise, will request for override. '
                || 'Default value is 1.'
       WHERE param_type = 'V' AND param_name = 'VALIDATE_MC_FMV';

      COMMIT;
      DBMS_OUTPUT.put_line
           ('Successfully updated VALIDATE_MC_FMV in underwriting parameters.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'VALIDATE_MC_FMV', '1',
                      'Indicates if the system will allow MC policy issuance with Sum Insured not within the FMV set-up. '
                   || '1- will allow policies to be issued without validating the FMV set-up. (GIIS_MC_FMV). '
                   || '2- Will NOT allow policies to be issued if they are not within the FMV set-up. This will also provide the default value for basic perils TSI based from the set-up. If there is no set-up, system will prompt the user and be blocked from issuance. '
                   || '3- This will provide the default value for basic perils TSI based from the set-up. If the user changes the default value, system will validate if it is within the range. Otherwise, will request for override. '
                   || 'Default value is 1.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
             ('Successfully added VALIDATE_MC_FMV in underwriting parameters.');
END;
/* benjo brito 11.24.2016 SR-5278 */
SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_type = 'V' AND param_name = 'AUTO_COMPUTE_MC_DEP';

   IF v_exist = 1
   THEN
      UPDATE cpi.giis_parameters
         SET param_value_v = '1',
             remarks =
                   'Indicates the type pf depreciation to be applied for motorcar policies. '
                || '1- Will apply fixed depreciation rate for all perils (MC_DEP_PCT). '
                || '2- Will depend on the peril depreciation, set-up at maintenance (GIEX_DEP_PERL). '
                || '3- Will depend on the vehicle type (GIIS_MC_DEP_RATE). '
                || 'N- system will not auto-compute the depreciation. '
                || 'Default value is 1.'
       WHERE param_type = 'V' AND param_name = 'AUTO_COMPUTE_MC_DEP';

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully updated AUTO_COMPUTE_MC_DEP in underwriting parameters.'
         );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'AUTO_COMPUTE_MC_DEP', '1',
                      'Indicates the type pf depreciation to be applied for motorcar policies. '
                   || '1- Will apply fixed depreciation rate for all perils (MC_DEP_PCT). '
                   || '2- Will depend on the peril depreciation, set-up at maintenance (GIEX_DEP_PERL). '
                   || '3- Will depend on the vehicle type (GIIS_MC_DEP_RATE). '
                   || 'N- system will not auto-compute the depreciation. '
                   || 'Default value is 1.'
                  );

      COMMIT;
      DBMS_OUTPUT.put_line
         ('Successfully added AUTO_COMPUTE_MC_DEP in underwriting parameters.');
END;
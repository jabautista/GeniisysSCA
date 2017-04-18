/* Formatted on 2015/07/16 16:15 (Formatter Plus v4.8.8) */
SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'RECOMP_RENEWAL_PREM_RT')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter RECOMP_RENEWAL_PREM_RT is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'RECOMP_RENEWAL_PREM_RT', 'N',
                      'Indicates whether the premium rate of the renewal PAR/policy will be recomputed based on summarized premium amount. '
                   || ' Y = Recompute premium rate amount based on renewable premium and renewable TSI.; '
                   || ' N = Premium Rate of the renewal PAR will based on the latest effective premium rate. '
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added RECOMP_RENEWAL_PREM_RT in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;
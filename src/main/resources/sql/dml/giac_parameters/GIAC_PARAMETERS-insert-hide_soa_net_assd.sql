SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giac_parameters
              WHERE param_name = 'HIDE_SOA_NET_ASSD')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter HIDE_SOA_NET_ASSD is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giac_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'HIDE_SOA_NET_ASSD', 'N',
                      'N = Show Print Type SOA Net of Commission in Layout 2 by Assured; Y = Hides Print Type SOA Net of Commission in Layout 2 by Assured'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added HIDE_SOA_NET_ASSD in GIAC_PARAMETERS. ');
      COMMIT;
   END IF;
END;
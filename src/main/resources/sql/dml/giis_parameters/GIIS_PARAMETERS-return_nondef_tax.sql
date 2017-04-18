SET serveroutput on

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT 1
               FROM cpi.giis_parameters
              WHERE param_name = 'RETURN_NONDEF_TAX')
   LOOP
      v_exists := 'Y';
      DBMS_OUTPUT.put_line
                ('The parameter RETURN_NONDEF_TAX is already existing. ');
   END LOOP;

   IF v_exists = 'N'
   THEN
      INSERT INTO cpi.giis_parameters
                  (param_type, param_name, param_value_v,
                   remarks
                  )
           VALUES ('V', 'RETURN_NONDEF_TAX', '1',
                      'This parameter indicates if the client allows return of non-default/non-required charges. Valid values are 1,2 and 3.'
                   || ' If value is 1, system will return non-required taxes whose giis_tax_charges.refund_sw is Y.'
                   || ' If value is 2, system will return all non-required taxes irregardless of refund_sw value.'
                   || ' If value is 3, system will system will NOT return all non-required taxes.'
                  );

      DBMS_OUTPUT.put_line
             ('Successfully added RETURN_NONDEF_TAX in GIIS_PARAMETERS. ');
      COMMIT;
   END IF;
END;
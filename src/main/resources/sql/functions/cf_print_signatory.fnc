DROP FUNCTION CPI.CF_PRINT_SIGNATORY;

CREATE OR REPLACE FUNCTION CPI.CF_PRINT_SIGNATORY RETURN Char IS

        v_param   VARCHAR2(1);
   BEGIN
       FOR A IN (SELECT text
                         FROM giis_document
                       WHERE report_id = 'GIPIR914'
                           AND title = 'PRINT_SIGNATORY')
                           
       LOOP
                           
            v_param := A.text;
            EXIT;
       END LOOP;
       RETURN(v_param);             
   END;
/



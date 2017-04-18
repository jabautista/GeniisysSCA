DROP FUNCTION CPI.CF_PRINT_TSI;

CREATE OR REPLACE FUNCTION CPI.CF_PRINT_TSI RETURN Char IS

           v_param   VARCHAR2(1);
    BEGIN
         FOR A IN (SELECT text
                           FROM giis_document
                         WHERE report_id = 'GIPIR914'
                             AND title = 'PRINT_TSI')
                             
          LOOP
          
               v_param := A.text;
               EXIT;
          END LOOP;
          RETURN(v_param);             
       END;
/



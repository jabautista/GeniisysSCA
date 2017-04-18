DROP FUNCTION CPI.CF_COC_SIGNATORY;

CREATE OR REPLACE FUNCTION CPI.CF_COC_SIGNATORY(
	   p_report_id 		 giis_signatory.report_id%TYPE) RETURN Char IS

            v_signatory   VARCHAR2(100);
     BEGIN
        FOR c IN (SELECT SIGNATORY
                         FROM giis_signatory_names A, giis_signatory b
                       WHERE A.signatory_id = b.signatory_id
                           AND b.current_signatory_sw = 'Y'
                           AND b.line_cd IN (SELECT param_value_v
                                                        FROM giis_parameters
                                                      WHERE param_name = 'LINE_CODE_MC')
                           AND report_id = p_report_id)
                           
                           LOOP 
                           
                              v_signatory  :=  C.SIGNATORY;
                           END LOOP;
            RETURN(v_signatory); 
     END;
/



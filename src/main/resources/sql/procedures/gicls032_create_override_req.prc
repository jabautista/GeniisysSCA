DROP PROCEDURE CPI.GICLS032_CREATE_OVERRIDE_REQ;

CREATE OR REPLACE PROCEDURE CPI.gicls032_create_override_req(
  p_claim_id          gicl_claims.claim_id%TYPE,
  p_advice_id         gicl_advice.advice_id%TYPE,
  p_function_code     VARCHAR2, 
  p_or_request_remarks VARCHAR2
) IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Converted procedure from GICLS032 - :CG$CTRL.OR_REQUEST_CREATE_BTN - WHEN-BUTTON-PRESSED
   */

   v_display      VARCHAR2 (500);
   v_columns      VARCHAR2 (500);
   v_line_cd      gicl_advice.line_cd%TYPE;
   v_iss_cd       gicl_advice.iss_cd%TYPE;
   v_advice_year  gicl_advice.advice_year%TYPE;
   v_advice_seq_no gicl_advice.advice_seq_no%TYPE;
   var_columns    VARCHAR2(1000) := NULL;
BEGIN
   SELECT line_cd, iss_cd
     INTO v_line_cd, v_iss_cd
     FROM gicl_claims
    WHERE claim_id = p_claim_id;  

  FOR i IN (SELECT function_col_cd, table_name, column_name
              FROM giac_function_columns
             WHERE module_id in (SELECT module_id
                                   FROM giac_modules
                                  WHERE module_name = 'GICLS032')
               AND function_cd = p_function_code) 
  LOOP
    IF i.table_name = 'GICL_ADVICE' and i.column_name = 'CLAIM_ID' THEN
    	 var_columns := override.generate_p_column(var_columns, i.function_col_cd, p_claim_id);
    ELSIF i.table_name = 'GICL_ADVICE' and i.column_name = 'ADVICE_ID' THEN
    	var_columns := override.generate_p_column(var_columns, i.function_col_cd, p_advice_id);
    END IF;
  END LOOP;

  IF var_columns IS NULL THEN
    raise_application_error(-20001, 'Geniisys Exception#I#Function setup for override request is not yet existing. Please contact your administrator.');
  END IF;

   FOR i IN (SELECT a.display_col_id, b.table_name, b.column_name
               FROM giac_function_display a, giac_column_display_dtl b
              WHERE a.display_col_id = b.display_col_id
                AND module_id IN (SELECT module_id
                                    FROM giac_modules
                                   WHERE module_name = 'GICLS032')
                AND a.function_cd = p_function_code)
   LOOP
      IF i.column_name = 'CLAIM_ID'
      THEN
         v_columns := override.generate_p_column (v_columns, i.display_col_id, i.column_name || ' = ' || p_claim_id);
      ELSIF i.column_name = 'ADVICE_ID'
      THEN
         v_columns := override.generate_p_column (v_columns, i.display_col_id, i.column_name || ' = ' || p_advice_id);
      END IF;
   END LOOP;

  IF v_columns IS NULL THEN
    raise_application_error(-20001, 'Geniisys Exception#I#Function setup for override request is not yet existing. Please contact your administrator.');
  END IF;

   v_display := override.generate_display ('GICLS032', p_function_code, v_columns);

  IF v_display IS NULL THEN
    raise_application_error(-20001, 'Geniisys Exception#I#Function setup for override request is not yet existing. Please contact your administrator.');
  END IF;

   --added by MAGeamoga 08/22/2011 for the override request in function code RP
   IF p_advice_id IS NOT NULL AND INSTR (v_display, 'Advice Number') = 0
   THEN
       SELECT line_cd, iss_cd, advice_year, advice_seq_no
         INTO v_line_cd, v_iss_cd, v_advice_year, v_advice_seq_no
         FROM gicl_advice
        WHERE claim_id = p_claim_id
          AND advice_id = p_advice_id;
      
      v_display :=
            v_display
         || CHR (10)
         || 'Advice Number : '
         || v_line_cd
         || '-'
         || v_iss_cd
         || '-'
         || v_advice_year
         || v_advice_seq_no;
   END IF;

   IF p_advice_id IS NULL
   THEN                                                                       --for gen_adv button created by MAGeamoga 08/19/2011
      override.generate_request ('GICLS032',
                                 p_function_code,
                                 v_line_cd,
                                 v_iss_cd,
                                 p_or_request_remarks,
                                 v_display,
                                 var_columns
                                );
                                
       IF p_function_code = 'AC'
       THEN
          gicls032_check_set_res_amount(p_claim_id, p_advice_id, NULL, 'N', NULL);
       END IF;                                
   ELSE
      override.generate_request ('GICLS032',
                                 p_function_code,
                                 v_line_cd,
                                 v_iss_cd,
                                 p_or_request_remarks,
                                 v_display,
                                 var_columns
                                );
   END IF;
END;
/



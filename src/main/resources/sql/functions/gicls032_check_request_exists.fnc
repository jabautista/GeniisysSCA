DROP FUNCTION CPI.GICLS032_CHECK_REQUEST_EXISTS;

CREATE OR REPLACE FUNCTION CPI.gicls032_check_request_exists(
   p_claim_id            gicl_clm_loss_exp.claim_id%TYPE,
   p_advice_id           gicl_clm_loss_exp.advice_id%TYPE,
   p_function_code       VARCHAR2
) RETURN NUMBER IS
   /*
   **  Created by   :  Andrew Robes
   **  Date Created :  3.2.2011
   **  Reference By : (GICLS032 - Generate Advice)
   **  Description  : Procedure to check if override request exists
   */ 
   
  v_request         NUMBER; 
  v_columns         VARCHAR2 (500);
BEGIN

  v_columns := NULL;

  FOR i IN (SELECT function_col_cd, table_name, column_name
              FROM giac_function_columns
             WHERE module_id IN (SELECT module_id
                                   FROM giac_modules
                                  WHERE module_name = 'GICLS032') AND function_cd = p_function_code)
  LOOP
     IF i.table_name = 'GICL_ADVICE' AND i.column_name = 'CLAIM_ID'
     THEN
        v_columns := override.generate_p_column (v_columns, i.function_col_cd, p_claim_id);
     ELSIF i.table_name = 'GICL_ADVICE' AND i.column_name = 'ADVICE_ID'
     THEN
        v_columns := override.generate_p_column (v_columns, i.function_col_cd, NVL (p_advice_id, 0));
     END IF;
  END LOOP;
  
  v_request := override.check_request_exist ('GICLS032', p_function_code, v_columns);
  
  RETURN v_request;
END;
/



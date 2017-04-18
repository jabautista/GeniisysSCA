DROP PROCEDURE CPI.CREATE_REQUEST_OVERRIDE;

CREATE OR REPLACE PROCEDURE CPI.create_request_override
(p_claim_id        IN  GICL_EVAL_CSL.claim_id%TYPE,
 p_eval_id         IN  GICL_EVAL_CSL.eval_id%TYPE,
 p_clm_loss_id     IN  GICL_EVAL_CSL.clm_loss_id%TYPE,
 p_payee_class_cd  IN  GICL_EVAL_CSL.payee_type_cd%TYPE,
 p_payee_cd        IN  GICL_EVAL_CSL.payee_cd%TYPE,
 p_iss_cd          IN  GICL_CLAIMS.iss_cd%TYPE,
 p_line_cd         IN  GICL_CLAIMS.line_cd%TYPE,
 p_remarks         IN  GICL_FUNCTION_OVERRIDE.remarks%TYPE,
 p_canvas          IN  VARCHAR2,
 p_user_id         IN  GIIS_USERS.user_id%TYPE) IS
                                  
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.04.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Executes CREATE_REQUEST_OVERRIDE Program Unit in GICLS030                 
*/ 
 
  v_override_id      GICL_FUNCTION_OVERRIDE.override_id%TYPE;
  v_display          GICL_FUNCTION_OVERRIDE.display%TYPE;
  v_remarks          GICL_FUNCTION_OVERRIDE.remarks%TYPE;
  v_iss_cd           GICL_CLAIMS.iss_cd%TYPE;
  
  --jen.03162007
  v_moduleId         GIAC_MODULES.module_id%TYPE;
  
BEGIN
  
  IF p_canvas = 'CSL' THEN
    v_display := get_claim_info(p_claim_id)||CHR(10)||get_eval_csl_info(p_claim_id,p_eval_id,p_payee_class_cd,p_payee_cd);
  ELSIF p_canvas = 'LOA' THEN
    v_display := get_claim_info(p_claim_id)||CHR(10)||get_eval_loa_info(p_claim_id,p_eval_id,p_payee_class_cd,p_payee_cd);
  END IF;
  
  v_iss_cd  := p_iss_cd;
  v_remarks := p_remarks;
  
  SELECT NVL(MAX(override_id),0) + 1
    INTO v_override_id
    FROM GICL_FUNCTION_OVERRIDE;
 
  --jen.03162007 begin
  --retrieve the module_id of GICLS030 from GIAC_MODULES to be inserted in GICL_FUNCTION_OVERRIDE
  BEGIN
      SELECT module_id
        INTO v_moduleId
        FROM GIAC_MODULES
       WHERE module_name = 'GICLS030';
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'GICLS030 does not exist in GIAC_MODULES.');
        
      WHEN TOO_MANY_ROWS THEN  
        RAISE_APPLICATION_ERROR(-20002, 'There is more than one record of GICLS030 that exists in GIAC_MODULES.');
  END;
  --jen.03162007 end
   
  INSERT INTO GICL_FUNCTION_OVERRIDE
    (override_id,   line_cd,        iss_cd,         module_id,      function_cd,    display,
     request_date,  request_by,     override_user,  override_date,  remarks,        user_id,    last_update)
  VALUES 
    (v_override_id, p_line_cd,      v_iss_cd,       v_moduleId,     'LO',           v_display,
     SYSDATE,       p_user_id,      NULL,           NULL,           v_remarks,      p_user_id,   SYSDATE);
      
  /*jen.03162007
  **moified query*/
  FOR rec IN (SELECT UPPER(column_name) column_name , function_col_cd
                FROM GIAC_FUNCTION_COLUMNS A, 
                     GIAC_MODULES b
               WHERE A.module_id = b.module_id
                 AND b.module_name = 'GICLS070'
                 AND A.function_cd = 'LO'
                 AND table_name = 'GICL_EVAL_LOA'
                 AND column_name <> 'EVAL_ID')
 
  LOOP
      
      IF rec.column_name = 'CLAIM_ID' THEN
          INSERT_OVERRIDE_DTL(v_override_id, rec.function_col_cd, p_claim_id, p_user_id);
	  ELSIF rec.column_name = 'CLM_LOSS_ID' THEN
	  	IF p_clm_loss_id != NULL THEN -- ADDED FOR MC EVAL, BECAUSE CLM LOSS ID IS NULL IN CSL OF MC EVAL - IRWIN
          INSERT_OVERRIDE_DTL(v_override_id, rec.function_col_cd, p_clm_loss_id, p_user_id);
	  END IF;
      ELSIF rec.column_name = 'PAYEE_TYPE_CD' THEN
          INSERT_OVERRIDE_DTL(v_override_id, rec.function_col_cd, p_payee_class_cd, p_user_id);
      ELSIF rec.column_name = 'PAYEE_CD' THEN
          INSERT_OVERRIDE_DTL(v_override_id, rec.function_col_cd, p_payee_cd, p_user_id);
      END IF;
        
  END LOOP;

    --jen.03162007
  BEGIN
    SELECT module_id
      INTO v_moduleId
      FROM GIAC_MODULES
     WHERE module_name = 'GICLS070';
  EXCEPTION
      WHEN NO_DATA_FOUND THEN  
         RAISE_APPLICATION_ERROR(-20003, 'GICLS070 does not exist in GIAC_MODULES.');
         
      WHEN TOO_MANY_ROWS THEN  
         RAISE_APPLICATION_ERROR(-20004,'There is more than one record of GICLS070 that exists in GIAC_MODULES.');
  END;
    
  --set override switch to Y for module_id = 477 and function_code = 'LO'
  UPDATE GIAC_FUNCTIONS
     SET override_sw = 'Y'
   WHERE module_id = v_moduleId
     AND function_code = 'LO';
  
END;
/



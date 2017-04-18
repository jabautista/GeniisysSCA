DROP PROCEDURE CPI.GICLS024_CREATE_OVERRIDE_REQ;

CREATE OR REPLACE PROCEDURE CPI.gicls024_create_override_req(
        p_line_cd       VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_claim_id      NUMBER,
        p_user_id       VARCHAR2,
        p_ovr_remarks   VARCHAR2
) IS
    v_ovrd_id             NUMBER;
    v_mod_id              NUMBER(3);
    v_func_cl_cd         NUMBER(12);
BEGIN
    SELECT NVL(MAX(override_id),0) + 1
      INTO v_ovrd_id
      FROM gicl_function_override;
          
    SELECT module_id
        INTO v_mod_id
      FROM giac_modules
     WHERE module_name = 'GICLS024';
         
    BEGIN
        SELECT function_col_cd
          INTO v_func_cl_cd
          FROM giac_function_columns
         WHERE module_id = v_mod_id
           AND function_cd = 'RO'
           AND column_name = p_claim_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_func_cl_cd := 0;
    END;
         
    INSERT INTO gicl_function_override(override_id, 
                                   LINE_CD, 
                                   ISS_CD, 
                                   MODULE_ID, 
                                   FUNCTION_CD, 
                                   DISPLAY, 
                                   REQUEST_DATE, 
                                   REQUEST_BY, 
                                   REMARKS) 
    VALUES (v_ovrd_id, 
            p_line_cd, 
            p_iss_cd, 
            v_mod_id, 
            'RO', 
            get_claim_info(p_claim_id), 
            sysdate, 
            nvl(p_user_id, USER), 
            p_ovr_remarks);          
                
    INSERT INTO gicl_function_override_dtl(override_id, 
                                            FUNCTION_COL_CD, 
                                            FUNCTION_COL_VAL) 
    VALUES  (v_ovrd_id, 
               v_func_cl_cd,
             p_claim_id);                           
END gicls024_create_override_req;
/



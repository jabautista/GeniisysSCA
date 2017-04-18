DROP PROCEDURE CPI.AEG_PARAMETERS_GIACS012;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_giacs012
   (p_gacc_tran_id              GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
    p_module_name               GIAC_MODULES.module_name%TYPE,
    p_message           OUT     VARCHAR2) IS
   
    v_module_id         GIAC_MODULES.module_id%TYPE;        
    v_gen_type          GIAC_MODULES.generation_type%TYPE;
    v_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE;
    v_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE;
    v_dummy             VARCHAR2(1);
    
    CURSOR C IS
        SELECT gacc_tran_id, gibr_branch_cd, item_no, 
               collection_amt, gibr_gfun_fund_cd                      
        FROM GIAC_OTH_FUND_OFF_COLLNS
        WHERE gacc_tran_id = p_gacc_tran_id;

           
BEGIN
    p_message := 'SUCCESS';
  BEGIN    
    SELECT module_id,
           generation_type
      INTO v_module_id,
           v_gen_type
      FROM giac_modules
     WHERE module_name  = p_module_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_message := 'No data found in GIAC MODULES.';
  END;
  
   /*
   ** Call the deletion of accounting entry procedure.
   */
          
    GIAC_ACCT_ENTRIES_PKG.aeg_delete_acct_entries (p_gacc_tran_id, v_gen_type);

    /*
    ** Call the accounting entry generation procedure.
    */
  BEGIN  
    FOR GL_rec IN(SELECT gl_acct_category, gl_control_acct,
                         gl_sub_acct_1   , gl_sub_acct_2  ,
                         gl_sub_acct_3   , gl_sub_acct_4  ,
                         gl_sub_acct_5   , gl_sub_acct_6  ,
                         gl_sub_acct_7   , pol_type_tag   ,
                         intm_type_level , old_new_acct_level,
                         dr_cr_tag       , line_dependency_level
                  FROM giac_module_entries
                  WHERE module_id = v_module_id
                  AND item_no   = 1)
        LOOP
            FOR C_rec IN C
                LOOP    
                    BEGIN
                     SELECT 'x', credit_amt, debit_amt
                     INTO v_dummy, v_credit_amt, v_debit_amt
                     FROM GIAC_ACCT_ENTRIES
                     WHERE gacc_gibr_branch_cd =  C_rec.gibr_branch_cd
                       AND gacc_gfun_fund_cd   =  C_rec.gibr_gfun_fund_cd
                       AND gacc_tran_id        =  p_gacc_tran_id
                       AND gl_acct_category    =  gl_rec.gl_acct_category    
                       AND gl_control_acct     =  gl_rec.gl_control_acct        
                       AND gl_sub_acct_1       =  gl_rec.gl_sub_acct_1       
                       AND gl_sub_acct_2       =  gl_rec.gl_sub_acct_2       
                       AND gl_sub_acct_3       =  gl_rec.gl_sub_acct_3       
                       AND gl_sub_acct_4       =  gl_rec.gl_sub_acct_4       
                       AND gl_sub_acct_5       =  gl_rec.gl_sub_acct_5       
                       AND gl_sub_acct_6       =  gl_rec.gl_sub_acct_6       
                       AND gl_sub_acct_7       =  gl_rec.gl_sub_acct_7;
                                        
                    GIAC_ACCT_ENTRIES_PKG.update_acct_entries(
                                C_rec.gibr_branch_cd    ,C_rec.gibr_gfun_fund_cd,
                                p_gacc_tran_id          ,C_rec.collection_amt,
                                GL_REC.GL_ACCT_CATEGORY ,GL_REC.GL_CONTROL_ACCT, 
                                GL_REC.GL_SUB_ACCT_1    ,GL_REC.GL_SUB_ACCT_2,
                                GL_REC.GL_SUB_ACCT_3    ,GL_REC.GL_SUB_ACCT_4,
                                GL_REC.GL_SUB_ACCT_5    ,GL_REC.GL_SUB_ACCT_6,
                                GL_REC.GL_SUB_ACCT_7);  

                  EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                        GIAC_ACCT_ENTRIES_PKG.aeg_create_acct_entr_giacs012
                                (C_rec.gibr_branch_cd,      C_rec.gibr_gfun_fund_cd,
                                 p_gacc_tran_id,            v_module_id,
                                 C_rec.item_no,             C_rec.collection_amt,
                                 v_gen_type,                p_message);
                  END;
              END LOOP;
        END LOOP;
    
  END;
  
END;
/



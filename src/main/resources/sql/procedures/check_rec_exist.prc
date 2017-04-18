DROP PROCEDURE CPI.CHECK_REC_EXIST;

CREATE OR REPLACE PROCEDURE CPI.CHECK_REC_EXIST
(p_claim_id       IN   GICL_EVAL_CSL.claim_id%TYPE,
 p_eval_id        IN   GICL_EVAL_CSL.eval_id%TYPE,
 p_clm_loss_id    IN   GICL_EVAL_CSL.clm_loss_id%TYPE,
 p_payee_class_cd IN   GICL_EVAL_CSL.payee_type_cd%TYPE,
 p_payee_cd       IN   GICL_EVAL_CSL.payee_cd%TYPE,
 p_rec_exist      OUT  NUMBER) IS
 
/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 04.03.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : This procedure will check if the record is  
**                  existing in gicl_function_override_dtl
*/ 
                                                
  --cursor of all override_id that has a function_col_cd = 5 and function_col_val equal to the record's claim_id                                            
  CURSOR override_id_cursor(p_claim gicl_eval_loa.claim_id%TYPE) IS  
    SELECT override_id 
          FROM GICL_FUNCTION_OVERRIDE_DTL A,
               GIAC_FUNCTION_COLUMNS b,
               GIAC_MODULES c
         WHERE b.table_name = 'GICL_EVAL_LOA'
           AND b.function_cd = 'LO'
           AND b.column_name = 'CLAIM_ID'
           AND b.module_id = c.module_id
           AND c.module_name = 'GICLS070'
           AND A.function_col_cd = b.function_col_cd
           AND function_col_val = p_claim;
           
  --cursor of all the function_col_cd excluding the function_col_cd = 5 
  CURSOR function_col_cd_cursor IS
    SELECT UPPER(COLUMN_NAME) column_name, function_col_cd
        FROM GIAC_FUNCTION_COLUMNS a, 
             GIAC_MODULES b
       WHERE a.module_id = b.module_id
         AND b.module_name = 'GICLS070'
         AND function_cd = 'LO'
         AND table_name = 'GICL_EVAL_LOA'
         AND UPPER(COLUMN_NAME) <> 'CLAIM_ID';
  
  
  v_rec_exist1    NUMBER  := 0; --jason(03.19.2007) checking for claim_id, eval_id, payee_class_cd, payee_cd combination
  v_rec_exist2    NUMBER  := 0; --jason(03.19.2007) checking for claim_id, clm_loss_id, payee_class_cd, payee_cd combination
  v_exist         NUMBER  := 0;
  v_value         NUMBER  := 0;  
 
  v_approved     BOOLEAN := FALSE; --jen.043007 is true if there exists an approved override request.
  
BEGIN

  FOR rec IN override_id_cursor(p_claim_id) LOOP
    
    p_rec_exist     := 0;
    v_rec_exist1    := 0; 
    v_rec_exist2    := 0;
    
    FOR rec2 IN function_col_cd_cursor 
    LOOP
          
        
        IF rec2.column_name = 'EVAL_ID' THEN
          /*GOTO skip; -- skip checking the eval_id*/ --jason 031907
            v_value := p_eval_id;
        ELSIF rec2.column_name = 'CLM_LOSS_ID'THEN
            v_value := p_clm_loss_id;  
        ELSIF rec2.column_name = 'PAYEE_TYPE_CD' THEN
            v_value := p_payee_class_cd;
        ELSIF rec2.column_name = 'PAYEE_CD' THEN 
             v_value := p_payee_cd;
        END IF;
          --check if record exists
        BEGIN
           SELECT 1
             INTO v_exist
             FROM GICL_FUNCTION_OVERRIDE_DTL
            WHERE function_col_cd = rec2.function_col_cd
              AND function_col_val = v_value
              AND override_id = rec.override_id;
                
           IF rec2.column_name = 'EVAL_ID' THEN 
              v_rec_exist1 := NVL(v_rec_exist1,0) + NVL(v_exist,0); --eval_id exists
              
           ELSIF rec2.column_name = 'CLM_LOSS_ID'THEN
              v_rec_exist2 := NVL(v_rec_exist2,0) + NVL(v_exist,0); --clm_loss_id exists
              
           ELSE
              v_rec_exist1 := NVL(v_rec_exist1,0) + NVL(v_exist,0);
              v_rec_exist2 := NVL(v_rec_exist2,0) + NVL(v_exist,0);
              
           END IF;
              
            --there is an existing record for claim_id, eval_id/clm_loss_id, payee_type_cd, and payee_cd in gicl_function_override_dtl
           IF v_rec_exist1 = 3 OR v_rec_exist2 = 3 THEN 
              
              BEGIN
                 --check if override_id exist in gicl_function_override and that override_user is not null
                 
                 SELECT 1
                   INTO v_exist
                   FROM GICL_FUNCTION_OVERRIDE
                  WHERE override_id = rec.override_id
                    AND override_user IS NOT NULL;
                        
                 v_rec_exist1 := NVL(v_rec_exist1,0) + NVL(v_exist,0);
                 v_rec_exist2 := NVL(v_rec_exist2,0) + NVL(v_exist,0);
                     
                 v_approved := TRUE;--jen.043007
                     
                 EXIT;
                     
              EXCEPTION 
                  WHEN NO_DATA_FOUND THEN
                    v_rec_exist1 := NVL(v_rec_exist1,0) + 2;
                    v_rec_exist2 := NVL(v_rec_exist2,0) + 2;
                            
                    IF v_rec_exist1 > v_rec_exist2 THEN
                         p_rec_exist := v_rec_exist1;
                    ELSE
                         p_rec_exist := v_rec_exist2;
                    END IF;
                            
                    RETURN;
              END;
                  
           END IF;
           
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
           p_rec_exist := 0;
        END;
        
    END LOOP;
    
    IF v_approved THEN
         EXIT;
    END IF;
    
    <<SKIP>>
      NULL;
      
  END LOOP;
  
  IF v_rec_exist1 > v_rec_exist2 THEN
      p_rec_exist := v_rec_exist1;
  
  ELSE
      p_rec_exist := v_rec_exist2;
  
  END IF;
    
END check_rec_exist;
/



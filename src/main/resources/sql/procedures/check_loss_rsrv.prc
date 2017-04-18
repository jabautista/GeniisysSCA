DROP PROCEDURE CPI.CHECK_LOSS_RSRV;

CREATE OR REPLACE PROCEDURE CPI.check_loss_rsrv (
        p_c007_claim_id          IN GICL_ITEM_PERIL.claim_id%TYPE,
        p_c007_item_no            IN GICL_ITEM_PERIL.item_no%TYPE,
        p_c007_peril_cd            IN GICL_ITEM_PERIL.peril_cd%TYPE,
        p_c007_grouped_item_no    IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_dsp_line_cd            IN GICL_CLAIMS.line_cd%TYPE,
        p_dsp_iss_cd            IN GICL_CLAIMS.iss_cd%TYPE,
        p_loss_reserve            IN NUMBER,
        p_expense_reserve        IN NUMBER,
        p_convert_rate            IN NUMBER,
        p_message               OUT VARCHAR2,
        p_override_approved_sw  OUT VARCHAR2,
        p_or_count              OUT NUMBER
    ) IS
        validate_reserve varchar2(1);
        all_res_sw              varchar2(1);
        res_amt                  gicl_adv_line_amt.res_range_to%TYPE;
        v_res_tot             gicl_adv_line_amt.res_range_to%TYPE := 0;  -- beth 08032006 variable to store total reserve
        ans                          NUMBER;
        goFlag                      BOOLEAN := TRUE;
        v_convert_rate   gicl_clm_res_hist.convert_rate%TYPE := 1; -- beth 08032006 variable to store item currency rate
        v_mod_id               NUMBER(3); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        v_or_cnt               NUMBER(3); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        v_func_cl_cd          NUMBER(12); -- consolidated by adrel 03152007 from pau's version gicls024-1172006
        --v_override_approved_sw              varchar2(1):='N'; -- added by adrel. 'Y' if reserve override for the user exists. 03222007
    BEGIN
        p_override_approved_sw := 'N';
        BEGIN
            SELECT param_value_v
              INTO validate_reserve
                FROM giis_parameters
             WHERE param_name = 'VALIDATE_RESERVE_LIMITS';
        EXCEPTION
            WHEN no_data_found THEN
               p_message := 'VALIDATE_RESERVE_LIMITS not found in giis_parameters';
        END;
        
        IF validate_reserve <> 'N' THEN
            FOR get_rate IN (
               SELECT currency_rate
                 FROM gicl_clm_item
                  WHERE claim_id  = p_c007_claim_id
                    AND item_no = p_c007_item_no)
            LOOP
                 v_convert_rate := get_rate.currency_rate;       
            END LOOP;
             
            BEGIN
                 SELECT nvl(all_res_amt_sw,'N')
                   INTO all_res_sw
                   FROM gicl_adv_line_amt
                  WHERE adv_user = USER
                  AND line_cd = p_dsp_line_cd
                    AND iss_cd = p_dsp_iss_cd;
            EXCEPTION
                  WHEN no_data_found THEN
                    p_message := 'User is not allowed to make a reserve, please refer to the reserve maintenance';
             END;
             
            IF all_res_sw = 'N' THEN
             
                FOR get_tot IN (
                     SELECT NVL(a.loss_reserve,0) * NVL(a.convert_rate,1) loss
                      FROM gicl_clm_res_hist a, gicl_item_peril b
                     WHERE a.claim_id  = b.claim_id
                       AND a.item_no = b.item_no
                       AND NVL(a.grouped_item_no,0) = NVL(b.grouped_item_no,0) 
                       AND a.peril_cd  = b.peril_cd
                       AND a.claim_id  = p_c007_claim_id
                       AND (a.item_no <> p_c007_item_no
                        OR NVL(a.grouped_item_no,0) <> NVL(p_c007_grouped_item_no,0) 
                        OR  a.peril_cd  <> p_c007_peril_cd)
                        AND NVL(a.dist_sw, 'N')= 'Y'
                        AND a.tran_id IS NULL
                        AND b.close_flag NOT IN ('DN', 'WD'))
                LOOP
                      v_res_tot := get_tot.loss;
                END LOOP;
                  
                IF validate_reserve = 'Y' THEN    
                     -- get total expense reserve for other item peril
                      FOR get_tot IN (
                        SELECT NVL(a.expense_reserve,0) * NVL(a.convert_rate,1) expense 
                         FROM gicl_clm_res_hist a, gicl_item_peril b
                        WHERE a.claim_id  = b.claim_id
                          AND a.item_no = b.item_no
                          AND NVL(a.grouped_item_no,0) = NVL(b.grouped_item_no,0) 
                          AND a.peril_cd  = b.peril_cd
                          AND a.claim_id  = p_c007_claim_id
                          AND (a.item_no <> p_c007_item_no
                           OR NVL(a.grouped_item_no,0) <> NVL(p_c007_grouped_item_no,0) 
                           OR  a.peril_cd  <> p_c007_peril_cd)
                          AND NVL(a.dist_sw, 'N')= 'Y'
                          AND a.tran_id IS NULL
                          AND b.close_flag2 NOT IN ('DN', 'WD'))
                     LOOP
                          v_res_tot := get_tot.expense;
                     END LOOP;
                END IF;
             --
                BEGIN
                    SELECT NVL(res_range_to,0)
                      INTO res_amt
                      FROM gicl_adv_line_amt
                     WHERE adv_user = USER
                       AND line_cd = p_dsp_line_cd
                       AND iss_cd  = p_dsp_iss_cd;
                        v_res_tot := v_res_tot + (NVL(p_loss_reserve,0)* NVL(p_convert_rate, v_convert_rate));
                       
                       IF validate_reserve = 'Y' THEN    
                        v_res_tot := v_res_tot + (NVL(p_expense_reserve,0)* NVL(p_convert_rate, v_convert_rate));            
                       END IF;
                    
                    IF v_res_tot > res_amt THEN

                      BEGIN
                            SELECT module_id
                            INTO V_MOD_ID
                             FROM giac_Modules
                            WHERE module_name = 'GICLS024';
                      EXCEPTION
                          WHEN too_many_rows THEN
                           NULL;
                      END;
                        
                      BEGIN
                        SELECT function_col_cd
                          INTO v_func_cl_cd
                          FROM giac_function_columns
                         WHERE module_id = v_mod_id
                           AND function_cd = 'RO'
                           AND column_name = 'CLAIM_ID';
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                      END;
                       
                       
                       BEGIN      
                              SELECT 'Y'
                                INTO p_override_approved_sw
                                    FROM GICL_FUNCTION_OVERRIDE A
                                     WHERE override_user IS NOT NULL
                                       AND EXISTS (SELECT 1
                                                                 FROM GICL_FUNCTION_OVERRIDE_DTL
                                                                 WHERE override_id = A.override_id
                                                                   AND function_col_cd = v_func_cl_cd 
                                                                   AND function_col_val = p_c007_claim_id);
                       EXCEPTION
                            WHEN TOO_MANY_ROWS THEN
                              p_override_approved_sw := 'Y';
                            WHEN NO_DATA_FOUND THEN
                              p_override_approved_sw := 'N';  
                       END;
                       
                       IF NVL(p_override_approved_sw,'N') <> 'Y' THEN
                           -- for request override
                           SELECT module_id
                               INTO v_mod_id
                             FROM giac_modules
                               WHERE module_name = 'GICLS024';
                       
                           SELECT count(override_id)
                                           INTO v_or_cnt
                                          FROM gicl_function_override_dtl a
                                            WHERE function_col_cd = v_func_cl_cd
                                            AND function_col_val = p_c007_claim_id
                                           AND NOT EXISTS (SELECT 1
                                                                           FROM GICL_FUNCTION_OVERRIDE
                                                                                WHERE override_id = a.override_id
                                                                                  AND override_user IS NOT NULL);
                            p_or_count := v_or_cnt;
                       END IF; -- end of "IF v_override_approved_sw <> 'Y'"
                    END IF;
                EXCEPTION
                       WHEN no_data_found THEN
                         nULL;
                END;
                
                
            END IF;
        END IF;
    END check_loss_rsrv;
/



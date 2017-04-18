CREATE OR REPLACE PACKAGE BODY CPI.populate_giclr070_pkg
AS
    /*
    **  Created by   :  Udel Dela Cruz Jr.
    **  Date Created :  April 19, 2012 
    **  Reference By :  GICLR070 - MC Evaluation Sheet report 
    **  Description :   get MC evaluation to populate GICLR070 report
    */
    FUNCTION populate_giclr070 (
            p_eval_id       gicl_mc_evaluation.eval_id%TYPE
      ) RETURN populate_giclr070_tab PIPELINED IS
        v_list      populate_giclr070_type;
    BEGIN
        FOR rec IN (SELECT a.subline_cd||'-'||a.iss_cd||'-'||lpad(a.eval_yy,2,'0')||'-'||lpad(a.eval_seq_no,7,'0')||'-'||lpad(a.eval_version,2,'0') eval_no,
                           b.line_cd||'-'||b.subline_cd||'-'||b.pol_iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no policy_no,
                           loss_date, b.assd_no, 
                           a.CLAIM_ID, a.ITEM_NO, a.EVAL_ID, a.SUBLINE_CD, a.ISS_CD, 
                           a.PLATE_NO, TP_SW, CSO_ID, EVAL_DATE, INSPECT_DATE, 
                           INSPECT_PLACE, (SELECT sum(vat_amt)
                                                  FROM gicl_Eval_vat
                                   WHERE nvl(with_vat,'N') = 'N'   AND eval_id = p_eval_id) VAT, 
                           DEDUCTIBLE, DEPRECIATION, a.REMARKS
                    FROM gicl_mc_evaluation a, gicl_claims b
                    WHERE 1=1 
                    AND a.eval_id = p_eval_id
                      AND a.claim_id = b.claim_id)
        LOOP
            v_list.eval_no          := rec.eval_no;
            v_list.policy_no        := rec.policy_no;
            v_list.loss_date        := rec.loss_date;
            v_list.assd_no          := rec.assd_no;
            v_list.claim_id         := rec.claim_id;
            v_list.item_no          := rec.item_no;
            v_list.eval_id          := rec.eval_id;
            v_list.subline_cd       := rec.subline_cd;
            v_list.iss_cd           := rec.iss_cd;
            v_list.plate_no         := rec.plate_no;
            v_list.tp_sw            := rec.tp_sw;
            v_list.cso_id           := rec.cso_id;
            v_list.eval_date        := rec.eval_date;
            v_list.inspect_date     := rec.inspect_date;
            v_list.inspect_place    := rec.inspect_place;
            v_list.vat              := rec.vat;
            v_list.deductible       := rec.deductible;
            v_list.depreciation     := rec.depreciation;
            v_list.remarks          := rec.remarks;
            
            -- Get assured name
            BEGIN
                SELECT assd_name
                  INTO v_list.assd_name
                  FROM giis_assured
                 WHERE assd_no = rec.assd_no;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_list.assd_name := null;
            END;
            
            -- Get eval name
            BEGIN
                SELECT user_name
                  INTO v_list.eval_name
                  FROM giis_users
                 WHERE user_id = rec.cso_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_list.eval_name := null;
            END;
            
            
            IF rec.tp_sw = 'Y' THEN
                -- Get third party
                FOR TP IN (SELECT payee_last_name||DECODE(NVL(payee_first_name,'x'), 'x', NULL, ', '||payee_first_name) tp_name
                                       FROM gicl_mc_tp_dtl a, giis_payees b
                                        WHERE a.claim_id = rec.claim_id
                                          AND a.item_no  = rec.item_no
                                          AND NVL(a.plate_no,'*') = NVL(rec.plate_no,'*')
                                          AND a.payee_class_cd = b.payee_class_cd
                                          AND a.payee_no = b.payee_no)LOOP
                   v_list.tp_name := TP.TP_NAME;
                END LOOP;
                
                -- Get vehicle if tp_sw is Y
                BEGIN
                    SELECT model_year||'-'||b.CAR_COMPANY||'-'||c.MAKE||'-'||d.ENGINE_SERIES||'-'||e.MOTOR_TYPE_DESC VEHICLE
                      INTO v_list.vehicle
                      FROM gicl_mc_tp_dtl a, GIIS_MC_CAR_COMPANY b, GIIS_MC_MAKE c, GIIS_MC_ENG_SERIES d, GIIS_MOTORTYPE e
                     WHERE a.claim_id = rec.claim_id
                       AND a.item_no  = rec.item_no
                       AND a.plate_no = rec.plate_no
                       AND a.MOTORCAR_COMP_CD = b.car_company_cd(+)
                       AND a.make_cd = c.make_cd(+)
                       AND b.car_company_cd = c.car_company_cd
                       AND a.series_cd = d.series_cd(+)
                       AND b.car_company_cd = d.car_company_cd
                       AND c.MAKE_cd = d.make_cd
                       AND a.MOT_TYPE = e.TYPE_CD(+)		
                       AND E.SUBLINE_CD = rec.SUBLINE_CD; --PAU 04FEB08
                EXCEPTION	   
                    WHEN no_data_found THEN
                      v_list.vehicle := NULL;
                END;
            ELSE
                -- Get vehicle if tp_sw is not Y
                BEGIN
                    SELECT item_title
                      INTO v_list.vehicle
                      FROM gicl_clm_item
                     WHERE claim_id = rec.claim_id
                       AND item_no  = rec.item_no;   
                EXCEPTION	   
                    WHEN no_data_found THEN
                      v_list.vehicle := NULL;
                END;
            END IF;
            
            -- Get sum of units
            BEGIN
                SELECT NVL(SUM(no_of_unit), 0)
                  INTO v_list.sum_nof
                  FROM gicl_eval_deductibles
                 WHERE ded_cd   <> giisp.v('MC_DEPRECIATION_CD')
                   AND ded_cd   <> giisp.v('CLM DISCOUNT') --------JEROME.O 
                   AND EVAL_ID  =  p_eval_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_list.sum_nof := 0;
            END;
            
            -- Get deductibles sum
            BEGIN
                SELECT NVL(SUM(ded_amt), 0)
                  INTO v_list.sum_ded_amt
                  FROM gicl_eval_deductibles
                 WHERE ded_cd <> giisp.v('CLM DISCOUNT')
                   AND EVAL_ID =  p_eval_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_list.sum_ded_amt := 0;
            END;
            
            -- Get discounts sum
            BEGIN
                SELECT NVL(SUM(ded_amt), 0)
                  INTO v_list.sum_discount_amt
                  FROM gicl_eval_deductibles
                 WHERE ded_cd = giisp.v('CLM DISCOUNT')
                   AND EVAL_ID =  p_eval_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_list.sum_discount_amt := 0;
            END;
            
            -- Get deductible rate
            BEGIN
                SELECT DISTINCT(ded_rt)
                  INTO v_list.ded_rt
                  FROM gicl_eval_dep_dtl a, gicl_replace b
                 WHERE 1=1
                   AND a.loss_exp_cd = b.loss_exp_cd
                   AND a.eval_id = b.eval_id
                   AND a.eval_id = p_eval_id;
            EXCEPTION
                WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
                    v_list.ded_rt := 0;
            END;
            
            -- Get deductible amount for depreciation
            BEGIN
                IF v_list.ded_rt = 0 THEN
                 SELECT sum(nvl(a.ded_amt,0))
                   INTO v_list.sum_dep_ded_amt
                   FROM gicl_eval_dep_dtl a,
                        gicl_replace b
                  WHERE 1=1
                    AND a.loss_Exp_cd = b.loss_exp_cd
                    AND a.eval_id = b.eval_id
                    AND a.EVAL_ID = p_eval_id
                    AND b.PART_TYPE = 'O';
              ELSE
                   SELECT nvl(SUM(b.part_amt),0)
                   INTO v_list.sum_dep_ded_amt
                   FROM gicl_eval_dep_dtl a, gicl_replace b
                  WHERE 1=1
                    AND a.loss_Exp_cd = b.loss_exp_cd
                    AND a.eval_id = b.eval_id
                    AND a.EVAL_ID = p_eval_id
                    AND b.PART_TYPE = 'O';
              END IF; 
            END;
            
            
            
            PIPE ROW(v_list);    
        END LOOP;
    END populate_giclr070;
    
    FUNCTION populate_scope (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
      ) RETURN populate_scope_tab PIPELINED IS
        v_list      populate_scope_type;
    BEGIN
        FOR rec IN (SELECT SCOPE, DECODE(TYPE,'REPLACE', AMOUNT,0.00) REPLACE, DECODE(TYPE,'REPAIR', AMOUNT, 0.00) REPAIR, rec1, item_no, flag
                      FROM (/*REPLACE parts*/
                                 SELECT b.LOSS_EXP_desc SCOPE,
                                   DECODE(Giisp.v('EXCLUDE_VAT_AMT'),'Y',
                                             DECODE (NVL(WITH_VAT,'N'),'Y',
                                                  DECODE((SELECT DISTINCT 'Y' 
                                                            FROM GICL_EVAL_VAT 
                                                           WHERE EVAL_ID = p_eval_id
                                                             AND APPLY_TO='P'),'Y',
                                                         ROUND((A.part_amt/(1+Giacp.n('INPUT_VAT_RT')/100)),2),
                                                         NULL,A.part_amt),
                                                  'N',A.part_amt),
                                          'N',A.part_amt) AMOUNT,
                                   'REPLACE' TYPE, ROWNUM rec1, item_no, 1 flag
                              FROM GICL_REPLACE A, GIIS_LOSS_EXP b
                             WHERE b.line_cd = 'MC'
                               AND A.loss_exp_cd = b.loss_exp_cd
                               AND b.comp_sw = '+'
                               AND b.loss_exp_type = 'L'
                               AND A.eval_id = p_eval_id
                               AND a.update_sw = nvl(p_update_sw,a.update_sw)
                                         --  AND a.part_type = 'O'
                             UNION ALL 
                            /*OTHER REPAIR*/
                            SELECT SCOPE, amount, TYPE, ROWNUM, item_no, 2 flag
                              FROM(SELECT b.repair_desc SCOPE,
                                   DECODE(Giisp.v('EXCLUDE_VAT_AMT'),'Y',
                                           DECODE (NVL(C.WITH_VAT,'N'),'Y',
                                                    DECODE((SELECT DISTINCT 'Y' 
                                                              FROM GICL_EVAL_VAT 
                                                           WHERE EVAL_ID = p_eval_id
                                                             AND APPLY_TO='L'),    'Y',
                                                         ROUND((A.amount/(1+Giacp.n('INPUT_VAT_RT')/100)),2),
                                                         NULL,A.amount),
                                                  'N',A.amount),
                                          'N',A.amount) AMOUNT,
                                     'REPAIR' TYPE, item_no, 2 flag
                              FROM GICL_REPAIR_OTHER_DTL A, GICL_REPAIR_TYPE b, GICL_REPAIR_HDR C 
                              WHERE A.repair_cd = b.repair_cd
                               AND A.eval_id = p_eval_id
                               AND A.EVAL_ID = C.EVAL_ID
                               AND A.UPDATE_SW = NVL(p_update_sw,a.update_sw)
                             UNION ALL
                            /*TINSMITH*/ 
                            SELECT 'TINSMITH' SCOPE,
                                   DECODE(Giisp.v('EXCLUDE_VAT_AMT'),'Y',
                                               DECODE (NVL(WITH_VAT,'N'),'Y',
                                                  DECODE((SELECT DISTINCT 'Y' 
                                                              FROM GICL_EVAL_VAT 
                                                           WHERE EVAL_ID=p_eval_id
                                                             AND APPLY_TO='L'),'Y',
                                                         ROUND((actual_tinsmith_amt/(1+Giacp.n('INPUT_VAT_RT')/100)),2),
                                                         NULL,actual_tinsmith_amt),
                                                    'N', actual_tinsmith_amt),
                                          'N',actual_tinsmith_amt)AMOUNT,
                                   'REPAIR' TYPE, null, 2 flag
                            FROM GICL_REPAIR_HDR
                           WHERE eval_id = p_eval_id
                             AND UPDATE_SW = NVL(p_update_sw,update_sw)
                             AND actual_tinsmith_amt IS NOT NULL
                           UNION ALL
                          /*PAINTING*/ 
                          SELECT 'PAINTING' SCOPE,
                                   DECODE(Giisp.v('EXCLUDE_VAT_AMT'),'Y',
                                           DECODE (NVL(WITH_VAT,'N'),'Y',
                                                DECODE((SELECT DISTINCT 'Y' 
                                                          FROM GICL_EVAL_VAT 
                                                         WHERE EVAL_ID=p_eval_id
                                                           AND APPLY_TO='L'),'Y',
                                                       ROUND((actual_painting_amt/(1+Giacp.n('INPUT_VAT_RT')/100)),2),
                                                       NULL,actual_painting_amt),
                                                  'N',actual_painting_amt),
                                        'N',actual_painting_amt)AMOUNT,
                                 'REPAIR' TYPE, null, 2 flag
                            FROM GICL_REPAIR_HDR
                            WHERE eval_id = p_eval_id
                             AND UPDATE_SW = NVL(p_update_sw,update_sw)
                             AND actual_painting_amt IS NOT NULL)
                           UNION ALL
                           /*TOTAL REPAIR*/
                          SELECT 'TOTAL REPAIR AMT' SCOPE,
                                   DECODE(Giisp.v('EXCLUDE_VAT_AMT'),'Y',
                                          DECODE (NVL(WITH_VAT,'N'),'Y',
                                                DECODE((SELECT DISTINCT 'Y' 
                                                          FROM GICL_EVAL_VAT 
                                                         WHERE EVAL_ID=p_eval_id
                                                           AND APPLY_TO='L'),'Y',
                                                       ROUND((actual_total_amt/(1+Giacp.n('INPUT_VAT_RT')/100)),2),
                                                       NULL,actual_total_amt),
                                                  'N',actual_total_amt),
                                        'N',actual_total_amt)AMOUNT,
                                 'REPAIR' TYPE,ROWNUM rec1, null, 2 flag
                            FROM GICL_REPAIR_HDR
                           WHERE eval_id = p_eval_id
                             AND UPDATE_SW = NVL(p_update_sw,update_sw)
                             AND actual_total_amt IS NOT NULL             
                              AND NVL(actual_painting_amt, 0) = 0       --Gzelle SR13107, to handle null and 0 values
                             AND NVL(actual_tinsmith_amt, 0) = 0       
                    )
                    ORDER BY flag, item_no)
        LOOP
            v_list.scope        := rec.scope;
            v_list.replace      := rec.replace;
            v_list.repair       := rec.repair;
            v_list.rec1         := rec.rec1;
            v_list.item_no      := rec.item_no;
            v_list.flag         := rec.flag;
            
            PIPE ROW(v_list);
        END LOOP;
    END populate_scope;
    
    FUNCTION populate_vat (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
      ) RETURN populate_vat_tab PIPELINED IS
        v_list      populate_vat_type;
    BEGIN
        FOR rec IN (SELECT (SELECT SUM(DECODE(Giisp.v('EXCLUDE_VAT_AMT'),
                                          'Y',ROUND(DECODE(nvl(A.with_vat,'N'),
                                                       'Y',(A.part_amt*Giacp.n('INPUT_VAT_RT')/100)/(1+Giacp.n('INPUT_VAT_RT')/100),
                                                       'N',(A.part_amt*(Giacp.n('INPUT_VAT_RT')/100))),2),
                                          'N',ROUND(DECODE(nvl(A.with_vat,'N'),'Y',0,'N',(A.part_amt*(Giacp.n('INPUT_VAT_RT')/100))),2))) vat_rt
                              FROM GICL_REPLACE A, GICL_EVAL_VAT b
                             WHERE A.eval_id = p_eval_id
                               AND A.update_sw = nvl(p_update_sw,a.update_sw)
                               AND A.eval_id = b.eval_id
                               AND NVL(A.payt_payee_type_cd,A.payee_Type_cd) = b.payee_Type_cd
                               AND NVL(A.payt_payee_cd,A.payee_cd) = b.payee_cd
                               AND b.apply_to = 'P') replace_vat,
                           (SELECT  DECODE(Giisp.v('EXCLUDE_VAT_AMT'),
                                       'Y',b.vat_amt,
                                       'N',DECODE(nvl(A.with_vat,'N'),
                                              'Y',0,'N',b.vat_amt),2)
                              FROM GICL_REPAIR_HDR A, GICL_EVAL_VAT b
                             WHERE b.eval_id = p_eval_id
                               AND A.eval_id = b.eval_id
                               AND A.update_sw = nvl(p_update_sw,a.update_sw)
                               AND apply_to = 'L') repair_vat
                    FROM DUAL)
        LOOP
            v_list.replace_vat  := NVL(rec.replace_vat, 0);
            v_list.repair_vat   := NVL(rec.repair_vat, 0);
            PIPE ROW (v_list);
        END LOOP;
    
    END populate_vat;
    
    FUNCTION populate_repair (
        p_eval_id       gicl_mc_evaluation.eval_id%TYPE,
        p_update_sw     VARCHAR2
      ) RETURN populate_repair_tab PIPELINED IS 
        v_list          populate_repair_type;
    BEGIN
        FOR rec IN (SELECT decode(a.repair_cd,'P','Painting','T','Tinsmith') repair_cd, b.loss_Exp_desc, item_no
                      FROM gicL_repair_lps_dtl a, giis_loss_exp b
                     WHERE 1=1
                       AND a.eval_id =p_eval_id
                       AND a.update_sw = nvl(p_update_sw, a.update_sw)
                       AND b.line_cd = 'MC'
                       AND b.lps_sw = 'Y'
                       AND b.comp_sw = '+'
                       AND b.loss_exp_type = 'L'
                       AND a.loss_exp_cd = b.loss_Exp_cd
                     ORDER BY eval_id)
        LOOP
            v_list.repair_cd        := rec.repair_cd;
            v_list.loss_exp_desc    := rec.loss_exp_desc;
            v_list.item_no          := rec.item_no;
            
            PIPE ROW (v_list);
        END LOOP;
    
    END populate_repair;

END populate_giclr070_pkg;
/



CREATE OR REPLACE PACKAGE BODY CPI.GICLS051_PKG
AS

    /*  Date created: July 30, 2013
     *  Description: counts number of claims with ungenerated PLAs (per line, user)
     *               which the user can print.
     */
    PROCEDURE query_count_ungen_pla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_module_id         IN  giis_modules.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_gen_cnt           OUT NUMBER,
        p_gen_cnt_all       OUT NUMBER
    ) IS
        v_gen_cnt       NUMBER := 0;
        v_gen_cnt_all   NUMBER := 0;
    BEGIN
        
        FOR chk IN (SELECT a.claim_id
                      FROM gicl_claims a 
                     WHERE EXISTS (SELECT b.claim_id
                                     FROM gicl_clm_res_hist b, gicl_reserve_ds c, gicl_item_peril d
                                    WHERE b.claim_id = a.claim_id
                                      AND b.claim_id = c.claim_id
                                      AND b.claim_id = d.claim_id
                                      AND b.item_no  = d.item_no
                                      AND b.grouped_item_no  = d.grouped_item_no
                                      AND b.peril_cd = d.peril_cd
                                      AND NVL(d.close_flag,'AP') IN ('AP', 'CP', 'CC')                      
                                      AND b.dist_sw = 'Y' 
                                      AND b.clm_res_hist_id = c.clm_res_hist_id
                                      AND NVL(c.negate_tag, 'N') = 'N' 
                                      AND c.share_type IN ('2','3')  
		                              AND EXISTS (SELECT '1' 
                                                    FROM gicl_reserve_rids e
                                                   WHERE e.claim_id = c.claim_id
                                                     AND e.clm_res_hist_id = c.clm_res_hist_id
                                                     AND e.clm_dist_no = c.clm_dist_no
                                                     AND e.hist_seq_no = c.hist_seq_no
                                                     AND e.pla_id IS NULL))
                       AND a.in_hou_adj = p_user_id
                       AND a.line_cd    = p_line_cd
                       AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,p_module_id,p_user_id) = 1)  --line added by jay 06/04/2012
        LOOP
            v_gen_cnt := 1;
        END LOOP;
        
        IF p_all_user_sw = 'Y' OR p_valid_tag = 'Y' THEN
  	        
            FOR chk IN (SELECT a.claim_id
                          FROM gicl_claims a 
                         WHERE EXISTS (SELECT b.claim_id
		                                 FROM gicl_clm_res_hist b, gicl_reserve_ds c, gicl_item_peril d
		                                WHERE b.claim_id = a.claim_id
                                          AND b.claim_id = c.claim_id
                                          AND b.claim_id = d.claim_id
                                          AND b.grouped_item_no  = d.grouped_item_no
                                          AND b.peril_cd = d.peril_cd
                                          AND NVL(d.close_flag,'AP') IN ('AP', 'CP', 'CC')                      
      	                                  AND b.dist_sw = 'Y' 
                                          AND b.clm_res_hist_id = c.clm_res_hist_id
                                          AND NVL(c.negate_tag, 'N') = 'N' 
                                          AND c.share_type IN ('2','3')  
		                                  AND EXISTS (SELECT '1' 
                                                        FROM gicl_reserve_rids e
                                                       WHERE e.claim_id = c.claim_id
                                                         AND e.clm_res_hist_id = c.clm_res_hist_id
                                                         AND e.clm_dist_no = c.clm_dist_no
                                                         AND e.hist_seq_no = c.hist_seq_no
                                                         AND e.pla_id IS NULL))
                           AND a.in_hou_adj != p_user_id
                           AND a.line_cd    = p_line_cd
                           AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,p_module_id, p_user_id) = 1) --line added by jay 06/04/2012
            LOOP
                v_gen_cnt_all := 1;
            END LOOP;
            
        END IF;
        
        p_gen_cnt       := v_gen_cnt;
        p_gen_cnt_all   := v_gen_cnt_all;
    
    END query_count_ungen_pla;
    
    -- counts number of claims with ungenerated FLAs (per line) which the user can generate
    PROCEDURE query_count_ungen_fla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_module_id         IN  giis_modules.module_id%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_gen_cnt           OUT NUMBER,
        p_gen_cnt_all       OUT NUMBER
    ) IS
        v_gen_cnt       NUMBER := 0;
        v_gen_cnt_all   NUMBER := 0;
    BEGIN
        
        FOR chk IN (SELECT a.claim_id
                      FROM gicl_claims a
                     WHERE clm_stat_cd NOT IN ('CC', 'WD', 'DN') 
                       AND EXISTS (SELECT '1' 
                                     FROM gicl_advice b, gicl_clm_loss_exp d, gicl_loss_exp_ds e
                                    WHERE a.claim_id    = b.claim_id
                                      AND b.claim_id    = d.claim_id
                                      AND b.advice_id   = d.advice_id
                                      AND e.clm_loss_id = d.clm_loss_id
                                      AND e.share_type  IN ('2','3')   
                                      AND b.advice_flag = 'Y'
                                      AND NOT EXISTS (SELECT '1'
                                                        FROM gicl_advs_fla c
                                                       WHERE c.claim_id   = b.claim_id
                                                         AND c.ADV_FLA_ID = b.ADV_FLA_ID  
                                                         AND NVL(c.cancel_tag,'N') = 'N'))
                       AND a.in_hou_adj = p_user_id
                       AND a.line_cd    = p_line_cd
                       AND check_user_per_iss_cd2( a.line_cd,a.iss_cd,p_module_id, p_user_id) = 1)  --line added by jay 06/04/2012
        LOOP
            v_gen_cnt := 1;
            EXIT;
        END LOOP;
        
        
        IF p_all_user_sw = 'Y' OR p_valid_tag = 'Y' THEN
     
            FOR chk IN (SELECT a.claim_id
                          FROM gicl_claims a
                         WHERE clm_stat_cd NOT IN ('CC', 'WD', 'DN') 
                           AND EXISTS (SELECT '1' 
                                         FROM gicl_advice b, gicl_clm_loss_exp d, gicl_loss_exp_ds e
                                        WHERE a.claim_id = b.claim_id
                                          AND b.claim_id = d.claim_id
                                          AND e.claim_id = d.claim_id
                                          AND b.advice_id = d.advice_id
                                          AND e.clm_loss_id = d.clm_loss_id
                                          AND e.share_type IN ('2','3')   
                                          AND b.advice_flag = 'Y'
                                          AND NOT EXISTS (SELECT '1'
                                                            FROM gicl_advs_fla c
                                                           WHERE c.claim_id   = b.claim_id
                                                             AND c.adv_fla_id = b.adv_fla_id 
                                                             AND NVL(c.cancel_tag,'N') = 'N'))
                           AND a.in_hou_adj != p_user_id
                           AND a.line_cd    = p_line_cd
                           AND check_user_per_iss_cd2( a.line_cd,a.iss_cd,p_module_id, p_user_id) = 1)  --line added by jay 06/04/2012
            LOOP
                v_gen_cnt_all := 1;
                EXIT;
            END LOOP;
            
        END IF;
  
        p_gen_cnt       := v_gen_cnt;
        p_gen_cnt_all   := v_gen_cnt_all;
        
    END query_count_ungen_fla;
    
    -- retrieves values for tg of PLA
    FUNCTION get_pla_listing(
        p_all_user_sw       GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         giac_user_functions.valid_tag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_line_cd           giis_line.line_cd%TYPE
    ) RETURN claim_info_tab PIPELINED
    IS
        v_pla       claim_info_type;
    BEGIN
    
        IF p_all_user_sw = 'Y' OR p_valid_tag = 'Y' THEN
            
            FOR rec IN (SELECT A.CLAIM_ID, A.LINE_CD, A.SUBLINE_CD, A.ISS_CD, A.CLM_YY, A.CLM_SEQ_NO, 
                               A.POL_ISS_CD, A.POL_SEQ_NO, A.RENEW_NO, A.ISSUE_YY, 
                               A.ASSURED_NAME, A.LOSS_DATE, A.CLM_STAT_CD, A.IN_HOU_ADJ, A.LOSS_CAT_CD
                          FROM GICL_CLAIMS A 
                         WHERE in_hou_adj = in_hou_adj
                           AND EXISTS (SELECT B.CLAIM_ID 
                                         FROM GICL_CLM_RES_HIST B, GICL_RESERVE_DS C, GICL_ITEM_PERIL D 
                                        WHERE B.CLAIM_ID = A.CLAIM_ID 
                                          AND B.CLAIM_ID = C.CLAIM_ID 
                                          AND B.CLAIM_ID = D.CLAIM_ID 
                                          AND B.ITEM_NO = D.ITEM_NO 
                                          AND B.PERIL_CD = D.PERIL_CD 
                                          AND NVL(D.CLOSE_FLAG,'AP') IN ('AP', 'CP', 'CC')
                                          AND B.DIST_SW = 'Y' 
                                          AND B.CLM_RES_HIST_ID = C.CLM_RES_HIST_ID 
                                          AND NVL(C.NEGATE_TAG, 'N') = 'N'
                                          AND C.SHARE_TYPE IN ('2','3') 
                                          AND EXISTS (SELECT '1'
                                                        FROM GICL_RESERVE_RIDS E
                                                       WHERE E.CLAIM_ID = C.CLAIM_ID 
                                                         AND E.CLM_RES_HIST_ID = C.CLM_RES_HIST_ID 
                                                         AND E.CLM_DIST_NO = C.CLM_DIST_NO
                                                         AND E.HIST_SEQ_NO = C.HIST_SEQ_NO 
                                                         AND E.PLA_ID IS NULL))                                 
                           AND check_user_per_iss_cd2( a.line_cd,a.iss_cd, p_module_id, p_user_id) = 1
                           AND line_cd = p_line_cd)
            LOOP
            
                v_pla.claim_id        := rec.CLAIM_ID;
                v_pla.line_cd         := rec.line_cd;
                v_pla.subline_cd      := rec.subline_cd;
                v_pla.iss_cd          := rec.iss_cd;
                v_pla.clm_yy          := rec.clm_yy;
                v_pla.clm_seq_no      := rec.clm_seq_no;
                v_pla.pol_iss_cd      := rec.pol_iss_cd;
                v_pla.issue_yy        := rec.issue_yy;
                v_pla.pol_seq_no      := rec.pol_seq_no;
                v_pla.renew_no        := rec.renew_no;
                v_pla.assured_name    := rec.assured_name;
                v_pla.loss_Date       := TO_CHAR(rec.loss_Date, 'MM-DD-YYYY');
                v_pla.in_hou_adj      := rec.in_hou_adj;
                v_pla.clm_stat_cd     := rec.clm_stat_cd;
                v_pla.clm_stat_desc   := get_clm_stat_desc(rec.clm_stat_cd);   
                v_pla.loss_cat_cd     := rec.loss_cat_cd;
                
                SELECT loss_cat_des
                  INTO v_pla.loss_cat_desc
                  FROM giis_loss_ctgry
                 WHERE line_cd = v_pla.line_cd
                   AND loss_cat_cd = v_pla.loss_cat_cd;
        
                PIPE ROW(v_pla);
            END LOOP;
        
        ELSE
        
            FOR rec IN (SELECT A.CLAIM_ID, A.LINE_CD, A.SUBLINE_CD, A.ISS_CD, A.CLM_YY, A.CLM_SEQ_NO, 
                               A.POL_ISS_CD, A.POL_SEQ_NO, A.RENEW_NO, A.ISSUE_YY, 
                               A.ASSURED_NAME, A.LOSS_DATE, A.CLM_STAT_CD, A.IN_HOU_ADJ , A.LOSS_CAT_CD
                          FROM GICL_CLAIMS A
                         WHERE in_hou_adj = p_user_id
                           AND A.CLM_STAT_CD NOT IN ('CC', 'WD', 'DN') 
                           AND EXISTS (SELECT '1'
                                         FROM GICL_ADVICE B, GICL_CLM_LOSS_EXP D, GICL_LOSS_EXP_DS E 
                                        WHERE B.CLAIM_ID = A.CLAIM_ID 
                                          AND B.CLAIM_ID = D.CLAIM_ID 
                                          AND B.ADVICE_ID = D.ADVICE_ID 
                                          AND E.CLAIM_ID = D.CLAIM_ID
                                          AND E.CLM_LOSS_ID = D.CLM_LOSS_ID 
                                          AND E.SHARE_TYPE IN ('2','3') 
                                          AND B.ADVICE_FLAG = 'Y'
                                          AND NOT EXISTS( SELECT '1'
                                                            FROM GICL_ADVS_FLA C 
                                                           WHERE C.CLAIM_ID = B.CLAIM_ID 
                                                             AND C.ADV_FLA_ID = B.ADV_FLA_ID 
                                                             AND NVL(C.CANCEL_TAG,'N') = 'N')) 
                           AND check_user_per_iss_cd2(a.line_cd,a.iss_cd, p_module_id, p_user_id) = 1)
            LOOP
            
                v_pla.claim_id        := rec.CLAIM_ID;
                v_pla.line_cd         := rec.line_cd;
                v_pla.subline_cd      := rec.subline_cd;
                v_pla.iss_cd          := rec.iss_cd;
                v_pla.clm_yy        := rec.clm_yy;
                v_pla.clm_seq_no      := rec.clm_seq_no;
                v_pla.pol_iss_cd      := rec.pol_iss_cd;
                v_pla.issue_yy        := rec.issue_yy;
                v_pla.pol_seq_no      := rec.pol_seq_no;
                v_pla.renew_no        := rec.renew_no;
                v_pla.assured_name    := rec.assured_name;
                v_pla.loss_Date       := rec.loss_Date;
                v_pla.in_hou_adj    := rec.in_hou_adj;
                v_pla.clm_stat_cd     := rec.clm_stat_cd;
                v_pla.clm_stat_desc   := get_clm_stat_desc(rec.clm_stat_cd);   
                v_pla.loss_cat_cd     := rec.loss_cat_cd;
                
                SELECT loss_cat_des
                  INTO v_pla.loss_cat_desc
                  FROM giis_loss_ctgry
                 WHERE line_cd = v_pla.line_cd
                   AND loss_cat_cd = v_pla.loss_cat_cd;
        
                PIPE ROW(v_pla);
            END LOOP;
        
        END IF;
        
    END get_pla_listing;
    
    -- retieves tg for FLA
    FUNCTION get_fla_listing(
        p_all_user_sw       GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         giac_user_functions.valid_tag%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_line_cd           giis_line.line_cd%TYPE
    ) RETURN claim_info_tab PIPELINED
    IS
        v_pla       claim_info_type;
    BEGIN
    
        FOR rec IN (SELECT CLAIM_ID, LINE_CD, SUBLINE_CD, ISS_CD, CLM_YY, CLM_SEQ_NO, 
                           POL_ISS_CD, ISSUE_YY, POL_SEQ_NO, RENEW_NO, 
                           ASSURED_NAME, LOSS_DATE, CLM_STAT_CD, /*USER_ID,*/ IN_HOU_ADJ , A.LOSS_CAT_CD
                      FROM GICL_CLAIMS A 
                     WHERE A.CLM_STAT_CD NOT IN ('CC', 'WD', 'DN') 
                       AND EXISTS (SELECT '1' 
                                     FROM GICL_ADVICE B, GICL_CLM_LOSS_EXP D, GICL_LOSS_EXP_DS E 
                                    WHERE B.CLAIM_ID = A.CLAIM_ID 
                                      AND B.CLAIM_ID = D.CLAIM_ID 
                                      AND B.ADVICE_ID = D.ADVICE_ID 
                                      AND E.CLAIM_ID = D.CLAIM_ID 
                                      AND E.CLM_LOSS_ID = D.CLM_LOSS_ID 
                                      AND E.SHARE_TYPE IN ('2','3') 
                                      AND B.ADVICE_FLAG = 'Y' 
                                      AND NOT EXISTS( SELECT '1' 
                                                        FROM GICL_ADVS_FLA C 
                                                       WHERE C.CLAIM_ID = B.CLAIM_ID 
                                                         AND C.ADV_FLA_ID = B.ADV_FLA_ID 
                                                         AND NVL(C.CANCEL_TAG,'N') = 'N') ) 
                       AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS051', p_user_id) = 1 /*--line added by jay 06/04/2012*/
                       AND line_cd = p_line_cd
                     ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
        LOOP
            
            v_pla.claim_id        := rec.CLAIM_ID;
            v_pla.line_cd         := rec.line_cd;
            v_pla.subline_cd      := rec.subline_cd;
            v_pla.iss_cd          := rec.iss_cd;
            v_pla.clm_yy          := rec.clm_yy;
            v_pla.clm_seq_no      := rec.clm_seq_no;
            v_pla.pol_iss_cd      := rec.pol_iss_cd;
            v_pla.issue_yy        := rec.issue_yy;
            v_pla.pol_seq_no      := rec.pol_seq_no;
            v_pla.renew_no        := rec.renew_no;
            v_pla.assured_name    := rec.assured_name;
            v_pla.loss_Date       := TO_CHAR(rec.loss_Date, 'MM-DD-YYYY');
            v_pla.in_hou_adj      := rec.in_hou_adj;
            v_pla.clm_stat_cd     := rec.clm_stat_cd;
            v_pla.clm_stat_desc   := get_clm_stat_desc(rec.clm_stat_cd);   
            v_pla.loss_cat_cd     := rec.loss_cat_cd;
                
            SELECT loss_cat_des
              INTO v_pla.loss_cat_desc
              FROM giis_loss_ctgry
             WHERE line_cd = v_pla.line_cd
               AND loss_cat_cd = v_pla.loss_cat_cd;
        
            PIPE ROW(v_pla);
        END LOOP;
        
    END get_fla_listing;
    
END GICLS051_PKG;
/



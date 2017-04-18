CREATE OR REPLACE PACKAGE BODY CPI.GICLS050_PKG
AS

    -- Counts the number of PLA records available for printing by the user.
    PROCEDURE query_count_pla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_pla_cnt           OUT NUMBER,
        p_pla_cnt_all       OUT NUMBER
    ) IS
        v_pla_cnt       NUMBER := 0;
        v_pla_cnt_all   NUMBER := 0;
    BEGIN
    
        FOR cnt IN (SELECT a.user_id usr
                      FROM gicl_advs_pla a, gicl_claims b
                     WHERE a.claim_id = b.claim_id 
                    --AND b.clm_stat_cd NOT IN ('CC','WD','DN') --removed by Pia, 09.23.02
                       AND a.claim_id IN (SELECT c.claim_id
                                            FROM gicl_clm_res_hist c, gicl_reserve_rids d
                                           WHERE c.dist_sw         = 'Y'
                                             AND c.claim_id        = d.claim_id
                                             AND c.clm_res_hist_id = d.clm_res_hist_id
                                             AND a.pla_id          = d.pla_id)
                    --AND a.share_type IN ('2','3')
                      AND nvl(a.print_sw,'N')   = 'N'
                      AND nvl(a.cancel_tag,'N') = 'N'
                      AND a.claim_id IN (SELECT d.claim_id
                                           FROM gicl_item_peril d
                                          WHERE nvl(d.close_flag, 'AP') IN ('AP', 'CP', 'CC'))
                      AND b.in_hou_adj = p_user_id
                      AND b.line_cd    = p_line_cd)
        LOOP
            v_pla_cnt := 1;
        END LOOP;
              
        IF p_all_user_sw = 'Y' OR p_valid_tag = 'Y' THEN
  	        
            FOR cnt IN (SELECT a.user_id usr
                          FROM gicl_advs_pla a, gicl_claims b
                         WHERE a.claim_id = b.claim_id 
                           AND a.claim_id IN (SELECT c.claim_id
                                                FROM gicl_clm_res_hist c, gicl_reserve_rids d
                                               WHERE c.dist_sw         = 'Y'
                                                 AND c.claim_id        = d.claim_id
                                                 AND c.clm_res_hist_id = d.clm_res_hist_id
                                                 AND a.pla_id          = d.pla_id)
                           --AND a.share_type in ('2','3')
                           AND nvl(a.print_sw,'N')   = 'N'
                           AND nvl(a.cancel_tag,'N') = 'N'
                           AND a.claim_id IN (SELECT d.claim_id
                                                FROM gicl_item_peril d
                                               WHERE nvl(d.close_flag, 'AP') IN ('AP', 'CP', 'CC'))
                           AND b.in_hou_adj != p_user_id
                           AND b.line_cd     = p_line_cd)
            LOOP
                v_pla_cnt_all := 1;
            END LOOP;
        END IF;
        
        p_pla_cnt       := v_pla_cnt;
        p_pla_cnt_all   := v_pla_cnt_all;
    
    END query_count_pla;
    
    -- Counts the number of FLA records available for printing by the user.
    PROCEDURE query_count_fla(
        p_all_user_sw       IN  GIIS_USERS.ALL_USER_SW%TYPE,
        p_valid_tag         IN  giac_user_functions.valid_tag%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_line_cd           IN  giis_line.line_Cd%TYPE,
        p_fla_cnt           OUT NUMBER,
        p_fla_cnt_all       OUT NUMBER
    ) IS
        v_fla_cnt       NUMBER := 0;
        v_fla_cnt_all   NUMBER := 0;
    BEGIN
    
        FOR cnt IN (SELECT a.user_id
                      FROM gicl_advs_fla a, gicl_advice b, gicl_claims c
                     WHERE a.claim_id = b.claim_id
                       AND a.adv_fla_id = b.adv_fla_id
                       AND a.claim_id = c.claim_id
                       AND c.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                       AND b.advice_flag != 'N'
                       AND a.print_sw = 'N'
                       AND nvl(a.cancel_tag,'N') = 'N'
                       AND c.in_hou_adj = p_user_id
                       AND a.line_cd    = p_line_cd)
        LOOP
            v_fla_cnt := 1;
            EXIT;
        END LOOP;        
        
        IF p_all_user_sw = 'Y'OR p_valid_tag = 'Y' THEN
            FOR cnt2 IN (SELECT a.user_id
                           FROM gicl_advs_fla a, gicl_advice b, gicl_claims c
                          WHERE a.claim_id = b.claim_id
                            AND a.adv_fla_id = b.adv_fla_id
                            AND a.claim_id = c.claim_id
                            AND c.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
                            AND b.advice_flag != 'N'
                            AND a.print_sw = 'N'
                            AND NVL(a.cancel_tag,'N') = 'N'
                            AND c.in_hou_adj != p_user_id
                                AND a.line_cd     = p_line_cd)
            LOOP
               v_fla_cnt_all := 1;
                EXIT;
            END LOOP;
            
        END IF;
        
        p_fla_cnt       := v_fla_cnt;
        p_fla_cnt_all   := v_fla_cnt_all;
    
    END query_count_fla;
    
    -- gets the list of unprinted PLAs
    FUNCTION get_unprinted_pla_list(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN pla_tab PIPELINED IS
        v_pla           pla_type;
    BEGIN
        -- c016
        FOR c016 IN (SELECT tbl1.* 
                      FROM (SELECT A.CLAIM_ID, A.PLA_ID, A.LINE_CD, A.LA_YY, A.PLA_SEQ_NO, A.RI_CD, 
                                   NVL(A.LOSS_SHR_AMT,0) LOSS_SHR_AMT, 
                                   NVL(A.EXP_SHR_AMT,0) EXP_SHR_AMT, 
                                   A.PLA_TITLE, A.PLA_HEADER, A.PLA_FOOTER, 
                                   A.GRP_SEQ_NO, A.USER_ID, A.LAST_UPDATE, 
                                   A.SHARE_TYPE, A.PRINT_SW, A.CANCEL_TAG, A.PLA_DATE, 
                                   B.LINE_CD LINE_CD2, B.SUBLINE_CD, B.ISS_CD, B.CLM_YY, 
                                   B.CLM_SEQ_NO, B.LINE_CD LINE_CD3, B.SUBLINE_CD SUBLINE_CD2, 
                                   B.POL_ISS_CD, B.ISSUE_YY, B.POL_SEQ_NO, B.RENEW_NO, 
                                   B.ASSURED_NAME, B.IN_HOU_ADJ, B.CLM_STAT_CD, B.LOSS_CAT_CD, 
                                   b.loss_date, B.CATASTROPHIC_CD 
                              FROM GICL_ADVS_PLA A, GICL_CLAIMS B 
                             WHERE A.CLAIM_ID = B.CLAIM_ID 
                               AND A.CLAIM_ID IN (SELECT C.CLAIM_ID 
                                                    FROM GICL_CLM_RES_HIST C, GICL_RESERVE_RIDS D 
                                                   WHERE C.DIST_SW = 'Y' 
                                                     AND C.CLAIM_ID = D.CLAIM_ID 
                                                     AND C.CLM_RES_HIST_ID = D.CLM_RES_HIST_ID 
                                                     AND A.PLA_ID = D.PLA_ID) 
                               AND A.SHARE_TYPE IN ('2','3','4') 
                               AND NVL(A.PRINT_SW,'N') = 'N' 
                               AND NVL(A.CANCEL_TAG,'N') = 'N' 
                               AND A.CLAIM_ID IN (SELECT E.CLAIM_ID 
                                                    FROM GICL_ITEM_PERIL E 
                                                   WHERE NVL(E.CLOSE_FLAG,'AP') IN ('AP', 'CP', 'CC')) 
                               AND b.iss_cd in (decode(check_user_per_iss_cd2(NULL,b.iss_cd,p_module_id, p_user_id),1,b.iss_cd,0,''))/*--added by jay 06/04/2012*/) tbl1                           
                     WHERE line_cd = p_line_cd                       
                       /*AND in_hou_adj = p_user_id*/)
        LOOP
        
            v_pla.pla_id        := c016.pla_id;
            v_pla.claim_id      := c016.claim_id;
            v_pla.line_cd       := c016.line_cd;
            v_pla.LA_YY         := c016.LA_YY;
            v_pla.PLA_SEQ_NO    := c016.PLA_SEQ_NO;
            v_pla.RI_CD         := c016.RI_CD;
            v_pla.LOSS_SHR_AMT  := c016.LOSS_SHR_AMT;
            v_pla.EXP_SHR_AMT   := c016.EXP_SHR_AMT;
            v_pla.PLA_TITLE     := c016.PLA_TITLE;
            v_pla.PLA_HEADER    := c016.PLA_HEADER;
            v_pla.PLA_FOOTER    := c016.PLA_FOOTER;
            v_pla.GRP_SEQ_NO    := c016.GRP_SEQ_NO;
            v_pla.SUBLINE_CD    := c016.SUBLINE_CD;
            v_pla.ISS_CD        := c016.ISS_CD;
            v_pla.CLM_YY        := c016.CLM_YY;
            v_pla.CLM_SEQ_NO    := c016.CLM_SEQ_NO;
            v_pla.POL_ISS_CD    := c016.POL_ISS_CD;
            v_pla.ISSUE_YY      := c016.ISSUE_YY;
            v_pla.POL_SEQ_NO    := c016.POL_SEQ_NO;
            v_pla.RENEW_NO      := c016.RENEW_NO;
            v_pla.ASSURED_NAME  := c016.ASSURED_NAME;
            v_pla.IN_HOU_ADJ    := c016.IN_HOU_ADJ;
            v_pla.CLM_STAT_CD   := c016.CLM_STAT_CD;
            v_pla.share_type    := c016.share_type;
            v_pla.print_sw      := c016.print_sw;
            v_pla.cancel_tag    := c016.cancel_tag;
            v_pla.pla_date      := c016.pla_date;

            FOR ri IN (SELECT ri_sname sname
                         FROM giis_reinsurer
                        WHERE ri_cd = c016.ri_cd)
            LOOP
                v_pla.ri_sname := ri.sname;
            END LOOP; 
            
            FOR pol IN (SELECT incept_date eff, expiry_date	expiry, policy_id
                          FROM gipi_polbasic
                         WHERE line_cd 		= c016.line_cd
                           AND subline_cd 	= c016.subline_cd
                           AND iss_cd		= c016.pol_iss_cd
                           AND issue_yy     = c016.issue_yy
                           AND pol_seq_no 	= c016.pol_seq_no
                           AND renew_no		= c016.renew_no)
            LOOP
                v_pla.policy_id         := pol.policy_id;
            END LOOP; 
            
            FOR res IN (SELECT res_pla_id res_id
                           FROM gicl_advs_pla
                          WHERE pla_id = c016.pla_id)
            LOOP
                v_pla.res_pla_id := res.res_id;
            END LOOP;
            
            v_pla.clm_stat_desc := get_clm_stat_desc(c016.clm_stat_cd);   
            
            -- c016 : claim_id and pla_id
            -- c017
            FOR c017 IN (SELECT b.claim_id, c.pla_id, b.hist_seq_no, b.item_no, b.grouped_item_no, b.peril_cd, 
                                NVL (b.loss_reserve, 0) loss_reserve,
                                NVL (b.expense_reserve, 0) expense_reserve, 
                                b.convert_rate, b.currency_cd
                           FROM gicl_clm_res_hist b, gicl_reserve_rids c
                          WHERE b.dist_sw = 'Y'
                            AND NVL (b.cancel_tag, 'N') = 'N'
                            AND b.claim_id = c.claim_id
                            AND b.clm_res_hist_id = c.clm_res_hist_id
                            AND b.claim_id = c016.claim_id  -- c016 and c017 relation
                            AND c.pla_id = c016.pla_id)  -- c016 and c017 relation
            LOOP
                v_pla.hist_seq_no       := c017.hist_seq_no;
                v_pla.item_no           := c017.item_no;
                v_pla.grouped_item_no   := c017.grouped_item_no;
                v_pla.peril_cd          := c017.peril_cd;
                v_pla.loss_reserve      := c017.loss_reserve;
                v_pla.expense_reserve   := c017.expense_reserve;
                
                FOR p IN (SELECT peril_sname sname
                            FROM giis_peril
                           WHERE line_cd = c016.line_cd
                             AND peril_cd = c017.peril_cd)
                LOOP
                    v_pla.peril_sname := p.sname;
                END LOOP;
                
                FOR p IN (SELECT item_title title
                            FROM gipi_item
                           WHERE policy_id = v_pla.policy_id
                             AND item_no = c017.item_no)
                LOOP
                    v_pla.item_title := p.title;
                END LOOP;
                
                
                -- c016 : claim_id and line_cd and share_type and grp_seq_no
                -- c017 : claim_id and hist_seq_no and item_no and peril_cd and grouped_item_no
                FOR c018 IN (SELECT grp_seq_no, shr_pct
                               FROM GICL_RESERVE_DS
                              WHERE share_type <> 1 
                                AND nvl(negate_tag,'N') = 'N'
                                AND claim_id = c017.claim_id
                                AND hist_seq_no = c017.hist_seq_no
                                AND item_no = c017.item_no
                                AND peril_cd = c017.peril_cd
                                AND grouped_item_no = c017.grouped_item_no
                                AND claim_id = c016.claim_id
                                AND line_Cd = c016.line_cd
                                AND share_type = c016.share_type
                                AND grp_seq_no = c016.grp_seq_no)
                LOOP
                        
                    v_pla.shr_pct := c018.shr_pct;
                    
                    FOR trty IN (SELECT trty_name name
                                   FROM giis_dist_share
                                  WHERE line_cd  = v_pla.line_cd
                                    AND share_cd = c018.grp_seq_no)
                    LOOP
                        v_pla.trty_name := trty.name;
                        EXIT;
                    END LOOP;
                    
                    FOR summ IN (SELECT NVL(SUM(shr_loss_res_amt),0) loss, 
                                        NVL(SUM(shr_exp_res_amt),0) exp
                                   FROM gicl_reserve_ds
                                  WHERE claim_id        = c016.claim_id
                                    AND item_no         = c017.item_no
                                    AND grouped_item_no = c017.grouped_item_no
                                    AND peril_cd        = c017.peril_cd
                                    AND grp_seq_no      = c016.grp_seq_no
                                    AND nvl(negate_tag,'N') = 'N')
                    LOOP
                        v_pla.shr_loss_res_amt := summ.loss;
                        v_pla.shr_exp_res_amt  := summ.exp;
                        EXIT;
                    END LOOP;
                
                END LOOP; -- end loop: c018
                
                EXIT; -- limit query of c017 to first record only.
            END LOOP; -- end loop: c017
            
            PIPE ROW(v_pla);
        END LOOP; -- end loop: c016
    
    END get_unprinted_pla_list;
    
    
    -- gets the list of unprinted FLAs
    FUNCTION get_unprinted_fla_list(
        p_line_cd       giis_line.line_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN fla_tab PIPELINED IS
        v_fla           fla_type;
    BEGIN
    
        FOR c028 IN (SELECT tbl1.*
                       FROM (SELECT DISTINCT A.FLA_ID, A.CLAIM_ID, A.GRP_SEQ_NO, A.RI_CD, 
                                    A.LINE_CD, A.LA_YY, A.FLA_SEQ_NO, A.PRINT_SW, 
                                    A.FLA_HEADER, A.FLA_DATE, A.FLA_FOOTER, A.ADV_FLA_ID, A.CANCEL_TAG, 
                                    NVL(A.PAID_SHR_AMT,0) PAID_SHR_AMT, 
                                    NVL(A.NET_SHR_AMT,0) NET_SHR_AMT, 
                                    NVL(A.ADV_SHR_AMT,0) ADV_SHR_AMT, 
                                    A.USER_ID, A.LAST_UPDATE, A.FLA_TITLE, A.SHARE_TYPE, 
                                    C.LINE_CD LINE_CD2, C.SUBLINE_CD, C.ISS_CD, C.CLM_YY, C.CLM_SEQ_NO, 
                                    C.LINE_CD LINE_CD3, C.SUBLINE_CD SUBLINE_CD2, 
                                    C.POL_ISS_CD, C.ISSUE_YY, C.POL_SEQ_NO, C.RENEW_NO, 
                                    C.ASSURED_NAME, C.IN_HOU_ADJ, C.CLM_STAT_CD, C.LOSS_CAT_CD, 
                                    C.DSP_LOSS_DATE, C.CATASTROPHIC_CD 
                               FROM GICL_ADVS_FLA A, GICL_ADVICE B, GICL_CLAIMS C 
                              WHERE A.CLAIM_ID = B.CLAIM_ID 
                                AND A.ADV_FLA_ID = B.ADV_FLA_ID 
                                AND A.CLAIM_ID = C.CLAIM_ID 
                                AND C.CLM_STAT_CD NOT IN ('CC', 'WD', 'DN') 
                                AND B.ADVICE_FLAG != 'N' 
                                AND A.PRINT_SW = 'N' 
                                AND NVL(A.CANCEL_TAG,'N') = 'N' 
                                AND C.iss_cd in (decode(check_user_per_iss_cd2(NULL,C.iss_cd, p_module_id, p_user_id),1,C.iss_cd,0,''))/*--added by jay 06/04/2012*/
                              ORDER BY line_cd, la_yy, fla_seq_no) tbl1
                      WHERE line_cd = p_line_cd)
        LOOP
        
            v_fla.fla_id                  := c028.fla_id;
            v_fla.claim_id                := c028.claim_id;
            v_fla.grp_seq_no              := c028.grp_seq_no;
            v_fla.ri_cd                   := c028.ri_cd;
            v_fla.line_cd                 := c028.line_cd;
            v_fla.la_yy                   := c028.la_yy;
            v_fla.fla_seq_no              := c028.fla_seq_no;
            v_fla.fla_date                := c028.fla_date;
            v_fla.paid_shr_amt            := c028.paid_shr_amt;
            v_fla.net_shr_amt             := c028.net_shr_amt;
            v_fla.adv_shr_amt             := c028.adv_shr_amt;
            v_fla.fla_title               := c028.fla_title;
            v_fla.fla_header              := c028.fla_header;
            v_fla.fla_footer              := c028.fla_footer;
            v_fla.adv_fla_id              := c028.adv_fla_id;
            v_fla.print_sw                := c028.print_sw;
            v_fla.cancel_tag              := c028.cancel_tag;
        
            v_fla.subline_cd        := c028.subline_cd;
            v_fla.iss_cd            := c028.iss_cd;
            v_fla.clm_yy            := c028.clm_yy;
            v_fla.clm_seq_no        := c028.clm_seq_no;
            v_fla.pol_iss_cd        := c028.pol_iss_cd;
            v_fla.issue_yy          := c028.issue_yy;
            v_fla.pol_seq_no        := c028.pol_seq_no;
            v_fla.renew_no          := c028.renew_no;
            v_fla.assured_name      := c028.assured_name;
            v_fla.in_hou_adj        := c028.in_hou_adj;
            v_fla.CLM_STAT_CD       := c028.CLM_STAT_CD;
            v_fla.share_type        := c028.share_type;
        
            FOR ri IN (SELECT ri_sname sname
                         FROM giis_reinsurer
                        WHERE ri_cd = c028.ri_cd)
            LOOP
                v_fla.ri_sname := ri.sname;
            END LOOP; 
            
            v_fla.clm_stat_desc := get_clm_stat_desc(c028.clm_stat_cd);
            
            
            -- c028 : claim_id and adv_fla_id
            -- c015
            FOR c015 IN (SELECT line_cd, iss_cd, advice_year, advice_seq_no,
                                net_amt, paid_amt, advise_amt, advice_id, claim_id
                           FROM gicl_advice
                          WHERE claim_id = c028.claim_id
                            AND adv_fla_id = c028.adv_fla_id)
            LOOP
                v_fla.adv_line_cd              := c015.line_cd;
                v_fla.adv_iss_cd               := c015.iss_cd;
                v_fla.adv_advice_year          := c015.advice_year;
                v_fla.adv_advice_seq_no        := c015.advice_seq_no;
                v_fla.net_amt                  := c015.net_amt;
                v_fla.paid_amt                 := c015.paid_amt;
                v_fla.advise_amt               := c015.advise_amt;
                v_fla.advice_id                := c015.advice_id;
                v_fla.claim_id                 := c015.claim_id;
                
                
                -- c015 : claim_id and advice_id
                -- c028 : claim_id and share_type and grp_seq_no
                FOR c029 IN (SELECT A.CLAIM_ID, A.ADVICE_ID, B.SHARE_TYPE, B.GRP_SEQ_NO, 
                                    SUM(B.SHR_LE_PD_AMT) PAID_AMT, 
                                    SUM(B.SHR_LE_NET_AMT) NET_AMT, 
                                    SUM(B.SHR_LE_ADV_AMT) ADV_AMT 
                               FROM GICL_CLM_LOSS_EXP A, GICL_LOSS_EXP_DS B 
                              WHERE A.CLAIM_ID = B.CLAIM_ID 
                                AND A.CLM_LOSS_ID = B.CLM_LOSS_ID 
                                AND a.claim_id = c015.claim_id
                                AND a.advice_id = c015.advice_id
                                AND a.claim_id = c028.claim_id
                                AND b.share_type = c028.share_type
                                AND b.grp_seq_no = c028.grp_seq_no
                              GROUP BY A.CLAIM_ID, A.ADVICE_ID, B.SHARE_TYPE, B.GRP_SEQ_NO)
                LOOP
                    v_fla.shr_paid_amt            := c029.paid_amt;
                    v_fla.shr_net_amt             := c029.net_amt;
                    v_fla.shr_advise_amt          := c029.adv_amt;
        
                    FOR x IN (SELECT trty_name
                                FROM giis_dist_share
                               WHERE line_cd = c028.line_cd
                                 AND share_cd = c029.grp_seq_no)
                    LOOP
                        v_fla.trty_name := x.trty_name;
                    END LOOP;
                
                END LOOP;  -- end loop: c029
            
                EXIT;
            END LOOP; -- end loop: c015
            
            PIPE ROW(v_fla);
        END LOOP;  -- end loop: c028
    
    END get_unprinted_fla_list;
    
    
END GICLS050_PKG;
/



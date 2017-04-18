CREATE OR REPLACE PACKAGE BODY CPI.GICLR057C_PKG
AS

   FUNCTION get_giclr057c(
        p_line_cd           VARCHAR2,
        p_catastrophic_cd   VARCHAR2,
        p_loss_cat_cd       VARCHAR2,
        p_iss_cd            VARCHAR2,
        p_location          VARCHAR2,
        p_block_no          VARCHAR2,
        p_district_no       VARCHAR2,
        p_city_cd           VARCHAR2,
        p_province_cd       VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
   )
   RETURN giclr057c_tab PIPELINED
   IS
   v_list giclr057c_type;
   BEGIN
    FOR i IN (
                SELECT   b.catastrophic_cd, b.claim_id, b.line_cd, b.loss_cat_cd,
                    b.line_cd
                 || '-'
                 || b.subline_cd
                 || '-'
                 || b.iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (b.clm_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.clm_seq_no, '0000009')) claim_number,
                    b.line_cd
                 || '-'
                 || b.subline_cd
                 || '-'
                 || b.pol_iss_cd
                 || '-'
                 || LTRIM (TO_CHAR (b.issue_yy, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                 || '-'
                 || LTRIM (TO_CHAR (b.renew_no, '09')) policy_number,
                 b.assured_name, TO_CHAR (b.loss_date, 'MM-DD-YYYY') ldate,
                 b.in_hou_adj, b.clm_stat_cd,
                 b.loss_loc1 || ' ' || b.loss_loc2 || ' ' || b.loss_loc3 LOCATION
            FROM gicl_claims b
           WHERE b.clm_stat_cd NOT IN
                    ('CC', 'WD', 'DN')
             AND (   b.catastrophic_cd = p_catastrophic_cd
                  OR b.line_cd = p_line_cd
                  OR iss_cd = p_iss_cd
                  OR UPPER (NVL (b.loss_loc1 || b.loss_loc2 || b.loss_loc3, '@#$')) LIKE'%' || NVL (p_location, '$#@') || '%'
                  OR (TRUNC(b.loss_date)  >= TO_DATE(p_from_date, 'MM-DD-YYYY') 
                                  AND TRUNC(b.loss_date) <= TO_DATE(p_to_date, 'MM-DD-YYYY'))
                  OR loss_cat_cd = p_loss_cat_cd
                  OR EXISTS (
                        SELECT a.claim_id
                          FROM gicl_fire_dtl a
                         WHERE b.claim_id = a.claim_id
                           AND a.block_id IN (
                                  SELECT c.block_id
                                    FROM giis_block c
                                   WHERE c.province_cd = p_province_cd
                                     AND c.city_cd = p_city_cd
                                     AND c.district_no = p_district_no
                                     AND c.block_no = p_block_no))
                 )
                 AND check_user_per_iss_cd2 (b.line_cd, NULL, 'GICLS057', USER) =1
                 AND check_user_per_iss_cd2 (NULL, b.iss_cd, 'GICLS057', USER) = 1
                 AND check_user_per_iss_cd (b.line_cd, b.iss_cd, 'GICLS057') = 1
        ORDER BY b.line_cd, b.subline_cd, b.iss_cd, b.clm_yy, b.clm_seq_no
            )
            LOOP
                v_list.catastrophic_desc  :=      '';
                v_list.loss_cat           :=      '';
                v_list.clm_stat           :=      '';
                v_list.claim_id           :=      i.claim_id;       
                v_list.catastrophic_cd    :=      i.catastrophic_cd;
                v_list.claim_no           :=      i.claim_number;       
                v_list.line_cd            :=      i.line_cd;        
                v_list.loss_cat_cd        :=      i.loss_cat_cd;    
                v_list.policy_no          :=      i.policy_number;
                v_list.assured_name       :=      i.assured_name;   
                v_list.ldate              :=      i.ldate;          
                v_list.in_hou_adj         :=      i.in_hou_adj;     
                v_list.clm_stat_cd        :=      i.clm_stat_cd;
                v_list.location           :=      i.location; 
                
                FOR losscat IN (
                    SELECT c.line_cd||'-'||c.LOSS_CAT_DES loss_cat  
                      FROM giis_loss_ctgry c
                     WHERE line_cd = i.line_cd 
                       AND loss_cat_cd = i.loss_cat_cd               
                )
                LOOP
                    v_list.loss_cat := losscat.loss_cat;
                END LOOP;
                
                FOR catevent IN (
                    SELECT LTRIM(TO_CHAR(a.catastrophic_cd,'09999'))||'-'||a.catastrophic_desc cat     
                      FROM gicl_cat_dtl a
                     WHERE a.catastrophic_cd =  i.catastrophic_cd             
                )
                LOOP
                    v_list.catastrophic_desc := catevent.cat;
                END LOOP;
                
                FOR clmstat IN (
                    SELECT clm_stat_desc
                       FROM giis_clm_stat 
                      WHERE clm_stat_Cd = i.clm_stat_cd             
                )
                LOOP
                    v_list.clm_stat := clmstat.clm_stat_desc;
                END LOOP;
                
                FOR res IN (
                    SELECT sum(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) loss_exp
                    FROM gicl_clm_res_hist a, gicl_reserve_ds b
                   WHERE a.claim_id = b.claim_id
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b.peril_cd
                     AND a.clm_res_hist_id = b.clm_res_hist_id
                     AND NVL(a.dist_sw,'N') = 'Y'
                     AND NVL(b.negate_tag,'N') = 'N'
                     AND a.tran_id IS NULL
                     AND a.claim_id = i.claim_id            
                )
                LOOP
                    v_list.res_amt := res.loss_exp;
                END LOOP;
                
                
                FOR pd IN (
                    SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                      FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                     WHERE a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND NVL(b.negate_tag,'N') = 'N'
                       AND a.tran_id IS NOT NULL
                       AND a.claim_id = i.claim_id            
                )
                LOOP
                    v_list.pd_amt := pd.le_pd;
                END LOOP;
                
                v_list.net_res_amt      := 0;
                v_list.net_pd_amt       := 0;
                v_list.facul_res_amt    := 0;
                v_list.facul_pd_amt     := 0;
                v_list.pts_res_amt      := 0;
                v_list.pts_pd_amt       := 0;
                v_list.npts_res_amt     := 0;
                v_list.npts_pd_amt      := 0;
                
                IF i.line_cd = 'FI'
                THEN
                   FOR j IN (SELECT province_cd, province, city_cd, city,
                                    district_no, district_desc, block_no,
                                    block_desc
                               FROM giis_block
                              WHERE block_id IN (SELECT block_id
                                                   FROM gicl_fire_dtl
                                                  WHERE claim_id = i.claim_id)
                                 OR province_cd = p_province_cd
                                 OR city_cd = p_city_cd
                                 OR district_no = p_district_no
                                 OR block_no = p_block_no)
                   LOOP
                      v_list.province_cd := j.province_cd;
                      v_list.province := j.province;
                      v_list.city_cd := j.city_cd;
                      v_list.city := j.city;
                      v_list.district_no := j.district_no;
                      v_list.district_desc := j.district_desc;
                      v_list.block_no := j.block_no;
                      v_list.block_desc := j.block_desc;
                   END LOOP;
                ELSE
                   v_list.province_cd := '';
                   v_list.province := '';
                   v_list.city_cd := '';
                   v_list.city := '';
                   v_list.district_no := '';
                   v_list.district_desc := '';
                   v_list.block_no := '';
                   v_list.block_desc := '';
                END IF;
                
                IF v_list.district_no IS NULL OR v_list.block_no IS NULL
                THEN
                   FOR amt IN (SELECT SUM (NVL (  b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                                     +SUM (NVL (  b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                                        b.share_type
                                   FROM gicl_clm_res_hist a,
                                        gicl_reserve_ds b,
                                        gicl_item_peril c
                                  WHERE a.claim_id = b.claim_id
                                    AND a.item_no = b.item_no
                                    AND a.peril_cd = b.peril_cd
                                    AND a.clm_res_hist_id = b.clm_res_hist_id
                                    AND NVL (a.dist_sw, 'N') = 'Y'
                                    AND NVL (b.negate_tag, 'N') = 'N'
                                    AND a.tran_id IS NULL
                                    AND a.claim_id = i.claim_id
                                    AND a.claim_id = c.claim_id
                                    AND a.item_no = c.item_no
                                    AND a.peril_cd = c.peril_cd
                                    AND a.grouped_item_no = c.grouped_item_no
                                    AND NVL (c.close_flag, 'AP') IN
                                                               ('AP', 'CC', 'CP')
                               GROUP BY b.share_type)
                   LOOP
                      IF amt.share_type = 1
                      THEN
                         v_list.net_res_amt := v_list.net_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      THEN
                         v_list.facul_res_amt := v_list.facul_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                      THEN
                         v_list.pts_res_amt := v_list.pts_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                      THEN
                         v_list.npts_res_amt := v_list.npts_res_amt + (amt.loss_res + amt.exp_res);
                      END IF;
                   END LOOP;
                ELSE
                   FOR amt IN (SELECT SUM (NVL (  b.shr_loss_res_amt * a.convert_rate,0)) loss_res,
                                     +SUM (NVL (  b.shr_exp_res_amt * a.convert_rate,0)) exp_res,
                                        b.share_type
                                   FROM gicl_clm_res_hist a,
                                        gicl_reserve_ds b,
                                        gicl_fire_dtl c,
                                        gicl_item_peril d
                                  WHERE a.claim_id = b.claim_id
                                    AND c.claim_id = a.claim_id
                                    AND a.item_no = b.item_no
                                    AND a.item_no = a.item_no
                                    AND a.peril_cd = b.peril_cd
                                    AND a.clm_res_hist_id = b.clm_res_hist_id
                                    AND c.district_no =
                                           NVL (v_list.district_no, c.district_no)
                                    AND c.block_no =
                                                 NVL (v_list.block_no, c.block_no)
                                    AND b.share_type = 1
                                    AND NVL (a.dist_sw, 'N') = 'Y'
                                    AND NVL (b.negate_tag, 'N') = 'N'
                                    AND a.tran_id IS NULL
                                    AND a.claim_id = i.claim_id
                                    AND a.claim_id = d.claim_id
                                    AND a.item_no = d.item_no
                                    AND a.peril_cd = d.peril_cd
                                    AND a.grouped_item_no = d.grouped_item_no
                                    AND NVL (d.close_flag, 'AP') IN
                                                               ('AP', 'CC', 'CP')
                               GROUP BY b.share_type)
                   LOOP
                      IF amt.share_type = 1
                      THEN
                         v_list.net_res_amt := v_list.net_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                      THEN
                         v_list.facul_res_amt := v_list.facul_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                      THEN
                         v_list.pts_res_amt := v_list.pts_res_amt + (amt.loss_res + amt.exp_res);
                      ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                      THEN
                         v_list.npts_res_amt :=
                            v_list.npts_res_amt
                            + (amt.loss_res + amt.exp_res);
                      END IF;
                   END LOOP;
                END IF;
               
                FOR amt IN (SELECT   SUM (NVL (b.shr_le_pd_amt * a.currency_rate,0)) le_pd,
                                     a.payee_type, b.share_type
                                FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                               WHERE a.claim_id = b.claim_id
                                 AND a.clm_loss_id = b.clm_loss_id
                                 AND NVL (b.negate_tag, 'N') = 'N'
                                 AND a.tran_id IS NOT NULL
                                 AND a.claim_id = i.claim_id
                            GROUP BY a.payee_type, b.share_type)
                LOOP
                   IF amt.share_type = 1
                   THEN
                      v_list.net_pd_amt := v_list.net_pd_amt + amt.le_pd;
                   ELSIF amt.share_type = giacp.v ('FACUL_SHARE_TYPE')
                   THEN
                      v_list.facul_pd_amt := v_list.facul_pd_amt + amt.le_pd;
                   ELSIF amt.share_type = giacp.v ('TRTY_SHARE_TYPE')
                   THEN
                      v_list.pts_pd_amt := v_list.pts_pd_amt + amt.le_pd;
                   ELSIF amt.share_type = giacp.v ('XOL_TRTY_SHARE_TYPE')
                   THEN
                      v_list.npts_pd_amt := v_list.npts_pd_amt + amt.le_pd;
                   END IF;
                END LOOP;
                
                FOR paramcat IN (
                        SELECT LTRIM(TO_CHAR(a.catastrophic_cd,'09999'))||'-'||a.catastrophic_desc cat     
                          FROM gicl_cat_dtl a
                         WHERE a.catastrophic_cd =  p_catastrophic_cd        
                        )
                LOOP
                    v_list.param_cat := paramcat.cat;
                END LOOP;
                
                FOR paramlosscat IN (
                        SELECT c.line_cd||'-'||c.LOSS_CAT_DES loss_cat  
                          FROM giis_loss_ctgry c
                         WHERE line_cd = i.line_cd 
                           AND loss_cat_cd = p_loss_cat_cd        
                        )
                LOOP
                    v_list.param_loss_cat := paramlosscat.loss_cat;
                END LOOP;
                
                FOR paramiss IN (
                        SELECT iss_cd||'-'||iss_name iss
                          FROM giis_issource
                         WHERE iss_cd = p_iss_cd        
                        )
                LOOP
                    v_list.param_iss := paramiss.iss;
                END LOOP;
                
                PIPE ROW(v_list);
            END LOOP;
   
    RETURN;
   END;
   
END;
/



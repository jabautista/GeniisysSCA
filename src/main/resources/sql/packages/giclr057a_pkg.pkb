CREATE OR REPLACE PACKAGE BODY CPI.GICLR057A_PKG
AS

   FUNCTION get_giclr057a(
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
   RETURN giclr057a_tab PIPELINED
   IS
   v_list giclr057a_type;
   BEGIN
    FOR i IN (
        SELECT a.claim_id, a.catastrophic_cd,
                  a.line_cd
               || '-'
               || a.subline_cd
               || '-'
               || a.iss_cd
               || '-'
               || LTRIM (TO_CHAR (a.clm_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')) claim_number,
               a.line_cd, a.loss_cat_cd,
                  a.line_cd
               || '-'
               || a.subline_cd
               || '-'
               || a.pol_iss_cd
               || '-'
               || LTRIM (TO_CHAR (a.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
               || '-'
               || LTRIM (TO_CHAR (a.renew_no, '09')) policy_number,
               a.assured_name, TO_CHAR (a.loss_date, 'MM-DD-RR') ldate, a.in_hou_adj,
               a.clm_stat_cd,
               a.loss_loc1 || ' ' || a.loss_loc2 || ' ' || a.loss_loc3 LOCATION,a.iss_cd
          FROM gicl_claims a
         WHERE NVL(a.catastrophic_cd, 0) = NVL(p_catastrophic_cd, NVL(a.catastrophic_cd, 0))
           AND a.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
           AND a.line_cd = 'FI'
           AND a.iss_cd = NVL(p_iss_cd, iss_cd)
           AND check_user_per_iss_cd2 (NULL, a.iss_cd, 'GICLS057', USER) = 1  
           AND check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS057', USER) = 1 
           AND a.loss_cat_cd = NVL(p_loss_cat_cd, a.loss_cat_cd)
           AND a.clm_stat_cd NOT IN ('WD', 'DN', 'CC')                    
           AND TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_from_date, 'MM-DD-YYYY'), TRUNC(a.loss_date))
           AND NVL(TO_DATE(p_to_date, 'MM-DD-YYYY'), TRUNC(a.loss_date))
           AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3, '@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2 ||a.loss_loc3, '@#$')))||'%'
           AND EXISTS (
                  SELECT b.claim_id
                    FROM gicl_fire_dtl b
                   WHERE b.claim_id = a.claim_id
                     AND b.block_id IN (SELECT c.block_id
                                          FROM giis_block c
                                         WHERE c.block_id = b.block_id
                                          AND c.province_cd = NVL(p_province_cd, c.province_cd)
                                          AND c.city_cd = NVL(p_city_cd, c.city_cd)
                                          AND c.district_no = NVL(p_district_no, c.district_no)
                                          AND c.block_no = NVL(p_block_no, c.block_no)
                         ))
            )
            LOOP
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
                      FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                     WHERE a.claim_id = b.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b.peril_cd
                       AND a.clm_res_hist_id = b.clm_res_hist_id
                       AND NVL(a.dist_sw,'N') = 'Y'
                       AND NVL(b.negate_tag,'N') = 'N'
                       AND a.tran_id IS NULL
                       AND a.claim_id = i.claim_id
                       AND a.claim_id = c.claim_id
                       AND a.ITEM_NO = c.item_no            
                )
                LOOP
                    v_list.res_amt := res.loss_exp;
                END LOOP;
                
                
                FOR pd IN (
                    SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                      FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                     WHERE a.claim_id = b.claim_id
                       AND a.clm_loss_id = b.clm_loss_id
                       AND NVL(b.negate_tag,'N') = 'N'
                       AND a.tran_id IS NOT NULL
                       AND a.claim_id = i.claim_id
                       AND a.item_no = b.item_no
                       AND a.peril_cd = b. peril_cd
                       AND a.item_no = c.item_no
                       AND a.claim_id = c.claim_id            
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
                
                
                FOR netres IN (
                        SELECT NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0) loss_exp
                        FROM gicl_clm_res_hist a, gicl_reserve_ds b,gicl_fire_dtl c
                       WHERE a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.share_type = 1
                         AND NVL(a.dist_sw,'N') = 'Y'
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NULL
                         AND a.claim_id = i.claim_id
                         AND a.claim_id = c.claim_id
                         AND a.ITEM_NO = c.item_no           
                )
                LOOP
                    v_list.net_res_amt := NVL(netres.loss_exp,0);
                END LOOP;
                
                FOR netpd IN (
                        SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND b.share_type = 1
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                           AND a.claim_id = i.claim_id	
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b. peril_cd
                           AND a.item_no = c.item_no
                           AND a.claim_id = c.claim_id         
                )
                LOOP
                    v_list.net_pd_amt := NVL(netpd.le_pd,0);
                END LOOP;
                
                FOR faculres IN (
                        SELECT NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0) loss_exp
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND b.share_type = 3
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id
                           AND a.claim_id = c.claim_id
                           AND a.ITEM_NO = c.item_no          
                )
                LOOP
                    v_list.facul_res_amt := NVL(faculres.loss_exp,0);
                END LOOP;
                
                FOR faculpd IN (
                  SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
	                FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                   WHERE a.claim_id = b.claim_id
                     AND a.clm_loss_id = b.clm_loss_id
                     AND b.share_type = 3
    		         AND NVL(b.negate_tag,'N') = 'N'
    		         AND a.tran_id IS NOT NULL
    		         AND a.claim_id = i.claim_id	
                     AND a.item_no = b.item_no
                     AND a.peril_cd = b. peril_cd
                     AND a.item_no = c.item_no
                     AND a.claim_id = c.claim_id         
                        )
                LOOP
                    v_list.facul_pd_amt := NVL(faculpd.le_pd,0);
                END LOOP;
                
                FOR ptsres IN (
                        SELECT NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0) loss_exp
                         FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                        WHERE a.claim_id = b.claim_id
                          AND a.item_no = b.item_no
                          AND a.peril_cd = b.peril_cd
                          AND a.clm_res_hist_id = b.clm_res_hist_id
                          AND b.share_type = 2
                          AND NVL(a.dist_sw,'N') = 'Y'
                          AND NVL(b.negate_tag,'N') = 'N'
                          AND a.tran_id IS NULL
                          AND a.claim_id = i.claim_id
                          AND a.claim_id = c.claim_id
                          AND a.ITEM_NO = c.item_no         
                )
                LOOP
                    v_list.pts_res_amt := NVL(ptsres.loss_exp,0);
                END LOOP;
                
                FOR ptspd IN (
                        SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
	                      FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND b.share_type = 2
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                           AND a.claim_id = i.claim_id	
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b. peril_cd
                           AND a.item_no = c.item_no
                           AND a.claim_id = c.claim_id         
                        )
                LOOP
                    v_list.pts_pd_amt := NVL(ptspd.le_pd,0);
                END LOOP;
                
                FOR nptsres IN (
                        SELECT sum(NVL(b.shr_loss_res_amt,0)) + sum(NVL(b.shr_exp_res_amt,0)) loss_exp
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b
					     WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id					  
                           AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')        
                )
                LOOP
                    v_list.npts_res_amt := NVL(nptsres.loss_exp,0);
                END LOOP;
                
                FOR nptspd IN (
                        SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd                 
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                             AND a.claim_id = i.claim_id         
                        )
                LOOP
                    v_list.npts_pd_amt := NVL(nptspd.le_pd,0);
                END LOOP;
                
                FOR paramcat IN (
                        SELECT LTRIM(TO_CHAR(a.catastrophic_cd,'09999'))||'-'||a.catastrophic_desc cat 	
                          FROM gicl_cat_dtl a
                         WHERE a.catastrophic_cd =  p_catastrophic_cd        
                        )
                LOOP
                    v_list.param_cat := paramcat.cat;
                END LOOP;
                
                FOR nptspd IN (
                        SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd                 
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                             AND a.claim_id = i.claim_id         
                        )
                LOOP
                    v_list.npts_pd_amt := NVL(nptspd.le_pd,0);
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
                
                FOR paramblock IN (
                          SELECT block_desc
                            FROM giis_block
                           WHERE district_no = p_district_no
                             AND block_no = p_block_no        
                        )
                LOOP
                    v_list.param_block := paramblock.block_desc;
                END LOOP;
                
                FOR paramdist IN (
                          SELECT district_desc
                            FROM giis_block
                           WHERE district_no = p_district_no        
                        )
                LOOP
                    v_list.param_district := paramdist.district_desc;
                END LOOP;
                
                FOR paramcity IN (
                           SELECT city
                             FROM giis_city
                            WHERE province_cd = p_province_cd
                              AND city_cd = p_city_cd        
                        )
                LOOP
                    v_list.param_city := paramcity.city;
                END LOOP;
                
                FOR paramprov IN (
                           SELECT province_desc
                             FROM giis_province
                            WHERE province_cd = p_province_cd        
                        )
                LOOP
                    v_list.param_province := paramprov.province_desc;
                END LOOP;
                
                PIPE ROW(v_list);
            END LOOP;
   
    RETURN;
   END;
   
   FUNCTION get_giclr057_header
       RETURN giclr057_header_tab PIPELINED
   IS
       v_list giclr057_header_type;
   BEGIN
       select param_value_v INTO v_list.company_name FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_NAME';
       select param_value_v INTO v_list.company_address FROM GIIS_PARAMETERS WHERE PARAM_NAME='COMPANY_ADDRESS';
       
       PIPE ROW(v_list);
       RETURN;
   END get_giclr057_header;

END;
/



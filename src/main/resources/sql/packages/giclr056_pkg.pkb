CREATE OR REPLACE PACKAGE BODY CPI.giclr056_pkg
AS
   FUNCTION get_giclr056 (p_cat_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr056_main_tab PIPELINED
   IS
      v_list   giclr056_main_type;
   BEGIN
      FOR i IN (SELECT a.catastrophic_cd, a.catastrophic_desc,
                       a.loss_cat_cd,  
                       a.start_date, a.end_date,
                       a.location, a.district_no, a.block_no,
                       a.city_cd, a.province_cd, a.line_cd
                  FROM gicl_cat_dtl a, gicl_claims b
                 WHERE a.catastrophic_cd = p_cat_cd
                   AND a.catastrophic_cd = b.catastrophic_cd
                   AND b.line_cd = DECODE (check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS056', p_user_id), 1, b.line_cd, 0, '')
--                   AND a.line_cd = DECODE (check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS056', p_user_id), 1, a.line_cd, 0, '')
                   AND b.clm_stat_cd NOT IN ('WD', 'DN', 'CC')
                   AND ROWNUM = 1)
      LOOP
         v_list.cat_cd := i.catastrophic_cd;
         v_list.cat := LTRIM (TO_CHAR (i.catastrophic_cd, '09999')) || '-' || i.catastrophic_desc;
         v_list.location := i.location;
         v_list.loss_date := 'Loss Date from ' || TO_CHAR(i.start_date, 'MM-DD-YYYY') || ' to ' || TO_CHAR(i.end_date, 'MM-DD-YYYY');
         v_list.line_cd := i.line_cd;
         
         IF i.start_date IS NULL OR i.end_date IS NULL THEN
            v_list.loss_date := NULL;
         END IF;
         
         BEGIN
            SELECT line_cd || '-' || loss_cat_des
              INTO v_list.loss_cat
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd 
               AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.loss_cat := NULL;      
         END;
         
         IF i.line_cd = 'FI' THEN
            BEGIN
               SELECT i.block_no || '-' || block_desc
                 INTO v_list.block
                 FROM giis_block
                WHERE district_no = i.district_no
                  AND block_no = i.block_no  
                  AND province_cd = i.province_cd
                  AND city_cd = i.city_cd
                  AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.block := NULL;      
            END;
            
            BEGIN
               SELECT i.district_no || '-' ||district_desc
                 INTO v_list.district
                 FROM giis_block
                WHERE district_no = i.district_no
                  AND block_no = i.block_no  
                  AND province_cd = i.province_cd
                  AND city_cd = i.city_cd
                  AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.district := NULL;      
            END;
            
            BEGIN
               SELECT i.city_cd || '-' || city
                 INTO v_list.city
                 FROM giis_city
                WHERE province_cd = i.province_cd
                  AND city_cd = i.city_cd
                  AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.city := NULL;     
            END;
            
            BEGIN
               SELECT i.province_cd || '-' || province_desc
                 INTO v_list.province
                 FROM giis_province
                WHERE province_cd = i.province_cd
                  AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.province := NULL;                  
            END;
         END IF;
         
         IF v_list.company_name IS NULL
         THEN
            v_list.company_name := giisp.v ('COMPANY_NAME');
            v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         END IF;
      
         PIPE ROW (v_list);
      END LOOP;
      
      IF v_list.company_name IS NULL THEN
         v_list.company_name := giisp.v ('COMPANY_NAME');
         v_list.company_address := giisp.v ('COMPANY_ADDRESS');
         PIPE ROW (v_list);
      END IF;
   END get_giclr056;
   
   FUNCTION get_details (p_cat_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN detail_tab PIPELINED
   IS
      v_list detail_type;
   BEGIN
      FOR i IN (SELECT b.claim_id, get_clm_no(b.claim_id) claim_no,
                       b.line_cd, b.subline_cd, b.pol_iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no,
                       b.assd_no, a.loss_cat_cd, b.dsp_loss_date,
                       a.location, b.in_hou_adj, b.clm_stat_cd
                  FROM gicl_cat_dtl a, gicl_claims b
                 WHERE a.catastrophic_cd = b.catastrophic_cd
                   AND a.catastrophic_cd = p_cat_cd
                   AND b.line_cd = DECODE (check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS056', p_user_id), 1, b.line_cd, 0, '')
--                   AND a.line_cd = DECODE (check_user_per_iss_cd2 (a.line_cd, NULL, 'GICLS056', p_user_id), 1, a.line_cd, 0, '')
                   AND b.clm_stat_cd NOT IN ('WD', 'DN', 'CC')
              ORDER BY claim_no)
      LOOP
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.line_cd || '-' || i.subline_cd || '-' || i.pol_iss_cd || '-' || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-' || LTRIM (TO_CHAR (i.pol_seq_no, '0999999')) || '-' || LTRIM (TO_CHAR (i.renew_no, '09'));
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.location := i.location;
         v_list.in_hou_adj := i.in_hou_adj;
         
         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.assd_name := NULL;    
         END;
         
         BEGIN
            SELECT loss_cat_cd||'-'||loss_cat_des
              INTO v_list.loss_cat
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd 
               AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.loss_cat := NULL;               
         END;
         
         BEGIN
            SELECT clm_stat_desc
              INTO v_list.clm_stat
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd; 
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.clm_stat := NULL;     
         END;
         
         giclr056_pkg.get_amounts(i.claim_id, i.line_cd, v_list.reserve_amt, v_list.paid_amt, v_list.reserve_net, v_list.paid_net,
            v_list.reserve_facul, v_list.paid_facul, v_list.reserve_treaty, v_list.paid_treaty, v_list.reserve_treaty_np, v_list.paid_treaty_np);
         
         PIPE ROW(v_list);
      END LOOP;
   END get_details;
   
   PROCEDURE get_amounts (
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_reserve_amt         OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_amt            OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_net         OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_net            OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_facul       OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,    
      p_paid_facul          OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_treaty      OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_treaty         OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_treaty_np   OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_treaty_np      OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE
   )
   IS
      v_reserve_amt               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_paid_amt                  gicl_loss_exp_ds.shr_le_pd_amt%TYPE := 0;
      v_reserve_net               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_paid_net                  gicl_loss_exp_ds.shr_le_pd_amt%TYPE := 0;
      v_reserve_facul             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;    
      v_paid_facul                gicl_loss_exp_ds.shr_le_pd_amt%TYPE := 0;
      v_reserve_treaty            gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_paid_treaty               gicl_loss_exp_ds.shr_le_pd_amt%TYPE := 0;
      v_reserve_treaty_np         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_paid_treaty_np            gicl_loss_exp_ds.shr_le_pd_amt%TYPE := 0;
   BEGIN
      --reserve amt
      IF p_line_cd <> 'FI' THEN
         FOR res IN (SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) loss_exp
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id)
         LOOP
           v_reserve_amt := res.loss_exp;
         END LOOP;
    
      ELSE 
         FOR res IN (SELECT sum(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) loss_exp
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                      WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id
                        AND a.claim_id = c.claim_id
                        AND a.ITEM_NO = c.item_no) 
         LOOP
            v_reserve_amt := res.loss_exp;
         END LOOP;             
      
      END IF;
      
      --paid amt      
      IF  p_line_cd <> 'FI' THEN
         FOR paid IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id)
         LOOP
            v_paid_amt := paid.le_pd;
         END LOOP; 
         
      ELSE
         FOR paid IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b. peril_cd
                         AND a.item_no = c.item_no
                         AND a.claim_id = c.claim_id)
         LOOP            
            v_paid_amt := paid.le_pd;
         END LOOP;
                      
      END IF;
      
      --reserve net
      IF p_line_cd <> 'FI' THEN
         FOR net IN (SELECT SUM(NVL(b.shr_loss_res_amt,0)) + SUM(NVL(b.shr_exp_res_amt,0)) loss_exp
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b
                      WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND b.share_type = 1
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id)
         LOOP
            v_reserve_net := net.loss_exp;
         END LOOP;  

      ELSE
         FOR net IN (SELECT SUM(NVL(b.shr_loss_res_amt,0)) + SUM(NVL(b.shr_exp_res_amt,0)) loss_exp
                       FROM gicl_clm_res_hist a, gicl_reserve_ds b,gicl_fire_dtl c
                      WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND b.share_type = 1
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id
                        AND a.claim_id = c.claim_id
                        AND a.ITEM_NO = c.item_no	)
         LOOP
            v_reserve_net := net.loss_exp;
         END LOOP;  

      END IF;
      
      --paid net
      IF p_line_cd <> 'FI' THEN

         FOR net IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                       FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                      WHERE a.claim_id = b.claim_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND b.share_type = 1
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND a.claim_id = p_claim_id)
         LOOP
            v_paid_net := net.le_pd;
         END LOOP; 
      ELSE
                  
         FOR net IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                       FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                      WHERE a.claim_id = b.claim_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND b.share_type = 1
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND a.claim_id = p_claim_id	
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b. peril_cd
                        AND a.item_no = c.item_no
                        AND a.claim_id = c.claim_id)
         LOOP
            v_paid_net := net.le_pd;
         END LOOP; 
      END IF;
      
      --reserve facul
      IF p_line_cd <> 'FI' THEN
         FOR facul IN (SELECT SUM(NVL(b.shr_loss_res_amt,0)) + SUM(NVL(b.shr_exp_res_amt,0)) loss_exp
                         FROM gicl_clm_res_hist a, gicl_reserve_ds b
                        WHERE a.claim_id = b.claim_id
                          AND a.item_no = b.item_no
                          AND a.peril_cd = b.peril_cd
                          AND a.clm_res_hist_id = b.clm_res_hist_id
                          AND b.share_type = 3
                          AND NVL(a.dist_sw,'N') = 'Y'
                          AND NVL(b.negate_tag,'N') = 'N'
                          AND a.tran_id IS NULL
                          AND a.claim_id = p_claim_id)
         LOOP
            v_reserve_facul := facul.loss_exp;
         END LOOP;   

      ELSE
         FOR facul IN (SELECT SUM(NVL(b.shr_loss_res_amt,0)) + SUM(NVL(b.shr_exp_res_amt,0)) loss_exp
                         FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                        WHERE a.claim_id = b.claim_id
                          AND a.item_no = b.item_no
                          AND a.peril_cd = b.peril_cd
                          AND a.clm_res_hist_id = b.clm_res_hist_id
                          AND b.share_type = 3
                          AND NVL(a.dist_sw,'N') = 'Y'
                          AND NVL(b.negate_tag,'N') = 'N'
                          AND a.tran_id IS NULL
                          AND a.claim_id = p_claim_id
                          AND a.claim_id = c.claim_id
                          AND a.ITEM_NO = c.item_no)
         LOOP
            v_reserve_facul := facul.loss_exp;
         END LOOP;             

      END IF;
      
      --paid facul
      IF p_line_cd <> 'FI' THEN

         FOR facul IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                         FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                        WHERE a.claim_id = b.claim_id
                          AND a.clm_loss_id = b.clm_loss_id
                          AND b.share_type = 3
                          AND NVL(b.negate_tag,'N') = 'N'
                          AND a.tran_id IS NOT NULL
                          AND a.claim_id = p_claim_id)
         LOOP
            v_paid_facul := facul.le_pd;
         END LOOP; 
      ELSE
                  
         FOR facul IN ( SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND b.share_type = 3
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                           AND a.claim_id = p_claim_id	
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b. peril_cd
                           AND a.item_no = c.item_no
                           AND a.claim_id = c.claim_id)
         LOOP
            v_paid_facul:= facul.le_pd;
         END LOOP; 
      END IF;
      
      --reserve treaty
      IF p_line_cd <> 'FI' THEN
         FOR trty IN (SELECT sum(NVL(b.shr_loss_res_amt,0)) + sum(NVL(b.shr_exp_res_amt,0)) loss_exp
                        FROM gicl_clm_res_hist a, gicl_reserve_ds b
                       WHERE a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.share_type = 2
                         AND NVL(a.dist_sw,'N') = 'Y'
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NULL
                         AND a.claim_id = p_claim_id)
         LOOP
            v_reserve_treaty := trty.loss_exp;
         END LOOP;    
      ELSE
         FOR trty IN (SELECT sum(NVL(b.shr_loss_res_amt,0)) + sum(NVL(b.shr_exp_res_amt,0)) loss_exp
                        FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                       WHERE a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b.peril_cd
                         AND a.clm_res_hist_id = b.clm_res_hist_id
                         AND b.share_type = 2
                         AND NVL(a.dist_sw,'N') = 'Y'
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NULL
                         AND a.claim_id = p_claim_id
                         AND a.claim_id = c.claim_id
                         AND a.ITEM_NO = c.item_no	)
         LOOP
            v_reserve_treaty := trty.loss_exp;
         END LOOP;    
           
          
      END IF;

      --paid treaty
      IF p_line_cd <> 'FI' THEN

         FOR trty IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND b.share_type = 2
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id)
         LOOP
            v_paid_treaty := trty.le_pd;
         END LOOP; 

      ELSE
                  
         FOR trty IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND b.share_type = 2
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id	
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b. peril_cd
                         AND a.item_no = c.item_no
                         AND a.claim_id = c.claim_id)
         LOOP
            v_paid_treaty := trty.le_pd;
         END LOOP; 
      END IF;      
      
      
     
      --reserve treaty np
      IF p_line_cd <> 'FI' THEN
         FOR trty IN (SELECT sum(NVL(b.shr_loss_res_amt,0)) + sum(NVL(b.shr_exp_res_amt,0)) loss_exp
                        FROM gicl_clm_res_hist a, gicl_reserve_ds b
                        WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND b.share_type = 4
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id)
         LOOP
            v_reserve_treaty_np := trty.loss_exp;
         END LOOP;    
      ELSE
         FOR trty IN (SELECT sum(NVL(b.shr_loss_res_amt,0)) + sum(NVL(b.shr_exp_res_amt,0)) loss_exp
                        FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                        WHERE a.claim_id = b.claim_id
                        AND a.item_no = b.item_no
                        AND a.peril_cd = b.peril_cd
                        AND a.clm_res_hist_id = b.clm_res_hist_id
                        AND b.share_type = 4
                        AND NVL(a.dist_sw,'N') = 'Y'
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NULL
                        AND a.claim_id = p_claim_id
                        AND a.claim_id = c.claim_id
                        AND a.ITEM_NO = c.item_no	)
         LOOP
            v_reserve_treaty_np := trty.loss_exp;
         END LOOP;   
              
             
      END IF;
      
      
      
      
      
      --paid treaty np
      IF p_line_cd <> 'FI' THEN

         FOR trty IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND b.share_type = 4
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id)
         LOOP
            v_paid_treaty_np := trty.le_pd;
         END LOOP; 

      ELSE
                  
         FOR trty IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                        FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b, gicl_fire_dtl c
                       WHERE a.claim_id = b.claim_id
                         AND a.clm_loss_id = b.clm_loss_id
                         AND b.share_type = 4
                         AND NVL(b.negate_tag,'N') = 'N'
                         AND a.tran_id IS NOT NULL
                         AND a.claim_id = p_claim_id	
                         AND a.item_no = b.item_no
                         AND a.peril_cd = b. peril_cd
                         AND a.item_no = c.item_no
                         AND a.claim_id = c.claim_id)
         LOOP
            v_paid_treaty_np := trty.le_pd;
         END LOOP; 
      END IF;
      
      
      
      p_reserve_amt :=  NVL(v_reserve_amt, 0);
      p_paid_amt :=  NVL(v_paid_amt, 0);
      p_reserve_net :=  NVL(v_reserve_net, 0);
      p_paid_net :=  NVL(v_paid_net, 0);
      p_reserve_facul :=  NVL(v_reserve_facul, 0);
      p_paid_facul :=  NVL(v_paid_facul, 0);
      p_reserve_treaty :=  NVL(v_reserve_treaty, 0);
      p_paid_treaty :=  NVL(v_paid_treaty, 0);
      p_reserve_treaty_np :=  NVL(v_reserve_treaty_np, 0);
      p_paid_treaty_np :=  NVL(v_paid_treaty_np, 0);
      
   END get_amounts;
      
END giclr056_pkg;
/



CREATE OR REPLACE PACKAGE BODY CPI.gicls056_pkg
AS
   FUNCTION get_catastrophic_event (p_user_id VARCHAR2)
      RETURN cat_tab PIPELINED
   IS
      v_list   cat_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_cat_dtl
                 WHERE check_user_per_iss_cd2(line_cd, NULL, 'GICLS056', p_user_id) = 1
              ORDER BY catastrophic_cd, line_cd, loss_cat_cd)
      LOOP
         v_list.catastrophic_cd := i.catastrophic_cd;
         v_list.catastrophic_desc := i.catastrophic_desc;
         v_list.line_cd := i.line_cd;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.start_date := i.start_date;
         v_list.end_date := i.end_date;
         v_list.location := i.location;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.province_cd := i.province_cd;
         v_list.city_cd := i.city_cd;
         v_list.district_no := i.district_no;
         v_list.block_no := i.block_no;
         gicls056_pkg.get_dsp_amt(i.catastrophic_cd, v_list.res_amt, v_list.pd_amt);
         
         BEGIN
            SELECT line_name
             INTO v_list.line_name
             FROM giis_line
            WHERE line_cd = i.line_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.line_name := NULL;   
         END;
         
         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_des
              FROM giis_loss_ctgry
             WHERE loss_cat_cd = i.loss_cat_cd
               AND line_cd = i.line_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.loss_cat_des := NULL;      
         END;
         
         BEGIN
            SELECT province_desc
              INTO v_list.province_desc
              FROM giis_province
             WHERE province_cd = i.province_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.province_desc := NULL;                 
         END;
         
         BEGIN
            SELECT city
              INTO v_list.city
              FROM giis_city
             WHERE city_cd = i.city_cd
               AND province_cd = i.province_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.city := NULL;                 
         END;
         
         BEGIN
            SELECT district_desc
              INTO v_list.district_desc
              FROM giis_block
             WHERE district_no = i.district_no
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.district_desc := NULL;                 
         END;
         
         BEGIN
            SELECT block_desc
              INTO v_list.block_desc
              FROM giis_block
             WHERE block_no = i.block_no
               AND district_no = i.district_no
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.block_desc := NULL;                 
         END;
         
         BEGIN
            SELECT 'Y'
              INTO v_list.print_sw
              FROM gicl_cat_dtl a, gicl_claims b
             WHERE a.catastrophic_cd = i.catastrophic_cd
               AND a.catastrophic_cd = b.catastrophic_cd
               AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS056', p_user_id) = 1
               AND b.clm_stat_cd NOT IN ('WD', 'DN', 'CC')
               AND ROWNUM = 1;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.print_sw := 'N';    
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_catastrophic_event;
   
   PROCEDURE get_dsp_amt (
      p_catastrophic_cd   IN gicl_cat_dtl.catastrophic_cd%TYPE,
      p_res_amt           OUT NUMBER,
      p_pd_amt            OUT NUMBER
   )
   IS
   BEGIN
      p_res_amt := 0;
      p_pd_amt := 0;
      
      FOR cat IN (SELECT line_cd, claim_id
                    FROM gicl_claims
                   WHERE catastrophic_cd = p_catastrophic_cd)
      LOOP
         IF cat.line_cd = 'FI' THEN
            FOR net IN (SELECT NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0) loss_exp
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND c.claim_id = a.claim_id
                           AND a.item_no = b.item_no
                           AND a.item_no = c.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND b.share_type = 1
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = cat.claim_id)
            LOOP
               p_res_amt := p_res_amt + net.loss_exp;
--               tot_res_fi := tot_res_fi + net.loss_exp;
            END LOOP;
         ELSE
            FOR net IN (SELECT NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0) loss_exp
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND b.share_type = 1
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = cat.claim_id)
            LOOP
               p_res_amt := p_res_amt + net.loss_exp;
--               tot_res := tot_res + net.loss_exp;
            END LOOP;
         END IF;
         
         
         FOR net IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) le_pd
                       FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                      WHERE a.claim_id = b.claim_id
                        AND a.clm_loss_id = b.clm_loss_id
                        AND b.share_type = 1
                        AND NVL(b.negate_tag,'N') = 'N'
                        AND a.tran_id IS NOT NULL
                        AND a.claim_id = cat.claim_id)
         LOOP
            p_pd_amt := p_pd_amt + net.le_pd;
         END LOOP;
         
         
         
      END LOOP;                   
   END get_dsp_amt;
   
   FUNCTION get_details (
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2
   )
      RETURN details_tab PIPELINED
   IS
      v_list details_type;
   BEGIN
      FOR i IN (SELECT claim_id, catastrophic_cd, line_cd, subline_cd, iss_cd, clm_yy,
                       clm_seq_no, loss_cat_cd, loss_date,
                       pol_iss_cd, issue_yy, pol_seq_no, renew_no,
                       loss_res_amt, assd_no, loss_pd_amt, in_hou_adj, exp_res_amt,
                       clm_stat_cd, exp_pd_amt, loss_loc1, loss_loc2, loss_loc3
                  FROM gicl_claims
                 WHERE catastrophic_cd = p_catastrophic_cd
                   AND line_cd = DECODE(check_user_per_iss_cd2(line_cd,iss_cd,'GICLS056',p_user_id),1,line_cd,0,'')
                   AND clm_stat_cd NOT IN ('WD', 'DN', 'CC')
              ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
      LOOP
         v_list.claim_id := i.claim_id;
         v_list.catastrophic_cd := i.catastrophic_cd;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.clm_yy := i.clm_yy;
         v_list.clm_seq_no := i.clm_seq_no;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.loss_date := i.loss_date;
         v_list.claim_no := get_clm_no(i.claim_id);
         v_list.in_hou_adj := i.in_hou_adj;
         v_list.location := NVL(i.loss_loc1, '') || ' ' || NVL(i.loss_loc2,'') || ' ' || NVL(i.loss_loc3,'');
         v_list.policy_no := 
               i.line_cd
            || '-'
            || i.subline_cd
            || '-'
            || i.pol_iss_cd
            || '-'
            || LTRIM (TO_CHAR (i.issue_yy, '09'))
            || '-'
            || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
            || '-'
            || LTRIM (TO_CHAR (i.renew_no, '09'));
         
         IF i.line_cd = 'FI' THEN
            v_list.loss_res_amt := NVL(i.loss_res_amt, 0);
            v_list.loss_pd_amt := NVL(i.loss_pd_amt, 0); 
            v_list.exp_res_amt := NVL(i.exp_res_amt, 0);
            v_list.exp_pd_amt := NVL(i.exp_pd_amt, 0);
         ELSE
            v_list.loss_res_amt := 0;
            FOR amt IN (SELECT NVL(b.shr_loss_res_amt, 0) loss_res
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id)
            LOOP
               v_list.loss_res_amt := v_list.loss_res_amt + amt.loss_res;
            END LOOP;  
            
            v_list.loss_pd_amt := 0;
            FOR amt IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) loss_pd
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND a.payee_type = 'L'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                           AND a.claim_id = i.claim_id)
            LOOP
               v_list.loss_pd_amt := v_list.loss_pd_amt + amt.loss_pd;
            END LOOP; 
            
            v_list.exp_res_amt := 0;
            FOR amt IN (SELECT SUM(NVL(b.shr_exp_res_amt, 0)) exp_res
                          FROM gicl_clm_res_hist a, gicl_reserve_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND a.peril_cd = b.peril_cd
                           AND a.clm_res_hist_id = b.clm_res_hist_id
                           AND NVL(a.dist_sw,'N') = 'Y'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NULL
                           AND a.claim_id = i.claim_id)
            LOOP
               v_list.exp_res_amt := v_list.exp_res_amt + amt.exp_res;
            END LOOP;
            
            v_list.exp_pd_amt := 0;
            FOR amt IN (SELECT NVL(SUM(b.shr_le_pd_amt),0) exp_pd
                          FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                         WHERE a.claim_id = b.claim_id
                           AND a.clm_loss_id = b.clm_loss_id
                           AND a.payee_type = 'E'
                           AND NVL(b.negate_tag,'N') = 'N'
                           AND a.tran_id IS NOT NULL
                           AND a.claim_id = i.claim_id)
            LOOP
               v_list.exp_pd_amt := v_list.exp_pd_amt + amt.exp_pd;
            END LOOP;
            
            v_list.loss_res_amt := NVL(v_list.loss_res_amt, 0);
            v_list.loss_pd_amt := NVL(v_list.loss_pd_amt, 0); 
            v_list.exp_res_amt := NVL(v_list.exp_res_amt, 0);
            v_list.exp_pd_amt := NVL(v_list.exp_pd_amt, 0);
            
            
         END IF;   
         
         
         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_des
              FROM giis_loss_ctgry
             WHERE loss_cat_cd = i.loss_cat_cd
               AND line_cd = i.line_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.loss_cat_des := NULL;         
         END;
         
         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.assd_name := NULL;
         END;
         
         BEGIN
            SELECT i.clm_stat_cd || ' - ' || clm_stat_desc 
              INTO v_list.clm_stat
              FROM giis_clm_stat
             WHERE clm_stat_cd = i.clm_stat_cd;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.clm_stat := NULL;    
         END;
         
         v_list.loss_cat := i.loss_cat_cd || ' - ' || v_list.loss_cat_des;
         
         gicls056_pkg.populate_details_amt(i.claim_id, p_district_no, p_block_no,
            v_list.net_res_amt, v_list.trty_res_amt, v_list.np_trty_res_amt,
            v_list.facul_res_amt, v_list.net_pd_amt , v_list.trty_pd_amt, v_list.np_trty_pd_amt, v_list.facul_pd_amt);
         
         v_list.net_res_amt := NVL(v_list.net_res_amt, 0);
         v_list.trty_res_amt := NVL(v_list.trty_res_amt, 0);
         v_list.np_trty_res_amt := NVL(v_list.np_trty_res_amt, 0);
         v_list.facul_res_amt := NVL(v_list.facul_res_amt, 0);
         v_list.net_pd_amt := NVL(v_list.net_pd_amt, 0);
         v_list.trty_pd_amt := NVL(v_list.trty_pd_amt, 0);
         v_list.np_trty_pd_amt := NVL(v_list.np_trty_pd_amt, 0);
         v_list.facul_pd_amt := NVL(v_list.facul_pd_amt, 0);
         
         IF v_list.tot_net_res_amt IS NULL THEN
            DECLARE
               v_tot_net_res_amt       NUMBER (14, 2) := 0;
               v_tot_trty_res_amt      NUMBER (14, 2) := 0;
               v_tot_np_trty_res_amt   NUMBER (14, 2) := 0;
               v_tot_facul_res_amt     NUMBER (14, 2) := 0;
               v_tot_net_pd_amt        NUMBER (14, 2) := 0;
               v_tot_trty_pd_amt       NUMBER (14, 2) := 0;
               v_tot_np_trty_pd_amt    NUMBER (14, 2) := 0;
               v_tot_facul_pd_amt      NUMBER (14, 2) := 0;
            BEGIN
               
               v_list.tot_net_res_amt := 0;
               v_list.tot_trty_res_amt := 0;
               v_list.tot_np_trty_res_amt := 0;
               v_list.tot_facul_res_amt := 0;
               v_list.tot_net_pd_amt := 0;
               v_list.tot_trty_pd_amt := 0;
               v_list.tot_np_trty_pd_amt := 0;
               v_list.tot_facul_pd_amt := 0;
            
               FOR j IN (SELECT claim_id
                           FROM gicl_claims
                          WHERE catastrophic_cd = p_catastrophic_cd
                            AND line_cd = DECODE(check_user_per_iss_cd2(line_cd,iss_cd,'GICLS056',p_user_id),1,line_cd,0,'')
                            AND clm_stat_cd NOT IN ('WD', 'DN', 'CC'))
               LOOP
                  gicls056_pkg.populate_details_amt(j.claim_id, p_district_no, p_block_no,
                     v_tot_net_res_amt, v_tot_trty_res_amt, v_tot_np_trty_res_amt,
                     v_tot_facul_res_amt, v_tot_net_pd_amt , v_tot_trty_pd_amt, v_tot_np_trty_pd_amt, v_tot_facul_pd_amt);
                     
                  v_list.tot_net_res_amt := v_list.tot_net_res_amt + NVL(v_tot_net_res_amt, 0);
                  v_list.tot_trty_res_amt := v_list.tot_trty_res_amt + NVL(v_tot_trty_res_amt, 0);
                  v_list.tot_np_trty_res_amt := v_list.tot_np_trty_res_amt + NVL(v_tot_np_trty_res_amt, 0);
                  v_list.tot_facul_res_amt := v_list.tot_facul_res_amt + NVL(v_tot_facul_res_amt, 0);
                  v_list.tot_net_pd_amt := v_list.tot_net_pd_amt + NVL(v_tot_net_pd_amt, 0);
                  v_list.tot_trty_pd_amt := v_list.tot_trty_pd_amt + NVL(v_tot_trty_pd_amt, 0);
                  v_list.tot_np_trty_pd_amt := v_list.tot_np_trty_pd_amt + NVL(v_tot_np_trty_pd_amt, 0);
                  v_list.tot_facul_pd_amt := v_list.tot_facul_pd_amt + NVL(v_tot_facul_pd_amt, 0);  
                     
               END LOOP;                            
            END;
         END IF;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_details;
   
   PROCEDURE populate_details_amt (
      p_claim_id          IN       gicl_claims.claim_id%TYPE,
      p_district_no       IN       VARCHAR2,
      p_block_no          IN       VARCHAR2,
      p_net_res_amt       OUT      NUMBER,
      p_trty_res_amt      OUT      NUMBER,
      p_np_trty_res_amt   OUT      NUMBER,
      p_facul_res_amt     OUT      NUMBER,
      p_net_pd_amt        OUT      NUMBER,
      p_trty_pd_amt       OUT      NUMBER,
      p_np_trty_pd_amt    OUT      NUMBER,
      p_facul_pd_amt      OUT      NUMBER
   )
   IS
      v_treaty gicl_reserve_ds.share_type%TYPE;
      v_facul  gicl_reserve_ds.share_type%TYPE;
   BEGIN
   
      BEGIN
         SELECT param_value_v
           INTO v_treaty
           FROM giac_parameters
          WHERE param_name = 'TRTY_SHARE_TYPE';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_treaty := NULL;    
      END;
      
      BEGIN
         SELECT param_value_v facul
           INTO v_facul
           FROM giac_parameters
          WHERE param_name = 'FACUL_SHARE_TYPE';
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_facul := NULL;    
      END;
      
      IF p_district_no IS NULL OR p_block_no IS NULL THEN
--         raise_application_error (-20001, 'Geniisys Exception#E#1');
         BEGIN
           SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_net_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b
             WHERE a.claim_id = b.claim_id
               AND a.item_no = b.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.share_type = 1
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_net_res_amt := 0;
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_trty_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b
             WHERE a.claim_id = b.claim_id
               AND a.item_no = b.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.share_type = v_treaty
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_trty_res_amt := 0;
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_np_trty_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b
             WHERE a.claim_id = b.claim_id
               AND a.item_no = b.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_np_trty_res_amt := 0;      
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_facul_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b
             WHERE a.claim_id = b.claim_id
               AND a.item_no = b.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.share_type = v_facul
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_facul_res_amt := 0;     
         END;
      
      ELSE
--         raise_application_error (-20001, 'Geniisys Exception#E#2');
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_net_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
             WHERE a.claim_id = b.claim_id
               AND c.claim_id = a.claim_id
               AND a.item_no = b.item_no
               AND a.item_no = c.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND c.district_no = NVL(p_district_no, c.district_no)
               AND c.block_no = NVL(p_block_no, c.block_no)
               AND b.share_type = 1
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_net_res_amt := 0;        
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_trty_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND a.item_no = b.item_no
               AND a.item_no = c.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND c.district_no = NVL(p_district_no, c.district_no)
               AND c.block_no = NVL(p_block_no, c.block_no)
               AND b.share_type = v_treaty
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_trty_res_amt := 0;
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_np_trty_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND a.item_no = b.item_no
               AND a.item_no = c.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND c.district_no = NVL(p_district_no, c.district_no)
               AND c.block_no = NVL(p_block_no, c.block_no)
               AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_np_trty_res_amt := 0;         
         END;
         
         BEGIN
            SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0))
              INTO p_facul_res_amt
              FROM gicl_clm_res_hist a, gicl_reserve_ds b, gicl_fire_dtl c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND a.item_no = b.item_no
               AND a.item_no = c.item_no
               AND a.peril_cd = b.peril_cd
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND c.district_no = NVL(p_district_no, c.district_no)
               AND c.block_no = NVL(p_block_no, c.block_no)
               AND b.share_type = v_facul
               AND NVL(a.dist_sw,'N') = 'Y'
               AND NVL(b.negate_tag,'N') = 'N'
               AND a.tran_id IS NULL
               AND a.claim_id = p_claim_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            p_facul_res_amt := 0;         
         END;
         
      END IF;
      
      BEGIN
         SELECT SUM(NVL(b.shr_le_pd_amt, 0))
           INTO p_net_pd_amt
                FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
               WHERE a.claim_id = b.claim_id
                 AND a.clm_loss_id = b.clm_loss_id
                 AND b.share_type = 1
                 AND NVL(b.negate_tag,'N') = 'N'
                 AND a.tran_id IS NOT NULL
                 AND a.claim_id = p_claim_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         p_net_pd_amt := 0;               
      END;
      
      BEGIN
         SELECT SUM(NVL(b.shr_le_pd_amt, 0))
           INTO p_trty_pd_amt
           FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
          WHERE a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND b.share_type = v_treaty
            AND NVL(b.negate_tag,'N') = 'N'
            AND a.tran_id IS NOT NULL
            AND a.claim_id = p_claim_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         p_trty_pd_amt := 0;            
      END;
      
      BEGIN
         SELECT SUM(NVL(b.shr_le_pd_amt, 0))
           INTO p_np_trty_pd_amt
           FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
          WHERE a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND b.share_type = giacp.v('XOL_TRTY_SHARE_TYPE')
            AND NVL(b.negate_tag,'N') = 'N'
            AND a.tran_id IS NOT NULL
            AND a.claim_id = p_claim_id;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         p_np_trty_pd_amt := 0;       
      END;
      
      BEGIN
         SELECT SUM(NVL(b.shr_le_pd_amt, 0))
           INTO p_facul_pd_amt
           FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
          WHERE a.claim_id = b.claim_id
            AND a.clm_loss_id = b.clm_loss_id
            AND b.share_type = v_facul
            AND NVL(b.negate_tag,'N') = 'N'
            AND a.tran_id IS NOT NULL
            AND a.claim_id = p_claim_id;
      END;
   
   END populate_details_amt;
   
   FUNCTION get_claim_list_fi (
      p_user_id      VARCHAR2,
      p_loss_cat_cd  VARCHAR2,
      p_start_date   VARCHAR2,   
      p_end_date     VARCHAR2,
      p_location     VARCHAR2,   
      p_province_cd  VARCHAR2,
      p_city_cd      VARCHAR2,
      p_district_no  VARCHAR2,
      p_block_no     VARCHAR2,
      p_search_type  VARCHAR2
   )
      RETURN claim_list_tab PIPELINED
   IS
      v_list claim_list_type;
   BEGIN
   
      IF UPPER(p_search_type) = 'ALL' THEN
         IF p_province_cd IS NULL AND p_city_cd IS NULL AND p_district_no IS NULL AND p_block_no IS NULL THEN
            BEGIN
               FOR i IN (SELECT claim_id, line_cd, subline_cd,
                                pol_iss_cd, issue_yy, pol_seq_no,
                                renew_no, assd_no, clm_stat_cd, dsp_loss_date,
                                in_hou_adj, loss_cat_cd
                           FROM gicl_claims a
                          WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                            AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                            AND catastrophic_cd IS NULL
                            AND line_cd = 'FI'
                            AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                            AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                   AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                            AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                       ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
               LOOP
                  v_list.claim_id   := i.claim_id;
                  v_list.claim_no := get_clm_no(i.claim_id);
                  v_list.policy_no := i.line_cd
                     || '-'
                     || i.subline_cd
                     || '-'
                     || i.pol_iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (i.issue_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                     || '-'
                     || LTRIM (TO_CHAR (i.renew_no, '09'));
                  v_list.dsp_loss_date := i.dsp_loss_date;
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
                     SELECT i.loss_cat_cd || ' - ' || loss_cat_des
                       INTO v_list.loss_cat
                       FROM giis_loss_ctgry
                      WHERE loss_cat_cd = i.loss_cat_cd
                        AND line_cd = i.line_cd;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                     v_list.loss_cat := NULL;      
                  END;
                  
                  BEGIN
                     SELECT clm_stat_desc 
                       INTO v_list.clm_stat_desc
                       FROM giis_clm_stat
                      WHERE clm_stat_cd = i.clm_stat_cd;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                     v_list.clm_stat_desc := NULL;    
                  END;               

                  PIPE ROW(v_list);
               END LOOP;
            END;
         ELSE
            BEGIN
               FOR i IN (SELECT claim_id, line_cd, subline_cd,
                                pol_iss_cd, issue_yy, pol_seq_no,
                                renew_no, assd_no, clm_stat_cd, dsp_loss_date,
                                in_hou_adj, loss_cat_cd
                           FROM gicl_claims a
                          WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                            AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                            AND catastrophic_cd IS NULL
                            AND line_cd = 'FI'
                            AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                            AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                   AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                            AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                            AND EXISTS (SELECT b.claim_id
                                          FROM gicl_fire_dtl b
                                         WHERE b.claim_id = a.claim_id
                                           AND b.block_id IN (SELECT c.block_id
                                                                FROM giis_block c
                                                               WHERE c.block_id = b.block_id
                                                                                     AND c.province_cd = NVL(p_province_cd, c.province_cd)
                                                                                     AND c.city_cd = NVL(p_city_cd, c.city_cd)
                                                                                     AND c.district_no = NVL(p_district_no, c.district_no)
                                                                                     AND c.block_no = NVL(p_block_no, c.block_no)))
                       ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
               LOOP
                  v_list.claim_id   := i.claim_id;
                  v_list.claim_no := get_clm_no(i.claim_id);
                  v_list.policy_no := i.line_cd
                     || '-'
                     || i.subline_cd
                     || '-'
                     || i.pol_iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (i.issue_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                     || '-'
                     || LTRIM (TO_CHAR (i.renew_no, '09'));
                  v_list.dsp_loss_date := i.dsp_loss_date;
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
                     SELECT i.loss_cat_cd || ' - ' || loss_cat_des
                       INTO v_list.loss_cat
                       FROM giis_loss_ctgry
                      WHERE loss_cat_cd = i.loss_cat_cd
                        AND line_cd = i.line_cd;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                     v_list.loss_cat := NULL;      
                  END;
                  
                  BEGIN
                     SELECT clm_stat_desc 
                       INTO v_list.clm_stat_desc
                       FROM giis_clm_stat
                      WHERE clm_stat_cd = i.clm_stat_cd;
                  EXCEPTION WHEN NO_DATA_FOUND THEN
                     v_list.clm_stat_desc := NULL;    
                  END;               

                  PIPE ROW(v_list);
               END LOOP;
            END;                  
         END IF;
      ELSE
         BEGIN
            FOR i IN(SELECT claim_id, line_cd, subline_cd,
                            pol_iss_cd, issue_yy, pol_seq_no,
                            renew_no, assd_no, clm_stat_cd, dsp_loss_date,
                            in_hou_adj, loss_cat_cd
                       FROM gicl_claims a
                      WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                        AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                        AND catastrophic_cd IS NULL
                        AND line_cd = 'FI'
                        AND (a.loss_cat_cd = p_loss_cat_cd
                              OR TRUNC(a.loss_date) BETWEEN TO_DATE(p_start_date,'MM-DD-YYYY')
                             AND TO_DATE(p_end_date, 'MM-DD-YYYY')
                              OR UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%' || NVL(p_location,'$#@')||'%'
                              OR EXISTS (SELECT b.claim_id
                                           FROM gicl_fire_dtl b
                                          WHERE b.claim_id = a.claim_id
                                            AND b.block_id IN (SELECT c.block_id
                                                                 FROM giis_block c
                                                                WHERE c.province_cd = p_province_cd
                                                                   OR c.city_cd = p_city_cd
                                                                   OR c.district_no = p_district_no
                                                                   OR c.block_no = p_block_no)))
                   ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_list.claim_id   := i.claim_id;
               v_list.claim_no := get_clm_no(i.claim_id);
               v_list.policy_no := i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (i.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (i.renew_no, '09'));
               v_list.dsp_loss_date := i.dsp_loss_date;
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
                  SELECT i.loss_cat_cd || ' - ' || loss_cat_des
                    INTO v_list.loss_cat
                    FROM giis_loss_ctgry
                   WHERE loss_cat_cd = i.loss_cat_cd
                     AND line_cd = i.line_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.loss_cat := NULL;      
               END;
               
               BEGIN
                  SELECT clm_stat_desc 
                    INTO v_list.clm_stat_desc
                    FROM giis_clm_stat
                   WHERE clm_stat_cd = i.clm_stat_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.clm_stat_desc := NULL;    
               END;               

               PIPE ROW(v_list);
            END LOOP;
         END;      
      END IF;
   END get_claim_list_fi; 
   
   FUNCTION get_claim_list (
      p_user_id      VARCHAR2,
      p_loss_cat_cd  VARCHAR2,
      p_start_date   VARCHAR2,   
      p_end_date     VARCHAR2,
      p_location     VARCHAR2,
      p_line_cd      VARCHAR2,
      p_search_type  VARCHAR2
   )
      RETURN claim_list_tab PIPELINED
   IS
      v_list claim_list_type;
   BEGIN
   
      IF UPPER(p_search_type) = 'ALL' THEN
         BEGIN
            FOR i IN (SELECT claim_id, line_cd, subline_cd,
                             pol_iss_cd, issue_yy, pol_seq_no,
                             renew_no, assd_no, clm_stat_cd, dsp_loss_date,
                             in_hou_adj, loss_cat_cd
                        FROM gicl_claims a
                       WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                         AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                         AND catastrophic_cd IS NULL
                         AND a.line_cd = p_line_cd
                         AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                         AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                         AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                    ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_list.claim_id   := i.claim_id;
               v_list.claim_no := get_clm_no(i.claim_id);
               v_list.policy_no := i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (i.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (i.renew_no, '09'));
               v_list.dsp_loss_date := i.dsp_loss_date;
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
                  SELECT i.loss_cat_cd || ' - ' || loss_cat_des
                    INTO v_list.loss_cat
                    FROM giis_loss_ctgry
                   WHERE loss_cat_cd = i.loss_cat_cd
                     AND line_cd = i.line_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.loss_cat := NULL;      
               END;
                  
               BEGIN
                  SELECT clm_stat_desc 
                    INTO v_list.clm_stat_desc
                    FROM giis_clm_stat
                   WHERE clm_stat_cd = i.clm_stat_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.clm_stat_desc := NULL;    
               END;               

               PIPE ROW(v_list);
            END LOOP;
         END;
      ELSE
         BEGIN
            FOR i IN(SELECT claim_id, line_cd, subline_cd,
                            pol_iss_cd, issue_yy, pol_seq_no,
                            renew_no, assd_no, clm_stat_cd, dsp_loss_date,
                            in_hou_adj, loss_cat_cd
                       FROM gicl_claims a
                      WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                        AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                        AND catastrophic_cd IS NULL
                        AND (a.line_cd = p_line_cd
                              OR a.loss_cat_cd = p_loss_cat_cd
                              OR TRUNC(a.loss_date) BETWEEN TO_DATE(p_start_date,'MM-DD-YYYY')
                             AND TO_DATE(p_end_date, 'MM-DD-YYYY')
                              OR UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%' || NVL(p_location,'$#@')||'%')
                   ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_list.claim_id   := i.claim_id;
               v_list.claim_no := get_clm_no(i.claim_id);
               v_list.policy_no := i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.pol_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (i.issue_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (i.pol_seq_no, '0999999'))
                  || '-'
                  || LTRIM (TO_CHAR (i.renew_no, '09'));
               v_list.dsp_loss_date := i.dsp_loss_date;
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
                  SELECT i.loss_cat_cd || ' - ' || loss_cat_des
                    INTO v_list.loss_cat
                    FROM giis_loss_ctgry
                   WHERE loss_cat_cd = i.loss_cat_cd
                     AND line_cd = i.line_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.loss_cat := NULL;      
               END;
               
               BEGIN
                  SELECT clm_stat_desc 
                    INTO v_list.clm_stat_desc
                    FROM giis_clm_stat
                   WHERE clm_stat_cd = i.clm_stat_cd;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_list.clm_stat_desc := NULL;    
               END;               

               PIPE ROW(v_list);
            END LOOP;
         END;      
      END IF;
   END get_claim_list;
   
   PROCEDURE update_details (
      p_claim_id           VARCHAR2,
      p_catastrophic_cd    VARCHAR2,
      p_action             VARCHAR2
   )
   IS
   BEGIN
   
      IF UPPER(p_action) = 'ADD' THEN
         UPDATE gicl_claims
         SET catastrophic_cd = p_catastrophic_cd
       WHERE claim_id = p_claim_id;
      ELSIF UPPER(p_action) = 'REMOVE' THEN
         UPDATE gicl_claims
         SET catastrophic_cd = NULL
       WHERE claim_id = p_claim_id; 
      END IF;
      
   END update_details;
   
   FUNCTION get_loss_cat_lov(
      p_line_cd   VARCHAR2
   )
      RETURN loss_cat_lov_tab PIPELINED
   IS
      v_list loss_cat_lov_type;
   BEGIN
      FOR i IN (SELECT loss_cat_cd, loss_cat_des
                  FROM giis_loss_ctgry
                 WHERE line_cd = p_line_cd
              ORDER BY loss_cat_cd)
      LOOP
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.loss_cat_des := i.loss_cat_des;
         PIPE ROW(v_list);
      END LOOP;
   END  get_loss_cat_lov;
   
   FUNCTION get_province_lov
      RETURN province_lov_tab PIPELINED
   IS
      v_list province_lov_type;
   BEGIN
      FOR i IN (SELECT province_cd, province_desc
                  FROM giis_province
              ORDER BY province_cd)
      LOOP
         v_list.province_cd := i.province_cd;
         v_list.province_desc := i.province_desc;
         PIPE ROW(v_list);
      END LOOP;
   END get_province_lov;     
   
   FUNCTION get_city_lov (
      p_province_cd  VARCHAR2
   )
      RETURN city_lov_tab PIPELINED
   IS
      v_list city_lov_type;
   BEGIN
      FOR i IN (SELECT city_cd, city
                  FROM giis_city
                 WHERE province_cd = NVL(p_province_cd, province_cd)
              ORDER BY 1, 2)
      LOOP
         v_list.city_cd := i.city_cd;
         v_list.city := i.city;
         PIPE ROW(v_list);
      END LOOP;
   END get_city_lov;
   
   FUNCTION get_district_lov (
      p_province_cd  VARCHAR2,
      p_city_cd      VARCHAR2
   )
      RETURN district_lov_tab PIPELINED
   IS
      v_list district_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT district_no, district_desc
                 FROM giis_block
                WHERE province_cd = NVL(p_province_cd, province_cd)
                  AND city_cd = NVL(p_city_cd, city_cd)
             ORDER BY district_no, district_desc)
      LOOP
         v_list.district_no := i.district_no;
         v_list.district_desc := i.district_desc;
         PIPE ROW(v_list);
      END LOOP;
   END get_district_lov;
   
   FUNCTION get_block_lov (
      p_province_cd   VARCHAR2,
      p_city_cd       VARCHAR2,
      p_district_no   VARCHAR2
   )
      RETURN block_lov_tab PIPELINED
   IS
      v_list block_lov_type;
   BEGIN
      FOR i IN (SELECT block_no, block_desc
                  FROM giis_block
                 WHERE district_no = NVL(p_district_no, district_no)
                   AND province_cd = NVL(p_province_cd, province_cd)
                   AND city_cd = NVL(p_city_cd, city_cd)
              ORDER BY block_no)
      LOOP
         v_list.block_no := i.block_no;
         v_list.block_desc := i.block_desc;
         PIPE ROW(v_list);
      END LOOP;
   END get_block_lov;
   
   PROCEDURE save_rec (p_rec gicl_cat_dtl%ROWTYPE)
   IS
      v_catastrophic_cd gicl_cat_dtl.catastrophic_cd%TYPE;
   BEGIN
   
      IF p_rec.catastrophic_cd IS NULL THEN
         BEGIN
            SELECT catastrophic_cd_s.NEXTVAL
              INTO v_catastrophic_cd
              FROM DUAL;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_catastrophic_cd := 0;
         END;
      END IF;
   
      MERGE INTO gicl_cat_dtl
         USING DUAL
         ON (catastrophic_cd = p_rec.catastrophic_cd)
         WHEN NOT MATCHED THEN
            INSERT (catastrophic_cd, catastrophic_desc, line_cd, loss_cat_cd,
                    start_date, end_date, location, district_no, block_no, city_cd,
                    province_cd, remarks, user_id, last_update)
            VALUES (v_catastrophic_cd, p_rec.catastrophic_desc, p_rec.line_cd, p_rec.loss_cat_cd,
                    p_rec.start_date, p_rec.end_date, p_rec.location, p_rec.district_no, p_rec.block_no, p_rec.city_cd,
                    p_rec.province_cd, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET catastrophic_desc = p_rec.catastrophic_desc, line_cd = p_rec.line_cd, loss_cat_cd = p_rec.loss_cat_cd,
                   start_date = p_rec.start_date, end_date = p_rec.end_date, location = p_rec.location,
                   district_no = p_rec.district_no, block_no = p_rec.block_no, city_cd = p_rec.city_cd,
                   province_cd = p_rec.province_cd, remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE;
   END save_rec;
   
   FUNCTION val_delete (
      p_cat_cd VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_temp VARCHAR2(1) := 'N';
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_temp
           FROM gicl_claims
          WHERE catastrophic_cd = p_cat_cd
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_temp := 'N';      
      END;
      RETURN v_temp;   
   END val_delete;
   
   PROCEDURE del_rec (p_cat_cd VARCHAR2)
   IS
      v_temp VARCHAR2(1);
   BEGIN
   
      IF p_cat_cd IS NULL OR UPPER(p_cat_cd) = UPPER('NULL') THEN
         RETURN;
      END IF;
   
      BEGIN
         SELECT gicls056_pkg.val_delete(p_cat_cd)
           INTO v_temp
           FROM DUAL;
      END;
      
      IF v_temp = 'Y' THEN
         BEGIN
            UPDATE gicl_claims
               SET catastrophic_cd = NULL
             WHERE catastrophic_cd = p_cat_cd;
         END;
      END IF;
      
      BEGIN
         DELETE gicl_cat_dtl
          WHERE catastrophic_cd = p_cat_cd;
      END;
      
   END del_rec;


   PROCEDURE update_details_all (
      p_cat_cd            VARCHAR2,
      p_user_id           VARCHAR2,
      p_loss_cat_cd       VARCHAR2,
      p_start_date        VARCHAR2,
      p_end_date          VARCHAR2,
      p_location          VARCHAR2,
      p_province_cd       VARCHAR2,
      p_city_cd           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2,
      p_line_cd           VARCHAR2,
      p_search_type       VARCHAR2
   )
   IS
      CURSOR curr_claim_list_fi
      IS
         SELECT claim_id 
           FROM TABLE(gicls056_pkg.get_claim_list_fi(p_user_id, p_loss_cat_cd, p_start_date, p_end_date, p_location,
                                  p_province_cd, p_city_cd, p_district_no, p_block_no, p_search_type));
      
      CURSOR curr_claim_list
      IS
         SELECT claim_id
           FROM TABLE(gicls056_pkg.get_claim_list(p_user_id, p_loss_cat_cd, p_start_date, p_end_date, p_location, 
                                  p_line_cd, p_search_type));
                                  
                                  
      v_claim_id gicl_claims.claim_id%TYPE;                                  
   BEGIN
      IF p_line_cd = 'FI' THEN
         OPEN curr_claim_list_fi;
         LOOP
            FETCH curr_claim_list_fi INTO v_claim_id;
            EXIT WHEN curr_claim_list_fi%NOTFOUND;
            
            BEGIN
               UPDATE gicl_claims
                  SET catastrophic_cd = p_cat_cd
                WHERE claim_id = v_claim_id; 
            END;
             
         END LOOP;
         CLOSE curr_claim_list_fi;
      ELSE
         OPEN curr_claim_list;
         LOOP
            FETCH curr_claim_list INTO v_claim_id;
            EXIT WHEN curr_claim_list%NOTFOUND;
            
            BEGIN
               UPDATE gicl_claims
                  SET catastrophic_cd = p_cat_cd
                WHERE claim_id = v_claim_id; 
            END;
             
         END LOOP;
         CLOSE curr_claim_list;      
      END IF;
   END update_details_all;
   
   PROCEDURE remove_all_details(
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2
   )
   IS
      CURSOR curr
      IS
         SELECT claim_id
                  FROM gicl_claims
                 WHERE catastrophic_cd = p_catastrophic_cd
                   AND line_cd = DECODE(check_user_per_iss_cd2(line_cd,iss_cd,'GICLS056',p_user_id),1,line_cd,0,'')
                   AND clm_stat_cd NOT IN ('WD', 'DN', 'CC');
                   
         v_claim_id gicl_claims.claim_id%TYPE;                   
      
   BEGIN
      OPEN curr;
      LOOP
         FETCH curr INTO v_claim_id;
         EXIT WHEN curr%NOTFOUND;
         
         BEGIN
            UPDATE gicl_claims
               SET catastrophic_cd = NULL
             WHERE claim_id = v_claim_id;  
         END;
         
      END LOOP; 
      CLOSE curr;
   END remove_all_details;
   
   FUNCTION get_line_lov(
      p_module_id VARCHAR2,
      p_user_id   VARCHAR2,
      p_find_text VARCHAR2
   )
      RETURN line_tab PIPELINED
   IS
      v_list line_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name 
                  FROM giis_line 
                 WHERE (UPPER(line_cd) LIKE UPPER(NVL(p_find_text, line_cd))
                        OR UPPER(line_name) LIKE UPPER(NVL(p_find_text, line_name)))
                   AND check_user_per_iss_cd2(line_cd, NULL, p_module_id, p_user_id) = 1
              ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_line_lov;
   
   PROCEDURE val_add_rec (
      p_cat_cd    VARCHAR2,
      p_cat_desc  VARCHAR2
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      IF p_cat_cd IS NULL THEN
         BEGIN
            FOR i IN (SELECT 1
                        FROM gicl_cat_dtl
                       WHERE UPPER(catastrophic_desc) = UPPER(p_cat_desc))
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;
         END;
         
         IF v_exists = 'Y' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same catastrophic_desc.');
         END IF;
      ELSE
         BEGIN
            FOR i IN (SELECT 1
                        FROM gicl_cat_dtl
                       WHERE UPPER(catastrophic_desc) = UPPER(p_cat_desc)
                         AND catastrophic_cd != p_cat_cd)
            LOOP
               v_exists := 'Y';
               EXIT;
            END LOOP;
         END;
         
         IF v_exists = 'Y' THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same catastrophic_desc.');
         END IF;            
      END IF;
   END val_add_rec;
   
   FUNCTION get_claim_nos (
      p_catastrophic_cd   VARCHAR2,
      p_user_id           VARCHAR2,
      p_district_no       VARCHAR2,
      p_block_no          VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_claim_nos VARCHAR2(32767) := '';
   BEGIN
      FOR i IN (SELECT claim_id
                  FROM gicl_claims
                 WHERE catastrophic_cd = p_catastrophic_cd
                   AND check_user_per_iss_cd2(line_cd,iss_cd,'GICLS056',p_user_id) = 1
                   AND clm_stat_cd NOT IN ('WD', 'DN', 'CC'))
      LOOP
         v_claim_nos := v_claim_nos || i.claim_id || ',';
      END LOOP;
      RETURN v_claim_nos;                   
   END get_claim_nos;
   
   FUNCTION get_claim_nos_list (
      p_user_id      VARCHAR2,
      p_loss_cat_cd  VARCHAR2,
      p_start_date   VARCHAR2,   
      p_end_date     VARCHAR2,
      p_location     VARCHAR2,
      p_line_cd      VARCHAR2,
      p_search_type  VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_claim_nos VARCHAR2(32767) := '';
   BEGIN
   
      IF UPPER(p_search_type) = 'ALL' THEN
         BEGIN
            FOR i IN (SELECT claim_id
                        FROM gicl_claims a
                       WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                         AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                         AND catastrophic_cd IS NULL
                         AND a.line_cd = p_line_cd
                         AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                         AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                         AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                    ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_claim_nos := v_claim_nos || i.claim_id || ',';
            END LOOP;
         END;
      ELSE
         BEGIN
            FOR i IN(SELECT claim_id
                       FROM gicl_claims a
                      WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                        AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                        AND catastrophic_cd IS NULL
                        AND (a.line_cd = p_line_cd
                              OR a.loss_cat_cd = p_loss_cat_cd
                              OR TRUNC(a.loss_date) BETWEEN TO_DATE(p_start_date,'MM-DD-YYYY')
                             AND TO_DATE(p_end_date, 'MM-DD-YYYY')
                              OR UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%' || NVL(p_location,'$#@')||'%')
                   ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_claim_nos := v_claim_nos || i.claim_id || ',';
            END LOOP;
         END;      
      END IF;
      
      RETURN v_claim_nos;
   END get_claim_nos_list;
   
   FUNCTION get_claim_nos_list_fi (
      p_user_id      VARCHAR2,
      p_loss_cat_cd  VARCHAR2,
      p_start_date   VARCHAR2,   
      p_end_date     VARCHAR2,
      p_location     VARCHAR2,   
      p_province_cd  VARCHAR2,
      p_city_cd      VARCHAR2,
      p_district_no  VARCHAR2,
      p_block_no     VARCHAR2,
      p_search_type  VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_claim_nos VARCHAR2(32767) := '';
   BEGIN
   
      IF UPPER(p_search_type) = 'ALL' THEN
         IF p_province_cd IS NULL AND p_city_cd IS NULL AND p_district_no IS NULL AND p_block_no IS NULL THEN
            BEGIN
               FOR i IN (SELECT claim_id
                           FROM gicl_claims a
                          WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                            AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                            AND catastrophic_cd IS NULL
                            AND line_cd = 'FI'
                            AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                            AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                   AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                            AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                       ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
               LOOP
                  v_claim_nos := v_claim_nos || i.claim_id || ',';
               END LOOP;
            END;
         ELSE
            BEGIN
               FOR i IN (SELECT claim_id
                           FROM gicl_claims a
                          WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                            AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                            AND catastrophic_cd IS NULL
                            AND line_cd = 'FI'
                            AND a.loss_cat_cd = NVL(p_loss_cat_cd, loss_cat_cd)
                            AND (TRUNC(a.loss_date) BETWEEN NVL(TO_DATE(p_start_date,'MM-DD-YYYY'), TRUNC(a.loss_date))
                                   AND NVL(TO_DATE(p_end_date,'MM-DD-YYYY'), TRUNC(a.loss_date)))
                            AND UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%'||NVL(p_location, UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')))||'%'
                            AND EXISTS (SELECT b.claim_id
                                          FROM gicl_fire_dtl b
                                         WHERE b.claim_id = a.claim_id
                                           AND b.block_id IN (SELECT c.block_id
                                                                FROM giis_block c
                                                               WHERE c.block_id = b.block_id
                                                                                     AND c.province_cd = NVL(p_province_cd, c.province_cd)
                                                                                     AND c.city_cd = NVL(p_city_cd, c.city_cd)
                                                                                     AND c.district_no = NVL(p_district_no, c.district_no)
                                                                                     AND c.block_no = NVL(p_block_no, c.block_no)))
                       ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
               LOOP
                  v_claim_nos := v_claim_nos || i.claim_id || ',';
               END LOOP;
            END;                  
         END IF;
      ELSE
         BEGIN
            FOR i IN(SELECT claim_id
                       FROM gicl_claims a
                      WHERE clm_stat_cd NOT IN ('WD', 'DN', 'CC', 'CD')
                        AND check_user_per_iss_cd2(line_cd, iss_cd, 'GICLS056',p_user_id) = 1
                        AND catastrophic_cd IS NULL
                        AND line_cd = 'FI'
                        AND (a.loss_cat_cd = p_loss_cat_cd
                              OR TRUNC(a.loss_date) BETWEEN TO_DATE(p_start_date,'MM-DD-YYYY')
                             AND TO_DATE(p_end_date, 'MM-DD-YYYY')
                              OR UPPER(NVL(a.loss_loc1||a.loss_loc2||a.loss_loc3,'@#$')) LIKE '%' || NVL(p_location,'$#@')||'%'
                              OR EXISTS (SELECT b.claim_id
                                           FROM gicl_fire_dtl b
                                          WHERE b.claim_id = a.claim_id
                                            AND b.block_id IN (SELECT c.block_id
                                                                 FROM giis_block c
                                                                WHERE c.province_cd = p_province_cd
                                                                   OR c.city_cd = p_city_cd
                                                                   OR c.district_no = p_district_no
                                                                   OR c.block_no = p_block_no)))
                   ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
            LOOP
               v_claim_nos := v_claim_nos || i.claim_id || ',';
            END LOOP;
         END;      
      END IF;
      
      RETURN v_claim_nos;
   END get_claim_nos_list_fi;
   
   PROCEDURE check_details (
      p_catastrophic_cd   IN VARCHAR2,
      p_user_id           IN VARCHAR2,
      p_res_amt           OUT NUMBER,
      p_pd_amt            OUT NUMBER,
      p_exists            OUT VARCHAR2
    )
    IS
    BEGIN
    
       gicls056_pkg.get_dsp_amt(p_catastrophic_cd, p_res_amt, p_pd_amt);
    
       BEGIN
          SELECT 'Y'
            INTO p_exists
            FROM gicl_cat_dtl a, gicl_claims b
           WHERE a.catastrophic_cd = p_catastrophic_cd
             AND a.catastrophic_cd = b.catastrophic_cd
             AND check_user_per_iss_cd2 (b.line_cd, b.iss_cd, 'GICLS056', p_user_id) = 1
             AND b.clm_stat_cd NOT IN ('WD', 'DN', 'CC')
             AND ROWNUM = 1;
       EXCEPTION WHEN NO_DATA_FOUND THEN
          p_exists := 'N';    
       END;
    END check_details;    

END;
/



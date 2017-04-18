CREATE OR REPLACE PACKAGE BODY CPI.override_pkg
IS
   CURSOR cur_itemds (
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE
   )
   IS
    SELECT SUM (a.tsi_amt) ann_tsi_amt
      FROM giri_basic_info_item_sum_v a,
           giuw_pol_dist b,
           giis_subline c,
           gicl_claims d
     WHERE a.policy_id = b.policy_id
       AND a.line_cd = c.line_cd
       AND a.subline_cd = c.subline_cd
       AND TO_DATE(CONCAT(TO_CHAR(TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(a.eff_date),
                                      DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), d.pol_eff_date, a.eff_date ),b.eff_date)) , 'MM/DD/YYYY'), 
                                      SUBSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'),' MM/DD/YYYY HH:MI AM'),
                                      INSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'), '/',1,2)+ 6)), 'MM/DD/YYYY HH:MI AM')
         <= d.loss_date 
       AND TO_DATE(CONCAT(TO_CHAR(TRUNC(DECODE(TRUNC(b.expiry_date),TRUNC(a.expiry_date),
                                      DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date, d.expiry_date,a.endt_expiry_date ),b.expiry_date)), 'MM/DD/YYYY'), 
                                      SUBSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'),' MM/DD/YYYY HH:MI AM'),
                                      INSTR (TO_CHAR (TO_DATE (c.subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'), '/',1,2)+ 6)), 'MM/DD/YYYY HH:MI AM')
         >= d.loss_date 
       AND a.item_no = p_item_no
       AND a.peril_cd = p_peril_cd
       AND a.line_cd = d.line_cd
       AND a.subline_cd = d.subline_cd
       AND a.iss_cd = d.pol_iss_cd
       AND a.issue_yy = d.issue_yy
       AND a.pol_seq_no = d.pol_seq_no
       AND a.renew_no = d.renew_no
       AND d.claim_id = p_claim_id
       AND b.dist_flag = giisp.v('DISTRIBUTED');

   CURSOR cur_perilds (
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE
   )
   IS
   SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw, f.acct_trty_type,
             SUM (d.dist_tsi) ann_dist_tsi, f.expiry_date
        FROM gipi_polbasic a,
             gipi_item b,
             giuw_pol_dist c,
             giuw_itemperilds_dtl d,
             giis_dist_share f,
             giis_parameters e,
             giis_subline g,
             gicl_claims h
       WHERE f.share_cd = d.share_cd
         AND f.line_cd = d.line_cd
         AND d.item_no = p_item_no
         AND d.peril_cd = p_peril_cd
         AND d.item_no = b.item_no
         AND d.dist_no = c.dist_no
         AND e.param_type = 'V'
         AND c.dist_flag = e.param_value_v
         AND e.param_name = 'DISTRIBUTED'
         AND c.policy_id = b.policy_id
         AND TO_DATE(CONCAT(TO_CHAR(TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(a.eff_date),
                                               DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), h.pol_eff_date, a.eff_date ),c.eff_date)), 'MM/DD/YYYY'), 
                                               SUBSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'),' MM/DD/YYYY HH:MI AM'),
                                               INSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'), '/',1,2)+ 6)), 'MM/DD/YYYY HH:MI AM') 
                  <= h.loss_date  
         AND TO_DATE(CONCAT(TO_CHAR(TRUNC(DECODE(TRUNC(c.expiry_date),TRUNC(a.expiry_date),
                                               DECODE(NVL(a.endt_expiry_date, a.expiry_date), a.expiry_date, h.expiry_date, a.endt_expiry_date), c.expiry_date)), 'MM/DD/YYYY'), 
                                               SUBSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'),' MM/DD/YYYY HH:MI AM'),
                                               INSTR (TO_CHAR (TO_DATE (g.subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'), '/',1,2)+ 6)), 'MM/DD/YYYY HH:MI AM') 
                  >= h.loss_date 
         AND b.policy_id = a.policy_id
         AND a.pol_flag IN ('1', '2', '3', 'X')
         AND a.line_cd = h.line_cd
         AND a.subline_cd = h.subline_cd
         AND a.iss_cd = h.pol_iss_cd
         AND a.issue_yy = h.issue_yy
         AND a.pol_seq_no = h.pol_seq_no
         AND a.renew_no = h.renew_no
         AND a.line_cd = g.line_cd
         AND a.subline_cd = g.subline_cd
         AND h.claim_id = p_claim_id
    GROUP BY a.line_cd,
             a.subline_cd,
             a.iss_cd,
             a.issue_yy,
             a.pol_seq_no,
             a.renew_no,
             d.share_cd,
             f.share_type,
             f.trty_yy,
             f.acct_trty_type,
             d.item_no,
             d.peril_cd,
             f.prtfolio_sw,
             f.expiry_date;
   
   CURSOR cur_xol (
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE
   )
   IS
   SELECT    a.share_cd, acct_trty_type, xol_allowed_amount, xol_base_amount,
             xol_allocated_amount, trty_yy, xol_aggregate_sum, a.line_cd,
             a.share_type
        FROM giis_dist_share a, giis_trty_peril b, gicl_claims c
       WHERE a.line_cd = b.line_cd
         AND a.share_cd = b.trty_seq_no
         AND a.share_type = '4'
         AND TRUNC (a.eff_date) <= TRUNC (c.dsp_loss_date)
         AND TRUNC (a.expiry_date) >= TRUNC (c.dsp_loss_date)
         AND b.peril_cd = p_peril_cd
         AND a.line_cd = c.line_cd
         AND c.claim_id = p_claim_id
       ORDER BY xol_base_amount ASC;
   
   PROCEDURE create_history (  --insert record in table GICL_OVERRIDE_HISTORY
      p_claim_id          gicl_override_history.claim_id%TYPE,
      p_user_id           gicl_override_history.user_id%TYPE,
      p_overriding_user   gicl_override_history.override_user_id%TYPE,
      p_module_id         gicl_override_history.module_id%TYPE,
      p_function_code     gicl_override_history.function_code%TYPE
   )
   IS
   BEGIN
      INSERT INTO gicl_override_history
                  (claim_id,
                   hist_seq_no,
                   user_id, override_user_id, override_date, module_id,
                   function_code
                  )
           VALUES (p_claim_id,
                   override_pkg.get_max_override_hist (p_claim_id) + 1,
                   p_user_id, p_overriding_user, SYSDATE, p_module_id,
                   p_function_code
                  );
                  
       COMMIT;
   END create_history;

   FUNCTION get_max_override_hist ( --get maximum history number per claim
      p_claim_id   gicl_override_history.claim_id%TYPE
   )                                    
      RETURN NUMBER
   IS
      v_hist_seq_no   gicl_override_history.hist_seq_no%TYPE := 0;
   BEGIN
      SELECT NVL(MAX (hist_seq_no), 0)
        INTO v_hist_seq_no
        FROM gicl_override_history
       WHERE claim_id = p_claim_id;

      RETURN (v_hist_seq_no);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN (0);
   END get_max_override_hist;
   
   FUNCTION get_ri_share_in_reserve ( --get RI Share amount in reserve of the current item peril 
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      p_loss_reserve      gicl_clm_res_hist.loss_reserve%TYPE,
      p_expense_reserve   gicl_clm_res_hist.expense_reserve%TYPE
   )
      RETURN NUMBER
   IS 
      v_total_amt           gicl_reserve_ds.shr_loss_res_amt%TYPE := NVL(p_loss_reserve, 0) + NVL(p_expense_reserve, 0);
      v_facul_treaty        gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_retention           gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_other_retention     gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_xol                 gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_retention_orig      gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_running_retention   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_total_retention     gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_total_xol_share     gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_overall_xol_share   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_old_xol_share       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
      v_xol_shr_pct         gicl_reserve_ds.shr_pct%TYPE;
      v_share_pct           gicl_reserve_ds.shr_pct%TYPE;
      v_first_layer         BOOLEAN := TRUE;
   BEGIN
      FOR itemds IN cur_itemds (p_claim_id, p_item_no, p_peril_cd)    
      LOOP
        FOR perilds IN cur_perilds (p_claim_id, p_item_no, p_peril_cd) 
        LOOP
            v_share_pct := perilds.ann_dist_tsi / itemds.ann_tsi_amt;
            IF perilds.share_type != 1 THEN --for Facul and Treaty
                v_facul_treaty := v_facul_treaty + (v_total_amt * v_share_pct);
            ELSE --compute XOL based on Net Retention
                FOR clm IN (SELECT a.catastrophic_cd, b.currency_rate
                              FROM gicl_claims a, gicl_clm_item b
                             WHERE a.claim_id = b.claim_id
                               AND b.claim_id = p_claim_id
                               AND b.item_no = p_item_no
                               AND ROWNUM = 1)
                LOOP
                    --get current net retention
                    v_retention :=  v_retention + (v_total_amt * v_share_pct) * clm.currency_rate;
                    v_retention_orig := v_retention;
                    v_running_retention := v_retention;
                    
                    --get net retention of other item peril (non-catastrophic) or other claims (catastrophic)
                    FOR total_net IN (SELECT SUM (  (  DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_loss_res_amt, 0),
                                                                 'CD', NVL (c.shr_loss_res_amt, 0),
                                                                 0
                                                                )
                                                       + DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_exp_res_amt, 0),
                                                                 'CD', NVL (c.shr_exp_res_amt, 0),
                                                                 0
                                                                )
                                                      )
                                                    * NVL (a.convert_rate, 1)
                                                   ) other_ret
                                          FROM gicl_clm_res_hist a,
                                               gicl_item_peril b,
                                               gicl_reserve_ds c,
                                               gicl_claims d
                                         WHERE a.claim_id = b.claim_id
                                           AND a.item_no = b.item_no
                                           AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                                           AND a.peril_cd = b.peril_cd
                                           AND (   a.claim_id != p_claim_id
                                                OR a.item_no != p_item_no
                                                OR a.peril_cd != p_peril_cd
                                               )
                                           AND NVL (a.dist_sw, 'N') = 'Y'
                                           AND a.claim_id = c.claim_id
                                           AND a.clm_res_hist_id = c.clm_res_hist_id
                                           AND NVL (c.negate_tag, 'N') = 'N'
                                           AND c.grp_seq_no = 1
                                           AND a.claim_id = d.claim_id
                                           AND DECODE (clm.catastrophic_cd, NULL, 1, d.catastrophic_cd) = NVL (clm.catastrophic_cd, 1)
                                           AND DECODE (clm.catastrophic_cd, NULL, p_claim_id, a.claim_id) = a.claim_id)
                    LOOP
                        v_other_retention := NVL(total_net.other_ret, 0);
                    END LOOP;
                    
                    v_total_retention := v_other_retention + v_retention; --get total retention

                    --get layers of xol in distribution share maintenance
                    FOR chk_xol IN cur_xol(p_claim_id, p_peril_cd)
                    LOOP
                        v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum, 0); --get XOL Aggregate Sum
                        
                        IF v_total_retention > chk_xol.xol_base_amount AND v_first_layer THEN --set retention to zero if total retention already exceeded Base Amount of first layer
                            v_retention := 0;
                        END IF;
                        --exit if no remaining running retention or total retention is less than or equal the in excess of amount of the first layer
                        IF v_running_retention = 0 OR (v_total_retention + v_xol <= chk_xol.xol_base_amount) THEN 
                            EXIT;
                            
                        --compute for retention amount if total retention minus current retention does not exceed In Excess of Amount of first layer
                        ELSIF (v_total_retention - v_retention_orig) < chk_xol.xol_base_amount AND v_first_layer THEN --for first xol layer only
                            v_retention := chk_xol.xol_base_amount - (v_total_retention - v_retention_orig); --retention should be based on in excess of amount minus net retention of other records.
                            v_running_retention := v_running_retention - v_retention; --update running retention.
                        END IF;
                   
                        v_first_layer := FALSE;
                        
                        FOR get_all_xol IN (SELECT SUM (  (  DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_loss_res_amt, 0),
                                                                 'CD', NVL (c.shr_loss_res_amt, 0),
                                                                 0
                                                                )
                                                       + DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_exp_res_amt, 0),
                                                                 'CD', NVL (c.shr_exp_res_amt, 0),
                                                                 0
                                                                )
                                                      )
                                                    * NVL (a.convert_rate, 1)
                                                   ) xol_amt
                                              FROM gicl_clm_res_hist a,
                                                   gicl_item_peril b,
                                                   gicl_reserve_ds c,
                                                   gicl_claims d
                                             WHERE a.claim_id = b.claim_id
                                               AND a.item_no = b.item_no
                                               AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                                               AND a.peril_cd = b.peril_cd
                                               AND (   a.claim_id != p_claim_id
                                                    OR a.item_no != p_item_no
                                                    OR a.peril_cd != p_peril_cd
                                                   )
                                               AND NVL (a.dist_sw, 'N') = 'Y'
                                               AND a.claim_id = c.claim_id
                                               AND a.clm_res_hist_id = c.clm_res_hist_id
                                               AND NVL (c.negate_tag, 'N') = 'N'
                                               AND c.grp_seq_no = chk_xol.share_cd
                                               AND a.claim_id = d.claim_id
                                               AND d.line_cd = chk_xol.line_cd)
                        LOOP
                            v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.xol_amt,0);    
                        END LOOP; --get_all_xol
                        
                        v_total_xol_share := 0;
                        v_old_xol_share := 0;
                        
                        FOR total_xol IN (SELECT SUM (  (  DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_loss_res_amt, 0),
                                                                 'CD', NVL (c.shr_loss_res_amt, 0),
                                                                 0
                                                                )
                                                       + DECODE (NVL (b.close_flag, 'AP'),
                                                                 'AP', NVL (c.shr_exp_res_amt, 0),
                                                                 'CD', NVL (c.shr_exp_res_amt, 0),
                                                                 0
                                                                )
                                                      )
                                                    * NVL (a.convert_rate, 1)
                                                   ) xol_amt
                                              FROM gicl_clm_res_hist a,
                                                   gicl_item_peril b,
                                                   gicl_reserve_ds c,
                                                   gicl_claims d
                                             WHERE a.claim_id = b.claim_id
                                               AND a.item_no = b.item_no
                                               AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                                               AND a.peril_cd = b.peril_cd
                                               AND (   a.claim_id != p_claim_id
                                                    OR a.item_no != p_item_no
                                                    OR a.peril_cd != p_peril_cd
                                                   )
                                               AND NVL (a.dist_sw, 'N') = 'Y'
                                               AND a.claim_id = c.claim_id
                                               AND a.clm_res_hist_id = c.clm_res_hist_id
                                               AND NVL (c.negate_tag, 'N') = 'N'
                                               AND c.grp_seq_no = chk_xol.share_cd
                                               AND a.claim_id = d.claim_id
                                               AND d.line_cd = chk_xol.line_cd
                                               AND DECODE (clm.catastrophic_cd, NULL, 1, d.catastrophic_cd) = NVL (clm.catastrophic_cd, 1)
                                               AND DECODE (clm.catastrophic_cd, NULL, p_claim_id, a.claim_id) = a.claim_id)
                        LOOP
                            v_old_xol_share   := NVL(total_xol.xol_amt,0);  
                        END LOOP; --total_xol
                        
                        IF v_overall_xol_share > chk_xol.xol_allowed_amount THEN
                            v_overall_xol_share := chk_xol.xol_allowed_amount; 
                        END IF;
                        
                        --if layer is not yet exhausted
                        IF (v_overall_xol_share - v_old_xol_share) > 0 AND v_running_retention > 0 THEN
                            IF v_running_retention <= (v_overall_xol_share - v_old_xol_share) THEN --insert running retention of current distribution if it is less than or equal remaining xol.
                                v_total_xol_share := v_running_retention;
                                v_running_retention := 0; --update running retention to disallow user from proceeding with other layers
                            ELSIF v_running_retention > (v_overall_xol_share - v_old_xol_share) THEN --insert difference of xol limit and total xol share per catastrophic or claim if retention of current distribution is greater than remaining xol.
                                v_total_xol_share := v_overall_xol_share - v_old_xol_share;
                                v_running_retention := v_running_retention - v_total_xol_share; --update v_running_retention for other layers
                            END IF;                
                        END IF;
                        
                        IF v_total_xol_share > 0 THEN
                            v_xol_shr_pct := v_total_xol_share/v_retention_orig;
                            v_xol := v_xol + v_retention_orig * v_xol_shr_pct;
                        END IF;
                    
                    END LOOP; --chk_xol
                    
                END LOOP; --clm
                
            END IF;  
        END LOOP; --perilds
      END LOOP; --itemds
      RETURN (v_facul_treaty + v_xol);
   END get_ri_share_in_reserve;
   
   FUNCTION get_other_ri_reserve ( --get RI Share amount of other item peril in same claim
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE  
   )   
      RETURN NUMBER
   IS
        v_other_ri_amt      gicl_clm_res_hist.loss_reserve%TYPE := 0;
   BEGIN
        FOR get_total IN (SELECT SUM ( ( DECODE (NVL (b.close_flag, 'AP'),
                                                 'AP', NVL (c.shr_loss_res_amt, 0),
                                                 'CD', NVL (c.shr_loss_res_amt, 0),
                                                 0
                                                )
                                       + DECODE (NVL (b.close_flag, 'AP'),
                                                 'AP', NVL (c.shr_exp_res_amt, 0),
                                                 'CD', NVL (c.shr_exp_res_amt, 0),
                                                 0
                                                )
                                      )
                                    * NVL (a.convert_rate, 1)
                                   ) other_reserve
                          FROM gicl_clm_res_hist a, gicl_item_peril b, gicl_reserve_ds c
                         WHERE a.claim_id = b.claim_id
                           AND a.item_no = b.item_no
                           AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                           AND a.peril_cd = b.peril_cd
                           AND a.claim_id = p_claim_id
                           AND (   a.item_no != p_item_no
                                OR NVL (a.grouped_item_no, 0) != NVL (p_grouped_item_no, 0)
                                OR a.peril_cd != p_peril_cd
                               )
                           AND NVL (a.dist_sw, 'N') = 'Y'
                           AND a.claim_id = c.claim_id
                           AND a.clm_res_hist_id = c.clm_res_hist_id
                           AND NVL(c.negate_tag, 'N') = 'N'
                           AND c.grp_seq_no != 1 )
         LOOP
            v_other_ri_amt := NVL(get_total.other_reserve, 0);
         END LOOP;
         
         RETURN (v_other_ri_amt);
   END get_other_ri_reserve;    
   
   FUNCTION validate_ri_reserve ( --check reserve amounts and parameter if valid
      p_user_id           gicl_clm_res_hist.user_id%TYPE,
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
      p_item_no           gicl_clm_res_hist.item_no%TYPE,
      p_grouped_item_no   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_peril_cd          gicl_clm_res_hist.peril_cd%TYPE,
      p_loss_reserve      gicl_clm_res_hist.loss_reserve%TYPE,
      p_expense_reserve   gicl_clm_res_hist.expense_reserve%TYPE
   )
      RETURN VARCHAR2
   IS 
        v_validate_res_sw   VARCHAR2 (1) :=  NVL(giacp.v('VALIDATE_RESERVE_WITH_RI'), 'N');
        v_all_ri_amt_sw     gicl_adv_line_amt.all_ri_amount_sw%TYPE;
        v_ri_range_to       gicl_adv_line_amt.ri_range_to%TYPE;
        v_other_ri_amt      gicl_clm_res_hist.loss_reserve%TYPE := 0;
        v_current_ri_amt    gicl_clm_res_hist.loss_reserve%TYPE := 0;
        v_ri_limit          VARCHAR2(50);
   BEGIN
        IF NOT check_user_override_function(p_user_id,'GICLS024','RS') THEN
            IF v_validate_res_sw != 'N' THEN
            
                SELECT NVL (a.all_ri_amount_sw, 'N'), NVL(ri_range_to, 0)
                  INTO v_all_ri_amt_sw, v_ri_range_to
                  FROM gicl_adv_line_amt a, gicl_claims b
                 WHERE a.adv_user = p_user_id
                   AND a.line_cd = b.line_cd
                   AND a.iss_cd = b.iss_cd
                   AND b.claim_id = p_claim_id;
                   
                IF v_all_ri_amt_sw = 'N' THEN --check amount if user has limited access
                    --get RI Share amount of other item, grouped item, or peril
                    
                     v_other_ri_amt := override_pkg.get_other_ri_reserve(p_claim_id, p_item_no, p_grouped_item_no, p_peril_cd);
                     v_current_ri_amt := override_pkg.get_ri_share_in_reserve(p_claim_id, p_item_no, p_peril_cd, p_loss_reserve, p_expense_reserve);
                     v_ri_limit := TRIM (TO_CHAR (v_ri_range_to, '999,999,999,990.90'));
                     
                     IF NVL(v_other_ri_amt, 0) + NVL(v_current_ri_amt, 0) > NVL(v_ri_range_to, 0) THEN
                        IF v_validate_res_sw = 'Y' THEN
                            RETURN ('Total RI Share cannot exceed ' || v_ri_limit);
                        ELSIF v_validate_res_sw = 'O' THEN
                            RETURN ('User is not allowed to distribute Total RI Share amount greater than ' || v_ri_limit ||'. Would you like to override?');
                        END IF;
                     END IF;
                    RETURN (NULL); --allow if total RI amount per claim does not exceed RI amount limit.
                END IF;
            ELSE --skip checking of parameter is not set to validate reserve with RI.
                RETURN (NULL);
            END IF;
        ELSE --skip checking of RI Limit if user is allowed to override
            --create history if logged-in user is valid to override.
      override_pkg.create_history(p_claim_id, p_user_id, p_user_id, 'GICLS024', 'RS');
            RETURN (NULL);
        END IF;
   
   EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN ('User is not allowed to make a reserve, please refer to the reserve maintenance.');     
   END validate_ri_reserve;  
   
   FUNCTION get_ri_share_in_settlement ( --get RI Share amount in settlement of the current item peril 
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE
   )
      RETURN NUMBER
   IS 
      v_total_amt           gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_facul_treaty        gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_retention           gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_other_retention     gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_xol                 gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_retention_orig      gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_running_retention   gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_total_retention     gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_total_xol_share     gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_overall_xol_share   gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_old_xol_share       gicl_clm_loss_exp.advise_amt%TYPE := 0;
      v_xol_shr_pct         gicl_loss_exp_ds.shr_loss_exp_pct%TYPE;
      v_share_pct           gicl_loss_exp_ds.shr_loss_exp_pct%TYPE;
      v_first_layer         BOOLEAN := TRUE;
      v_item_no             gicl_clm_loss_exp.item_no%TYPE;
      v_peril_cd            gicl_clm_loss_exp.peril_cd%TYPE;
   BEGIN
      SELECT item_no, peril_cd, advise_amt
        INTO v_item_no, v_peril_cd, v_total_amt
        FROM gicl_clm_loss_exp
       WHERE claim_id = p_claim_id
         AND clm_loss_id = p_clm_loss_id;
   
      FOR itemds IN cur_itemds (p_claim_id, v_item_no, v_peril_cd)    
      LOOP
        FOR perilds IN cur_perilds (p_claim_id, v_item_no, v_peril_cd) 
        LOOP
            v_share_pct := perilds.ann_dist_tsi / itemds.ann_tsi_amt;
            IF perilds.share_type != 1 THEN --for Facul and Treaty
                v_facul_treaty := v_facul_treaty + (v_total_amt * v_share_pct);
            ELSE --compute XOL based on Net Retention
                FOR clm IN (SELECT a.catastrophic_cd, b.currency_rate
                              FROM gicl_claims a, gicl_clm_item b
                             WHERE a.claim_id = b.claim_id
                               AND b.claim_id = p_claim_id
                               AND b.item_no = v_item_no
                               AND ROWNUM = 1)
                LOOP
                    --get current net retention
                    v_retention :=  v_retention + (v_total_amt * v_share_pct) * clm.currency_rate;
                    v_retention_orig := v_retention;
                    v_running_retention := v_retention;
                    
                    --get net retention of other item peril (non-catastrophic) or other claims (catastrophic)
                    FOR total_net IN (SELECT SUM(NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) other_ret
                                        FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b, gicl_claims c
                                       WHERE a.claim_id             = b.claim_id
                                         AND a.clm_loss_id          = b.clm_loss_id
                                         AND a.claim_id             = c.claim_id
                                         AND DECODE(clm.catastrophic_cd, NULL, 1, c.catastrophic_cd) = NVL(clm.catastrophic_cd, 1)
                                         AND DECODE(clm.catastrophic_cd, NULL, p_claim_id, a.claim_id) = a.claim_id
                                         AND (     b.claim_id != p_claim_id
                                                OR b.item_no != v_item_no
                                                OR b.peril_cd != v_peril_cd
                                             )
                                         AND a.share_type           = 1
                                         AND a.line_cd = c.line_cd
                                         AND NVL(b.cancel_sw, 'N')  = 'N'
                                         AND NVL(a.negate_tag, 'N') = 'N')
                    LOOP
                        v_other_retention := NVL(total_net.other_ret, 0);
                    END LOOP;
                    
                    v_total_retention := v_other_retention + v_retention; --get total retention

                    --get layers of xol in distribution share maintenance
                    FOR chk_xol IN cur_xol(p_claim_id, v_peril_cd)
                    LOOP
                        v_overall_xol_share := NVL(chk_xol.xol_aggregate_sum, 0); --get XOL Aggregate Sum
                        
                        IF v_total_retention > chk_xol.xol_base_amount AND v_first_layer THEN --set retention to zero if total retention already exceeded Base Amount of first layer
                            v_retention := 0;
                        END IF;
                        --exit if no remaining running retention or total retention is less than or equal the in excess of amount of the first layer
                        IF v_running_retention = 0 OR (v_total_retention + v_xol <= chk_xol.xol_base_amount) THEN 
                            EXIT;
                            
                        --compute for retention amount if total retention minus current retention does not exceed In Excess of Amount of first layer
                        ELSIF (v_total_retention - v_retention_orig) < chk_xol.xol_base_amount AND v_first_layer THEN --for first xol layer only
                            v_retention := chk_xol.xol_base_amount - (v_total_retention - v_retention_orig); --retention should be based on in excess of amount minus net retention of other records.
                            v_running_retention := v_running_retention - v_retention; --update running retention.
                        END IF;
                   
                        v_first_layer := FALSE;
                        
                        FOR get_all_xol IN (SELECT SUM (NVL (a.shr_le_adv_amt, 0) * NVL (b.currency_rate, 0)) xol_amt
                                              FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                                             WHERE a.claim_id = b.claim_id
                                               AND a.clm_loss_id = b.clm_loss_id
                                               AND NVL (b.cancel_sw, 'N') = 'N'
                                               AND NVL (a.negate_tag, 'N') = 'N'
                                               AND grp_seq_no = chk_xol.share_cd
                                               AND line_cd = chk_xol.line_cd)
                        LOOP
                            v_overall_xol_share := v_overall_xol_share - NVL(get_all_xol.xol_amt,0);    
                        END LOOP; --get_all_xol
                        
                        v_total_xol_share := 0;
                        v_old_xol_share := 0;
                        
                        FOR total_xol IN (SELECT SUM (NVL (a.shr_le_adv_amt, 0) * NVL (b.currency_rate, 0)) xol_amt
                                            FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b, gicl_claims c
                                           WHERE 1 = 1
                                             AND a.claim_id = b.claim_id
                                             AND a.clm_loss_id = b.clm_loss_id
                                             AND NVL (b.cancel_sw, 'N') = 'N'
                                             AND NVL (a.negate_tag, 'N') = 'N'
                                             AND grp_seq_no = chk_xol.share_cd
                                             AND c.claim_id = b.claim_id
                                             AND DECODE (clm.catastrophic_cd, NULL, 1, c.catastrophic_cd) = NVL (clm.catastrophic_cd, 1)
                                             AND DECODE(clm.catastrophic_cd, NULL, p_claim_id, a.claim_id) = a.claim_id
                                             AND a.line_cd = c.line_cd)
                        LOOP
                            v_old_xol_share   := NVL(total_xol.xol_amt,0);  
                        END LOOP; --total_xol
                        
                        IF v_overall_xol_share > chk_xol.xol_allowed_amount THEN
                            v_overall_xol_share := chk_xol.xol_allowed_amount; 
                        END IF;
                        
                        --if layer is not yet exhausted
                        IF (v_overall_xol_share - v_old_xol_share) > 0 AND v_running_retention > 0 THEN
                            IF v_running_retention <= (v_overall_xol_share - v_old_xol_share) THEN --insert running retention of current distribution if it is less than or equal remaining xol.
                                v_total_xol_share := v_running_retention;
                                v_running_retention := 0; --update running retention to disallow user from proceeding with other layers
                            ELSIF v_running_retention > (v_overall_xol_share - v_old_xol_share) THEN --insert difference of xol limit and total xol share per catastrophic or claim if retention of current distribution is greater than remaining xol.
                                v_total_xol_share := v_overall_xol_share - v_old_xol_share;
                                v_running_retention := v_running_retention - v_total_xol_share; --update v_running_retention for other layers
                            END IF;                
                        END IF;
                        
                        IF v_total_xol_share > 0 THEN
                            v_xol_shr_pct := v_total_xol_share/v_retention_orig;
                            v_xol := v_xol + v_retention_orig * v_xol_shr_pct;
                        END IF;
                    
                    END LOOP; --chk_xol
                    
                END LOOP; --clm
                
            END IF;  
        END LOOP; --perilds
      END LOOP; --itemds
      RETURN (v_facul_treaty + v_xol);
   END get_ri_share_in_settlement;
   
   FUNCTION get_other_ri_settlement ( --get RI Share amount of other item peril in same claim
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE  
   )   
      RETURN NUMBER
   IS
        v_other_ri_amt    gicl_clm_loss_exp.advise_amt%TYPE := 0;
   BEGIN
        FOR get_total IN (SELECT SUM(b.shr_le_adv_amt) other_settlement
                            FROM gicl_clm_loss_exp a, gicl_loss_exp_ds b
                           WHERE a.claim_id = b.claim_id
                             AND a.clm_loss_id = b.clm_loss_id
                             AND NVL (a.dist_sw, 'N') = 'Y'
                             AND NVL (b.negate_tag, 'N') = 'N'
                             AND a.claim_id = p_claim_id
                             AND a.clm_loss_id != p_clm_loss_id
                             AND b.grp_seq_no != 1)
         LOOP
            v_other_ri_amt := NVL(get_total.other_settlement, 0);
         END LOOP;
         
         RETURN (v_other_ri_amt);
   END get_other_ri_settlement;
      
   FUNCTION validate_ri_settlement ( --check settlement amounts and parameter if valid
      p_user_id           gicl_clm_loss_exp.user_id%TYPE,
      p_claim_id          gicl_clm_loss_exp.claim_id%TYPE,
      p_clm_loss_id       gicl_clm_loss_exp.clm_loss_id%TYPE
   )
      RETURN VARCHAR2
   IS 
        v_validate_le_sw    VARCHAR2 (1) :=  NVL(giacp.v('VALIDATE_LE_WITH_RI'), 'N');
        v_all_ri_amt_sw     gicl_adv_line_amt.all_ri_amount_sw%TYPE := 'N';
        v_ri_range_to       gicl_adv_line_amt.ri_range_to%TYPE := 0;
        v_other_ri_amt      gicl_clm_loss_exp.advise_amt%TYPE := 0;
        v_current_ri_amt    gicl_clm_loss_exp.advise_amt%TYPE := 0;
        v_ri_limit          VARCHAR2(50);
   BEGIN
        IF NOT check_user_override_function(p_user_id,'GICLS030','RS') THEN
            IF v_validate_le_sw != 'N' THEN
            
                FOR ri IN ( SELECT NVL (a.all_ri_amount_sw, 'N') all_ri_amount_sw, NVL(ri_range_to, 0) ri_range_to
                              FROM gicl_adv_line_amt a, gicl_claims b
                             WHERE a.adv_user = p_user_id
                               AND a.line_cd = b.line_cd
                               AND a.iss_cd = b.iss_cd
                               AND b.claim_id = p_claim_id)
                LOOP
                    v_all_ri_amt_sw := ri.all_ri_amount_sw;
                    v_ri_range_to := ri.ri_range_to;
                END LOOP;
                   
                IF v_all_ri_amt_sw = 'N' THEN --check amount if user has limited access
                    --get RI Share amount of other item, grouped item, or peril
                    
                     v_other_ri_amt := override_pkg.get_other_ri_settlement(p_claim_id, p_clm_loss_id);
                     v_current_ri_amt := override_pkg.get_ri_share_in_settlement(p_claim_id, p_clm_loss_id);
                     v_ri_limit := TRIM (TO_CHAR (v_ri_range_to, '999,999,999,990.90'));
                     
                     IF NVL(v_other_ri_amt, 0) + NVL(v_current_ri_amt, 0) > NVL(v_ri_range_to, 0) THEN
                        IF v_validate_le_sw = 'Y' THEN
                            RETURN ('Loss Advise Amount cannot exceed ' || v_ri_limit);
                        ELSIF v_validate_le_sw = 'O' THEN
                            RETURN ('User is not allowed to distribute Total RI Share amount greater than ' || v_ri_limit ||'. Would you like to override?');
                        END IF;
                     END IF;
                    RETURN (NULL); --allow if total RI amount per claim does not exceed RI amount limit.
                END IF;
            ELSE --skip checking of parameter is not set to validate settlement with RI.
                RETURN (NULL);
            END IF;
        ELSE --skip checking of RI Limit if user is allowed to override
            --create history if logged-in user is valid to override.
      override_pkg.create_history(p_claim_id, p_user_id, p_user_id, 'GICLS030', 'RS');
            RETURN (NULL);
        END IF;
   END validate_ri_settlement;
   
   PROCEDURE check_request ( --check override request per claim
      p_module_name       giac_modules.module_name%TYPE,
      p_function_cd       gicl_function_override.function_cd%TYPE,
      p_claim_id          gicl_function_override_dtl.function_col_val%TYPE,
      p_request_status    OUT NUMBER,
      p_user_id           OUT gicl_function_override.override_user%TYPE
   )
   IS
      v_exist     NUMBER := 0;
      v_approved  NUMBER := 0; 
   BEGIN
      FOR i IN (SELECT c.override_user, c.override_date
                  FROM giac_function_columns a,
                       giac_modules b,
                       gicl_function_override c,
                       gicl_function_override_dtl d
                 WHERE a.module_id = b.module_id
                   AND b.module_name = p_module_name
                   AND a.function_cd = p_function_cd
                   AND a.module_id = c.module_id
                   AND a.function_cd = c.function_cd
                   AND c.override_id = d.override_id
                   AND d.function_col_cd = a.function_col_cd
                   AND d.function_col_val = p_claim_id
                 ORDER BY c.override_date)
      LOOP
        v_exist := 1;
        
        IF i.override_user IS NOT NULL THEN
            v_approved := 1;
            p_user_id := i.override_user;
            EXIT;
        END IF;
      END LOOP;
           
      IF v_approved = 1 THEN
        p_request_status := 2;
      ELSE  
        p_request_status := v_exist;
      END IF;
   END check_request;  
      
   PROCEDURE update_ri_stat ( --procedure to update RI Stat in Claim Basic Information if distribution includes share type 2,3,or 4
      p_claim_id          gicl_clm_res_hist.claim_id%TYPE
   )
   IS
        v_exists    NUMBER(1) := 0;
   BEGIN
     
     FOR i IN (SELECT 1
                 FROM gicl_reserve_ds b, gicl_clm_res_hist c
                WHERE b.claim_id = p_claim_id
                  AND b.claim_id = c.claim_id
                  AND b.clm_res_hist_id = c.clm_res_hist_id
                  AND NVL(c.dist_sw, 'N') = 'Y'
                  AND NVL(b.negate_tag, 'N') = 'N'
                  AND b.share_type IN (2,3,4)
                  AND ROWNUM = 1 )
     LOOP
        v_exists := 1;
     END LOOP;
        
     FOR i IN (SELECT 1
                 FROM gicl_loss_exp_ds d, gicl_clm_loss_exp e
                WHERE d.claim_id = p_claim_id
                  AND d.claim_id = e.claim_id
                  AND d.clm_loss_id = e.clm_loss_id
                  AND NVL(e.dist_sw, 'N') = 'Y'
                  AND NVL(d.negate_tag, 'N') = 'N'
                  AND d.share_type IN (2,3,4)
                  AND ROWNUM = 1 )
     LOOP
        v_exists := 1;
     END LOOP;   
        
     IF v_exists = 0 THEN --if no Share Type 2,3,4 in Reserve or Settlement distribution
        UPDATE gicl_claims a
         SET a.ri_stat = NULL
       WHERE a.claim_id = p_claim_id;
     ELSE --with Share Type 2,3,4 in Reserve or Settlement distribution
        UPDATE gicl_claims a
         SET a.ri_stat = 'Y'
       WHERE a.claim_id = p_claim_id;
     END IF;
        COMMIT;
   END update_ri_stat;
   
   PROCEDURE create_request_override ( --procedure to create override request
      p_module_name       giac_modules.module_name%TYPE,
      p_function_cd       gicl_function_override.function_cd%TYPE,
      p_claim_id          gicl_function_override_dtl.function_col_val%TYPE,
      p_user_id           gicl_function_override.override_user%TYPE,
      p_remarks           gicl_function_override.remarks%TYPE
   )
   IS
        v_ovrd_id    gicl_function_override.override_id%TYPE;
        v_module_id    giac_modules.module_id%TYPE;
        v_func_cl_cd   giac_function_columns.function_col_cd%TYPE;
        v_line_cd           gicl_claims.line_cd%TYPE;
        v_iss_cd            gicl_claims.iss_cd%TYPE;
   BEGIN
    SELECT NVL(MAX(override_id),0) + 1
     INTO v_ovrd_id
     FROM gicl_function_override;
   
    SELECT module_id
      INTO v_module_id
      FROM giac_modules
     WHERE module_name = p_module_name;
     
    SELECT function_col_cd
     INTO v_func_cl_cd
     FROM giac_function_columns
     WHERE module_id = v_module_id
       AND function_cd = p_function_cd
       AND column_name = 'CLAIM_ID'; 
       
    SELECT line_cd, iss_cd
      INTO v_line_cd, v_iss_cd
      FROM gicl_claims
     WHERE claim_id = p_claim_id;
   
    INSERT INTO gicl_function_override
                (override_id, line_cd, iss_cd, module_id, function_cd,
                 display, request_date, request_by, remarks
                )
         VALUES (v_ovrd_id, v_line_cd, v_iss_cd, v_module_id, p_function_cd,
                 get_claim_info(p_claim_id), SYSDATE, p_user_id, p_remarks
                );

    INSERT INTO gicl_function_override_dtl
                (override_id, function_col_cd, function_col_val
                )
         VALUES (v_ovrd_id, v_func_cl_cd, p_claim_id
                );
    COMMIT;            
   END create_request_override;
      
END override_pkg;
/



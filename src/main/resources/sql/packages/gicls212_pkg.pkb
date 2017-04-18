CREATE OR REPLACE PACKAGE BODY CPI.GICLS212_PKG
   /*
   **  Created by        : bonok
   **  Date Created      : 09.12.2013
   **  Reference By      : GICLS212 - VIEW LOSS PROFILE DETAILS
   **
   */
AS
   FUNCTION get_summary_list(
      p_global_choice         VARCHAR2,
      p_global_treaty         VARCHAR2,
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN summary_tab PIPELINED AS
      summ                    summary_type;
      sum_policy_count        gicl_loss_profile.policy_count%TYPE := 0;
      sum_total_tsi_amt       gicl_loss_profile.total_tsi_amt%TYPE := 0;
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE := 0;
      sum_net_retention       gicl_loss_profile.net_retention%TYPE := 0;
      sum_facultative         gicl_loss_profile.facultative%TYPE := 0;
      sum_treaty              gicl_loss_profile.treaty%TYPE := 0;
      v_sum_nbt_gross_loss    NUMBER(16, 2);
      v_sum_nbt_net_ret       NUMBER(16, 2);
      v_sum_nbt_treaty        NUMBER(16, 2);
      v_sum_nbt_facul         NUMBER(16, 2);
   BEGIN
--      FOR i IN(SELECT sum_nbt_gross_loss, sum_net_retention, sum_treaty, sum_facultative
--                 FROM TABLE(gicls212_pkg.get_sum_summary_list(p_global_choice, p_global_treaty, p_global_line_cd, p_global_subline_cd, p_user_id))
--                ORDER BY ROWNUM DESC)
--      LOOP
--         v_sum_nbt_gross_loss := i.sum_nbt_gross_loss;
--         v_sum_nbt_net_ret := i.sum_net_retention;
--         v_sum_nbt_treaty := i.sum_treaty;
--         v_sum_nbt_facul := i.sum_facultative; 
--         EXIT;
--      END LOOP;   
   
      IF p_global_choice = 'L' THEN
         FOR i IN (SELECT *
                     FROM gicl_loss_profile
                    WHERE line_cd = NVL(p_global_line_cd,line_cd)
		                AND NVL(subline_cd,'***') = NVL(p_global_subline_cd,'***')
		                AND user_id = UPPER(p_user_id))
         LOOP
            summ.range_from               := i.range_from;
            summ.range_to                 := i.range_to;
            summ.policy_count             := i.policy_count;
            summ.total_tsi_amt            := i.total_tsi_amt;
            summ.net_retention            := i.net_retention;
            summ.sec_net_retention_loss   := i.sec_net_retention_loss;
            summ.facultative              := i.facultative;
            summ.treaty1_loss             := NVL(i.treaty1_loss, 0);
            summ.treaty2_loss             := NVL(i.treaty2_loss, 0);
            summ.treaty3_loss             := NVL(i.treaty3_loss, 0);
            summ.treaty4_loss             := NVL(i.treaty4_loss, 0);
            summ.treaty5_loss             := NVL(i.treaty5_loss, 0);
            summ.treaty6_loss             := NVL(i.treaty6_loss, 0);
            summ.treaty7_loss             := NVL(i.treaty7_loss, 0);
            summ.treaty8_loss             := NVL(i.treaty8_loss, 0);
            summ.treaty9_loss             := NVL(i.treaty9_loss, 0);
            summ.treaty10_loss            := NVL(i.treaty10_loss, 0);
            summ.treaty                   := i.treaty;
            summ.quota_share              := i.quota_share;
            
            IF p_global_treaty = 'N' THEN
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.treaty,0) + NVL(summ.facultative,0);
            ELSE
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.facultative,0) + NVL(summ.sec_net_retention_loss,0) + 
	 	                                NVL(summ.treaty1_loss,0) + NVL(summ.treaty2_loss,0) + NVL(summ.treaty3_loss,0) + NVL(summ.treaty4_loss,0) + 
	 	                                NVL(summ.treaty5_loss,0) + NVL(summ.treaty6_loss,0) + NVL(summ.treaty7_loss,0) + NVL(summ.treaty8_loss,0) + 
	 	                                NVL(summ.treaty9_loss,0) + NVL(summ.treaty10_loss,0) + NVL(summ.quota_share, 0);
            END IF;
            
            sum_policy_count := sum_policy_count + summ.policy_count;
            sum_total_tsi_amt := sum_total_tsi_amt + summ.total_tsi_amt;
            sum_nbt_gross_loss := sum_nbt_gross_loss + summ.nbt_gross_loss;
            sum_net_retention := sum_net_retention + summ.net_retention;
            sum_facultative := sum_facultative + summ.facultative;
            sum_treaty := sum_treaty + summ.treaty;
            
            summ.sum_policy_count := sum_policy_count;
            summ.sum_total_tsi_amt := sum_total_tsi_amt;
            summ.sum_nbt_gross_loss := sum_nbt_gross_loss;
            summ.sum_net_retention := sum_net_retention;
            summ.sum_facultative := sum_facultative;
            summ.sum_treaty := sum_treaty;
            
            FOR num IN 1..10
            LOOP
               FOR rec IN (SELECT INITCAP(trty_name) trty
	                          FROM giis_dist_share
		                      WHERE line_cd = p_global_line_cd
	                           AND share_cd = num)
               LOOP
                  IF num = 1 THEN
                     summ.lbl1 := NVL(rec.trty, 'Treaty1');
                  ELSIF num = 2 THEN
                     summ.lbl2 := NVL(rec.trty, 'Treaty2');
                  ELSIF num = 3 THEN
                     summ.lbl3 := NVL(rec.trty, 'Treaty3');
                  ELSIF num = 4 THEN
                     summ.lbl4 := NVL(rec.trty, 'Treaty4');
                  ELSIF num = 5 THEN
                     summ.lbl5 := NVL(rec.trty, 'Treaty5');
                  ELSIF num = 6 THEN
                     summ.lbl6 := NVL(rec.trty, 'Treaty6');
                  ELSIF num = 7 THEN
                     summ.lbl7 := NVL(rec.trty, 'Treaty7');
                  ELSIF num = 8 THEN
                     summ.lbl8 := NVL(rec.trty, 'Treaty8');
                  ELSIF num = 9 THEN
                     summ.lbl9 := NVL(rec.trty, 'Treaty9');
                  ELSIF num = 10 THEN
                     summ.lbl10 := NVL(rec.trty, 'Treaty10');
                  END IF;
               END LOOP;
            END LOOP;
            
            PIPE ROW(summ);
         END LOOP;
      ELSE
         FOR i IN (SELECT *
                     FROM gicl_loss_profile
                    WHERE line_cd = NVL(p_global_line_cd,line_cd)
		                AND NVL(subline_cd,'1') = NVL(p_global_subline_cd,'2')
		                AND user_id = UPPER(p_user_id)
                        AND check_user_per_line2(line_cd, NULL, 'GICLS212', p_user_id) = 1) -- andrew 2.21.2014 - added for user security access
         LOOP
            summ.range_from               := i.range_from;
            summ.range_to                 := i.range_to;
            summ.policy_count             := i.policy_count;
            summ.total_tsi_amt            := i.total_tsi_amt;
            summ.net_retention            := i.net_retention;
            summ.sec_net_retention_loss   := i.sec_net_retention_loss;
            summ.facultative              := i.facultative;
            summ.treaty1_loss             := i.treaty1_loss;
            summ.treaty2_loss             := i.treaty2_loss;
            summ.treaty3_loss             := i.treaty3_loss;
            summ.treaty4_loss             := i.treaty4_loss;
            summ.treaty5_loss             := i.treaty5_loss;
            summ.treaty6_loss             := i.treaty6_loss;
            summ.treaty7_loss             := i.treaty7_loss;
            summ.treaty8_loss             := i.treaty8_loss;
            summ.treaty9_loss             := i.treaty9_loss;
            summ.treaty10_loss            := i.treaty10_loss;
            summ.treaty                   := i.treaty;
            summ.quota_share              := i.quota_share;
            
            IF p_global_treaty = 'N' THEN
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.treaty,0) + NVL(summ.facultative,0);
            ELSE
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.facultative,0) + NVL(summ.sec_net_retention_loss,0) + 
	 	                                NVL(summ.treaty1_loss,0) + NVL(summ.treaty2_loss,0) + NVL(summ.treaty3_loss,0) + NVL(summ.treaty4_loss,0) + 
	 	                                NVL(summ.treaty5_loss,0) + NVL(summ.treaty6_loss,0) + NVL(summ.treaty7_loss,0) + NVL(summ.treaty8_loss,0) + 
	 	                                NVL(summ.treaty9_loss,0) + NVL(summ.treaty10_loss,0) + NVL(summ.quota_share, 0);
            END IF;
            
            sum_policy_count := sum_policy_count + summ.policy_count;
            sum_total_tsi_amt := sum_total_tsi_amt + summ.total_tsi_amt;
            sum_nbt_gross_loss := sum_nbt_gross_loss + summ.nbt_gross_loss;
            sum_net_retention := sum_net_retention + summ.net_retention;
            sum_facultative := sum_facultative + summ.facultative;
            sum_treaty := sum_treaty + summ.treaty;
            
            summ.sum_policy_count := sum_policy_count;
            summ.sum_total_tsi_amt := sum_total_tsi_amt;
            summ.sum_nbt_gross_loss := sum_nbt_gross_loss;
            summ.sum_net_retention := sum_net_retention;
            summ.sum_facultative := sum_facultative;
            summ.sum_treaty := sum_treaty;
         
            PIPE ROW(summ);
         END LOOP;
      END IF;
   END get_summary_list;
   
   FUNCTION get_sum_summary_list(
      p_global_choice         VARCHAR2,
      p_global_treaty         VARCHAR2,
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN summary_tab PIPELINED AS
      summ                    summary_type;
      sum_policy_count        gicl_loss_profile.policy_count%TYPE := 0;
      sum_total_tsi_amt       gicl_loss_profile.total_tsi_amt%TYPE := 0;
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE := 0;
      sum_net_retention       gicl_loss_profile.net_retention%TYPE := 0;
      sum_facultative         gicl_loss_profile.facultative%TYPE := 0;
      sum_treaty              gicl_loss_profile.treaty%TYPE := 0;
   BEGIN
      IF p_global_choice = 'L' THEN
         FOR i IN (SELECT *
                     FROM gicl_loss_profile
                    WHERE line_cd = NVL(p_global_line_cd,line_cd)
		                AND NVL(subline_cd,'***') = NVL(p_global_subline_cd,'***')
		                AND user_id = UPPER(p_user_id))
         LOOP
            summ.range_from               := i.range_from;
            summ.range_to                 := i.range_to;
            summ.policy_count             := i.policy_count;
            summ.total_tsi_amt            := i.total_tsi_amt;
            summ.net_retention            := i.net_retention;
            summ.sec_net_retention_loss   := i.sec_net_retention_loss;
            summ.facultative              := i.facultative;
            summ.treaty1_loss             := i.treaty1_loss;
            summ.treaty2_loss             := i.treaty2_loss;
            summ.treaty3_loss             := i.treaty3_loss;
            summ.treaty4_loss             := i.treaty4_loss;
            summ.treaty5_loss             := i.treaty5_loss;
            summ.treaty6_loss             := i.treaty6_loss;
            summ.treaty7_loss             := i.treaty7_loss;
            summ.treaty8_loss             := i.treaty8_loss;
            summ.treaty9_loss             := i.treaty9_loss;
            summ.treaty10_loss            := i.treaty10_loss;
            summ.treaty                   := i.treaty;
            summ.quota_share              := i.quota_share;
            
            IF p_global_treaty = 'N' THEN
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.treaty,0) + NVL(summ.facultative,0);
            ELSE
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.facultative,0) + NVL(summ.sec_net_retention_loss,0) + 
	 	                                NVL(summ.treaty1_loss,0) + NVL(summ.treaty2_loss,0) + NVL(summ.treaty3_loss,0) + NVL(summ.treaty4_loss,0) + 
	 	                                NVL(summ.treaty5_loss,0) + NVL(summ.treaty6_loss,0) + NVL(summ.treaty7_loss,0) + NVL(summ.treaty8_loss,0) + 
	 	                                NVL(summ.treaty9_loss,0) + NVL(summ.treaty10_loss,0) + NVL(summ.quota_share, 0);
            END IF;
            
            sum_policy_count := sum_policy_count + summ.policy_count;
            sum_total_tsi_amt := sum_total_tsi_amt + summ.total_tsi_amt;
            sum_nbt_gross_loss := sum_nbt_gross_loss + summ.nbt_gross_loss;
            sum_net_retention := sum_net_retention + summ.net_retention;
            sum_facultative := sum_facultative + summ.facultative;
            sum_treaty := sum_treaty + summ.treaty;
            
            summ.sum_policy_count := sum_policy_count;
            summ.sum_total_tsi_amt := sum_total_tsi_amt;
            summ.sum_nbt_gross_loss := sum_nbt_gross_loss;
            summ.sum_net_retention := sum_net_retention;
            summ.sum_facultative := sum_facultative;
            summ.sum_treaty := sum_treaty;
            
            FOR num IN 1..10
            LOOP
               FOR rec IN (SELECT INITCAP(trty_name) trty
	                          FROM giis_dist_share
		                      WHERE line_cd = p_global_line_cd
	                           AND share_cd = num)
               LOOP
                  IF num = 1 THEN
                     summ.lbl1 := NVL(rec.trty, 'Treaty1');
                  ELSIF num = 2 THEN
                     summ.lbl2 := NVL(rec.trty, 'Treaty2');
                  ELSIF num = 3 THEN
                     summ.lbl3 := NVL(rec.trty, 'Treaty3');
                  ELSIF num = 4 THEN
                     summ.lbl4 := NVL(rec.trty, 'Treaty4');
                  ELSIF num = 5 THEN
                     summ.lbl5 := NVL(rec.trty, 'Treaty5');
                  ELSIF num = 6 THEN
                     summ.lbl6 := NVL(rec.trty, 'Treaty6');
                  ELSIF num = 7 THEN
                     summ.lbl7 := NVL(rec.trty, 'Treaty7');
                  ELSIF num = 8 THEN
                     summ.lbl8 := NVL(rec.trty, 'Treaty8');
                  ELSIF num = 9 THEN
                     summ.lbl9 := NVL(rec.trty, 'Treaty9');
                  ELSIF num = 10 THEN
                     summ.lbl10 := NVL(rec.trty, 'Treaty10');
                  END IF;
               END LOOP;
            END LOOP;
            
            PIPE ROW(summ);
         END LOOP;
      ELSE
         FOR i IN (SELECT *
                     FROM gicl_loss_profile
                    WHERE line_cd = NVL(p_global_line_cd,line_cd)
		                AND NVL(subline_cd,'1') = NVL(p_global_subline_cd,'2')
		                AND user_id = UPPER(p_user_id))
         LOOP
            summ.range_from               := i.range_from;
            summ.range_to                 := i.range_to;
            summ.policy_count             := i.policy_count;
            summ.total_tsi_amt            := i.total_tsi_amt;
            summ.net_retention            := i.net_retention;
            summ.sec_net_retention_loss   := i.sec_net_retention_loss;
            summ.facultative              := i.facultative;
            summ.treaty1_loss             := i.treaty1_loss;
            summ.treaty2_loss             := i.treaty2_loss;
            summ.treaty3_loss             := i.treaty3_loss;
            summ.treaty4_loss             := i.treaty4_loss;
            summ.treaty5_loss             := i.treaty5_loss;
            summ.treaty6_loss             := i.treaty6_loss;
            summ.treaty7_loss             := i.treaty7_loss;
            summ.treaty8_loss             := i.treaty8_loss;
            summ.treaty9_loss             := i.treaty9_loss;
            summ.treaty10_loss            := i.treaty10_loss;
            summ.treaty                   := i.treaty;
            summ.quota_share              := i.quota_share;
            
            IF p_global_treaty = 'N' THEN
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.treaty,0) + NVL(summ.facultative,0);
            ELSE
               summ.nbt_gross_loss := NVL(summ.net_retention,0) + NVL(summ.facultative,0) + NVL(summ.sec_net_retention_loss,0) + 
	 	                                NVL(summ.treaty1_loss,0) + NVL(summ.treaty2_loss,0) + NVL(summ.treaty3_loss,0) + NVL(summ.treaty4_loss,0) + 
	 	                                NVL(summ.treaty5_loss,0) + NVL(summ.treaty6_loss,0) + NVL(summ.treaty7_loss,0) + NVL(summ.treaty8_loss,0) + 
	 	                                NVL(summ.treaty9_loss,0) + NVL(summ.treaty10_loss,0) + NVL(summ.quota_share, 0);
            END IF;
            
            sum_policy_count := sum_policy_count + summ.policy_count;
            sum_total_tsi_amt := sum_total_tsi_amt + summ.total_tsi_amt;
            sum_nbt_gross_loss := sum_nbt_gross_loss + summ.nbt_gross_loss;
            sum_net_retention := sum_net_retention + summ.net_retention;
            sum_facultative := sum_facultative + summ.facultative;
            sum_treaty := sum_treaty + summ.treaty;
            
            summ.sum_policy_count := sum_policy_count;
            summ.sum_total_tsi_amt := sum_total_tsi_amt;
            summ.sum_nbt_gross_loss := sum_nbt_gross_loss;
            summ.sum_net_retention := sum_net_retention;
            summ.sum_facultative := sum_facultative;
            summ.sum_treaty := sum_treaty;
         
            PIPE ROW(summ);
         END LOOP;
      END IF;
   END get_sum_summary_list;
   
   FUNCTION get_range_list(
      p_global_line_cd        gicl_loss_profile.line_cd%TYPE,
      p_global_subline_cd     gicl_loss_profile.subline_cd%TYPE
   ) RETURN range_tab PIPELINED AS
      range                   range_type;
   BEGIN
      FOR i IN (SELECT range_from, range_to
                  FROM gicl_loss_profile
                 WHERE line_cd = NVL(p_global_line_cd, line_cd)
                   AND NVL(subline_cd, 1) = NVL(p_global_subline_cd, 1))
      LOOP
         range.range_from := i.range_from;
         range.range_to := i.range_to;
         
         PIPE ROW(range);
      END LOOP;
   END get_range_list;
   
   FUNCTION get_detail_list(
      p_global_extr           VARCHAR2,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN detail_tab PIPELINED AS
      dtl                     detail_type;
      v_net_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_facultative           gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_treaty                gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_close_sw              gicl_loss_profile_ext3.close_sw%TYPE;
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_net_ret         gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_treaty          gicl_loss_profile.treaty%TYPE := 0;
      sum_nbt_facul           gicl_loss_profile.facultative%TYPE := 0;
      v_sum_nbt_gross_loss    NUMBER(16, 2);
      v_sum_nbt_net_ret       NUMBER(16, 2);
      v_sum_nbt_treaty        NUMBER(16, 2);
      v_sum_nbt_facul         NUMBER(16, 2);
   BEGIN
      FOR i IN(SELECT sum_nbt_gross_loss, sum_nbt_net_ret, sum_nbt_treaty, sum_nbt_facul
                 FROM TABLE(gicls212_pkg.get_sum_detail_list(p_global_extr, p_range_from, p_range_to, p_line_cd, p_subline_cd, p_user_id))
                ORDER BY ROWNUM DESC)
      LOOP
         v_sum_nbt_gross_loss := i.sum_nbt_gross_loss;
         v_sum_nbt_net_ret := i.sum_nbt_net_ret;
         v_sum_nbt_treaty := i.sum_nbt_treaty;
         v_sum_nbt_facul := i.sum_nbt_facul; 
         EXIT;
      END LOOP;         
   
      IF p_global_extr = '1' THEN
         FOR i IN (SELECT a.tsi_amt, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, b.loss_date, b.iss_cd, b.clm_yy, 
                          b.clm_seq_no, b.clm_file_date, b.clm_stat_cd, b.claim_id, b.assured_name 
                     FROM gicl_loss_profile_ext2 a, gicl_claims b 
                    WHERE a.line_cd = b.line_cd 
                      AND a.subline_cd = b.subline_cd 
                      AND a.pol_iss_cd = b.pol_iss_cd 
                      AND a.issue_yy = b.issue_yy 
                      AND a.pol_seq_no = b.pol_seq_no 
                      AND a.renew_no = b.renew_no
                      AND a.tsi_amt >= p_range_from
	                   AND a.tsi_amt <= p_range_to
	                   AND a.line_cd = p_line_cd
                      AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                      AND b.clm_stat_cd NOT IN ('CC','DN','WD'))
         LOOP
            v_net_retention := 0;
            v_facultative := 0;
            v_treaty := 0;
         
            dtl.claim_id := i.claim_id;
            dtl.nbt_pol := i.line_cd||'-'||i.subline_cd||'-'||i.pol_iss_cd||'-'||
                           LTRIM(TO_CHAR(i.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(i.pol_seq_no,'0000009'))||'-'||
                           LTRIM(TO_CHAR(i.renew_no,'09'));
            dtl.tsi_amt := i.tsi_amt;            
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
            dtl.assured_name := i.assured_name;
            
            IF i.clm_stat_cd != 'CD' THEN  	
	            FOR val IN (SELECT SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) amt, c018.share_type share_type
                             FROM gicl_clm_res_hist c017,
                                  gicl_reserve_ds   c018
                            WHERE c017.claim_id = i.claim_id
                              AND c017.claim_id = c018.claim_id
                              AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                              AND NVL(c017.dist_sw,'N') = 'Y'
                            GROUP BY c018.share_type)
               LOOP       	       	
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;         
               END LOOP;   
            ELSIF i.clm_stat_cd = 'CD' THEN 
               FOR val IN (SELECT NVL(c018.shr_le_net_amt,0) amt, c018.share_type share_type
                             FROM gicl_clm_res_hist c017,
                                  gicl_clm_loss_exp c016, 
                                  gicl_loss_exp_ds  c018
                            WHERE c017.claim_id = i.claim_id
                              AND NVL(c017.cancel_tag,'N') = 'N'
                              AND c017.tran_id IS NOT NULL                      
                              AND c016.claim_id = c017.claim_id
                              AND c016.tran_id  = c017.tran_id
                              AND c016.item_no  = c017.item_no
                              AND c016.peril_cd = c017.peril_cd
                              AND c018.claim_id = c016.claim_id     
                              AND c018.clm_loss_id = c016.clm_loss_id     
                              AND nvl(c018.negate_tag, 'N') = 'N')
               LOOP
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	   
               END LOOP;       
            END IF; 	  
            
            dtl.nbt_net_ret := NVL(v_net_retention,0);
            dtl.nbt_facul := NVL(v_facultative,0);
            dtl.nbt_treaty := NVL(v_treaty,0);
            dtl.nbt_gross_loss := NVL(v_net_retention,0) + NVL(v_facultative,0) + NVL(v_treaty,0);
            
            sum_nbt_gross_loss := sum_nbt_gross_loss + NVL(dtl.nbt_gross_loss, 0); 
            sum_nbt_net_ret := sum_nbt_net_ret + NVL(dtl.nbt_net_ret, 0);
            sum_nbt_treaty := sum_nbt_treaty + NVL(dtl.nbt_treaty, 0);
            sum_nbt_facul := sum_nbt_facul + NVL(dtl.nbt_facul, 0);
            
            --dtl.sum_nbt_gross_loss := sum_nbt_gross_loss;
            --dtl.sum_nbt_net_ret := sum_nbt_net_ret;
            --dtl.sum_nbt_treaty := sum_nbt_treaty;
            --dtl.sum_nbt_facul := sum_nbt_facul;
            
            dtl.sum_nbt_gross_loss := v_sum_nbt_gross_loss;
            dtl.sum_nbt_net_ret := v_sum_nbt_net_ret;
            dtl.sum_nbt_treaty := v_sum_nbt_treaty;
            dtl.sum_nbt_facul := v_sum_nbt_facul;
            PIPE ROW(dtl);
         END LOOP;
      ELSE
         FOR i IN (SELECT a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, loss_amt, a.loss_date, a.iss_cd, 
                           a.clm_yy, a.clm_seq_no, a.clm_file_date, a.clm_stat_cd, a.assured_name, a.claim_id 
                      FROM gicl_claims a, gicl_loss_profile_ext3 b 
                     WHERE a.claim_id = b.claim_id
                       AND b.loss_amt >= p_range_from
                       AND b.loss_amt <= p_range_to
                       AND a.clm_stat_cd NOT IN ('CC','DN','WD'))  
         LOOP
            v_net_retention := 0;
            v_facultative := 0;
            v_treaty := 0;
         
            dtl.claim_id := i.claim_id;
            dtl.nbt_pol := i.line_cd||'-'||i.subline_cd||'-'||i.pol_iss_cd||'-'||
                           LTRIM(TO_CHAR(i.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(i.pol_seq_no,'0000009'))||'-'||
                           LTRIM(TO_CHAR(i.renew_no,'09'));
            dtl.loss_amt := i.loss_amt;
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
            dtl.assured_name := i.assured_name;
            
            FOR rec IN (SELECT close_sw
                          FROM gicl_loss_profile_ext3
                         WHERE claim_id IN (SELECT claim_id
                                              FROM gicl_claims
                                             WHERE line_cd = i.line_cd
                                               AND subline_cd = i.subline_cd
                                               AND pol_iss_cd = i.pol_iss_cd
                                               AND issue_yy = i.issue_yy
                                               AND pol_seq_no = i.pol_seq_no
                                               AND renew_no = i.renew_no)
                                               AND loss_amt = i.loss_amt)
            LOOP
  	            v_close_sw := rec.close_sw;
            END LOOP;	

	
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
                               
            IF v_close_sw = 'N' THEN		
	            FOR val IN (SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) amt, b.share_type share_type
                             FROM gicl_clm_res_hist a, 
                                  gicl_reserve_ds b                  
                            WHERE a.claim_id = i.claim_id
                              AND a.claim_id         = b.claim_id
                              AND a.clm_res_hist_id  = b.clm_res_hist_id
                              AND NVL(a.dist_sw,'N') = 'Y'
                            GROUP BY b.share_type)
               LOOP
  	               IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	        	    
               END LOOP;     
            ELSIF v_close_sw = 'Y' THEN
               FOR val IN (SELECT SUM(NVL(c.shr_le_net_amt,0)) amt, c.share_type share_type
                             FROM gicl_clm_res_hist a,
                                  gicl_clm_loss_exp b, 
                                  gicl_loss_exp_ds c	   
                            WHERE a.claim_id             = i.claim_id
                              AND NVL(a.cancel_tag,'N')  = 'N'
                              AND a.tran_id              IS NOT NULL
                              AND b.claim_id             = a.claim_id
                              AND b.tran_id              = a.tran_id
                              AND b.item_no              = a.item_no
                              AND b.peril_cd             = a.peril_cd
                              AND c.claim_id             = b.claim_id     
                              AND c.clm_loss_id          = b.clm_loss_id     
                              AND nvl(c.negate_tag, 'N') = 'N'
                            GROUP BY c.share_type)
               LOOP
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	   
          
               END LOOP;
            END IF;	
            
            dtl.nbt_net_ret := NVL(v_net_retention,0);
            dtl.nbt_facul := NVL(v_facultative,0);
            dtl.nbt_treaty := NVL(v_treaty,0);
            dtl.nbt_gross_loss := NVL(v_net_retention,0) + NVL(v_facultative,0) + NVL(v_treaty,0);
            
            sum_nbt_gross_loss := sum_nbt_gross_loss + NVL(dtl.nbt_gross_loss, 0); 
            sum_nbt_net_ret := sum_nbt_net_ret + NVL(dtl.nbt_net_ret, 0);
            sum_nbt_treaty := sum_nbt_treaty + NVL(dtl.nbt_treaty, 0);
            sum_nbt_facul := sum_nbt_facul + NVL(dtl.nbt_facul, 0);
            
            --dtl.sum_nbt_gross_loss := sum_nbt_gross_loss;
            --dtl.sum_nbt_net_ret := sum_nbt_net_ret;
            --dtl.sum_nbt_treaty := sum_nbt_treaty;
            --dtl.sum_nbt_facul := sum_nbt_facul;
            
            dtl.sum_nbt_gross_loss := v_sum_nbt_gross_loss;
            dtl.sum_nbt_net_ret := v_sum_nbt_net_ret;
            dtl.sum_nbt_treaty := v_sum_nbt_treaty;
            dtl.sum_nbt_facul := v_sum_nbt_facul;
  
            PIPE ROW(dtl); 
         END LOOP;        
      END IF;
   END get_detail_list;
   
   FUNCTION get_sum_detail_list(
      p_global_extr           VARCHAR2,
      p_range_from            gicl_loss_profile.range_from%TYPE,
      p_range_to              gicl_loss_profile.range_to%TYPE,
      p_line_cd               gicl_loss_profile.line_cd%TYPE,
      p_subline_cd            gicl_loss_profile.subline_cd%TYPE,
      p_user_id               gicl_loss_profile.user_id%TYPE
   ) RETURN detail_tab PIPELINED
   AS
      dtl                     detail_type;
      v_net_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_facultative           gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_treaty                gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_close_sw              gicl_loss_profile_ext3.close_sw%TYPE;
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_net_ret         gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_treaty          gicl_loss_profile.treaty%TYPE := 0;
      sum_nbt_facul           gicl_loss_profile.facultative%TYPE := 0;
   BEGIN
      IF p_global_extr = '1' THEN
         FOR i IN (SELECT a.tsi_amt, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, b.loss_date, b.iss_cd, b.clm_yy, 
                          b.clm_seq_no, b.clm_file_date, b.clm_stat_cd, b.claim_id, b.assured_name 
                     FROM gicl_loss_profile_ext2 a, gicl_claims b 
                    WHERE a.line_cd = b.line_cd 
                      AND a.subline_cd = b.subline_cd 
                      AND a.pol_iss_cd = b.pol_iss_cd 
                      AND a.issue_yy = b.issue_yy 
                      AND a.pol_seq_no = b.pol_seq_no 
                      AND a.renew_no = b.renew_no
                      AND a.tsi_amt >= p_range_from
	                   AND a.tsi_amt <= p_range_to
	                   AND a.line_cd = p_line_cd
                      AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                      AND b.clm_stat_cd NOT IN ('CC','DN','WD'))
         LOOP
            v_net_retention := 0;
            v_facultative := 0;
            v_treaty := 0;
         
            dtl.claim_id := i.claim_id;
            dtl.nbt_pol := i.line_cd||'-'||i.subline_cd||'-'||i.pol_iss_cd||'-'||
                           LTRIM(TO_CHAR(i.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(i.pol_seq_no,'0000009'))||'-'||
                           LTRIM(TO_CHAR(i.renew_no,'09'));
            dtl.tsi_amt := i.tsi_amt;            
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
            dtl.assured_name := i.assured_name;
            
            IF i.clm_stat_cd != 'CD' THEN  	  
	            FOR val IN (SELECT SUM(NVL(c018.shr_loss_res_amt,0) + NVL(c018.shr_exp_res_amt,0)) amt, c018.share_type share_type
                             FROM gicl_clm_res_hist c017,
                                  gicl_reserve_ds   c018
                            WHERE c017.claim_id = i.claim_id
                              AND c017.claim_id = c018.claim_id
                              AND c017.clm_res_hist_id  = c018.clm_res_hist_id
                              AND NVL(c017.dist_sw,'N') = 'Y'
                            GROUP BY c018.share_type)
               LOOP       	       	
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;         
               END LOOP;   
 	
            ELSIF i.clm_stat_cd = 'CD' THEN 
               FOR val IN (SELECT NVL(c018.shr_le_net_amt,0) amt, c018.share_type share_type
                             FROM gicl_clm_res_hist c017,
                                  gicl_clm_loss_exp c016, 
                                  gicl_loss_exp_ds  c018
                            WHERE c017.claim_id = i.claim_id
                              AND NVL(c017.cancel_tag,'N') = 'N'
                              AND c017.tran_id IS NOT NULL                      
                              AND c016.claim_id = c017.claim_id
                              AND c016.tran_id  = c017.tran_id
                              AND c016.item_no  = c017.item_no
                              AND c016.peril_cd = c017.peril_cd
                              AND c018.claim_id = c016.claim_id     
                              AND c018.clm_loss_id = c016.clm_loss_id     
                              AND nvl(c018.negate_tag, 'N') = 'N')
               LOOP
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	   
               END LOOP;       
            END IF; 	  
            
            dtl.nbt_net_ret := NVL(v_net_retention,0);
            dtl.nbt_facul := NVL(v_facultative,0);
            dtl.nbt_treaty := NVL(v_treaty,0);
            dtl.nbt_gross_loss := NVL(v_net_retention,0) + NVL(v_facultative,0) + NVL(v_treaty,0);
            
            sum_nbt_gross_loss := sum_nbt_gross_loss + NVL(dtl.nbt_gross_loss, 0); 
            sum_nbt_net_ret := sum_nbt_net_ret + NVL(dtl.nbt_net_ret, 0);
            sum_nbt_treaty := sum_nbt_treaty + NVL(dtl.nbt_treaty, 0);
            sum_nbt_facul := sum_nbt_facul + NVL(dtl.nbt_facul, 0);
            
            dtl.sum_nbt_gross_loss := sum_nbt_gross_loss;
            dtl.sum_nbt_net_ret := sum_nbt_net_ret;
            dtl.sum_nbt_treaty := sum_nbt_treaty;
            dtl.sum_nbt_facul := sum_nbt_facul;
  
            PIPE ROW(dtl);
         END LOOP;
      ELSE
         FOR i IN (SELECT a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, loss_amt, a.loss_date, a.iss_cd, 
                           a.clm_yy, a.clm_seq_no, a.clm_file_date, a.clm_stat_cd, a.assured_name, a.claim_id 
                      FROM gicl_claims a, gicl_loss_profile_ext3 b 
                     WHERE a.claim_id = b.claim_id
                       AND b.loss_amt >= p_range_from
                       AND b.loss_amt <= p_range_to
                       AND a.clm_stat_cd NOT IN ('CC','DN','WD'))  
         LOOP
            v_net_retention := 0;
            v_facultative := 0;
            v_treaty := 0;
         
            dtl.claim_id := i.claim_id;
            dtl.nbt_pol := i.line_cd||'-'||i.subline_cd||'-'||i.pol_iss_cd||'-'||
                           LTRIM(TO_CHAR(i.issue_yy,'09'))||'-'||
                           LTRIM(TO_CHAR(i.pol_seq_no,'0000009'))||'-'||
                           LTRIM(TO_CHAR(i.renew_no,'09'));
            dtl.loss_amt := i.loss_amt;
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||
                                LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
            dtl.assured_name := i.assured_name;
            
            FOR rec IN (SELECT close_sw
                          FROM gicl_loss_profile_ext3
                         WHERE claim_id IN (SELECT claim_id
                                              FROM gicl_claims
                                             WHERE line_cd = i.line_cd
                                               AND subline_cd = i.subline_cd
                                               AND pol_iss_cd = i.pol_iss_cd
                                               AND issue_yy = i.issue_yy
                                               AND pol_seq_no = i.pol_seq_no
                                               AND renew_no = i.renew_no)
                                               AND loss_amt = i.loss_amt)
            LOOP
  	            v_close_sw := rec.close_sw;
            END LOOP;	

	
            dtl.nbt_claim_no := i.line_cd||'-'||i.subline_cd||'-'||i.iss_cd||'-'||
                                LTRIM(TO_CHAR(i.clm_yy,'09'))||'-'||LTRIM(TO_CHAR(i.clm_seq_no,'0000009'));
                               
            IF v_close_sw = 'N' THEN		
	            FOR val IN (SELECT SUM(NVL(b.shr_loss_res_amt,0) + NVL(b.shr_exp_res_amt,0)) amt, b.share_type share_type
                             FROM gicl_clm_res_hist a, 
                                  gicl_reserve_ds b                  
                            WHERE a.claim_id = i.claim_id
                              AND a.claim_id         = b.claim_id
                              AND a.clm_res_hist_id  = b.clm_res_hist_id
                              AND NVL(a.dist_sw,'N') = 'Y'
                            GROUP BY b.share_type)
               LOOP
  	               IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	        	    
               END LOOP;     
            ELSIF v_close_sw = 'Y' THEN
               FOR val IN (SELECT SUM(NVL(c.shr_le_net_amt,0)) amt, c.share_type share_type
                             FROM gicl_clm_res_hist a,
                                  gicl_clm_loss_exp b, 
                                  gicl_loss_exp_ds c	   
                            WHERE a.claim_id             = i.claim_id
                              AND NVL(a.cancel_tag,'N')  = 'N'
                              AND a.tran_id              IS NOT NULL
                              AND b.claim_id             = a.claim_id
                              AND b.tran_id              = a.tran_id
                              AND b.item_no              = a.item_no
                              AND b.peril_cd             = a.peril_cd
                              AND c.claim_id             = b.claim_id     
                              AND c.clm_loss_id          = b.clm_loss_id     
                              AND nvl(c.negate_tag, 'N') = 'N'
                            GROUP BY c.share_type)
               LOOP
                  IF val.share_type = '1' THEN
                     v_net_retention := NVL(v_net_retention,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '3' THEN
                     v_facultative := NVL(v_facultative,0) + NVL(val.amt,0);
                  ELSIF val.share_type = '2' THEN
                     v_treaty := NVL(v_treaty,0) + NVL(val.amt,0);
                  END IF;               	        	   
          
               END LOOP;
            END IF;	
            
            dtl.nbt_net_ret := NVL(v_net_retention,0);
            dtl.nbt_facul := NVL(v_facultative,0);
            dtl.nbt_treaty := NVL(v_treaty,0);
            dtl.nbt_gross_loss := NVL(v_net_retention,0) + NVL(v_facultative,0) + NVL(v_treaty,0);
            
            sum_nbt_gross_loss := sum_nbt_gross_loss + NVL(dtl.nbt_gross_loss, 0); 
            sum_nbt_net_ret := sum_nbt_net_ret + NVL(dtl.nbt_net_ret, 0);
            sum_nbt_treaty := sum_nbt_treaty + NVL(dtl.nbt_treaty, 0);
            sum_nbt_facul := sum_nbt_facul + NVL(dtl.nbt_facul, 0);
            
            dtl.sum_nbt_gross_loss := sum_nbt_gross_loss; 
            dtl.sum_nbt_net_ret := sum_nbt_net_ret;
            dtl.sum_nbt_treaty := sum_nbt_treaty;
            dtl.sum_nbt_facul := sum_nbt_facul;
  
            PIPE ROW(dtl); 
         END LOOP;        
      END IF;
   END get_sum_detail_list;

   FUNCTION check_recovery(
      p_claim_id              gicl_claims.claim_id%TYPE
   ) RETURN VARCHAR2 AS
      v_exist                 VARCHAR2(1) := 'N';
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM gicl_clm_recovery
                   WHERE claim_id = p_claim_id)
      LOOP
  	      v_exist := 'Y';  	
      END LOOP;
      
      RETURN v_exist;
   END check_recovery;
   
   FUNCTION get_recovery_list(
      p_claim_id              gicl_clm_recovery.claim_id%TYPE,
      p_global_extr           VARCHAR2
   ) RETURN recovery_tab PIPELINED AS
      rec                     recovery_type;
      v_net_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_facultative           gicl_reserve_ds.shr_loss_res_amt%TYPE;
      v_treaty                gicl_reserve_ds.shr_loss_res_amt%TYPE;
      sum_nbt_gross_loss      gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_net_ret         gicl_loss_profile.net_retention%TYPE := 0;
      sum_nbt_treaty          gicl_loss_profile.treaty%TYPE := 0;
      sum_nbt_facul           gicl_loss_profile.facultative%TYPE := 0;
   BEGIN
      FOR i IN (SELECT a.line_cd, a.iss_cd, a.rec_year, a.rec_seq_no, a.claim_id, a.recovery_id, b.loss_date
                  FROM gicl_clm_recovery a,
                       gicl_claims b
                 WHERE a.claim_id = p_claim_id
                   AND a.claim_id = b.claim_id)
      LOOP
         rec.nbt_rec_no := i.line_cd||'-'||i.iss_cd||'-'||
	                        LTRIM(SUBSTR(TO_CHAR(i.rec_year),3))||'-'||
	                        LTRIM(TO_CHAR(i.rec_seq_no,'000009'));
         
         IF p_global_extr = '1' THEN
            FOR rec IN (SELECT -SUM(NVL(c018.shr_recovery_amt,0)) amt, c018.share_type
                          FROM gicl_recovery_payt c017,
                               gicl_recovery_ds   c018
                         WHERE c017.claim_id = i.claim_id
                           AND c017.recovery_id = i.recovery_id
                           AND NVL(c017.cancel_tag,'N') = 'N'                 
                           AND TO_NUMBER(TO_CHAR(i.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                           AND c017.recovery_id = c018.recovery_id
                           AND c017.recovery_payt_id = c018.recovery_payt_id
                           AND nvl(c018.negate_tag, 'N') = 'N'
                         GROUP BY c018.share_type)
            LOOP
               IF rec.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) + NVL(rec.amt,0);
               ELSIF rec.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(rec.amt,0);
               ELSIF rec.share_type = '2' THEN
                  v_treaty := NVL(v_treaty,0) + NVL(rec.amt,0);
               END IF;             
            END LOOP;
         ELSE
            FOR rec IN (SELECT -SUM(NVL(c018.shr_recovery_amt,0)) amt, c018.share_type
                          FROM gicl_recovery_payt c017,
                               gicl_recovery_ds   c018
                         WHERE c017.claim_id = i.claim_id
                           AND c017.recovery_id = i.recovery_id
                           AND NVL(c017.cancel_tag,'N') = 'N'                 
                           AND TO_NUMBER(TO_CHAR(i.loss_date,'YYYY'))= TO_NUMBER(TO_CHAR(c017.tran_date,'YYYY'))
                           AND c017.recovery_id = c018.recovery_id
                           AND c017.recovery_payt_id = c018.recovery_payt_id
                           AND nvl(c018.negate_tag, 'N') = 'N'
                         GROUP BY c018.share_type)
            LOOP
  	            IF rec.share_type = '1' THEN
                  v_net_retention := NVL(v_net_retention,0) + NVL(rec.amt,0);
   	         ELSIF rec.share_type = '3' THEN
                  v_facultative := NVL(v_facultative,0) + NVL(rec.amt,0);
	            ELSIF rec.share_type = '2' THEN
                  v_treaty := NVL(v_treaty,0) + NVL(rec.amt,0);
               END IF;             
            END LOOP;
         END IF;   
         
         rec.nbt_net_ret := NVL(v_net_retention,0);
         rec.nbt_facul := NVL(v_facultative,0);
         rec.nbt_treaty := NVL(v_treaty,0);
         rec.nbt_gross_loss := NVL(v_net_retention,0) + NVL(v_facultative,0) + NVL(v_treaty,0);
            
         sum_nbt_gross_loss := sum_nbt_gross_loss + NVL(rec.nbt_gross_loss, 0); 
         sum_nbt_net_ret := sum_nbt_net_ret + NVL(rec.nbt_net_ret, 0);
         sum_nbt_treaty := sum_nbt_treaty + NVL(rec.nbt_treaty, 0);
         sum_nbt_facul := sum_nbt_facul + NVL(rec.nbt_facul, 0);
            
         rec.sum_nbt_gross_loss := sum_nbt_gross_loss; 
         rec.sum_nbt_net_ret := sum_nbt_net_ret;
         rec.sum_nbt_treaty := sum_nbt_treaty;
         rec.sum_nbt_facul := sum_nbt_facul;
                    
         PIPE ROW(rec);
      END LOOP;
   END;
   
END GICLS212_PKG;
/



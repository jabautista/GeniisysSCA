DROP PROCEDURE CPI.EXTRACT_LATEST_AV_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Av_Data (p_expiry_date        gicl_claims.expiry_date%TYPE,
                                    p_incept_date      gicl_claims.expiry_date%TYPE,
                                    p_loss_date        gicl_claims.loss_date%TYPE,
                                    p_clm_endt_seq_no  gicl_claims.max_endt_seq_no%TYPE,
                                    p_line_cd          gicl_claims.line_cd%TYPE,
                                    p_subline_cd       gicl_claims.subline_cd%TYPE,
                                    p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
                                    p_issue_yy         gicl_claims.issue_yy%TYPE,
                                    p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                                    p_renew_no     gicl_claims.renew_no%TYPE,
                                    p_claim_id         gicl_claims.claim_id%TYPE,
                                    p_item_no          gicl_clm_item.item_no%TYPE)

/** Created by : Hardy Teng
    Date Creted : 09/22/03
**/

IS
   v_endt_seq_no		gipi_polbasic.endt_seq_no%TYPE;
   v_item_title			gicl_aviation_dtl.item_title%TYPE;
   v_currency_cd		gicl_aviation_dtl.currency_cd%TYPE;
   v_currency_rate		gicl_aviation_dtl.currency_rate%TYPE;
   v_total_fly_time		gicl_aviation_dtl.total_fly_time%TYPE;
   v_purpose		    	gicl_aviation_dtl.purpose%TYPE;
   v_deduct_text   		gicl_aviation_dtl.deduct_text%TYPE;
   v_prev_util_hrs	 	gicl_aviation_dtl.prev_util_hrs%TYPE;
   v_est_util_hrs		gicl_aviation_dtl.est_util_hrs%TYPE;
   v_qualification		gicl_aviation_dtl.qualification%TYPE;
   v_geog_limit			gicl_aviation_dtl.geog_limit%TYPE;
   v_vessel_cd			gicl_aviation_dtl.vessel_cd%TYPE;
   v_rec_flag			gicl_aviation_dtl.rec_flag%TYPE;
   v_fixed_wing			gicl_aviation_dtl.fixed_wing%TYPE;
   v_rotor			gicl_aviation_dtl.rotor%TYPE;
BEGIN
  FOR v1 IN (SELECT endt_seq_no, b.item_title, b.currency_cd, b.currency_rt,
                    c.total_fly_time, c.purpose, c.deduct_text, c.prev_util_hrs,
                    c.est_util_hrs, c.qualification, c.geog_limit, c.vessel_cd,
                    c.rec_flag, c.fixed_wing, c.rotor
               FROM gipi_polbasic a, gipi_item b, gipi_aviation_item c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.endt_seq_no > p_clm_endt_seq_no
                AND a.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),
                    p_incept_date, a.eff_date ))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND b.item_no    = p_item_no
                AND a.policy_id  = b.policy_id
                AND b.policy_id  = c.policy_id
                AND b.item_no    = c.item_no
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_endt_seq_no := v1.endt_seq_no;
    v_item_title := v1.item_title;
    v_currency_cd := v1.currency_cd;
    v_currency_rate := v1.currency_rt;
    v_total_fly_time := v1.total_fly_time;
    v_purpose := v1.purpose;
    v_deduct_text := v1.deduct_text;
    v_prev_util_hrs := v1.prev_util_hrs;
    v_est_util_hrs := v1.est_util_hrs;
    v_qualification := v1.qualification;
    v_geog_limit := v1.geog_limit;
    v_vessel_cd := v1.vessel_cd;
    v_rec_flag := v1.rec_flag;
    v_fixed_wing := v1.fixed_wing;
    v_rotor := v1.rotor;
    EXIT;
  END LOOP;
  FOR v2 IN (SELECT b.item_title, b.currency_cd, b.currency_rt, c.total_fly_time,
                    c.purpose, c.deduct_text, c.prev_util_hrs, c.est_util_hrs,
	            c.qualification, c.geog_limit, c.vessel_cd, c.rec_flag,
                    c.fixed_wing, c.rotor
               FROM gipi_polbasic a,
                    gipi_item b,
                    gipi_aviation_item c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.pol_flag IN ('1','2','3','X')
                AND NVL(a.back_stat,5) = 2
                AND endt_seq_no > v_endt_seq_no
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),
                    p_incept_date, a.eff_date))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND b.item_no    = p_item_no
                AND a.policy_id  = b.policy_id
                AND b.policy_id  = c.policy_id
                AND b.item_no    = c.item_no
              ORDER BY endt_seq_no DESC)
  LOOP
    v_item_title := NVL(v_item_title,v2.item_title);
    v_currency_cd := NVL(v_currency_cd,v2.currency_cd);
    v_currency_rate := NVL(v_currency_rate,v2.currency_rt);
    v_total_fly_time := NVL(v_total_fly_time,v2.total_fly_time);
    v_purpose := NVL(v_purpose,v2.purpose);
    v_deduct_text := NVL(v_deduct_text,v2.deduct_text);
    v_prev_util_hrs := NVL(v_prev_util_hrs,v2.prev_util_hrs);
    v_est_util_hrs := NVL(v_est_util_hrs,v2.est_util_hrs);
    v_qualification := NVL(v_qualification,v2.qualification);
    v_geog_limit := NVL(v_geog_limit,v2.geog_limit);
    v_vessel_cd := NVL(v_vessel_cd,v2.vessel_cd);
    v_rec_flag := NVL(v_rec_flag,v2.rec_flag);
    v_fixed_wing := NVL(v_fixed_wing,v2.fixed_wing);
    v_rotor := NVL(v_rotor,v2.rotor);
    EXIT;
  END LOOP;
  UPDATE gicl_aviation_dtl
     SET item_title = NVL(v_item_title,item_title),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rate,currency_rate),
         total_fly_time = NVL(v_total_fly_time,total_fly_time),
         purpose = NVL(v_purpose,purpose),
         deduct_text = NVL(v_deduct_text,deduct_text),
         prev_util_hrs = NVL(v_prev_util_hrs,prev_util_hrs),
         est_util_hrs = NVL(v_est_util_hrs,est_util_hrs),
         qualification = NVL(v_qualification,qualification),
         geog_limit = NVL(v_geog_limit,geog_limit),
         vessel_cd = NVL(v_vessel_cd,vessel_cd),
         rec_flag = NVL(v_rec_flag,rec_flag),
         fixed_wing = NVL(v_fixed_wing,fixed_wing),
         rotor = NVL(v_rotor,rotor)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/



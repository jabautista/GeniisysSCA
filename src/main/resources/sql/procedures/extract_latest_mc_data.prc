DROP PROCEDURE CPI.EXTRACT_LATEST_MC_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Mc_Data (p_expiry_date        gicl_claims.expiry_date%TYPE,
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
    Date Created : 09/22/03
**/

/*Modified by: jen
  Date: Mar 3, 2010
  Modification: To handle assignee endorsement (if parameter is set to Y)
*/

IS
   v_motor_no          gicl_motor_car_dtl.motor_no%TYPE;
   v_item_title        gicl_motor_car_dtl.item_title%TYPE;
   v_color             gicl_motor_car_dtl.color%TYPE;
   v_color_cd          gicl_motor_car_dtl.color_cd%TYPE;
   v_basic_color_cd    gicl_motor_car_dtl.basic_color_cd%TYPE;
   v_serial_no         gipi_vehicle.serial_no%TYPE;
   v_mv_file_no        gicl_motor_car_dtl.mv_file_no%TYPE;
   v_currency_cd       gicl_motor_car_dtl.currency_cd%TYPE;
   v_currency_rate     gicl_motor_car_dtl.currency_rate%TYPE;
   v_make_cd           gicl_motor_car_dtl.make_cd%TYPE;
   v_plate_no          gicl_motor_car_dtl.plate_no%TYPE;
   v_model_year        gicl_motor_car_dtl.model_year%TYPE;
   v_motcar_comp_cd    gicl_motor_car_dtl.motcar_comp_cd%TYPE;
   v_subline_type_cd   gicl_motor_car_dtl.subline_type_cd%TYPE;
   v_max_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE;
   v_mot_type          gicl_motor_car_dtl.mot_type%TYPE;
   v_series_cd         gicl_motor_car_dtl.series_cd%TYPE;
   v_towing            gicl_motor_car_dtl.towing%TYPE;
   v_no_of_pass        gicl_motor_car_dtl.no_of_pass%TYPE;
   v_assignee          gipi_vehicle.assignee%TYPE;  --jen.030310
BEGIN
  --first get info. from policy and all valid endt.
  FOR a1 IN (SELECT endt_seq_no,   b.item_title,   c.motor_no,
                    c.color,       c.color_cd,     c.basic_color_cd,
                    c.serial_no,   c.mv_file_no,   b.currency_cd,
                    c.make_cd,     c.plate_no,     c.model_year,
                    c.car_company_cd, c.subline_type_cd,
                    c.mot_type,    c.series_cd,
                    b.currency_rt,
	            c.towing,      c.no_of_pass, c.assignee --jen.030310
               FROM gipi_polbasic a, gipi_item b,
                    gipi_vehicle c
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
    v_max_endt_seq_no := a1.endt_seq_no;
    v_item_title      := NVL(a1.item_title, v_item_title);
    v_color           := NVL(a1.color, v_color);
    v_color_cd        := NVL(a1.color_cd, v_color_cd);
    v_basic_color_cd  := NVL(a1.basic_color_cd, v_basic_color_cd);
    v_serial_no       := NVL(a1.serial_no, v_serial_no);
    v_mv_file_no      := NVL(a1.mv_file_no, v_mv_file_no);
    v_currency_cd     := NVL(a1.currency_cd, v_currency_cd);
    v_currency_rate   := NVL(a1.currency_rt, v_currency_rate);
    v_make_cd         := NVL(a1.make_cd, v_make_cd);
    v_plate_no        := NVL(a1.plate_no, v_plate_no);
    v_model_year      := NVL(a1.model_year, v_model_year);
    v_motcar_comp_cd  := NVL(a1.car_company_cd, v_motcar_comp_cd);
    v_subline_type_cd := NVL(a1.subline_type_cd, v_subline_type_cd);
    v_motor_no        := NVL(a1.motor_no, v_motor_no);
    v_mot_type        := NVL(a1.mot_type, v_mot_type);
    v_series_cd       := NVL(a1.series_cd, v_series_cd);
    v_towing          := NVL(a1.towing, v_towing);
    v_no_of_pass      := NVL(a1.no_of_pass, v_no_of_pass);
	v_assignee        := NVL(a1.assignee,v_assignee); --jen.030310
    EXIT;
  END LOOP;
  --get info from backward endt.
  FOR a2 IN (SELECT b.item_title,  c.motor_no,
                    c.color,       c.color_cd,     c.basic_color_cd,
                    c.serial_no,   c.mv_file_no,   b.currency_cd,
                    c.make_cd,     c.plate_no,     c.model_year,
                    c.car_company_cd,  c.subline_type_cd,
                    c.mot_type,    c.series_cd,
	            b.currency_rt, c.towing,      c.no_of_pass, c.assignee
               FROM gipi_polbasic a, gipi_item b,
                    gipi_vehicle c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.pol_flag IN ('1','2','3','X')
                AND NVL(a.back_stat,5) = 2
                AND endt_seq_no > v_max_endt_seq_no
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date),
                    p_incept_date, a.eff_date ))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= TRUNC(p_loss_date)
                AND b.item_no    = p_item_no
                AND a.policy_id  = b.policy_id
                AND b.policy_id  = c.policy_id
                AND b.item_no    = c.item_no
           ORDER BY endt_seq_no DESC)
  LOOP
    v_item_title      := NVL(a2.item_title, v_item_title);
    v_color           := NVL(a2.color, v_color);
    v_color_cd        := NVL(a2.color_cd, v_color_cd);
    v_basic_color_cd  := NVL(a2.basic_color_cd, v_basic_color_cd);
    v_serial_no       := NVL(a2.serial_no, v_serial_no);
    v_mv_file_no      := NVL(a2.mv_file_no, v_mv_file_no);
    v_currency_cd     := NVL(a2.currency_cd, v_currency_cd);
    v_currency_rate   := NVL(a2.currency_rt, v_currency_rate);
    v_make_cd         := NVL(a2.make_cd, v_make_cd);
    v_plate_no        := NVL(a2.plate_no, v_plate_no);
    v_model_year      := NVL(a2.model_year, v_model_year);
    v_motcar_comp_cd  := NVL(a2.car_company_cd, v_motcar_comp_cd);
    v_subline_type_cd := NVL(a2.subline_type_cd, v_subline_type_cd);
    v_motor_no        := NVL(a2.motor_no, v_motor_no);
    v_mot_type        := NVL(a2.mot_type, v_mot_type);
    v_series_cd       := NVL(a2.series_cd, v_series_cd);
    v_towing          := NVL(a2.towing, v_towing);
    v_no_of_pass      := NVL(a2.no_of_pass, v_no_of_pass);
	v_assignee        := NVL(a2.assignee,v_assignee); --jen.030310
    EXIT;
  END LOOP;
  UPDATE gicl_motor_car_dtl
     SET item_title = NVL(v_item_title,v_item_title),
         color = NVL(v_color,color),
         color_cd = NVL(v_color_cd,color_cd),
         basic_color_cd = NVL(v_basic_color_cd,basic_color_cd),
         serial_no = NVL(v_serial_no,serial_no),
         mv_file_no = NVL(v_mv_file_no,mv_file_no),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rate,currency_rate),
         make_cd = NVL(v_make_cd,make_cd),
         plate_no = NVL(v_plate_no,plate_no),
         model_year = NVL(v_model_year,model_year),
         motcar_comp_cd = NVL(v_motcar_comp_cd,motcar_comp_cd),
         subline_type_cd = NVL(v_subline_type_cd,subline_type_cd),
         motor_no = NVL(v_motor_no,motor_no),
         mot_type = NVL(v_mot_type,mot_type),
         series_cd = NVL(v_series_cd,series_cd),
         towing = NVL(v_towing,towing),
         no_of_pass = NVL(v_no_of_pass,no_of_pass)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;

  IF nvl(giisp.v('ORA2010_SW'),'N') = 'Y' THEN --jen.030310
     update gicl_motor_car_dtl
	    set assignee = v_assignee
	  where claim_id = p_claim_id
	    and item_no = p_item_no;
  END IF;
END;
/



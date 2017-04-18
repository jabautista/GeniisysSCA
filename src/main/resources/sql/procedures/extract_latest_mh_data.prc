DROP PROCEDURE CPI.EXTRACT_LATEST_MH_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Mh_Data (p_expiry_date        gicl_claims.expiry_date%TYPE,
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

IS
  v_vestype_cd         		   giis_vessel.vestype_cd%TYPE;
  v_hull_type_cd       		   giis_vessel.hull_type_cd%TYPE;
  v_vess_class_cd      		   giis_vessel.vess_class_cd%TYPE;
  v_currency_cd                    gipi_item.currency_cd%TYPE;
  v_currency_rt                    gipi_item.currency_rt%TYPE;
  v_vessel_cd                      gipi_item_ves.vessel_cd%TYPE;
  v_geog_limit                     gipi_item_ves.geog_limit%TYPE;
  v_deduct_text                    gipi_item_ves.deduct_text%TYPE;
  v_dry_date                       gipi_item_ves.dry_date%TYPE;
  v_dry_place                      gipi_item_ves.dry_place%TYPE;
  v_loss_date                      gicl_claims.loss_date%TYPE;
  v_item_title                     gipi_item.item_title%TYPE;
  v_max_endt_seq_no		   gipi_polbasic.endt_seq_no%TYPE;
BEGIN
  FOR v1 IN (SELECT c.endt_seq_no endt_seq_no,
      	            b.item_title item_title,
                    b.currency_cd currency_cd,
                    b.currency_rt currency_rt,
                    a.vessel_cd vessel_cd,
                    a.geog_limit geog_limit,
                    a.deduct_text deduct_text,
                    a.dry_date dry_date,
                    a.dry_place dry_place,
                    d.loss_date loss_date
               FROM gicl_claims d,gipi_polbasic c,
                    gipi_item b,gipi_item_ves a
              WHERE c.line_cd       = p_line_cd
                AND c.subline_cd    = p_subline_cd
                AND c.iss_cd        = p_pol_iss_cd
                AND c.issue_yy      = p_issue_yy
                AND c.pol_seq_no    = p_pol_seq_no
                AND c.renew_no      = p_renew_no
                AND c.policy_id     = b.policy_id
                AND b.policy_id     = a.policy_id
                AND b.item_no       = a.item_no
                AND b.item_no       = p_item_no
                AND endt_seq_no     = p_clm_endt_seq_no
                AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date),
                    p_incept_date, c.eff_date))
                    <= p_loss_date
                AND c.eff_date <= d.loss_date
                AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
	            c.expiry_date,p_expiry_date,c.endt_expiry_date))
                    >= p_loss_date
                AND c.pol_flag      IN ('1','2','3','X')
              ORDER BY c.eff_date DESC, endt_seq_no DESC)
  LOOP
    v_currency_cd                    := v1.currency_cd;
    v_currency_rt                    := v1.currency_rt;
    v_vessel_cd                      := v1.vessel_cd;
    v_geog_limit                     := v1.geog_limit;
    v_deduct_text                    := v1.deduct_text;
    v_dry_date                       := v1.dry_date;
    v_dry_place                      := v1.dry_place;
    v_loss_date                      := v1.loss_date;
    v_item_title                     := v1.item_title;
    v_max_endt_seq_no	   	     := v1.endt_seq_no;
    EXIT;
  END LOOP;
  FOR v2 IN (SELECT b.item_title item_title,
                    b.currency_cd currency_cd,
                    b.currency_rt currency_rt,
                    a.vessel_cd vessel_cd,
                    a.geog_limit geog_limit,
                    a.deduct_text deduct_text,
                    a.dry_date dry_date,
                    a.dry_place dry_place,
                    d.loss_date loss_date
               FROM gicl_claims d,gipi_polbasic c,
                    gipi_item b,gipi_item_ves a
              WHERE c.line_cd       = p_line_cd
                AND c.subline_cd    = p_subline_cd
                AND c.iss_cd        = p_pol_iss_cd
                AND c.issue_yy      = p_issue_yy
                AND c.pol_seq_no    = p_pol_seq_no
                AND c.renew_no      = p_renew_no
                AND c.policy_id     = b.policy_id
                AND b.policy_id     = a.policy_id
                AND b.item_no       = a.item_no
                AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date),
                    p_incept_date, c.eff_date))
                    <= p_loss_date
                AND c.eff_date <= d.loss_date
                AND TRUNC(DECODE(NVL(c.endt_expiry_date, c.expiry_date),
          	    c.expiry_date,p_expiry_date,c.endt_expiry_date))
                    >= p_loss_date
                AND c.pol_flag      IN ('1','2','3','X')
                AND b.item_no       = p_item_no
                AND NVL(c.back_stat, 5) = 2
                AND c.endt_seq_no   = v_max_endt_seq_no
             ORDER BY c.endt_seq_no DESC)
  LOOP
    v_currency_cd                    := v2.currency_cd;
    v_currency_rt                    := v2.currency_rt;
    v_vessel_cd                      := v2.vessel_cd;
    v_geog_limit                     := v2.geog_limit;
    v_deduct_text                    := v2.deduct_text;
    v_dry_date                       := v2.dry_date;
    v_dry_place                      := v2.dry_place;
    v_loss_date                      := v2.loss_date;
    v_item_title                     := v2.item_title;
    EXIT;
  END LOOP;
  UPDATE gicl_hull_dtl
     SET currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rt,currency_rate),
         vessel_cd = NVL(v_vessel_cd,vessel_cd),
         geog_limit = NVL(v_geog_limit,geog_limit),
         deduct_text = NVL(v_deduct_text,deduct_text),
         dry_date = NVL(v_dry_date,dry_date),
         dry_place = NVL(v_dry_place,dry_place),
         loss_date = NVL(v_loss_date,loss_date),
         item_title = NVL(v_item_title,item_title)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/



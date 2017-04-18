DROP PROCEDURE CPI.EXTRACT_LATEST_CA_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Ca_Data (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
   v_endt_seq_no        gipi_polbasic.endt_seq_no%TYPE;
   v_item_title            gicl_casualty_dtl.item_title%TYPE;
   v_currency_cd        gicl_casualty_dtl.currency_cd%TYPE;
   v_currency_rate        gicl_casualty_dtl.currency_rate%TYPE;
   v_capacity_cd        gicl_casualty_dtl.capacity_cd%TYPE;
   v_section_line_cd        gicl_casualty_dtl.section_line_cd%TYPE;
   v_section_subline_cd     gicl_casualty_dtl.section_subline_cd%TYPE;
   v_section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE;
   v_section_or_hazard_info    gicl_casualty_dtl.section_or_hazard_info%TYPE;
   v_property_no_type        gicl_casualty_dtl.property_no_type%TYPE;
   v_property_no        gicl_casualty_dtl.property_no%TYPE;
   v_location_cd            gicl_casualty_dtl.location_cd%TYPE; -- jess 06232010
   v_location            gicl_casualty_dtl.location%TYPE;
   v_conveyance_info        gicl_casualty_dtl.conveyance_info%TYPE;
   v_interest_on_premises    gicl_casualty_dtl.interest_on_premises%TYPE;
   v_limit_of_liability        gicl_casualty_dtl.limit_of_liability%TYPE;
BEGIN
  FOR v1 IN (SELECT endt_seq_no, b.item_title, b.currency_cd, b.currency_rt,
                    c.capacity_cd, c.section_line_cd, c.section_subline_cd,
                    c.section_or_hazard_cd, c.section_or_hazard_info,
            c.property_no_type, c.property_no, c.location_cd, c.location,
                    c.conveyance_info, c.interest_on_premises, c.limit_of_liability
               FROM gipi_polbasic a, gipi_item b, gipi_casualty_item c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND endt_seq_no  > p_clm_endt_seq_no
                AND a.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                               a.eff_date )) <= p_loss_date
                AND b.item_no    = p_item_no
                AND a.policy_id  = b.policy_id
                AND b.policy_id  = c.policy_id(+)
                AND b.item_no    = c.item_no(+)
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_endt_seq_no := v1.endt_seq_no;
    v_item_title := v1.item_title;
    v_currency_cd := v1.currency_cd;
    v_currency_rate := v1.currency_rt;
    v_capacity_cd := v1.capacity_cd;
    v_section_line_cd := v1.section_line_cd;
    v_section_subline_cd := v1.section_subline_cd;
    v_section_or_hazard_cd := v1.section_or_hazard_cd;
    v_section_or_hazard_info := v1.section_or_hazard_info;
    v_property_no_type := v1.property_no_type;
    v_property_no := v1.property_no;
    v_location_cd := v1.location_cd; -- jess 06232010
    v_location := v1.location;
    v_conveyance_info := v1.conveyance_info;
    v_interest_on_premises := v1.interest_on_premises;
    v_limit_of_liability := v1.limit_of_liability;
    EXIT;
  END LOOP;
  FOR v2 IN (SELECT b.item_title, b.currency_cd, b.currency_rt, c.capacity_cd,
                    c.section_line_cd, c.section_subline_cd, c.section_or_hazard_cd,
                    c.section_or_hazard_info, c.property_no_type, c.property_no, c.location_cd, c.location, c.conveyance_info, c.interest_on_premises,
                      c.limit_of_liability
               FROM gipi_polbasic a, gipi_item b, gipi_casualty_item c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.pol_flag IN ('1','2','3','X')
                AND NVL(a.back_stat,5) = 2
                AND endt_seq_no > v_endt_seq_no
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date)) <= p_loss_date
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND b.item_no    = p_item_no
                AND a.policy_id  = b.policy_id
                AND b.policy_id  = c.policy_id(+)
                AND b.item_no    = c.item_no(+)
              ORDER BY a.endt_seq_no DESC)
  LOOP
    v_item_title := NVL(v_item_title,v2.item_title);
    v_currency_cd := NVL(v_currency_cd,v2.currency_cd);
    v_currency_rate := NVL(v_currency_rate,v2.currency_rt);
    v_capacity_cd := NVL(v_capacity_cd,v2.capacity_cd);
    v_section_line_cd := NVL(v_section_line_cd,v2.section_line_cd);
    v_section_subline_cd := NVL(v_section_subline_cd,v2.section_subline_cd);
    v_section_or_hazard_cd := NVL(v_section_or_hazard_cd,v2.section_or_hazard_cd);
    v_section_or_hazard_info := NVL(v_section_or_hazard_info,v2.section_or_hazard_info);
    v_property_no_type := NVL(v_property_no_type,v2.property_no_type);
    v_property_no := NVL(v_property_no,v2.property_no);
    v_location_cd := NVL(v_location_cd, v2.location_cd); -- jess 06232010
    v_location := NVL(v_location,v2.location);
    v_conveyance_info := NVL(v_conveyance_info,v2.conveyance_info);
    v_interest_on_premises := NVL(v_interest_on_premises,v2.interest_on_premises);
    v_limit_of_liability := NVL(v_limit_of_liability,v2.limit_of_liability);
    EXIT;
  END LOOP;
  UPDATE gicl_casualty_dtl
     SET item_title = NVL(v_item_title,item_title),
         currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rate,currency_rate),
         capacity_cd = NVL(v_capacity_cd,capacity_cd),
         section_line_cd = NVL(v_section_line_cd,section_line_cd),
         section_subline_cd = NVL(v_section_subline_cd,section_subline_cd),
         section_or_hazard_cd = NVL(v_section_or_hazard_cd,section_or_hazard_cd),
         section_or_hazard_info = NVL(v_section_or_hazard_info,section_or_hazard_info),
         property_no_type = NVL(v_property_no_type,property_no_type),
         property_no = NVL(v_property_no,property_no),
         location_cd = NVL(v_location_cd, location_cd), -- jess 06232010
         location = NVL(v_location,location),
         conveyance_info = NVL(v_conveyance_info,conveyance_info),
         interest_on_premises = NVL(v_interest_on_premises,interest_on_premises),
         limit_of_liability = NVL(v_limit_of_liability,limit_of_liability)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/



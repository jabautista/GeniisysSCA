DROP PROCEDURE CPI.EXTRACT_LATEST_EN_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_En_Data (p_expiry_date        gicl_claims.expiry_date%TYPE,
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
  v_currency_cd 		gipi_item.currency_cd%TYPE;
  v_currency_desc		giis_currency.currency_desc%TYPE;
  v_currency_rt 		gipi_item.currency_rt%TYPE;
  v_region_cd		      	gipi_location.region_cd%TYPE;
  v_province_cd          	gipi_location.province_cd%TYPE;
  v_max_endt_seq_no     	gipi_polbasic.endt_seq_no%TYPE;
  v_item_desc			gipi_item.item_desc%TYPE;
  v_item_desc2			gipi_item.item_desc2%TYPE;
BEGIN
  FOR c1 IN (SELECT NVL(endt_seq_no,0) endt_seq_no, c.currency_cd,
                    e.currency_desc, d.region_cd, d.province_cd,
                    c.item_desc, c.item_desc2, c.currency_rt
               FROM gipi_polbasic b, gipi_item c, gipi_location d, giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.endt_seq_no > p_clm_endt_seq_no
                AND b.policy_id = c.policy_id
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id(+)
                AND c.item_no = d.item_no(+)
                AND b.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date,p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_max_endt_seq_no    := NVL(c1.endt_seq_no,0);
    v_currency_cd        := NVL(c1.currency_cd, v_currency_cd);
    v_currency_desc	 := NVL(c1.currency_desc, v_currency_desc);
    v_currency_rt 	 := NVL(c1.currency_rt, v_currency_rt);
    v_region_cd          := NVL(c1.region_cd, v_region_cd);
    v_province_cd 	 := NVL(c1.province_cd, v_province_cd);
    v_item_desc		 := NVL(c1.item_desc, v_item_desc);
    v_item_desc2 	 := NVL(c1.item_desc2, v_item_desc2);
    EXIT;
  END LOOP;
  FOR c2 IN (SELECT c.currency_cd, e.currency_desc, c.currency_rt,
                    d.region_cd, d.province_cd, c.item_desc, c.item_desc2
               FROM gipi_polbasic b, gipi_item c, gipi_location d, giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id(+)
                AND c.item_no = d.item_no(+)
                AND NVL(b.back_stat,5) = 2
                AND b.pol_flag IN ('1','2','3','X')
                AND endt_seq_no > v_max_endt_seq_no
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date,p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY endt_seq_no DESC)
  LOOP
    v_currency_cd 	:= NVL(c2.currency_cd, v_currency_cd);
    v_currency_desc	:= NVL(c2.currency_desc, v_currency_desc);
    v_currency_rt 	:= NVL(c2.currency_rt, v_currency_rt);
    v_region_cd 	:= NVL(c2.region_cd, v_region_cd);
    v_province_cd 	:= NVL(c2.province_cd, v_province_cd);
    v_item_desc		:= NVL(c2.item_desc, v_item_desc);
    v_item_desc2 	:= NVL(c2.item_desc2, v_item_desc2);
    EXIT;
  END LOOP;
  UPDATE gicl_engineering_dtl
     SET currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rt,currency_rate),
         region_cd = NVL(v_region_cd,region_cd),
         province_cd = NVL(v_province_cd,province_cd),
         item_desc = NVL(v_item_desc,item_desc),
         item_desc2 = NVL(v_item_desc2,item_desc2)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/



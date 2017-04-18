DROP PROCEDURE CPI.EXTRACT_LATEST_MN_DATA;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Mn_Data (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
  v_max_endt_seq_no     	gipi_polbasic.endt_seq_no%TYPE;
  v_vessel_cd		      	gipi_cargo.vessel_cd%TYPE;
  v_geog_cd 			gipi_cargo.geog_cd%TYPE;
  v_cargo_class_cd		gipi_cargo.cargo_class_cd%TYPE;
  v_pack_method			gipi_cargo.pack_method%TYPE;
  v_origin			gipi_cargo.origin%TYPE;
  v_destn			gipi_cargo.destn%TYPE;
  v_tranship_origin		gipi_cargo.tranship_origin%TYPE;
  v_tranship_destination	gipi_cargo.tranship_destination%TYPE;
  v_voyage_no			gipi_cargo.voyage_no%TYPE;
  v_lc_no			gipi_cargo.lc_no%TYPE;
  v_deduct_text			gipi_cargo.deduct_text%TYPE;
  v_bl_awb			gipi_cargo.bl_awb%TYPE;
  v_cargo_type			gipi_cargo.cargo_type%TYPE;
  v_etd				gipi_cargo.etd%TYPE;
  v_eta				gipi_cargo.eta%TYPE;
  v_cnt				NUMBER := 0;
  v_item_title                  gipi_item.item_title%TYPE;
BEGIN
  FOR c1 IN (SELECT endt_seq_no, c.currency_cd, e.currency_desc, c.currency_rt,
                    d.vessel_cd, d.geog_cd, d.cargo_class_cd, d.pack_method,
             	    d.origin, d.destn, d.tranship_origin, d.tranship_destination,
  	            d.voyage_no, d.lc_no, d.deduct_text, d.bl_awb, d.cargo_type,
  	            d.etd, d.eta, c.item_title
               FROM gipi_polbasic b, gipi_item c, gipi_cargo d, giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND b.endt_seq_no > p_clm_endt_seq_no
                AND b.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date))<= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date, p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_max_endt_seq_no      := c1.endt_seq_no;
    v_currency_cd 	   := NVL(c1.currency_cd, v_currency_cd);
    v_currency_desc	   := NVL(c1.currency_desc, v_currency_desc);
    v_currency_rt 	   := NVL(c1.currency_rt, v_currency_rt);
    v_vessel_cd		   := NVL(c1.vessel_cd, v_vessel_cd);
    v_geog_cd 		   := NVL(c1.geog_cd, v_geog_cd);
    v_cargo_class_cd	   := NVL(c1.cargo_class_cd, v_cargo_class_cd);
    v_pack_method	   := NVL(c1.pack_method, v_pack_method);
    v_origin		   := NVL(c1.origin, v_origin);
    v_destn		   := NVL(c1.destn, v_destn);
    v_tranship_origin	   := NVL(c1.tranship_origin, v_tranship_origin);
    v_tranship_destination := NVL(c1.tranship_destination, v_tranship_destination);
    v_voyage_no		   := NVL(c1.voyage_no, v_voyage_no);
    v_lc_no		   := NVL(c1.lc_no, v_lc_no);
    v_deduct_text	   := NVL(c1.deduct_text, v_deduct_text);
    v_bl_awb		   := NVL(c1.bl_awb, v_bl_awb);
    v_cargo_type	   := NVL(c1.cargo_type, v_cargo_type);
    v_etd		   := NVL(c1.etd, v_etd);
    v_eta		   := NVL(c1.eta, v_eta);
    v_item_title           := NVL(c1.item_title, v_item_title);
    EXIT;
  END LOOP;
  FOR c2 IN (SELECT c.currency_cd, e.currency_desc, c.currency_rt,
                    d.vessel_cd, d.geog_cd, d.cargo_class_cd, d.pack_method,
            	    d.origin, d.destn, d.tranship_origin, d.tranship_destination,
   	            d.voyage_no, d.lc_no, d.deduct_text, d.bl_awb, d.cargo_type,
  	            d.etd, d.eta, c.item_title
               FROM gipi_polbasic b, gipi_item c, gipi_cargo d, giis_currency e
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND c.currency_cd = e.main_currency_cd
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND NVL(b.back_stat,5) = 2
                AND b.pol_flag IN ('1','2','3','X')
                AND endt_seq_no > v_max_endt_seq_no
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date)) <= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date, p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY endt_seq_no DESC)
  LOOP
    v_currency_cd 	    := NVL(c2.currency_cd, v_currency_cd);
    v_currency_desc	    := NVL(c2.currency_desc, v_currency_desc);
    v_currency_rt 	    := NVL(c2.currency_rt, v_currency_rt);
    v_vessel_cd		    := NVL(c2.vessel_cd, v_vessel_cd);
    v_geog_cd 		    := NVL(c2.geog_cd, v_geog_cd);
    v_cargo_class_cd	    := NVL(c2.cargo_class_cd, v_cargo_class_cd);
    v_pack_method	    := NVL(c2.pack_method, v_pack_method);
    v_origin		    := NVL(c2.origin, v_origin);
    v_destn		    := NVL(c2.destn, v_destn);
    v_tranship_origin	    := NVL(c2.tranship_origin, v_tranship_origin);
    v_tranship_destination  := NVL(c2.tranship_destination, v_tranship_destination);
    v_voyage_no		    := NVL(c2.voyage_no, v_voyage_no);
    v_lc_no		    := NVL(c2.lc_no, v_lc_no);
    v_deduct_text	    := NVL(c2.deduct_text, v_deduct_text);
    v_bl_awb		    := NVL(c2.bl_awb, v_bl_awb);
    v_cargo_type	    := NVL(c2.cargo_type, v_cargo_type);
    v_etd		    := NVL(c2.etd, v_etd);
    v_eta		    := NVL(c2.eta, v_eta);
    v_item_title            := NVL(c2.item_title, v_item_title);
    EXIT;
  END LOOP;
  UPDATE gicl_cargo_dtl
     SET currency_cd = NVL(v_currency_cd,currency_cd),
         currency_rate = NVL(v_currency_rt,currency_rate),
         vessel_cd = NVL(v_vessel_cd,vessel_cd),
         geog_cd = NVL(v_geog_cd,geog_cd),
         cargo_class_cd = NVL(v_cargo_class_cd,cargo_class_cd),
         pack_method = NVL(v_pack_method,pack_method),
         origin = NVL(v_origin,origin),
         destn = NVL(v_destn,destn),
         tranship_origin = NVL(v_tranship_origin,tranship_origin),
         tranship_destination = NVL(v_tranship_destination,tranship_destination),
         voyage_no = NVL(v_voyage_no,voyage_no),
         lc_no = NVL(v_lc_no,lc_no),
         deduct_text = NVL(v_deduct_text,deduct_text),
         bl_awb = NVL(v_bl_awb,bl_awb),
         cargo_type = NVL(v_cargo_type,cargo_type),
         etd = NVL(v_etd,etd),
         eta = NVL(v_eta,eta),
         item_title = NVL(v_item_title,item_title)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no;
END;
/



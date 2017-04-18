DROP PROCEDURE CPI.EXTRACT_LATEST_MN_MULTI;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Mn_Multi (p_expiry_date        gicl_claims.expiry_date%TYPE,
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
                                    p_item_no          gicl_clm_item.item_no%TYPE,
                                    p_vessel_cd        gipi_cargo_carrier.vessel_cd%TYPE)
/** Created by : Hardy Teng
    Date Created : 09/22/03
**/

IS
  v_max_endt_seq_no     	gipi_polbasic.endt_seq_no%TYPE;
  v_origin			gipi_cargo.origin%TYPE;
  v_destn			gipi_cargo.destn%TYPE;
  v_etd				gipi_cargo.etd%TYPE;
  v_eta				gipi_cargo.eta%TYPE;
BEGIN
  FOR c1 IN (SELECT endt_seq_no, d.origin, d.destn, d.etd, d.eta
               FROM gipi_polbasic b, gipi_item c, gipi_cargo_carrier d
              WHERE d.vessel_cd = p_vessel_cd
                AND b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.endt_seq_no > p_clm_endt_seq_no
                AND b.policy_id = c.policy_id
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND b.pol_flag IN ('1','2','3','X')
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date,p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_max_endt_seq_no   := c1.endt_seq_no;
    v_origin		:= NVL(c1.origin, v_origin);
    v_destn		:= NVL(c1.destn, v_destn);
    v_etd		:= NVL(c1.etd, v_etd);
    v_eta		:= NVL(c1.eta, v_eta);
    EXIT;
  END LOOP;
  FOR c2 IN (SELECT d.origin, d.destn, d.etd, d.eta
               FROM gipi_polbasic b, gipi_item c, gipi_cargo d
              WHERE d.vessel_cd = p_vessel_cd
                AND b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_pol_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND c.item_no = p_item_no
                AND b.policy_id = c.policy_id
                AND c.policy_id = d.policy_id
                AND c.item_no = d.item_no
                AND NVL(b.back_stat,5) = 2
                AND b.pol_flag IN ('1','2','3','X')
                AND endt_seq_no > v_max_endt_seq_no
                AND TRUNC(DECODE(TRUNC(b.eff_date),TRUNC(b.incept_date),
                    p_incept_date, b.eff_date ))
                    <= p_loss_date
                AND TRUNC(DECODE(NVL(b.endt_expiry_date, b.expiry_date),
                    b.expiry_date,p_expiry_date,b.endt_expiry_date))
                    >= p_loss_date
              ORDER BY endt_seq_no DESC)
  LOOP
    v_origin		  := NVL(c2.origin, v_origin);
    v_destn		  := NVL(c2.destn, v_destn);
    v_etd		  := NVL(c2.etd, v_etd);
    v_eta		  := NVL(c2.eta, v_eta);
    EXIT;
  END LOOP;
  UPDATE gicl_cargo_dtl
     SET origin = NVL(v_origin,origin),
         destn = NVL(v_destn,destn),
         etd = NVL(v_etd,etd),
         eta = NVL(v_eta,eta)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
     AND vessel_cd = p_vessel_cd;
END;
/



DROP PROCEDURE CPI.EXTRACT_LATEST_CA_GROUPED;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Ca_Grouped (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
                             p_grouped_item_no  gicl_casualty_dtl.grouped_item_no%TYPE)

/** Created by : Hardy Teng
    Date Created : 09/22/03
**/

IS
   v_endt_seq_no 		gipi_polbasic.endt_seq_no%TYPE;
   v_grouped_item_title		gicl_casualty_dtl.grouped_item_title%TYPE;
   v_amount_coverage		gicl_casualty_dtl.amount_coverage%TYPE;
BEGIN
  FOR v1 IN (SELECT a.endt_seq_no, c.grouped_item_title, c.amount_coverage
               FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.pol_flag IN ('1','2','3','X')
                AND endt_seq_no > p_clm_endt_seq_no
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date)) <= p_loss_date
                AND b.item_no    = p_item_no
	        AND c.grouped_item_no = p_grouped_item_no
                AND a.policy_id  = b.policy_id
	        AND b.policy_id  = c.policy_id
                AND b.item_no    = c.item_no
              ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_endt_seq_no := v1.endt_seq_no;
    v_grouped_item_title := v1.grouped_item_title;
    v_amount_coverage := v1.amount_coverage;
    EXIT;
  END LOOP;
  FOR v2 IN (SELECT c.grouped_item_title, c.amount_coverage
               FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
              WHERE a.line_cd    = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd     = p_pol_iss_cd
                AND a.issue_yy   = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no   = p_renew_no
                AND a.pol_flag IN ('1','2','3','X')
                AND NVL(a.back_stat,5) = 2
                AND endt_seq_no > v_endt_seq_no
                AND TRUNC(DECODE(NVL(a.endt_expiry_date, a.expiry_date),
                    a.expiry_date,p_expiry_date,a.endt_expiry_date))
                    >= p_loss_date
                AND TRUNC(DECODE(TRUNC(a.eff_date),TRUNC(a.incept_date), p_incept_date,                              a.eff_date)) <= p_loss_date
                AND b.item_no    = p_item_no
                AND c.grouped_item_no = p_grouped_item_no
                AND a.policy_id  = b.policy_id
  		AND b.policy_id  = c.policy_id
                AND b.item_no    = c.item_no
              ORDER BY endt_seq_no DESC)
  LOOP
    v_grouped_item_title := NVL(v2.grouped_item_title,v_grouped_item_title);
    v_amount_coverage := NVL(v2.amount_coverage,v_amount_coverage);
    EXIT;
  END LOOP;
  UPDATE gicl_casualty_dtl
     SET grouped_item_title = NVL(v_grouped_item_title,v_grouped_item_title),
         amount_coverage = NVL(v_amount_coverage,amount_coverage)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
     AND grouped_item_no = p_grouped_item_no;
END;
/



DROP PROCEDURE CPI.EXTRACT_LATEST_PERIL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Peril (p_expiry_date      gicl_claims.expiry_date%TYPE,
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
                        p_peril_cd         gicl_item_peril.peril_cd%TYPE)
/** Created by : Hardy Teng
    Date Created : 09/22/03
**/
IS
  v_tsi_amt   NUMBER;
BEGIN
  FOR d IN (SELECT SUM(NVL(a.tsi_amt,0)) amt
              FROM gipi_itmperil a, gipi_polbasic c
             WHERE a.peril_cd = p_peril_cd
               AND a.item_no = p_item_no
               AND c.line_cd = p_line_cd
               AND c.subline_cd = p_subline_cd
               AND c.iss_cd = p_pol_iss_cd
               AND c.issue_yy = p_issue_yy
               AND c.pol_seq_no = p_pol_seq_no
               AND c.renew_no = p_renew_no
               AND c.pol_flag IN ('1','2','3','X')
               AND a.policy_id = c.policy_id
               AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date),
                   p_incept_date, c.eff_date))
                   <= p_loss_date
               AND DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                   c.expiry_date, p_expiry_date, c.endt_expiry_date)
                   >= p_loss_date)
  LOOP
    v_tsi_amt := d.amt;
  END LOOP;
  UPDATE gicl_item_peril
     SET ann_tsi_amt = NVL(v_tsi_amt,ann_tsi_amt)
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
     AND peril_cd = p_peril_cd;
END;
/



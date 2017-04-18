DROP FUNCTION CPI.RISK_DIST_EXISTS;

CREATE OR REPLACE FUNCTION CPI.risk_dist_exists (p_claim_id gicl_claims.claim_id%TYPE, v_risk_cd gipi_fireitem.risk_cd%TYPE, v_loss_date DATE)
   RETURN BOOLEAN
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - risk_dist_exists program unit
   */
   
BEGIN
   FOR a IN (SELECT   d.share_cd, f.share_type, f.trty_yy, f.acct_trty_type, f.prtfolio_sw, v_risk_cd,
                      SUM (d.dist_tsi) ann_dist_tsi, f.expiry_date
                 FROM gipi_polbasic a, gipi_item b, giis_peril b3, giuw_pol_dist c, giuw_itemperilds_dtl d, giis_dist_share f
                WHERE f.share_cd = d.share_cd
                  AND b3.line_cd = a.line_cd
                  AND b3.peril_cd = d.peril_cd
                  AND b3.peril_type = 'B'
                  AND f.line_cd = d.line_cd
                  AND d.item_no = b.item_no
                  AND d.dist_no = c.dist_no
                  AND c.dist_flag = giisp.v ('DISTRIBUTED')
                  AND c.policy_id = b.policy_id
                  AND TRUNC (a.eff_date) <= TRUNC (v_loss_date)
                  AND TRUNC (a.expiry_date) >= TRUNC (v_loss_date)
                  AND b.policy_id = a.policy_id
                  AND a.pol_flag IN ('1', '2', '3', 'X')
                  AND EXISTS (
                         SELECT 1
                           FROM gipi_polbasic sub_a, gipi_item sub_b, gipi_fireitem sub_c
                          WHERE sub_a.line_cd = a.line_cd
                            AND sub_a.subline_cd = a.subline_cd
                            AND sub_a.iss_cd = a.iss_cd
                            AND sub_a.issue_yy = a.issue_yy
                            AND sub_a.pol_seq_no = a.pol_seq_no
                            AND sub_a.renew_no = a.renew_no
                            AND sub_b.item_no = d.item_no
                            AND TRUNC (sub_a.eff_date) <= TRUNC (v_loss_date)
                            AND TRUNC (sub_a.expiry_date) >= TRUNC (v_loss_date)
                            AND sub_c.risk_cd = v_risk_cd
                            AND EXISTS (
                                   SELECT 1
                                     FROM gicl_fire_dtl b_id
                                    WHERE b_id.claim_id = p_claim_id
                                      AND b_id.item_no = sub_b.item_no
                                      AND b_id.block_id = sub_c.block_id)
                            AND sub_a.policy_id = sub_b.policy_id
                            AND sub_b.policy_id = sub_c.policy_id
                            AND sub_b.item_no = sub_c.item_no)
             GROUP BY d.share_cd, f.share_type, f.trty_yy, f.acct_trty_type, f.prtfolio_sw, v_risk_cd, f.expiry_date)
   LOOP
      RETURN (TRUE);
   END LOOP;

   RETURN (FALSE);
END;
/



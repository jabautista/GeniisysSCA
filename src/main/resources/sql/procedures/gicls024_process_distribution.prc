DROP PROCEDURE CPI.GICLS024_PROCESS_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.gicls024_process_distribution (
   p_claim_id            gicl_claims.claim_id%TYPE,
   p_item_no             gicl_item_peril.item_no%TYPE,
   p_peril_cd            gicl_item_peril.peril_cd%TYPE,
   p_grouped_item_no     gicl_item_peril.grouped_item_no%TYPE,
   p_distribution_date   gicl_clm_res_hist.distribution_date%TYPE,
   p_clm_res_hist        gicl_clm_res_hist.clm_res_hist_id%TYPE,
   p_hist_seq_no         gicl_clm_res_hist.hist_seq_no%TYPE   
)
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - process_distribution program unit
   */

   v_prtf_sw       NUMBER                               := 0;           --indicate if distribution is portfolio or natural expiry
   v_loss_amt      gicl_claims.loss_res_amt%TYPE;                   --temp. storage of loss_reserve amount for gicl_claims update
   v_exp_amt       gicl_clm_reserve.expense_reserve%TYPE;--koks gicl_claims.exp_res_amt%TYPE;                     --temp. storage of exp_reserve amount for gicl_claims update
   v_location_cd   gicl_casualty_dtl.location_cd%TYPE;
   v_line_cd       gicl_claims.line_cd%TYPE;
   v_loss_date     gicl_claims.loss_date%TYPE;
   v_eff_date      gicl_claims.pol_eff_date%TYPE;
   v_expiry_date   gicl_claims.expiry_date%TYPE;
   v_cat_cd        gicl_claims.catastrophic_cd%TYPE;
   v_risk_cd       gicl_fire_dtl.risk_cd%TYPE;
BEGIN
   --update negate_tag on table gicl_reserve_ds to 'Y' to indicate
   --that it is already negated
   UPDATE gicl_reserve_ds
      SET negate_tag = 'Y'
    WHERE claim_id = p_claim_id
      AND hist_seq_no < p_hist_seq_no
      AND item_no = p_item_no
      AND peril_cd = p_peril_cd
      AND grouped_item_no = p_grouped_item_no;

   SELECT line_cd, pol_eff_date, expiry_date, catastrophic_cd
     INTO v_line_cd, v_eff_date, v_expiry_date, v_cat_cd
     FROM gicl_claims
    WHERE claim_id = p_claim_id;

   IF v_line_cd = giis_line_pkg.get_line_cd ('FI') THEN
       SELECT risk_cd
         INTO v_risk_cd
         FROM gicl_fire_dtl
        WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END IF;

   IF v_line_cd = giis_line_pkg.get_line_cd ('CA') THEN
       SELECT location_cd
         INTO v_location_cd
         FROM gicl_casualty_dtl
        WHERE claim_id = p_claim_id AND item_no = p_item_no;
   END IF;

  --check if distribution is natural expiry or portfolio transfer
  --v_prtf_sw := check_transfer(p_peril_cd, p_item_no);
  --call the corresponding procedure of creating records for reserve distribution
/*modified by mon
**date modified: 04242002
**description: removed the execution of check transfer and distribute_loss_exp_ne */
  --IF v_prtf_sw = 1 THEN
   IF     giisp.v ('DISTRIBUTE_BY_LOC') = 'Y'
      AND trty_peril_exists_loc (v_line_cd, p_peril_cd, v_loss_date, v_location_cd)
      AND v_line_cd = giis_line_pkg.get_line_cd ('CA')
      AND loc_dist_exists (v_location_cd, v_loss_date)
   THEN
      clm_dist_by_loc (p_claim_id, p_clm_res_hist, v_eff_date, v_expiry_date, p_distribution_date, v_location_cd, v_cat_cd);
--      MESSAGE ('Distribution Complete.', no_acknowledge);
--      FORMS_DDL ('COMMIT');
--      CLEAR_MESSAGE;
   ELSIF     giisp.v ('DISTRIBUTE_BY_RISK') = 'Y'
         AND trty_peril_exists_risk (v_line_cd, p_peril_cd, v_loss_date, v_risk_cd)
         AND v_line_cd = giis_line_pkg.get_line_cd ('FI')
         AND risk_dist_exists (p_claim_id, v_risk_cd, v_loss_date)
   THEN
      clm_dist_by_risk (p_claim_id, p_clm_res_hist, v_eff_date, v_expiry_date, p_distribution_date, v_risk_cd, v_cat_cd);
--      MESSAGE ('Distribution Complete.', no_acknowledge);
--      FORMS_DDL ('COMMIT');
--      CLEAR_MESSAGE;
   ELSE
      --distribute_reserve (p_claim_id, p_clm_res_hist); -- replaced by: Nica 09.26.2012
      GICLS024_DISTRIBUTE_RESERVE (p_claim_id, p_clm_res_hist, p_item_no,
                                   p_peril_cd, p_grouped_item_no, p_distribution_date);
   END IF;

   --BETH 03202002
   --     summation of reserves for update in table gicl_claims should consider
   --     that the record is not denied,cancelled or withdrawn
   FOR sum_res IN (SELECT SUM (loss_reserve) loss_reserve, SUM (expense_reserve) exp_reserve
                     FROM gicl_clm_reserve a, gicl_item_peril b
                    WHERE a.claim_id = b.claim_id
                      AND a.grouped_item_no = b.grouped_item_no                                            --added by gmi 02/28/06
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = p_claim_id
                      AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP'))
   LOOP
      v_loss_amt := sum_res.loss_reserve;
      v_exp_amt := sum_res.exp_reserve;
      EXIT;
   END LOOP;                                                                                                    --end sum_res loop

   --update table  gicl_claims for correct reserve amounts
   UPDATE gicl_claims
      SET loss_res_amt = NVL (v_loss_amt, 0),
          exp_res_amt = NVL (v_exp_amt, 0)
    WHERE claim_id = p_claim_id;
--SET_BLOCK_PROPERTY ('e012', order_by, 'dist_year desc');
END;                                                                                             -- process_distribution procedure
/



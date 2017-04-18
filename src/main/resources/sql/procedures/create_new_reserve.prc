DROP PROCEDURE CPI.CREATE_NEW_RESERVE;

CREATE OR REPLACE PROCEDURE CPI.create_new_reserve(
  p_claim_id            IN GICL_CLAIMS.claim_id%TYPE,
  p_item_no             IN GICL_ITEM_PERIL.item_no%TYPE,
  p_peril_cd            IN GICL_ITEM_PERIL.peril_cd%TYPE,
  p_grouped_item_no     IN GICL_ITEM_PERIL.grouped_item_no%TYPE,
  p_distribution_date   IN GICL_CLM_RES_HIST.distribution_date%TYPE,  
  p_loss_reserve        IN GICL_CLM_RESERVE.LOSS_RESERVE%type,
  p_expense_reserve     IN GICL_CLM_RESERVE.expense_RESERVE%type,
  p_hist_seq_no         OUT gicl_clm_res_hist.hist_seq_no%TYPE,
  p_clm_res_hist_id     OUT gicl_clm_res_hist.clm_res_hist_id%TYPE  --added by Halley 09.20.2013
)
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - create_new_reserve program unit
   */

   -- variable to be use for storing hist_seq_no to be used by new reserve record
   v_hist_seq_no       gicl_clm_res_hist.hist_seq_no%TYPE       := 1;
   -- variable to be use for storing old hist_seq_no to be used for update of prev reserve and payments
   v_hist_seq_no_old   gicl_clm_res_hist.hist_seq_no%TYPE       := 0;
   -- variable to be use for storing clm_res_hist_id to be used by new reserve record
   v_clm_res_hist      gicl_clm_res_hist.clm_res_hist_id%TYPE   := 1;
   -- variable to be use for storing previous loss reseve to be used by new reserve record
   v_prev_loss_res     gicl_clm_res_hist.prev_loss_res%TYPE     := 0;
   -- variable to be use for storing previous exp. reseve to be used by new reserve record
   v_prev_exp_res      gicl_clm_res_hist.prev_loss_res%TYPE     := 0;
   -- variable to be use for storing previous loss paid to be used by new reserve record
   v_prev_loss_paid    gicl_clm_res_hist.prev_loss_res%TYPE     := 0;
   -- variable to be use for storing previous exp.paid to be used by new reserve record
   v_prev_exp_paid     gicl_clm_res_hist.prev_loss_res%TYPE     := 0;
  v_month VARCHAR2(10); 
  v_year NUMBER;
  v_currency_cd GICL_CLM_RESERVE.currency_cd%TYPE;
  v_convert_rate      GICL_CLM_RES_HIST.convert_rate%TYPE;
BEGIN

  SELECT currency_cd , currency_rate
    INTO v_currency_cd , v_convert_rate
    FROM gicl_clm_item
   WHERE claim_id = p_claim_id
    AND item_no = p_item_no
    AND grouped_item_no = p_grouped_item_no;   
   
   -- get max hist_seq_no from gicl_clm_res_hist for insert of new reserve record
   FOR hist IN (SELECT NVL (MAX (NVL (hist_seq_no, 0)), 0) + 1 seq_no
                  FROM gicl_clm_res_hist
                 WHERE claim_id = p_claim_id
                   AND item_no = p_item_no
                   AND peril_cd = p_peril_cd
                   AND grouped_item_no = p_grouped_item_no)                                            --added by gmi 02/23/06
   LOOP
      v_hist_seq_no := hist.seq_no;
      p_hist_seq_no := v_hist_seq_no;
      EXIT;
   END LOOP;                                                                                                       --end hist loop

   -- get prev hist_seq_no from gicl_clm_res_hist for update of previous amounts
   FOR old_hist IN (SELECT NVL (MAX (NVL (hist_seq_no, 0)), 0) seq_no
                      FROM gicl_clm_res_hist
                     WHERE claim_id = p_claim_id
                       AND item_no = p_item_no
                       AND peril_cd = p_peril_cd
                       AND grouped_item_no = p_grouped_item_no                                         --added by gmi 02/23/06
                       AND NVL (dist_sw, 'N') = 'Y')
   LOOP
      v_hist_seq_no_old := old_hist.seq_no;
      EXIT;
   END LOOP;                                                                                                   --end old_hist loop

   -- get max clm_res_hist_id from gicl_clm_res_hist for insert of new reserve record
   FOR hist_id IN (SELECT NVL (MAX (NVL (clm_res_hist_id, 0)), 0) + 1 hist_id
                     FROM gicl_clm_res_hist
                    WHERE claim_id = p_claim_id)
   LOOP
      v_clm_res_hist := hist_id.hist_id;
      p_clm_res_hist_id := v_clm_res_hist;  --added by Halley 09.20.2013
      EXIT;
   END LOOP;                                                                                                    --end hist_id loop

   -- get prev amounts from gicl_clm_res_hist using old hist_seq_no
   -- for insert of new reserve record
   FOR prev_amt IN (SELECT NVL (loss_reserve, 0) loss_reserve, NVL (expense_reserve, 0) expense_reserve,
                           NVL (losses_paid, 0) losses_paid, NVL (expenses_paid, 0) expenses_paid
                      FROM gicl_clm_res_hist
                     WHERE claim_id = p_claim_id
                       AND item_no = p_item_no
                       AND peril_cd = p_peril_cd
                       AND grouped_item_no = p_grouped_item_no                                         --added by gmi 02/23/06
                       AND hist_seq_no = v_hist_seq_no_old)
   LOOP
      v_prev_loss_res := prev_amt.loss_reserve;
      v_prev_exp_res := prev_amt.expense_reserve;
      v_prev_loss_paid := prev_amt.losses_paid;
      v_prev_exp_paid := prev_amt.expenses_paid;
   END LOOP;                                                                                                  -- end prev_amt loop

   -- retrieve valid booking date for this record
   get_booking_date(p_claim_id, v_month, v_year);

   -- insert record into table gicl_clm_res_hist
   INSERT INTO gicl_clm_res_hist
               (claim_id, clm_res_hist_id, hist_seq_no, item_no, peril_cd, grouped_item_no, setup_by,
                setup_date, loss_reserve, expense_reserve, dist_sw, booking_month, booking_year, currency_cd,
                convert_rate, prev_loss_res, prev_loss_paid, prev_exp_res,
                prev_exp_paid, distribution_date
               )
        VALUES (p_claim_id, v_clm_res_hist, v_hist_seq_no, p_item_no, p_peril_cd, p_grouped_item_no, giis_users_pkg.app_user,
                SYSDATE, p_loss_reserve, p_expense_reserve, 'Y', v_month, v_year, v_currency_cd,
                v_convert_rate, v_prev_loss_res, v_prev_loss_paid, v_prev_exp_res,
                v_prev_exp_paid, NVL (p_distribution_date, SYSDATE)
               );

   --BETH 12182003 update claim status after first reserve set-up
   IF v_clm_res_hist = 1
   THEN
      UPDATE gicl_claims
         SET clm_stat_cd = 'OP'
       WHERE claim_id = p_claim_id;
   END IF;

   -- update previous distributed record in gicl_clm_res_hist
   -- set its dist_sw = N and negate date = sysdate
   UPDATE gicl_clm_res_hist
      SET dist_sw = 'N',
          negate_date = SYSDATE
    WHERE claim_id = p_claim_id
      AND item_no = p_item_no
      AND peril_cd = p_peril_cd
      AND grouped_item_no = p_grouped_item_no                                                          --added by gmi 02/23/06
      AND NVL (dist_sw, 'N') = 'Y'
      AND hist_seq_no <> v_hist_seq_no;

   -- call procedure which will generate records in claims distribution tables
   -- gicl_reserve_ds and gicl_reserve_rids   p_claim_id            gicl_claims.claim_id%TYPE,   
   gicls024_process_distribution (p_claim_id, p_item_no, p_peril_cd, p_grouped_item_no, p_distribution_date, v_clm_res_hist, v_hist_seq_no);
END;                                                                                           -- end create new reserve procedure
/



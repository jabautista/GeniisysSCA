DROP PROCEDURE CPI.POPULATE_BATCH_REVALL2;

CREATE OR REPLACE PROCEDURE CPI.populate_batch_revall2(v_date DATE ) AS
/*Created by:        Joey
    Date created: 040105
    Description:    extract records into gicl_batch_takeup_revall for the specified dates
*/
  TYPE claim_id_tab             IS TABLE OF gicl_clm_res_hist.claim_id%TYPE;
  TYPE clm_res_hist_id_tab      IS TABLE OF gicl_clm_res_hist.clm_res_hist_id%TYPE;
  TYPE item_no_tab              IS TABLE OF gicl_clm_res_hist.item_no%TYPE;
  TYPE grouped_item_no_tab      IS TABLE OF gicl_clm_res_hist.grouped_item_no%TYPE;
  TYPE peril_cd_tab             IS TABLE OF gicl_clm_res_hist.peril_cd%TYPE;
  TYPE losses_tab               IS TABLE OF gicl_clm_res_hist.loss_reserve%TYPE;
  TYPE expenses_tab             IS TABLE OF gicl_clm_res_hist.expense_reserve%TYPE;
  TYPE dsp_loss_date_tab        IS TABLE OF gicl_claims.dsp_loss_date%TYPE;
  TYPE clm_file_date_tab        IS TABLE OF gicl_claims.clm_file_date%TYPE;
  TYPE booking_month_tab        IS TABLE OF gicl_clm_res_hist.booking_month%TYPE;
  TYPE booking_year_tab         IS TABLE OF gicl_clm_res_hist.booking_year%TYPE;
  TYPE iss_cd_tab               IS TABLE OF gicl_claims.iss_cd%TYPE;
  TYPE dist_no_tab              IS TABLE OF gicl_clm_res_hist.dist_no%TYPE;
  vv_claim_id                   claim_id_tab;
  vv_clm_res_hist_id            clm_res_hist_id_tab;
  vv_item_no                    item_no_tab;
  vv_grouped_item_no            grouped_item_no_tab;
  vv_peril_cd                   peril_cd_tab;
  vv_losses                     losses_tab;
  vv_expenses                   expenses_tab;
  vv_dsp_loss_date              dsp_loss_date_tab;
  vv_clm_file_date              clm_file_date_tab;
  vv_booking_month              booking_month_tab;
  vv_booking_year               booking_year_tab;
  vv_iss_cd                     iss_cd_tab;
  vv_dist_no                    dist_no_tab;

BEGIN
  --delete records for the specified dates
  DELETE FROM gicl_batch_takeup_revall;

  COMMIT;
  --retrieve records
  SELECT a.claim_id, a.clm_res_hist_id, a.item_no, a.grouped_item_no, a.peril_cd,
         --DECODE(loss_sign, 1,(NVL (a.loss_reserve, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/- (NVL (c.net_pd_loss, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/)),0) losses, comment out by alizag SR GENQA5217
         DECODE(loss_sign, 1,((NVL (a.loss_reserve, 0) * NVL (a.convert_rate, 1)) - NVL (c.net_pd_loss, 0)),0 )  losses,
         --DECODE(expense_sign, 1,(NVL(a.expense_reserve,0) - NVL(c.net_pd_exp,0)),0) expenses, commented out by aliza g. 12/09/2015 SR GENQA5217
         DECODE(expense_sign, 1,((NVL(a.expense_reserve,0) * (NVL (a.convert_rate, 1))) - NVL(c.net_pd_exp,0)),0) expenses, 
         d.dsp_loss_date, d.clm_file_date,NVL(a.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) booking_month, NVL(a.booking_year, TO_CHAR(d.clm_file_date,'YYYY')) booking_year,d.iss_cd,a.dist_no
  BULK COLLECT
    INTO vv_claim_id,
         vv_clm_res_hist_id,
         vv_item_no,
         vv_grouped_item_no,
         vv_peril_cd,
           vv_losses,
         vv_expenses,
         vv_dsp_loss_date,
         vv_clm_file_date,
         vv_booking_month,
         vv_booking_year,
         vv_iss_cd,
           vv_dist_no
  FROM gicl_clm_res_hist a,
       (SELECT b1.claim_id, b1.clm_res_hist_id, b1.item_no, b1.grouped_item_no, b1.peril_cd, SIGN(TRUNC(NVL(b2.close_date, v_date +1)) - TRUNC(v_date)) loss_sign, SIGN(TRUNC(NVL(b2.close_date2, v_date +1)) - TRUNC(v_date)) expense_sign
          FROM gicl_clm_res_hist b1 , gicl_item_peril b2
         WHERE tran_id IS NULL
           AND b2.claim_id = b1.claim_id
           AND b2.item_no  = b1.item_no
           AND b2.grouped_item_no  = b1.grouped_item_no
           AND b2.peril_cd = b1.peril_cd
           AND (TRUNC(NVL(b2.close_date, v_date +1))  > TRUNC(v_date)
            OR TRUNC(NVL(b2.close_date2, v_date +1))  > TRUNC(v_date))) b,
       (SELECT claim_id, item_no, grouped_item_no, peril_cd,
               SUM(net_pd_loss) net_pd_loss,
               SUM(net_pd_exp) net_pd_exp
          FROM gicl_clm_res_hist
         WHERE 1 = 1
           AND tran_id IS NOT NULL
           AND TRUNC(NVL(cancel_date, v_date +1))  > TRUNC(v_date)
           AND TRUNC(date_paid) <= TRUNC(v_date)
         GROUP BY claim_id, item_no, grouped_item_no, peril_cd ) c, gicl_claims d
  WHERE 1 = 1
    AND a.claim_id = d.claim_id
    AND a.claim_id = b.claim_id
    AND a.clm_res_hist_id = b.clm_res_hist_id
    AND b.claim_id = c.claim_id (+)
    AND b.item_no = c.item_no (+)
    AND b.grouped_item_no = c.grouped_item_no (+)
    AND b.peril_cd = c.peril_cd (+)
    AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                               FROM gicl_clm_res_hist a2
                              WHERE a2.claim_id =a.claim_id
                                AND a2.item_no =a.item_no
                                AND a2.grouped_item_no =a.grouped_item_no
                                AND a2.peril_cd =a.peril_cd
                                AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')<= TRUNC(v_date)
                                AND tran_id IS NULL)
    AND TRUNC(NVL(close_date, v_date+1)) > TRUNC(v_date)
   GROUP BY a.claim_id, a.clm_res_hist_id, a.item_no, a.grouped_item_no, a.peril_cd, DECODE(loss_sign, 1,(NVL (a.loss_reserve, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/- (NVL (c.net_pd_loss, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/)),0), DECODE(expense_sign, 1,(NVL(a.expense_reserve,0) - NVL(c.net_pd_exp,0)),0), d.dsp_loss_date, d.clm_file_date, a.booking_month, a.booking_year,d.iss_cd,a.dist_no
   HAVING DECODE(loss_sign, 1,(NVL (a.loss_reserve, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/- (NVL (c.net_pd_loss, 0) * (NVL (a.convert_rate, 1)) /*added by pjsantos NVL(a.convert_rate,1) to correct amounts in O/S*/)),0) >= 0
   OR DECODE(expense_sign, 1,(NVL(a.expense_reserve,0) - NVL(c.net_pd_exp,0)),0) >= 0;


  IF SQL% FOUND THEN
    FOR i IN vv_claim_id.FIRST..vv_claim_id.LAST
    LOOP
      IF vv_losses(i) < 0 THEN
        vv_losses(i) := 0;
      END IF;

      IF vv_expenses(i) < 0 THEN
        vv_expenses(i) := 0;
      END IF;

    INSERT INTO gicl_batch_takeup_revall
               (claim_id,             clm_res_hist_id,        item_no,             peril_cd,           losses,       expenses,
                dsp_loss_date,        clm_file_date,          booking_month,       booking_year,       iss_cd,       dist_no,
                grouped_item_no)
        VALUES (vv_claim_id(i),       vv_clm_res_hist_id(i),  vv_item_no(i),       vv_peril_cd(i),     vv_losses(i), vv_expenses(i),
                vv_dsp_loss_date(i),  vv_clm_file_date(i),    vv_booking_month(i), vv_booking_year(i), vv_iss_cd(i), vv_dist_no(i),
                vv_grouped_item_no(i));
  END LOOP;
  END IF;

  COMMIT;

END;
/



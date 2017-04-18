DROP PROCEDURE CPI.RECAP_LOSS_WEB;

CREATE OR REPLACE PROCEDURE CPI.recap_loss_web (p_fm_date DATE, p_to_date DATE)
AS
/*
** Modified by   : MAC
** Date Modified : 09/12/2013
** Modifications : Modified procedure for Recap II to be tally with Bordereaux - Losses Paid based on Posting Date.
*/
BEGIN
   EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_LOSSPD_EXT';

   BEGIN
    INSERT INTO giac_recap_losspd_ext
               (iss_cd, line_cd, subline_cd, issue_yy, pol_seq_no, renew_no,
                claim_id, item_no, peril_cd, tariff_cd, subline_type_cd,
                ri_cd, local_foreign_sw, cedant, nr_loss, nr_exp,
                treaty_loss, treaty_exp, facul_loss, facul_exp)
      SELECT   g.iss_cd, g.line_cd, g.subline_cd, g.issue_yy, g.pol_seq_no,
               g.renew_no, g.claim_id, a.item_no, a.peril_cd,
               h.tarf_cd tariff_cd, i.subline_type_cd, e.ri_cd,
               j.local_foreign_sw, g.ri_cd cedant,
               SUM
                  (DECODE
                      (b.share_type,
                       1, ROUND
                          (DECODE
                              (c.payee_type,
                               'L', ABS (NVL (b.shr_le_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.losses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          ),
                       0
                      )
                  ) nr_loss,
               SUM
                  (DECODE
                      (b.share_type,
                       1, ROUND
                          (DECODE
                              (c.payee_type,
                               'E', ABS (NVL (b.shr_le_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.expenses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          ),
                       0
                      )
                  ) nr_exp,
               SUM
                  (DECODE
                      (b.share_type,
                       1, 0,
                       giacp.v ('FACUL_SHARE_TYPE'), 0,
                       ROUND
                          (DECODE
                              (c.payee_type,
                               'L', ABS (NVL (e.shr_le_ri_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.losses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          )
                      )
                  ) treaty_loss,
               SUM
                  (DECODE
                      (b.share_type,
                       1, 0,
                       giacp.v ('FACUL_SHARE_TYPE'), 0,
                       ROUND
                          (DECODE
                              (c.payee_type,
                               'E', ABS (NVL (e.shr_le_ri_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.expenses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          )
                      )
                  ) treaty_exp,
               SUM
                  (DECODE
                      (b.share_type,
                       giacp.v ('FACUL_SHARE_TYPE'), ROUND
                          (DECODE
                              (c.payee_type,
                               'L', ABS (NVL (e.shr_le_ri_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.losses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          ),
                       0
                      )
                  ) facul_loss,
               SUM
                  (DECODE
                      (b.share_type,
                       giacp.v ('FACUL_SHARE_TYPE'), ROUND
                          (DECODE
                              (c.payee_type,
                               'E', ABS (NVL (e.shr_le_ri_adv_amt, 0))
                                * NVL (f.orig_curr_rate, f.convert_rate)
                                * SIGN (a.expenses_paid)
                                * gicls202_extraction_pkg.get_reversal
                                                                   (a.tran_id,
                                                                    p_fm_date,
                                                                    p_to_date,
                                                                    2
                                                                   ),
                               0
                              ),
                           2
                          ),
                       0
                      )
                  ) facul_exp
          FROM gicl_clm_res_hist a,
               gicl_loss_exp_ds b,
               gicl_clm_loss_exp c,
               giac_acctrans d,
               gicl_loss_exp_rids e,
               gicl_advice f,
               gicl_claims g,
               gicl_fire_dtl h,
               gicl_motor_car_dtl i,
               giis_reinsurer j
         WHERE a.dist_sw IS NULL
           AND gicls202_extraction_pkg.get_reversal (a.tran_id,
                                                     p_fm_date,
                                                     p_to_date,
                                                     2
                                                    ) != 0
           AND a.claim_id = b.claim_id
           AND a.clm_loss_id = b.clm_loss_id
           AND a.dist_no = b.clm_dist_no
           AND b.claim_id = c.claim_id
           AND b.clm_loss_id = c.clm_loss_id
           AND a.tran_id = d.tran_id
           AND b.claim_id = e.claim_id(+)
           AND b.clm_loss_id = e.clm_loss_id(+)
           AND b.clm_dist_no = e.clm_dist_no(+)
           AND b.grp_seq_no = e.grp_seq_no(+)
           AND a.advice_id = f.advice_id
           AND a.claim_id = g.claim_id
           AND a.claim_id = h.claim_id(+)
           AND a.item_no = h.item_no(+)
           AND a.claim_id = i.claim_id(+)
           AND a.item_no = i.item_no(+)
           AND e.ri_cd = j.ri_cd(+)
           AND (  TRUNC (d.posting_date) BETWEEN p_fm_date AND p_to_date
               OR DECODE (gicls202_extraction_pkg.get_reversal (a.tran_id, p_fm_date, p_to_date, 2 ), 1, 0, 1) = 1
               )
           AND (   DECODE (a.cancel_tag,
                           'Y', TRUNC (a.cancel_date),
                           p_to_date + 1
                          ) > p_to_date
                OR DECODE (gicls202_extraction_pkg.get_reversal (a.tran_id,
                                                                 p_fm_date,
                                                                 p_to_date,
                                                                 2
                                                                ),
                           1, 0,
                           1
                          ) = 1
               )
      GROUP BY g.iss_cd,
               g.line_cd,
               g.subline_cd,
               g.issue_yy,
               g.pol_seq_no,
               g.renew_no,
               g.claim_id,
               a.item_no,
               a.peril_cd,
               h.tarf_cd,
               i.subline_type_cd,
               b.grp_seq_no,
               e.ri_cd,
               j.local_foreign_sw,
               g.ri_cd;
   
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END ;
/*added by aliza G. 2016-04-06*/

   --retrieve OS as of 'to date'
   EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_LOSS_CUR_DTL_EXT ';
    
   BEGIN
       INSERT INTO giac_recap_loss_cur_dtl_ext
          (SELECT d.*
             FROM (SELECT a.claim_id, a.item_no, a.peril_cd, a.grouped_item_no,
                          line_cd, iss_cd, c.grp_seq_no, b.posting_date,
                          acct_tran_id, os_loss, os_expense,
                          NVL (giis_users_pkg.app_user, USER), SYSDATE
                     FROM gicl_take_up_hist a, giac_acctrans b, gicl_reserve_ds c
                    WHERE a.acct_tran_id = b.tran_id
                      AND b.tran_flag = 'P'
                      AND a.clm_res_hist_id = c.clm_res_hist_id
                      AND b.tran_class = 'OL'
                      AND a.claim_id = c.claim_id
                      AND a.item_no = c.item_no
                      AND a.peril_cd = c.peril_cd
                      AND c.grp_seq_no = giisp.n ('NET_RETENTION')
                      AND NVL (a.grouped_item_no, 0) = NVL (c.grouped_item_no, 0)) d,
                  (SELECT MAX (posting_date) posting_date
                     FROM giac_acctrans
                    WHERE tran_class = 'OL'
                      AND posting_date BETWEEN p_fm_date AND p_to_date) e
            WHERE d.posting_date = e.posting_date);
    EXCEPTION WHEN NO_DATA_FOUND THEN
        NULL;
    END ;


--retrieve IS as of 'from date'
   EXECUTE IMMEDIATE 'TRUNCATE TABLE giac_recap_loss_prev_dtl_ext';

   INSERT INTO giac_recap_loss_prev_dtl_ext
      SELECT *
        FROM (SELECT d.*
                FROM (SELECT a.claim_id, a.item_no, a.peril_cd,
                             a.grouped_item_no, line_cd, iss_cd, c.grp_seq_no,
                             b.posting_date, acct_tran_id, os_loss,
                             os_expense, NVL (giis_users_pkg.app_user, USER),
                             SYSDATE
                        FROM gicl_take_up_hist a,
                             giac_acctrans b,
                             gicl_reserve_ds c
                       WHERE a.acct_tran_id = b.tran_id
                         AND b.tran_flag = 'P'
                         AND a.clm_res_hist_id = c.clm_res_hist_id
                         AND b.tran_class = 'OL'
                         AND a.claim_id = c.claim_id
                         AND a.item_no = c.item_no
                         AND a.peril_cd = c.peril_cd
                         AND c.grp_seq_no = giisp.n ('NET_RETENTION')
                         AND NVL (a.grouped_item_no, 0) =
                                                    NVL (c.grouped_item_no, 0)) d,
                     (SELECT MAX (posting_date) posting_date
                        FROM giac_acctrans
                       WHERE tran_class = 'OL'
                         AND posting_date BETWEEN TO_DATE (   '01/01/'
                                         || (TO_CHAR (p_to_date, 'RRRR') - 1),
                                         'MM/DD/RRRR'
                                        ) AND
                                TO_DATE (   '12/31/'
                                         || (TO_CHAR (p_to_date, 'RRRR') - 1),
                                         'MM/DD/RRRR'
                                        )) e
               WHERE d.posting_date = NVL(e.posting_date,TO_DATE('01/01/1900','MM/DD/RRRR')));
           
/*end of code added by aliza G. 2016-04-06*/
END; 
/


/



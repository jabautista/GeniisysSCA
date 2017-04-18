DROP PROCEDURE CPI.RECAP_OSLOSS_WEB;

CREATE OR REPLACE PROCEDURE CPI.Recap_Osloss_web (p_to_date  DATE)
AS
/*
** Modified by   : MAC
** Date Modified : 09/12/2013
** Modifications : Modified procedure of Recap V to be tally with Bordereaux - Outstanding Losses.
*/
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE giac_recap_osloss_ext';

       INSERT INTO giac_recap_osloss_ext
               (iss_cd, line_cd, subline_cd, claim_id, issue_yy, pol_seq_no,
                renew_no, item_no, peril_cd, peril_type, tariff_cd,
                subline_type_cd, ri_cd, local_foreign_sw, cedant, nr_loss,
                nr_exp, treaty_loss, treaty_exp, facul_loss, facul_exp)
      SELECT   a.iss_cd, a.line_cd, a.subline_cd, a.claim_id, a.issue_yy,
               a.pol_seq_no, a.renew_no, c.item_no, c.peril_cd, b.peril_type,
               d.tarf_cd tariff_cd, e.subline_type_cd, g.ri_cd,
               h.local_foreign_sw, a.ri_cd cedant,
               SUM (DECODE (f.share_type,
                            1, ROUND (  c.os_loss
                                      * (f.shr_pct / 100)
                                      --* c.convert_rate, commented out mlachica 09252013
                                      ,2
                                     ),
                            0
                           )
                   ) nr_loss,
               SUM (DECODE (f.share_type,
                            1, ROUND (  c.os_expense
                                      * (f.shr_pct / 100)
                                      --* c.convert_rate, commented out mlachica 09252013
                                      ,2
                                     ),
                            0
                           )
                   ) nr_exp,
               SUM (DECODE (f.share_type,
                            1, 0,
                            giacp.v ('FACUL_SHARE_TYPE'), 0,
                            ROUND (  c.os_loss
                                   * (g.shr_ri_pct / 100)
                                   --* c.convert_rate, commented out mlachica 09252013
                                   ,2
                                  )
                           )
                   ) treaty_loss,
               SUM (DECODE (f.share_type,
                            1, 0,
                            giacp.v ('FACUL_SHARE_TYPE'), 0,
                            ROUND (  c.os_expense
                                   * (g.shr_ri_pct / 100)
                                   --* c.convert_rate, commented out mlachica 09252013
                                   ,2
                                  )
                           )
                   ) treaty_exp,
               SUM (DECODE (f.share_type,
                            giacp.v ('FACUL_SHARE_TYPE'), ROUND
                                                             (  c.os_loss
                                                              * (  g.shr_ri_pct
                                                                 / 100
                                                                )
                                                             --* c.convert_rate, commented out mlachica 09252013
                                                             ,2
                                                             ),
                            0
                           )
                   ) facul_loss,
               SUM (DECODE (f.share_type,
                            giacp.v ('FACUL_SHARE_TYPE'), ROUND
                                                             (  c.os_expense
                                                              * (  g.shr_ri_pct
                                                                 / 100
                                                                )
                                                             --* c.convert_rate, commented out mlachica 09252013
                                                             ,2
                                                             ),
                            0
                           )
                   ) facul_exp
          FROM gicl_claims a,
               giis_peril b,
               (SELECT a.claim_id, a.item_no, a.peril_cd, d.os_loss,
                       d.os_expense, a.grouped_item_no, a.clm_res_hist_id,
                       TRUNC (e.posting_date) posting_date,
                       NVL (a.convert_rate, 1) convert_rate
                  FROM gicl_clm_res_hist a,
                       gicl_item_peril b,
                       gicl_claims c,
                       gicl_take_up_hist d,
                       giac_acctrans e
                 WHERE a.claim_id = b.claim_id
                   AND a.item_no = b.item_no
                   AND a.peril_cd = b.peril_cd
                   AND a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id
                   AND a.clm_res_hist_id = d.clm_res_hist_id
                   AND d.acct_tran_id = e.tran_id
                   AND TRUNC (e.posting_date) = p_to_date
                   AND e.tran_flag = 'P'
                   AND NVL (d.os_loss, 0) + NVL (d.os_expense, 0) > 0) c,
               gicl_fire_dtl d,
               gicl_motor_car_dtl e,
               gicl_reserve_ds f,
               gicl_reserve_rids g,
               giis_reinsurer h
         WHERE a.line_cd = b.line_cd
           AND c.peril_cd = b.peril_cd
           AND a.claim_id = c.claim_id
           AND c.claim_id = d.claim_id(+)
           AND c.item_no = d.item_no(+)
           AND c.claim_id = e.claim_id(+)
           AND c.item_no = e.item_no(+)
           AND f.claim_id = c.claim_id
           AND f.clm_res_hist_id = c.clm_res_hist_id
           AND f.claim_id = g.claim_id(+)
           AND f.clm_res_hist_id = g.clm_res_hist_id(+)
           AND f.clm_dist_no = g.clm_dist_no(+)
           AND f.grp_seq_no = g.grp_seq_no(+)
           AND g.ri_cd = h.ri_cd(+)
      GROUP BY a.iss_cd,
               a.line_cd,
               a.subline_cd,
               a.claim_id,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no,
               c.item_no,
               c.peril_cd,
               b.peril_type,
               d.tarf_cd,
               e.subline_type_cd,
               g.ri_cd,
               h.local_foreign_sw,
               c.posting_date,
               f.grp_seq_no,
               a.ri_cd;
  COMMIT;
END;
/



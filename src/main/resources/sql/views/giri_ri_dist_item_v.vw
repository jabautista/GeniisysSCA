DROP VIEW CPI.GIRI_RI_DIST_ITEM_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_ri_dist_item_v (line_cd,
                                                      subline_cd,
                                                      iss_cd,
                                                      issue_yy,
                                                      pol_seq_no,
                                                      renew_no,
                                                      eff_date,
                                                      expiry_date,
                                                      item_no,
                                                      currency_cd,
                                                      currency_rt,
                                                      ri_cd,
                                                      peril_cd,
                                                      ri_tsi_amt
                                                     )
AS
   SELECT   t5.line_cd, t5.subline_cd, t5.iss_cd, t5.issue_yy, t5.pol_seq_no,
            t5.renew_no, NVL (t7.from_date, t5.eff_date) eff_date,
            NVL (t7.TO_DATE, t5.expiry_date) expiry_date, t6.item_no,
            t3.currency_cd, t3.currency_rt, t1.ri_cd, t1.peril_cd,
            SUM (t1.ri_tsi_amt) ri_tsi_amt
       FROM giri_frperil t1,
            giri_frps_ri t2,
            giri_distfrps t3,
            giuw_pol_dist t4,
            gipi_polbasic t5,
            giuw_itemperilds t6,
            gipi_item t7
      WHERE t1.line_cd = t2.line_cd
        AND t1.frps_yy = t2.frps_yy
        AND t1.frps_seq_no = t2.frps_seq_no
        AND t1.ri_seq_no = t2.ri_seq_no
        AND t2.line_cd = t3.line_cd
        AND t2.frps_yy = t3.frps_yy
        AND t2.frps_seq_no = t3.frps_seq_no
        AND NVL (t2.reverse_sw, 'N') = 'N'
        AND NVL (t2.delete_sw, 'N') = 'N'
        AND t3.dist_no = t4.dist_no
        AND t4.policy_id = t5.policy_id
        AND t3.dist_no = t6.dist_no
        AND t3.dist_seq_no = t6.dist_seq_no
        AND t1.line_cd = t6.line_cd
        AND t1.peril_cd = t6.peril_cd
        AND t4.dist_flag = '3'
        AND t3.ri_flag = '2'
        AND t5.policy_id = t7.policy_id
        AND t6.item_no = t7.item_no
   GROUP BY t5.line_cd,
            t5.subline_cd,
            t5.iss_cd,
            t5.issue_yy,
            t5.pol_seq_no,
            t5.renew_no,
            NVL (t7.from_date, t5.eff_date),
            NVL (t7.TO_DATE, t5.expiry_date),
            t6.item_no,
            t3.currency_cd,
            t3.currency_rt,
            t1.ri_cd,
            t1.peril_cd;



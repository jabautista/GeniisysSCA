DROP VIEW CPI.GIRI_BASIC_INFO_ITEM_SUM_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_basic_info_item_sum_v (line_cd,
                                                             subline_cd,
                                                             iss_cd,
                                                             issue_yy,
                                                             pol_seq_no,
                                                             renew_no,
                                                             eff_date,
                                                             incept_date,
                                                             endt_expiry_date,
                                                             expiry_date,
                                                             item_no,
                                                             currency_cd,
                                                             currency_rt,
                                                             peril_cd,
                                                             policy_id,
                                                             tsi_amt
                                                            )
AS
   SELECT   t2.line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,
            t2.eff_date, t2.incept_date, t2.endt_expiry_date, t2.expiry_date,
            t1.item_no, currency_cd, currency_rt, t1.peril_cd, t2.policy_id,
            SUM (t1.tsi_amt) tsi_amt
       FROM gipi_itmperil t1, gipi_polbasic t2, gipi_item t3
      WHERE t1.policy_id = t2.policy_id
        AND t1.policy_id = t3.policy_id
        AND t1.item_no = t3.item_no
        AND t2.pol_flag NOT IN ('4', '5')
   GROUP BY t2.line_cd,
            subline_cd,
            iss_cd,
            issue_yy,
            pol_seq_no,
            renew_no,
            t2.eff_date,
            t2.expiry_date,
            t1.item_no,
            currency_cd,
            currency_rt,
            t1.peril_cd,
            t2.policy_id,
            t2.incept_date,
            t2.endt_expiry_date
            WITH READ ONLY;



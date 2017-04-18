DROP VIEW CPI.GIPI_FIRESTAT_ACCUM_DTL_VW;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_firestat_accum_dtl_vw (zone_type,
                                                             as_of_sw,
                                                             as_of_date,
                                                             date_from,
                                                             date_to,
                                                             share_type,
                                                             acct_trty_type,
                                                             dist_share_name,
                                                             zone_grp,
                                                             zone_no,
                                                             share_cd,
                                                             line_cd,
                                                             subline_cd,
                                                             iss_cd,
                                                             issue_yy,
                                                             pol_seq_no,
                                                             renew_no,
                                                             policy_no,
                                                             bldg_tsi_amt,
                                                             bldg_prem_amt,
                                                             contents_tsi_amt,
                                                             contents_prem_amt,
                                                             lossprofit_tsi_amt,
                                                             lossprofit_prem_amt,
                                                             user_id
                                                            )
AS
   SELECT   a.zone_type, a.as_of_sw, a.as_of_date, a.date_from, a.date_to,
            a.share_type, a.acct_trty_type,
            DECODE (a.share_type,
                    '1', 'NET RETENTION',
                    '3', 'FACULTATIVE',
                    '2', NVL (a.acct_trty_type_lname, a.acct_trty_type_sname)
                   ) dist_share_name,
            NVL (a.zone_grp, '0') zone_grp, NVL (a.zone_no, '0') zone_no,
            NULL share_cd, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
            a.pol_seq_no, a.renew_no, a.policy_no,
            SUM (DECODE (a.fi_item_grp, 'B', NVL (a.share_tsi_amt, 0), 0)
                ) bldg_tsi_amt,
            SUM (DECODE (a.fi_item_grp, 'B', NVL (a.share_prem_amt, 0), 0)
                ) bldg_prem_amt,
            SUM (DECODE (a.fi_item_grp, 'C', NVL (a.share_tsi_amt, 0), 0)
                ) contents_tsi_amt,
            SUM (DECODE (a.fi_item_grp, 'C', NVL (a.share_prem_amt, 0), 0)
                ) contents_prem_amt,
            SUM (DECODE (a.fi_item_grp, 'L', NVL (a.share_tsi_amt, 0), 0)
                ) lossprofit_tsi_amt,
            SUM (DECODE (a.fi_item_grp, 'L', NVL (a.share_prem_amt, 0), 0)
                ) lossprofit_prem_amt,
            a.user_id
       FROM gipi_firestat_extract_dtl_vw a
      WHERE 1 = 1 AND a.fi_item_grp IS NOT NULL AND a.peril_cd IS NOT NULL
-- only retrieve extraction based on latest ext logic
   GROUP BY a.zone_grp,
            a.zone_no,
            a.zone_type,
            a.line_cd,
            a.subline_cd,
            a.iss_cd,
            a.issue_yy,
            a.pol_seq_no,
            a.renew_no,
            a.policy_no,
            a.as_of_sw,
            a.as_of_date,
            a.date_from,
            a.date_to,
            a.user_id,
            a.share_type,
            a.acct_trty_type,
            a.acct_trty_type_lname,
            a.acct_trty_type_sname;



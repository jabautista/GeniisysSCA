DROP VIEW CPI.GIPI_FIRESTAT_ZONE_DTL_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_firestat_zone_dtl_v (assd_name,
                                                           policy_no,
                                                           share_tsi_amt,
                                                           share_prem_amt,
                                                           as_of_sw,
                                                           user_id,
                                                           share_cd
                                                          )
AS
   SELECT   a.assd_name assd_name,
               b.line_cd
            || ' - '
            || b.subline_cd
            || ' - '
            || b.iss_cd
            || ' - '
            || LTRIM (TO_CHAR (b.issue_yy, '00'))
            || ' - '
            || LTRIM (TO_CHAR (b.pol_seq_no, '0000000'))
            || ' - '
            || LTRIM (TO_CHAR (b.renew_no, '00')) policy_no,
            SUM (c.share_tsi_amt) share_tsi_amt,
            SUM (c.share_prem_amt) share_prem_amt, c.as_of_sw, c.user_id,
            c.share_cd
       FROM giis_assured a, gipi_polbasic b, gipi_firestat_extract_dtl c
      WHERE c.assd_no = a.assd_no AND c.policy_id = b.policy_id
   GROUP BY b.line_cd,
            b.subline_cd,
            b.iss_cd,
            b.issue_yy,
            b.pol_seq_no,
            b.renew_no,
            c.as_of_sw,
            c.user_id,
            c.share_cd,
            a.assd_name,
            c.zone_type,
            c.zone_no;



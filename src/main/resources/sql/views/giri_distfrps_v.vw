DROP VIEW CPI.GIRI_DISTFRPS_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_distfrps_v (line_cd,
                                                  subline_cd,
                                                  iss_cd,
                                                  issue_yy,
                                                  pol_seq_no,
                                                  renew_no,
                                                  endt_iss_cd,
                                                  endt_yy,
                                                  endt_seq_no,
                                                  frps_yy,
                                                  frps_seq_no,
                                                  policy_no,
                                                  frps_no,
                                                  assured,
                                                  eff_date,
                                                  expiry_date,
                                                  tot_fac_tsi,
                                                  tot_fac_spct,
                                                  tot_fac_prem,
                                                  endt_no,
                                                  currency_desc,
                                                  policy_id,
                                                  tsi_amt,
                                                  ri_flag,
                                                  dist_no,
                                                  dist_seq_no,
                                                  tsi_amt2,
                                                  prem_amt,
                                                  tot_fac_spct2
                                                 )
AS
   SELECT t1.line_cd, subline_cd, t1.iss_cd, issue_yy, pol_seq_no, renew_no,
          endt_iss_cd, endt_yy, endt_seq_no, frps_yy, frps_seq_no,
             t1.line_cd
          || ' - '
          || t1.subline_cd
          || ' - '
          || t1.iss_cd
          || '- '
          || LTRIM (RTRIM (TO_CHAR (t1.issue_yy, '09')))
          || ' - '
          || LTRIM (RTRIM (TO_CHAR (t1.pol_seq_no, '0999999')))
          || LTRIM (RTRIM (TO_CHAR (t1.renew_no, '09'))) policy_no,
             t2.frps_yy
          || ' - '
          || LTRIM (TO_CHAR (frps_seq_no, '099999')) frps_no,
          t3.assd_name assured, t4.eff_date, t4.expiry_date, t2.tot_fac_tsi,
          tot_fac_spct2, t2.tot_fac_prem,
             t1.line_cd
          || ' - '
          || t1.subline_cd
          || ' - '
          || t1.iss_cd
          || ' - '
          || t1.endt_iss_cd
          || ' - '
          || LTRIM (RTRIM (TO_CHAR (t1.endt_yy, '09')))
          || ' - '
          || LTRIM (RTRIM (TO_CHAR (t1.endt_seq_no, '099999'))) endt_no,
          currency_desc, t1.policy_id, t2.tsi_amt, t2.ri_flag, t2.dist_no,
          t2.dist_seq_no, t4.tsi_amt tsi_amt2              --lemuel 08.06.08--
                                             ,
          t4.prem_amt                                      --lemuel 08.06.08--
                     ,
          NVL (t2.tot_fac_spct2, tot_fac_spct2) tot_fac_spct2
                                                           --lemuel 08.06.08--
     FROM gipi_polbasic t1,
          giri_distfrps t2,
          giis_assured t3,
          giuw_pol_dist t4,
          giis_currency t5,
          gipi_parlist t6
    WHERE t1.policy_id = t4.policy_id
      AND t1.par_id = t6.par_id
      AND t6.assd_no = t3.assd_no
      AND t4.dist_no = t2.dist_no
      AND t2.currency_cd = t5.main_currency_cd
      AND ri_flag = '2';



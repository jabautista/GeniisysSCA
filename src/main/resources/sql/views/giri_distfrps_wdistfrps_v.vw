DROP VIEW CPI.GIRI_DISTFRPS_WDISTFRPS_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_distfrps_wdistfrps_v (par_policy_id,
                                                            par_id,
                                                            line_cd,
                                                            frps_yy,
                                                            frps_seq_no,
                                                            iss_cd,
                                                            par_yy,
                                                            par_seq_no,
                                                            quote_seq_no,
                                                            subline_cd,
                                                            issue_yy,
                                                            pol_seq_no,
                                                            renew_no,
                                                            endt_iss_cd,
                                                            endt_yy,
                                                            endt_seq_no,
                                                            assd_name,
                                                            eff_date,
                                                            expiry_date,
                                                            dist_no,
                                                            dist_seq_no,
                                                            tot_fac_spct,
                                                            tsi_amt,
                                                            tot_fac_tsi,
                                                            prem_amt,
                                                            tot_fac_prem,
                                                            currency_desc,
                                                            dist_flag,
                                                            prem_warr_sw,
                                                            create_date,
                                                            user_id,
                                                            endt_type,
                                                            ri_flag,
                                                            incept_date,
                                                            op_group_no,
                                                            tot_fac_spct2
                                                           )
AS
   SELECT NULL par_policy_id, t3.par_id, t1.line_cd, frps_yy, frps_seq_no,
          t4.iss_cd, par_yy, par_seq_no, quote_seq_no, subline_cd, issue_yy,
          pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, assd_name,
          t2.eff_date, t2.expiry_date, t1.dist_no, t1.dist_seq_no,
          tot_fac_spct, t1.tsi_amt, tot_fac_tsi, t1.prem_amt, tot_fac_prem,
          currency_desc, t2.dist_flag, prem_warr_sw, t1.create_date,
          t1.user_id, t2.endt_type, ri_flag, t3.incept_date, t1.op_group_no,
          t1.tot_fac_spct2
     FROM giis_currency t6,
          giis_assured t5,
          gipi_parlist t4,
          gipi_wpolbas t3,
          giuw_pol_dist t2,
          giri_wdistfrps t1
    WHERE t1.dist_no = t2.dist_no
      AND t2.par_id = t3.par_id
      AND t3.par_id = t4.par_id
      AND t4.assd_no = t5.assd_no
      AND t1.currency_cd = t6.main_currency_cd
      AND t2.dist_flag = '2'
      AND t3.pol_flag != '5'
   UNION
   SELECT t3.policy_id, t4.par_id, t1.line_cd, frps_yy, frps_seq_no,
          t4.iss_cd, par_yy, par_seq_no, quote_seq_no, subline_cd, issue_yy,
          pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, assd_name,
          t2.eff_date, t2.expiry_date, t1.dist_no, t1.dist_seq_no,
          tot_fac_spct, t1.tsi_amt, tot_fac_tsi, t1.prem_amt, tot_fac_prem,
          currency_desc, t2.dist_flag, prem_warr_sw, t1.create_date,
          t1.user_id, t2.endt_type, ri_flag, t3.incept_date, t1.op_group_no,
          t1.tot_fac_spct2
     FROM giis_currency t6,
          giis_assured t5,
          gipi_parlist t4,
          gipi_polbasic t3,
          giuw_pol_dist t2,
          giri_wdistfrps t1
    WHERE t1.dist_no = t2.dist_no
      AND t2.policy_id = t3.policy_id
      AND t3.par_id = t4.par_id
      AND t4.assd_no = t5.assd_no
      AND t1.currency_cd = t6.main_currency_cd
      AND t2.dist_flag = '2'
      AND t3.pol_flag != '5'
   UNION
   SELECT t3.policy_id, t4.par_id, t1.line_cd, frps_yy, frps_seq_no,
          t4.iss_cd, par_yy, par_seq_no, quote_seq_no, subline_cd, issue_yy,
          pol_seq_no, renew_no, endt_iss_cd, endt_yy, endt_seq_no, assd_name,
          t2.eff_date, t2.expiry_date, t1.dist_no, t1.dist_seq_no,
          tot_fac_spct, t1.tsi_amt, tot_fac_tsi, t1.prem_amt, tot_fac_prem,
          currency_desc, t2.dist_flag, prem_warr_sw, t1.create_date,
          t1.user_id, t2.endt_type, ri_flag, t3.incept_date, t1.op_group_no,
          t1.tot_fac_spct2
     FROM giis_currency t6,
          giis_assured t5,
          gipi_parlist t4,
          gipi_polbasic t3,
          giuw_pol_dist t2,
          giri_distfrps t1
    WHERE t1.dist_no = t2.dist_no
      AND t2.policy_id = t3.policy_id
      AND t3.par_id = t4.par_id
      AND t4.assd_no = t5.assd_no
      AND t1.currency_cd = t6.main_currency_cd
      AND t1.ri_flag = '3'
      AND t3.pol_flag != '5';



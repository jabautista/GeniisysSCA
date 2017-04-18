DROP VIEW CPI.GIRI_BINDER_POL_PERIL_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_binder_pol_peril_v (policy_id,
                                                          dist_no,
                                                          dist_seq_no,
                                                          line_cd,
                                                          binder_yy,
                                                          binder_seq_no,
                                                          binder_date,
                                                          ri_cd,
                                                          ri_sname,
                                                          frps_yy,
                                                          frps_seq_no,
                                                          subline_cd,
                                                          iss_cd,
                                                          issue_yy,
                                                          pol_seq_no,
                                                          renew_no,
                                                          currency_desc,
                                                          currency_rt,
                                                          endt_iss_cd,
                                                          endt_yy,
                                                          endt_seq_no,
                                                          reverse_date,
                                                          assd_name,
                                                          tsi_amt,
                                                          prem_amt,
                                                          peril_cd,
                                                          ri_peril_prem_amt,
                                                          ri_prem_amt,
                                                          tot_fac_prem,
                                                          ri_tsi_amt,
                                                          tot_fac_tsi,
                                                          ri_comm_amt,
                                                          ri_shr_pct,
                                                          prem_tax,
                                                          fnl_binder_id,
                                                          bndr_print_date,
                                                          create_date,
                                                          user_id,
                                                          acc_ent_date,
                                                          acc_rev_date
                                                         )
AS
   SELECT t6.policy_id, t5.dist_no, t4.dist_seq_no, t1.line_cd, binder_yy,
          binder_seq_no, binder_date, t3.ri_cd, ri_sname, t3.frps_yy,
          t3.frps_seq_no, subline_cd, t6.iss_cd, issue_yy, pol_seq_no,
          renew_no, currency_desc, t4.currency_rt, endt_iss_cd, endt_yy,
          endt_seq_no, reverse_date, assd_name, t4.tsi_amt, t4.prem_amt,
          t10.peril_cd, t10.ri_prem_amt ri_peril_prem_amt, t1.ri_prem_amt,
          t4.tot_fac_prem, t1.ri_tsi_amt, t4.tot_fac_tsi, t1.ri_comm_amt,
          t1.ri_shr_pct, t1.prem_tax, t1.fnl_binder_id, bndr_print_date,
          t4.create_date, t4.user_id, t1.acc_ent_date, t1.acc_rev_date
     FROM giri_binder t1,
          giis_reinsurer t2,
          giri_frps_ri t3,
          giri_distfrps t4,
          giuw_pol_dist t5,
          gipi_polbasic t6,
          giis_assured t7,
          giis_currency t8,
          gipi_parlist t9,
          giri_frperil t10
    WHERE t1.ri_cd = t2.ri_cd
      AND t1.fnl_binder_id = t3.fnl_binder_id
      AND t3.line_cd = t4.line_cd
      AND t3.frps_yy = t4.frps_yy
      AND t3.frps_seq_no = t4.frps_seq_no
      AND t4.dist_no = t5.dist_no
      AND t5.policy_id = t6.policy_id
      AND t6.par_id = t9.par_id
      AND t9.assd_no = t7.assd_no
      AND t4.currency_cd = t8.main_currency_cd
      AND t3.line_cd = t10.line_cd
      AND t3.frps_yy = t10.frps_yy
      AND t3.frps_seq_no = t10.frps_seq_no
      AND t3.ri_cd = t10.ri_cd
      AND t3.ri_seq_no = t10.ri_seq_no;



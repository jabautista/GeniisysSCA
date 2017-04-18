DROP VIEW CPI.GIRI_BINDER_POLBASIC_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giri_binder_polbasic_v (line_cd,
                                                         binder_yy,
                                                         binder_seq_no,
                                                         binder_date,
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
                                                         ri_prem_amt,
                                                         ri_tsi_amt,
                                                         ri_comm_amt,
                                                         ri_comm_rt,
                                                         ri_accept_date,
                                                         ri_accept_by,
                                                         ri_as_no,
                                                         remarks,
                                                         bndr_remarks1,
                                                         bndr_remarks2,
                                                         bndr_remarks3,
                                                         ri_shr_pct,
                                                         prem_tax,
                                                         prem_amt,
                                                         fnl_binder_id,
                                                         bndr_print_date,
                                                         ri_prem_vat,
                                                         ri_comm_vat,
                                                         ri_wholding_vat,
                                                         local_foreign_sw
                                                        )
AS
   SELECT t1.line_cd, binder_yy, binder_seq_no, binder_date, ri_sname,
          t3.frps_yy, t3.frps_seq_no, subline_cd, t6.iss_cd, issue_yy,
          pol_seq_no, renew_no, currency_desc, t4.currency_rt, endt_iss_cd,
          endt_yy, endt_seq_no, reverse_date, assd_name, t4.tsi_amt,
          t1.ri_prem_amt, t1.ri_tsi_amt, t1.ri_comm_amt,
          t1.ri_comm_rt                                            --vj 041107
                       ,
          t3.ri_accept_date                                        --vj 041107
                           ,
          t3.ri_accept_by                                          --vj 041107
                         ,
          t3.ri_as_no                                              --vj 041107
                     ,
          t3.remarks                                               --vj 041107
                    ,
          t3.bndr_remarks1                                         --vj 041107
                          ,
          t3.bndr_remarks2                                         --vj 041107
                          ,
          t3.bndr_remarks3                                         --vj 041107
                          ,
          t1.ri_shr_pct, t1.prem_tax, t4.prem_amt, t1.fnl_binder_id,
          bndr_print_date, t1.ri_prem_vat, t1.ri_comm_vat, t1.ri_wholding_vat,
          t2.local_foreign_sw
     FROM giri_binder t1,
          giis_reinsurer t2,
          giri_frps_ri t3,
          giri_distfrps t4,
          giuw_pol_dist t5,
          gipi_polbasic t6,
          giis_assured t7,
          giis_currency t8,
          gipi_parlist t9
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
      AND t4.ri_flag = '2';



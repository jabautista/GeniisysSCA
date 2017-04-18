CREATE OR REPLACE FORCE VIEW cpi.gipi_parlist_polbasic_v (par_id,
                                                          plist_line_cd,
                                                          plist_iss_cd,
                                                          par_yy,
                                                          par_seq_no,
                                                          quote_seq_no,
                                                          par_type,
                                                          assd_no,
                                                          underwriter,
                                                          assign_sw,
                                                          remarks,
                                                          par_status,
                                                          policy_id,
                                                          pbasic_line_cd,
                                                          subline_cd,
                                                          pbasic_iss_cd,
                                                          issue_yy,
                                                          pol_seq_no,
                                                          endt_iss_cd,
                                                          endt_yy,
                                                          endt_seq_no,
                                                          renew_no,
                                                          endt_type,
                                                          incept_date,
                                                          expiry_date,
                                                          eff_date,
                                                          issue_date,
                                                          pol_flag,
                                                          designation,
                                                          address1,
                                                          address2,
                                                          address3,
                                                          mortg_name,
                                                          tsi_amt,
                                                          prem_amt,
                                                          ann_tsi_amt,
                                                          ann_prem_amt,
                                                          pool_pol_no,
                                                          foreign_acc_sw,
                                                          invoice_sw,
                                                          back_stat,
                                                          acct_ent_date,
                                                          user_id,
                                                          last_upd_date,
                                                          spld_acct_ent_date,
                                                          spld_approval,
                                                          spld_date,
                                                          spld_user_id,
                                                          spld_flag,
                                                          dist_flag,
                                                          orig_policy_id,
                                                          endt_expiry_date,
                                                          no_of_items,
                                                          subline_type_cd,
                                                          auto_renew_flag,
                                                          cred_branch,
                                                          pack_par_id
                                                         )
AS
   SELECT a.par_id, a.line_cd plist_line_cd, a.iss_cd plist_iss_cd, a.par_yy,
          a.par_seq_no, a.quote_seq_no, a.par_type, a.assd_no, a.underwriter,
          a.assign_sw, a.remarks, a.par_status, b.policy_id,
          b.line_cd pbasic_line_cd, b.subline_cd, b.iss_cd pbasic_iss_cd,
          b.issue_yy, b.pol_seq_no, b.endt_iss_cd, b.endt_yy, b.endt_seq_no,
          b.renew_no, b.endt_type,
          NVL (b.incept_date, c.incept_date) incept_date,
          
          --modified by VJPS 20130502
          NVL (b.expiry_date, c.expiry_date) expiry_date,
          
          --modified by VJPS 20130502
          NVL (b.eff_date, c.eff_date) eff_date,   --modified by VJPS 20130502
          NVL (b.issue_date, c.issue_date) issue_date,
                                                      --modified by VJPS 20130502
                                                      b.pol_flag,
          b.designation, b.address1, b.address2, b.address3, b.mortg_name,
          b.tsi_amt, b.prem_amt, b.ann_tsi_amt, b.ann_prem_amt, b.pool_pol_no,
          b.foreign_acc_sw, b.invoice_sw, b.back_stat, b.acct_ent_date,
          b.user_id, b.last_upd_date, b.spld_acct_ent_date, b.spld_approval,
          b.spld_date, b.spld_user_id, b.spld_flag, b.dist_flag,
          b.orig_policy_id, b.endt_expiry_date, b.no_of_items,
          b.subline_type_cd, b.auto_renew_flag,
          b.cred_branch,                           --added by cherrie 09.06.2012
          a.pack_par_id --added by edward
     FROM gipi_parlist a, gipi_polbasic b, gipi_wpolbas c
    WHERE a.par_id = b.par_id(+) AND a.par_id = c.par_id(+);


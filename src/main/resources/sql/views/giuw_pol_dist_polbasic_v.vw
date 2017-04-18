DROP VIEW CPI.GIUW_POL_DIST_POLBASIC_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.giuw_pol_dist_polbasic_v (policy_id,
                                                           line_cd,
                                                           subline_cd,
                                                           iss_cd,
                                                           issue_yy,
                                                           par_id,
                                                           pol_seq_no,
                                                           assd_no,
                                                           endt_iss_cd,
                                                           spld_flag,
                                                           dist_flag,
                                                           dist_no,
                                                           eff_date,
                                                           eff_date_polbas,
                                                           issue_date,
                                                           expiry_date_polbas,
                                                           endt_expiry_date,
                                                           expiry_date_poldist,
                                                           endt_yy,
                                                           dist_type,
                                                           acct_ent_date,
                                                           endt_seq_no,
                                                           renew_no,
                                                           pol_flag,
                                                           negate_date,
                                                           acct_neg_date,
                                                           incept_date,
                                                           last_upd_date,
                                                           user_id,
                                                           batch_id,
                                                           tsi_amt,
                                                           prem_amt,
                                                           user_id2
                                                          )
AS
   SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
          a.par_id, a.pol_seq_no, c.assd_no, a.endt_iss_cd, a.spld_flag,
          b.dist_flag, b.dist_no, b.eff_date, a.eff_date eff_date_polbas,
          a.issue_date, a.expiry_date expiry_date_polbas, a.endt_expiry_date,
          b.expiry_date expiry_date_poldist, a.endt_yy, b.dist_type,
          a.acct_ent_date, a.endt_seq_no, a.renew_no, a.pol_flag,
          b.negate_date, b.acct_neg_date, a.incept_date, b.last_upd_date,
          c.underwriter user_id, b.batch_id, a.tsi_amt, a.prem_amt,
          b.user_id user_id2
     FROM gipi_polbasic a, giuw_pol_dist b, gipi_parlist c
    WHERE b.policy_id = a.policy_id
      AND a.par_id = c.par_id
      AND c.par_status = 10
      AND a.pol_flag <> '5';



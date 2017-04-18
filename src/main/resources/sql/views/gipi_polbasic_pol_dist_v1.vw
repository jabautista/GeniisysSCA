DROP VIEW CPI.GIPI_POLBASIC_POL_DIST_V1;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_polbasic_pol_dist_v1 (policy_id,
                                                            line_cd,
                                                            subline_cd,
                                                            iss_cd,
                                                            issue_yy,
                                                            pol_seq_no,
                                                            endt_iss_cd,
                                                            endt_yy,
                                                            endt_seq_no,
                                                            renew_no,
                                                            par_id,
                                                            pol_flag,
                                                            assd_no,
                                                            acct_ent_date,
                                                            spld_flag,
                                                            dist_flag,
                                                            dist_no,
                                                            eff_date,
                                                            expiry_date,
                                                            negate_date,
                                                            dist_type,
                                                            acct_neg_date,
                                                            par_type
                                                           )
AS
   SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
          a.pol_seq_no, a.endt_iss_cd, a.endt_yy, a.endt_seq_no, a.renew_no,
          a.par_id, a.pol_flag, c.assd_no, a.acct_ent_date, a.spld_flag,
          b.dist_flag, b.dist_no, b.eff_date, b.expiry_date, b.negate_date,
          b.dist_type, b.acct_neg_date, c.par_type
     FROM gipi_polbasic a, giuw_pol_dist b, gipi_parlist c
    WHERE a.policy_id = b.policy_id
      AND a.par_id = c.par_id
      AND a.pol_flag <> '5'
      AND b.negate_date IS NULL;



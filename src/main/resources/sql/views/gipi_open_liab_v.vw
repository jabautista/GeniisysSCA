DROP VIEW CPI.GIPI_OPEN_LIAB_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_liab_v (line_cd,
                                                   subline_cd,
                                                   iss_cd,
                                                   issue_yy,
                                                   pol_seq_no,
                                                   eff_date,
                                                   geog_cd,
                                                   limit_liability,
                                                   rec_flag,
                                                   policy_id,
                                                   currency_cd,
                                                   currency_rt,
                                                   voy_limit
                                                  )
AS
   SELECT t1.line_cd, t1.subline_cd, t1.iss_cd, t1.issue_yy, t1.pol_seq_no,
          t1.eff_date, t2.geog_cd, t2.limit_liability, t2.rec_flag,
          t2.policy_id, t2.currency_cd, t2.currency_rt, t2.voy_limit
     FROM gipi_polbasic t1, gipi_open_liab t2
    WHERE t2.policy_id = t1.policy_id AND t1.spld_flag != '3';



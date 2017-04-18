DROP VIEW CPI.GIPI_OPEN_CARGO_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_open_cargo_v (line_cd,
                                                    subline_cd,
                                                    iss_cd,
                                                    issue_yy,
                                                    pol_seq_no,
                                                    eff_date,
                                                    rec_flag,
                                                    geog_cd,
                                                    cargo_class_cd
                                                   )
AS
   SELECT t1.line_cd, t1.subline_cd, t1.iss_cd, t1.issue_yy, t1.pol_seq_no,
          t1.eff_date, t2.rec_flag, t2.geog_cd, t2.cargo_class_cd
     FROM gipi_polbasic t1, gipi_open_cargo t2
    WHERE t1.policy_id = t2.policy_id AND t1.spld_flag != '3';



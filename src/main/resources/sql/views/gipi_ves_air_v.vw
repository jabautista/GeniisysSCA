DROP VIEW CPI.GIPI_VES_AIR_V;

/* Formatted on 2015/05/15 10:41 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.gipi_ves_air_v (line_cd,
                                                 subline_cd,
                                                 iss_cd,
                                                 issue_yy,
                                                 pol_seq_no,
                                                 eff_date,
                                                 vessel_cd,
                                                 vescon,
                                                 voy_limit,
                                                 rec_flag
                                                )
AS
   SELECT t1.line_cd, t1.subline_cd, t1.iss_cd, t1.issue_yy, t1.pol_seq_no,
          t1.eff_date, t2.vessel_cd, t2.vescon, t2.voy_limit, t2.rec_flag
     FROM gipi_polbasic t1, gipi_ves_air t2
    WHERE t1.policy_id = t2.policy_id AND spld_flag != 3;



DROP PROCEDURE CPI.GET_LATEST_ASSURED;

CREATE OR REPLACE PROCEDURE CPI.get_latest_assured (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                              p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                              p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                              p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                              p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                              p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                              p_date1      IN DATE,
                              p_date2      IN DATE,
                              p_date_param  IN NUMBER,
                              p_assd_no     OUT giis_assured.assd_no%TYPE) IS
BEGIN
  FOR asd  IN (
   SELECT y.assd_no assd_no
     FROM gipi_polbasic x,
          gipi_parlist  y
    WHERE 1=1
      AND x.par_id     = y.par_id
      AND x.line_cd    = p_line_cd
      AND x.subline_cd = p_subline_cd
      AND x.iss_cd     = p_iss_cd
      AND x.issue_yy   = p_issue_yy
      AND x.pol_seq_no = p_pol_seq_no
      AND x.renew_no   = p_renew_no
      AND x.pol_flag IN ('1','2','3','X')
      AND TRUNC(DECODE(p_date_param, 1, x.issue_date,
                                     2, x.eff_date,
                                     4, LAST_DAY(TO_DATE(UPPER(x.booking_mth)||' 1,'||TO_CHAR(x.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                     >= p_date1
      AND TRUNC(DECODE(p_date_param, 1, x.issue_date,
                                     2, x.eff_date,
                                     4, LAST_DAY(TO_DATE(UPPER(x.booking_mth)||' 1,'||TO_CHAR(x.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                     >= p_date2
      AND NOT EXISTS(SELECT 'X'
                       FROM gipi_polbasic m,
                            gipi_parlist  n
                      WHERE m.line_cd    = p_line_cd
                        AND m.subline_cd = p_subline_cd
                        AND m.iss_cd     = p_iss_cd
                        AND m.issue_yy   = p_issue_yy
                        AND m.pol_seq_no = p_pol_seq_no
                        AND m.renew_no   = p_renew_no
                        AND m.pol_flag IN ('1','2','3','X')
                        AND m.endt_seq_no > x.endt_seq_no
                        AND NVL(m.back_stat,5) = 2
                        AND m.par_id     = n.par_id
                        AND TRUNC(DECODE(p_date_param, 1, x.issue_date,
                                                       2, x.eff_date,
                                                       4, LAST_DAY(TO_DATE(UPPER(m.booking_mth)||' 1,'||TO_CHAR(m.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                                       >= p_date1
                        AND TRUNC(DECODE(p_date_param, 1, x.issue_date,
                                                       2, x.eff_date,
                                                       4, LAST_DAY(TO_DATE(UPPER(m.booking_mth)||' 1,'||TO_CHAR(m.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                                       >= p_date2)
      ORDER BY x.eff_date DESC)
  LOOP
    p_assd_no   := asd.assd_no;
    EXIT;
  END LOOP;
END get_latest_assured;
/



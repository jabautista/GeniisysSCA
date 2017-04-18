DROP FUNCTION CPI.GET_LATEST_ASSURED_NO2;

CREATE OR REPLACE FUNCTION CPI."GET_LATEST_ASSURED_NO2" (p_line_cd      gipi_polbasic.line_cd%TYPE,
                                                  p_subline_cd   gipi_polbasic.line_cd%TYPE,
                                                  p_iss_cd       gipi_polbasic.iss_cd%TYPE,
                                                  p_issue_yy     gipi_polbasic.issue_yy%TYPE,
                                                  p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
                                                  p_renew_no     gipi_polbasic.renew_no%TYPE) RETURN NUMBER IS
  v_assd_no    giis_assured.assd_no%TYPE;
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
   AND x.policy_id  > 0
      AND x.pol_flag IN ('1','2','3','X')
      --AND TRUNC(x.eff_date) >= p_date1
      --AND TRUNC(x.eff_date) <= p_date2
      AND NOT EXISTS(SELECT 'X'
                       FROM gipi_polbasic m
                      WHERE m.line_cd    = p_line_cd
                        AND m.subline_cd = p_subline_cd
                        AND m.iss_cd     = p_iss_cd
                        AND m.issue_yy   = p_issue_yy
                        AND m.pol_seq_no = p_pol_seq_no
                        AND m.endt_seq_no > x.endt_seq_no
                        AND m.renew_no   = p_renew_no
                        AND m.pol_flag IN ('1','2','3','X')
                        AND NVL(m.back_stat,5) = 2
      --AND TRUNC(m.eff_date) >= p_date1
                        --AND TRUNC(m.eff_date) <= p_date2
                        AND m.assd_no IS NOT NULL)
      ORDER BY x.eff_date DESC)
  LOOP
    v_assd_no   := asd.assd_no;
    EXIT;
  END LOOP;
  RETURN v_assd_no;
END Get_Latest_Assured_No2;
/



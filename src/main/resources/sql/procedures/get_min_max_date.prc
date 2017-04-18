DROP PROCEDURE CPI.GET_MIN_MAX_DATE;

CREATE OR REPLACE PROCEDURE CPI.get_min_max_date(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,   
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_loss_date         GIPI_POLBASIC.eff_date%TYPE,
    p_pol_eff_date  OUT VARCHAR2,  
    p_pol_eff_date2 OUT GIPI_POLBASIC.incept_date%TYPE,
    p_expiry_date   OUT VARCHAR2,  
    p_expiry_date2  OUT GIPI_POLBASIC.expiry_date%TYPE,
    p_issue_date    OUT VARCHAR2, --GIPI_POLBASIC.issue_date%TYPE,
    p_msg_alert     OUT VARCHAR2
    ) IS
BEGIN
  /*extract_incept2(p_line_cd, p_subline_cd, p_pol_iss_cd,
                  p_issue_yy, p_pol_seq_no, p_renew_no, p_loss_date, p_pol_eff_date, p_pol_eff_date2);
  extract_expiry4(p_line_cd, p_subline_cd, p_pol_iss_cd,
                  p_issue_yy, p_pol_seq_no, p_renew_no, p_loss_date, p_expiry_date, p_expiry_date2);*/
  /*Added by Joanne
  **Date: 02.19.14
  **Description: Replace code call new procedure toretrieve correct incept date and expiry date*/
  -- applied by bonok :: 05.26.2014
  extract_expiry_incept2(p_pol_eff_date, p_pol_eff_date2, p_expiry_date, p_expiry_date2, p_loss_date,
                        p_line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no);                
     
  IF giisp.v('VALIDATE_POL_ISSUE_DATE') <> 'N' THEN
    FOR i IN (SELECT TO_CHAR(issue_date, 'MM-DD-YYYY HH:MI AM') issue_date
                FROM gipi_polbasic
               WHERE line_cd = p_line_cd
                 AND subline_cd = p_subline_cd
                 AND iss_cd = p_pol_iss_cd
                 AND issue_yy = p_issue_yy
                 AND pol_seq_no = p_pol_seq_no
                 AND renew_no = p_renew_no)
    LOOP
      p_issue_date := i.issue_date;
      EXIT;
    END LOOP;
  ELSIF giisp.v('VALIDATE_POL_ISSUE_DATE') IS NULL THEN
    p_msg_alert := 'VALIDATE_POL_ISSUE_DATE does not exist in GIIS_PARAMETERS';--,'E',FALSE);     
  END IF;
END;
/



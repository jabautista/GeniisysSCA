DROP FUNCTION CPI.GET_LATEST_INCEPT_DATE;

CREATE OR REPLACE FUNCTION CPI.get_latest_incept_date (
   p_line_cd      gipi_polbasic.line_cd%TYPE,
   p_subline_cd   gipi_polbasic.subline_cd%TYPE,
   p_iss_cd       gipi_polbasic.iss_cd%TYPE,
   p_issue_yy     gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
   p_renew_no     gipi_polbasic.renew_no%TYPE
)
   RETURN DATE
AS
   v_incept_date   gipi_polbasic.incept_date%TYPE;
BEGIN
   FOR rec IN (SELECT incept_date
                 FROM gipi_polbasic
                WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND iss_cd = p_iss_cd
                  AND issue_yy = p_issue_yy
                  AND pol_seq_no = p_pol_seq_no
                  AND renew_no = p_renew_no
                  AND endt_seq_no =
                         (SELECT MAX (endt_seq_no) endt_seq_no
                            FROM gipi_polbasic
                           WHERE line_cd = p_line_cd
                             AND subline_cd = p_subline_cd
                             AND iss_cd = p_iss_cd
                             AND issue_yy = p_issue_yy
                             AND pol_seq_no = p_pol_seq_no
                             AND renew_no = p_renew_no))
   LOOP
      v_incept_date := rec.incept_date;
      EXIT;
   END LOOP;

   RETURN (v_incept_date);
END get_latest_incept_date;
/



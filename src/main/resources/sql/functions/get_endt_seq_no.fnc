DROP FUNCTION CPI.GET_ENDT_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Endt_Seq_No
/** rollie 02/18/04
*** get the latest endorsement number of a policy
**/
   (p_line_cd     gipi_polbasic.line_cd%TYPE,
    p_subline_cd  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd      gipi_polbasic.iss_cd%TYPE,
	p_issue_yy    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no    gipi_polbasic.renew_no%TYPE)
RETURN NUMBER AS
 v_endt_seq_no gipi_polbasic.endt_seq_no%TYPE;
BEGIN
   SELECT MAX(endt_seq_no)
     INTO v_endt_seq_no
     FROM gipi_polbasic a
    WHERE a.line_cd = p_line_cd
      AND a.subline_cd = p_subline_cd
      AND a.iss_cd = p_iss_cd
      AND a.issue_yy = p_issue_yy
      AND a.pol_seq_no = p_pol_seq_no
      AND a.renew_no  = p_renew_no;
   RETURN (v_endt_seq_no);
END;
/



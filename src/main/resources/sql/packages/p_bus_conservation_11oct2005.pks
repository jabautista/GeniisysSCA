CREATE OR REPLACE PACKAGE CPI.P_Bus_Conservation_11OCT2005 AS
  PROCEDURE get_data(
     p_line_cd     IN VARCHAR2,
     p_subline_cd  IN VARCHAR2,
     p_iss_cd      IN VARCHAR2,
     p_intm_no     IN NUMBER,
	 p_from_date   IN DATE,
     p_to_date     IN DATE,
 	 p_del_table   IN VARCHAR2);

  FUNCTION get_prem_of_renew(
  	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE)
  RETURN NUMBER;

  FUNCTION Check_Date(
  /** rollie 02/18/04
  *** date parameter of the last endt of policy
  *** must not be within the date given, else it will
  *** be exluded
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE,
	p_from_date	    DATE,
	p_to_date	    DATE)
  RETURN DATE;

  FUNCTION get_renew_pol(
  /* rollie 15 June 2004
  ** get the count the number of policies that
  ** has been renewed
  */
    p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE)
  RETURN NUMBER;

  FUNCTION get_expiry_year(
  /** rollie 15 june 2004
  *** get the expiry year of latest endt
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER;

  FUNCTION get_expiry_month(
  /** rollie 15 june 2004
  *** get the expiry month of latest endt
  **/
	p_line_cd	    gipi_polbasic.line_cd%TYPE,
	p_subline_cd	gipi_polbasic.subline_cd%TYPE,
    p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no	    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER;

  FUNCTION Get_Endt_Seq_No(
    /** rollie 02/18/04
    *** get the latest endt number of a policy
    **/
    p_line_cd     gipi_polbasic.line_cd%TYPE,
    p_subline_cd  gipi_polbasic.subline_cd%TYPE,
    p_iss_cd      gipi_polbasic.iss_cd%TYPE,
	p_issue_yy    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no    gipi_polbasic.renew_no%TYPE)
  RETURN NUMBER;

END;
/

DROP PACKAGE CPI.P_BUS_CONSERVATION_11OCT2005;



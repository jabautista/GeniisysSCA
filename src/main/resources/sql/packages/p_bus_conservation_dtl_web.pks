CREATE OR REPLACE PACKAGE CPI.P_BUS_CONSERVATION_DTL_WEB
AS
  PROCEDURE get_data (p_line_cd IN VARCHAR2,
                      p_subline_cd IN VARCHAR2, 
                      p_iss_cd IN VARCHAR2,
                      p_intm_no IN NUMBER,
                      p_from_date IN DATE,
                      p_to_date IN DATE,  
                      p_del_table IN VARCHAR2,
                      p_inc_package IN VARCHAR2 DEFAULT 'Y' ,
                      p_cred_cd IN VARCHAR2,     --added by rose b.(cred_cd and intm_type)08072008--
                      p_intm_type IN VARCHAR2,
                      p_user_id  IN VARCHAR2); 

  FUNCTION check_date (/** applied 09-22-2006
                       *** rollie 02/18/04
                       *** date parameter of the last endt of policy
                       *** must not be within the date given, else it will
                       *** be exluded
                       **/
                       p_line_cd gipi_polbasic.line_cd%TYPE,
                       p_subline_cd gipi_polbasic.subline_cd%TYPE,
                       p_iss_cd gipi_polbasic.iss_cd%TYPE,
                       p_issue_yy gipi_polbasic.issue_yy%TYPE,
                       p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                       p_renew_no gipi_polbasic.renew_no%TYPE,
                       p_from_date DATE,
                       p_to_date DATE)
    RETURN DATE;

  FUNCTION get_renew_tag (/** rollie 24 june 2004
                          *** validates if policy is renewed
                          **/
                          p_policy_id gipi_polbasic.policy_id%TYPE,
                          p_pack_sw VARCHAR2 DEFAULT 'N' )
    RETURN VARCHAR2;

  FUNCTION get_expiry_year (/** rollie 15 june 2004
                            *** get the expiry year of latest endt
                            **/
                            p_line_cd gipi_polbasic.line_cd%TYPE,
                            p_subline_cd gipi_polbasic.subline_cd%TYPE,
                            p_iss_cd gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no gipi_polbasic.renew_no%TYPE)
    RETURN NUMBER;

  FUNCTION get_expiry_month (/** rollie 15 june 2004
                             *** get the expiry month of latest endt
                             **/
                             p_line_cd gipi_polbasic.line_cd%TYPE,
                             p_subline_cd gipi_polbasic.subline_cd%TYPE,
                             p_iss_cd gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no gipi_polbasic.renew_no%TYPE)
    RETURN NUMBER;

  FUNCTION get_prem (/**
                     *** get the total sum premium from all its endts...
                     **/
                     p_line_cd gipi_polbasic.line_cd%TYPE,
                     p_subline_cd gipi_polbasic.subline_cd%TYPE,
                     p_iss_cd gipi_polbasic.iss_cd%TYPE,
                     p_issue_yy gipi_polbasic.issue_yy%TYPE,
                     p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                     p_renew_no gipi_polbasic.renew_no%TYPE)
    RETURN NUMBER;

  FUNCTION get_prem_of_renew (p_line_cd gipi_polbasic.line_cd%TYPE,
                              p_subline_cd gipi_polbasic.subline_cd%TYPE,
                              p_iss_cd gipi_polbasic.iss_cd%TYPE,
                              p_issue_yy gipi_polbasic.issue_yy%TYPE,
                              p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                              p_renew_no gipi_polbasic.renew_no%TYPE)
    RETURN NUMBER;

  FUNCTION get_endt_seq_no (/** rollie 02/18/04
                            *** get the latest endt number of a policy
                            **/
                            p_line_cd gipi_polbasic.line_cd%TYPE,
                            p_subline_cd gipi_polbasic.subline_cd%TYPE,
                            p_iss_cd gipi_polbasic.iss_cd%TYPE,
                            p_issue_yy gipi_polbasic.issue_yy%TYPE,
                            p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
                            p_renew_no gipi_polbasic.renew_no%TYPE)
    RETURN NUMBER;
END;
/



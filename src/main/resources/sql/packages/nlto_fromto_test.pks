CREATE OR REPLACE PACKAGE CPI.Nlto_Fromto_Test AS
  /*created by iris bordey (12.03.2002)
  **returns coverage description*/
  FUNCTION get_coverage_desc(p_coverage_cd NUMBER)
  RETURN VARCHAR2;

  /*created by iris bordey (12.02.2002)
  **returns latest coverage_cd of policy
  */
  FUNCTION get_coverage_cd(p_line_cd     VARCHAR2,
                           p_subline_cd  VARCHAR2,
    					   p_iss_cd      VARCHAR2,
    					   p_issue_yy    NUMBER,
    					   p_pol_seq_no  NUMBER,
    					   p_renew_no    NUMBER,
    					   p_item_no     NUMBER,
    					   p_dt_type     VARCHAR2,
    					   p_from        DATE,
    					   p_to          DATE)
  RETURN NUMBER;
  /*created by iris bordey (11.27.2002)
  **validate date */
  FUNCTION date_ok (
    p_ad       IN DATE,
    p_ed       IN DATE,
    p_id       IN DATE,
    p_mth      IN VARCHAR2,
    p_year     IN NUMBER,
    p_spld_ad  IN DATE,
	p_pol_flag IN VARCHAR2,
    p_dt_type  IN VARCHAR2,
    p_fmdate   IN DATE,
    p_todate   IN DATE)
  RETURN NUMBER;

  /*created by iris bordey (11.27.2002)
  **process extraction of records
  */
  PROCEDURE extract(
    v_dt_type   VARCHAR2,
    v_iss_cd    VARCHAR2,
	v_zone_type NUMBER,
	v_date_from DATE,
    v_date_to   DATE);


END;
/



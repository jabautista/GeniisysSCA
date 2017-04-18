CREATE OR REPLACE PACKAGE CPI.Lto_Fromto AS  
  /*created by iris bordey (12.04.2002)
  **returns subline_type_des from giis_mc_subline_type
  */
  FUNCTION get_subline_type_desc(
    p_subline_cd      VARCHAR2,
	p_subline_type_cd VARCHAR2)
  RETURN VARCHAR2;
  /*created by iris bordey (12.02.2002
  **returns peril_stat_name
  */
  FUNCTION get_peril_stat_name(p_zone_type VARCHAR2)
  RETURN VARCHAR2;
  /*created by iris bordey (12.02.2002)
  **returns latest subline_type_desc/subline_type_cd  of policy
  */
  FUNCTION get_subline_type(p_line_cd     VARCHAR2,
                            p_subline_cd  VARCHAR2,
    						p_iss_cd      VARCHAR2,
    						p_issue_yy    NUMBER,
    						p_pol_seq_no  NUMBER,
    						p_renew_no    NUMBER,
    						p_item_no     NUMBER,
    						p_dt_type     VARCHAR2,
    						p_from        DATE,
    						p_to          DATE)
  RETURN VARCHAR2;
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
	v_zone_type VARCHAR2,
	v_date_from DATE,
    v_date_to   DATE);
END;
/



CREATE OR REPLACE PACKAGE CPI.Lto_Yearly AS  
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
    						p_year        NUMBER)
  RETURN VARCHAR2;
  /*created by iris bordey (11.27.2002)
  **process extraction of records
  */
  PROCEDURE extract(
    v_dt_type   VARCHAR2,
    v_iss_cd    VARCHAR2,
	v_zone_type VARCHAR2,
	v_year      NUMBER);
  /*created by iris bordey 12.03.2002
  **return 1 if dates are ok*/
  FUNCTION date_ok (
    p_ad       IN DATE,   	  	  		--handles accounting entry date
    p_ed       IN DATE,                 --handles effectiviey date
    p_id       IN DATE,                 --handles issue date
    p_bk_year  IN NUMBER,               --handles booking year
    p_spld_ad  IN DATE,                 --handles spld_acct_ent_date
	p_pol_flag IN VARCHAR2,             --to check for spoiled policies (pol_flag = 5)
    p_dt_type  IN VARCHAR2,
    p_year     IN NUMBER)
  RETURN NUMBER;
END;
/



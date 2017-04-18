CREATE OR REPLACE PACKAGE CPI.Nlto_Yearly AS 

  /*created by iris bordey (11.27.2002)
  **process extraction of records
  */
  PROCEDURE extract(
    v_dt_type   VARCHAR2,
    v_year      NUMBER,
    v_iss_cd    VARCHAR2,
	v_zone_type NUMBER);

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

  /*created by iris bordey (12.03.2002)
  **returns coverage description*/
  FUNCTION get_coverage_desc(p_coverage_cd NUMBER)
  RETURN VARCHAR2;

  /*created by iris bordey (12.02.2002)
  **returns latest coverage_cd of policy
  */
  FUNCTION get_coverage_cd(
    p_line_cd     VARCHAR2,
    p_subline_cd  VARCHAR2,
    p_iss_cd      VARCHAR2,
    p_issue_yy    NUMBER,
    p_pol_seq_no  NUMBER,
    p_renew_no    NUMBER,
    p_item_no     NUMBER,
    p_dt_type     VARCHAR2,
    p_year        NUMBER)
  RETURN NUMBER;

END;
/



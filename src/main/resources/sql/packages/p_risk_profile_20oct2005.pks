CREATE OR REPLACE PACKAGE CPI.P_Risk_Profile_20oct2005 AS

  PROCEDURE risk_profile_ext
   (v_user        gipi_risk_profile.user_id%TYPE,
    v_line_cd     gipi_risk_profile.line_cd%TYPE,
    v_subline_cd  gipi_risk_profile.subline_cd%TYPE,
    v_date_from   gipi_risk_profile.date_from%TYPE,
    v_date_to     gipi_risk_profile.date_to%TYPE,
    v_basis       VARCHAR2,
    v_line_tag	  VARCHAR2);

  PROCEDURE get_poldist_ext
	(p_line_cd    gipi_polbasic.line_cd%TYPE,
     p_subline_cd gipi_polbasic.subline_cd%TYPE,
	 p_basis      VARCHAR2,
	 p_date_from  DATE,
	 p_date_to    DATE);

  PROCEDURE get_share_ext;

  FUNCTION Date_Risk
     (p_ad       IN DATE,
      p_ed       IN DATE,
	  p_id       IN DATE,
	  p_month    IN VARCHAR2,
	  p_year     IN NUMBER,
	  p_spld_ad  IN DATE,
	  p_pol_flag IN VARCHAR2,
	  p_dt_type  IN VARCHAR2,
	  p_fmdate   IN DATE,
	  p_todate   IN DATE,
	  p_ct		 IN DATE,
   	  p_policy_id IN NUMBER)
  RETURN NUMBER;

  FUNCTION Get_Ann_Tsi
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
     p_from       DATE,
     p_to         DATE,
	 p_basis	  VARCHAR2)
  RETURN NUMBER;

  PROCEDURE fire_risk_profile_ext
  /*created by iris bordey 02.04.2003
  **this procedure will extract records for risk_profile of FIRE policies only
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2);

   FUNCTION Get_Item_Ann_Tsi
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
	 p_item_no    NUMBER,
     p_from       DATE,
     p_to         DATE,
	 p_basis	  VARCHAR2)
  RETURN NUMBER;

  PROCEDURE risk_profile_per_peril
  /*created by iris bordey 11.27.2003
  **this procedure will extract records for risk_profile per peril
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2);

  PROCEDURE extract_risk_profile
  /*created by iris bordey 11.27.2003
  **this procedure will extract records for risk_profile per peril
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2,
   p_by_tarf        VARCHAR2);
END;
/

DROP PACKAGE CPI.P_RISK_PROFILE_20OCT2005;


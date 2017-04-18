CREATE OR REPLACE PACKAGE CPI.P_Risk_Profile AS
  PROCEDURE Risk_Profile_Ext
   (v_user        GIPI_RISK_PROFILE.user_id%TYPE,
    v_line_cd     GIPI_RISK_PROFILE.line_cd%TYPE,
    v_subline_cd  GIPI_RISK_PROFILE.subline_cd%TYPE,
    v_date_from   DATE,--GIPI_RISK_PROFILE.date_from%TYPE,
    v_date_to     DATE,--GIPI_RISK_PROFILE.date_to%TYPE,
    v_basis       VARCHAR2,
    v_line_tag	  VARCHAR2,--***
	v_cred_branch GIPI_POLBASIC.cred_branch%TYPE, -- mark jm additional record filter
	v_include_expired 	VARCHAR2,				  -- mark jm additional record filter
   	v_include_endt		VARCHAR2,				  -- mark jm additional record filter
    p_exist          OUT BOOLEAN);  -- Added by Hero 09-11-2012; Used for validation if there were records extracted to GIPI_POLRISK_EXT1
  PROCEDURE get_poldist_ext
	(p_line_cd    gipi_polbasic.line_cd%TYPE,
     p_subline_cd gipi_polbasic.subline_cd%TYPE,
	 p_basis      VARCHAR2,
	 p_date_from  DATE,
	 p_date_to    DATE,--***
	 p_cred_branch	   GIPI_POLBASIC.cred_branch%TYPE,	  -- mark jm additional record filter
	 p_include_expired VARCHAR2,						  -- mark jm additional record filter
   	 p_include_endt		VARCHAR2,						  -- mark jm additional record filter
   	 p_user_id     giis_users.user_id%TYPE);
  PROCEDURE get_share_ext (p_user_id		giis_users.user_id%TYPE);
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
	  p_and		 IN DATE)
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
	 p_basis	  VARCHAR2,
	 p_and		  DATE)
  RETURN NUMBER;
  PROCEDURE fire_risk_profile_ext
  /*created by iris bordey 02.04.2003
  **this procedure will extract records for risk_profile of FIRE policies only
  */
  (p_user           GIPI_RISK_PROFILE.user_id%TYPE,
   p_line_cd        GIPI_RISK_PROFILE.line_cd%TYPE,
   p_subline_cd     GIPI_RISK_PROFILE.subline_cd%TYPE,
   p_date_from      GIPI_RISK_PROFILE.date_from%TYPE,
   p_date_to        GIPI_RISK_PROFILE.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2,--***
   p_cred_branch		GIPI_POLBASIC.cred_branch%TYPE,	 -- mark jm additional record filter
   p_include_expired	VARCHAR2,						 -- mark jm additional record filter
   p_include_endt		VARCHAR2,  						 -- mark jm additional record filter
   p_exist          OUT BOOLEAN);    -- Added by Hero 09-11-2012; Used for validation if there were records extracted to GIPI_POLRISK_EXT1
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
	 p_basis	  VARCHAR2,
	 p_and		  DATE)
  RETURN NUMBER;
  PROCEDURE risk_profile_per_peril
  /*created by iris bordey 11.27.2003
  **this procedure will extract records for risk_profile per peril
  */
  (p_user           GIPI_RISK_PROFILE.user_id%TYPE,
   p_line_cd        GIPI_RISK_PROFILE.line_cd%TYPE,
   p_subline_cd     GIPI_RISK_PROFILE.subline_cd%TYPE,
   p_date_from      GIPI_RISK_PROFILE.date_from%TYPE,
   p_date_to        GIPI_RISK_PROFILE.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2,--***
   p_cred_branch	GIPI_POLBASIC.cred_branch%TYPE,	 -- mark jm additional record filter
   p_include_expired	VARCHAR2,					 -- mark jm additional record filter
   p_include_endt		VARCHAR2,					 -- mark jm additional record filter
   p_exist          OUT BOOLEAN);   -- Added by Hero 09-11-2012; Used for validation if there were records extracted to GIPI_POLRISK_EXT1
  PROCEDURE extract_risk_profile
  /*created by iris bordey 11.27.2003
  **this procedure will extract records for risk_profile per peril
  */
  (p_user           GIPI_RISK_PROFILE.user_id%TYPE,
   p_line_cd        GIPI_RISK_PROFILE.line_cd%TYPE,
   p_subline_cd     GIPI_RISK_PROFILE.subline_cd%TYPE,
   p_date_from      DATE,--GIPI_RISK_PROFILE.date_from%TYPE,
   p_date_to        DATE,--GIPI_RISK_PROFILE.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2,
   p_by_tarf        VARCHAR2, --***
   p_cred_branch	GIPI_POLBASIC.cred_branch%TYPE,		  -- mark jm additional record filter
   p_include_expired	VARCHAR2,						  -- mark jm additional record filter
   p_include_endt		VARCHAR2,						  -- mark jm additional record filter
   p_exist          OUT BOOLEAN);     -- Added by Hero 09-11-2012; Used for validation if there were records extracted to GIPI_POLRISK_EXT1
  FUNCTION Check_Date_Dist_Peril
  /** rollie 02/18/04
  *** date parameter of the last endorsement of policy
  *** must not be within the date given, else it will
  *** be exluded
  *** NOTE: policy with pol_flag = '4' only
  **/
  	(p_line_cd     gipi_polbasic.line_cd%TYPE,
	 p_subline_cd  gipi_polbasic.subline_cd%TYPE,
	 p_iss_cd      gipi_polbasic.iss_cd%TYPE,
	 p_issue_yy    gipi_polbasic.issue_yy%TYPE,
	 p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
	 p_renew_no    gipi_polbasic.renew_no%TYPE,
	 p_param_date  VARCHAR2,
	 p_from_date   DATE,
	 p_to_date     DATE)
  RETURN NUMBER;
  FUNCTION sign_tsi (p_from DATE,
			 		   p_to	  DATE,
					   p_and  DATE,
					   p_aed  DATE,
					   p_pol_flag VARCHAR2)
  RETURN NUMBER;
END;
/



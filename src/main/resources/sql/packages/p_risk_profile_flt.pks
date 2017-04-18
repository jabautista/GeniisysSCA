CREATE OR REPLACE PACKAGE CPI.p_risk_profile_flt AS

  PROCEDURE Risk_Profile_Ext
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

  FUNCTION date_risk
     (p_ad       IN DATE,
      p_ed       IN DATE,
	  p_id       IN DATE,
	  p_spld_ad  IN DATE,
	  p_pol_flag IN VARCHAR2,
	  p_dt_type  IN VARCHAR2,
	  p_fmdate   IN DATE,
	  p_todate   IN DATE)
  RETURN NUMBER;

  FUNCTION get_ann_tsi
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
  FUNCTION get_tarf_cd
  /* created by bdarusin 12/17/2002
  ** this function returns the tarf_cd of the latest endt_seq_no. this function is only used
  ** for fire policies
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
	 p_endt_iss_cd  VARCHAR2,
	 p_endt_yy      NUMBER,
	 p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
	 p_basis        VARCHAR2)
  RETURN NUMBER;
END;
/



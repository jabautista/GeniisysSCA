CREATE OR REPLACE PACKAGE CPI.giacr136b_pkg
AS
   TYPE get_giacr136b_type IS RECORD (
      company_name        VARCHAR2 (200),
      company_address     VARCHAR2 (200),
      quarter_year        VARCHAR2 (100),
      line_treaty         VARCHAR2 (150),
      cf_month            VARCHAR2 (200),
      branch_cd           gixx_trty_prem_comm.branch_cd%TYPE,
      ri_sname            giis_reinsurer.ri_sname%TYPE,
      shr_pct             giis_trty_panel.trty_shr_pct%TYPE,
      premium_amt         NUMBER (16, 2),
      month_grand         VARCHAR2 (200),
      ri_sname_grand      giis_reinsurer.ri_sname%TYPE,
      premium_shr_grand   NUMBER (16, 2),
      cession_mm          VARCHAR2 (100),
      line_cd             VARCHAR2 (100),
      trty_name           GIIS_DIST_SHARE.TRTY_NAME%TYPE,
      share_cd            VARCHAR2 (100),
      cession_year        VARCHAR2 (100),
      header_flag         VARCHAR2 (1)
   );

   TYPE get_giacr136b_tab IS TABLE OF get_giacr136b_type;

   FUNCTION get_giacr136b_dtls (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136b_tab PIPELINED;
      
   FUNCTION get_giacr136b_recap (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       VARCHAR2,
      p_trty_name      VARCHAR2,
      p_user_id        VARCHAR2,
      p_cf_month       VARCHAR2
   )
      RETURN get_giacr136b_tab PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.giacr136a_pkg
AS
   TYPE get_giacr136a_type IS RECORD (
      company_name         VARCHAR2 (200),
      company_address      VARCHAR2 (200),
      quarter_year         VARCHAR2 (100),
      line_treaty          VARCHAR2 (150),
      line_cd              gixx_trty_prem_comm.line_cd%TYPE,
      cf_month             VARCHAR2 (200),
      branch_cd            gixx_trty_prem_comm.branch_cd%TYPE,
      premium_per_branch   gixx_trty_prem_comm.premium_amt%TYPE,
      ri_sname             giis_reinsurer.ri_sname%TYPE,
      shr_pct              giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname1            giis_reinsurer.ri_sname%TYPE,
      shr_pct1             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname2            giis_reinsurer.ri_sname%TYPE,
      shr_pct2             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname3            giis_reinsurer.ri_sname%TYPE,
      shr_pct3             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname4            giis_reinsurer.ri_sname%TYPE,
      shr_pct4             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname5            giis_reinsurer.ri_sname%TYPE,
      shr_pct5             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname6            giis_reinsurer.ri_sname%TYPE,
      shr_pct6             giis_trty_panel.trty_shr_pct%TYPE,
      ri_sname7            giis_reinsurer.ri_sname%TYPE,
      shr_pct7             giis_trty_panel.trty_shr_pct%TYPE,
      premium_shr          NUMBER (16, 2),
      premium_shr1         NUMBER (16, 2),
      premium_shr2         NUMBER (16, 2),
      premium_shr3         NUMBER (16, 2),
      premium_shr4         NUMBER (16, 2),
      premium_shr5         NUMBER (16, 2),
      premium_shr6         NUMBER (16, 2),
      premium_shr7         NUMBER (16, 2),
      mm_total             NUMBER (16, 2),
      treaty_yy            giis_dist_share.trty_yy%TYPE,
      share_cd             gixx_trty_prem_comm.share_cd%TYPE,
      cession_mm           gixx_trty_prem_comm.cession_mm%TYPE,
      trty_com_rt          GIXX_TRTY_PREM_COMM.TRTY_COM_RT%TYPE,
      cession_year         gixx_trty_prem_comm.cession_year%TYPE,
      header_flag          VARCHAR2 (1),
      grp_ris              VARCHAR2(100),
      cf_month_dum         VARCHAR2(100) --added by marks cause cf_month was used.
      
   );

   TYPE get_giacr136a_tab IS TABLE OF get_giacr136a_type;

   FUNCTION get_giacr136a_dtls (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       NUMBER,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136a_tab PIPELINED;
      
   FUNCTION get_giacr136a_header (
        p_line_cd       gixx_trty_prem_comm.line_cd%TYPE,
        p_share_cd      gixx_trty_prem_comm.share_cd%TYPE,
        p_treaty_yy     giis_trty_panel.trty_yy%TYPE
   )
      RETURN get_giacr136a_tab PIPELINED;       

   FUNCTION get_giacr136a_dtls2 (
      p_quarter        VARCHAR2,
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136a_tab PIPELINED;
------
   FUNCTION get_giacr136a_dtls3 (
      p_quarter        VARCHAR2,
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136a_tab PIPELINED;

------
   FUNCTION get_giacr136a_total (
      p_line_cd        VARCHAR2,
      p_treaty_yy      VARCHAR2,
      p_share_cd       VARCHAR2,
      p_cession_year   VARCHAR2,
      p_quarter        VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136a_tab PIPELINED;
END;
/

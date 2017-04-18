CREATE OR REPLACE PACKAGE CPI.GIACB003S_PKG
AS
   TYPE giacb003s_record_type IS RECORD (
      iss_cd               giis_issource.iss_cd%TYPE,
      line_cd              VARCHAR2 (2),
      line_name            VARCHAR2 (20),
      subline_cd           giis_subline.subline_cd%TYPE,
      subline_name         giis_subline.subline_name%TYPE,
      peril_cd             giis_peril.peril_cd%TYPE,
      peril_name           VARCHAR2 (100),
      policy_number        VARCHAR2 (50),
      frps_no              VARCHAR2 (200),
      ri_prem_vat          giri_frperil.ri_prem_amt%TYPE,
      ri_comm_vat          giri_frperil.ri_comm_vat%TYPE,
      ri_wholding_vat      giri_frperil.ri_wholding_vat%TYPE,
      net_amt              giri_frperil.ri_prem_amt%TYPE,
      tsi_amt              giri_frperil.ri_tsi_amt%TYPE,
      prem_amt             giri_frperil.ri_prem_amt%TYPE,
      comm_amt             giri_frperil.ri_comm_vat%TYPE,
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      top_date             VARCHAR2 (70),
      v_flag               VARCHAR2 (1),
      v_subreport          VARCHAR2 (1)
   );

   TYPE giacb003s_record_tab IS TABLE OF giacb003s_record_type;

   TYPE giacb003s_gl_account_type IS RECORD (
      gl_acct_no           VARCHAR2 (200),
      acct_name            VARCHAR2 (100),
      debit                NUMBER (12, 2),
      credit               NUMBER (12, 2),
      cf_company_name      VARCHAR2 (500),
      cf_company_address   VARCHAR2 (500),
      top_date             VARCHAR2 (70),
      v_flag               VARCHAR2 (1)
   );

   TYPE giacb003s_gl_account_tab IS TABLE OF giacb003s_gl_account_type;

   FUNCTION get_giacb003s_record (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003s_record_tab PIPELINED;

   FUNCTION get_giacb003s_gl_account (p_date VARCHAR2, p_user_id VARCHAR2)
      RETURN giacb003s_gl_account_tab PIPELINED;
END GIACB003S_PKG;
/



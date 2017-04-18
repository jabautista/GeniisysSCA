CREATE OR REPLACE PACKAGE CPI.GIACB004S_PKG
AS
   TYPE giacb004s_type_main IS RECORD (
      company_name      giac_parameters.param_value_v%TYPE,
      company_address   giac_parameters.param_value_v%TYPE,
      line_cd           gipi_polbasic.line_cd%TYPE,
      subline_cd        gipi_polbasic.subline_cd%TYPE,
      peril_cd          gipi_invperil.peril_cd%TYPE,
      prem_invoice      gipi_invoice.prem_amt%TYPE,
      comm_invoice      gipi_invoice.ri_comm_amt%TYPE,
      tax_amt           gipi_invoice.tax_amt%TYPE,
      ri_comm_vat       gipi_invoice.ri_comm_vat%TYPE,
      currency_rt       gipi_invoice.currency_rt%TYPE,
      prem_amt          gipi_invperil.prem_amt%TYPE,
      tsi_amt           gipi_invperil.prem_amt%TYPE,
      ri_comm_amt       gipi_invperil.prem_amt%TYPE,
      peril_name        VARCHAR2 (100),
      prem_vat          NUMBER (16, 3),
      comm_vat          NUMBER (16, 3),
      tsi_basic_amt     NUMBER (16, 3),
      line_name         giis_line.line_name%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      v_flag            VARCHAR2 (1)
   );

   TYPE giacb004s_tab_main IS TABLE OF giacb004s_type_main;

   TYPE giacb004s_type_sub IS RECORD (
      company_name      giac_parameters.param_value_v%TYPE,
      company_address   giac_parameters.param_value_v%TYPE,
      gl_acct_no        VARCHAR2 (100),
      acct_name         giac_chart_of_accts.gl_acct_name%TYPE,
      credit            giac_acct_entries.debit_amt%TYPE,
      debit             giac_acct_entries.credit_amt%TYPE,
      v_flag            VARCHAR2 (1)
   );

   TYPE giacb004s_tab_sub IS TABLE OF giacb004s_type_sub;

   FUNCTION populate_giacb004s_main (
      p_date      DATE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacb004s_tab_main PIPELINED;

   FUNCTION populate_giacb004s_sub (
      p_date      DATE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN giacb004s_tab_sub PIPELINED;

   FUNCTION get_prem_vat (
      p_prem_invoice   gipi_invoice.prem_amt%TYPE,
      p_prem_amt       gipi_invperil.prem_amt%TYPE,
      p_tax_amt        gipi_invoice.tax_amt%TYPE,
      p_currency_rt    gipi_invoice.currency_rt%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_comm_vat (
      p_ri_comm_amt    gipi_invoice.prem_amt%TYPE,
      p_comm_invoice   gipi_invoice.ri_comm_amt%TYPE,
      p_currency_rt    gipi_invoice.currency_rt%TYPE,
      p_ri_comm_vat    gipi_invoice.ri_comm_vat%TYPE
   )
      RETURN NUMBER;

   FUNCTION get_tsi_basic (
      p_date         DATE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_peril_cd     giis_peril.peril_cd%TYPE
   )
      RETURN NUMBER;
END GIACB004S_PKG;
/



CREATE OR REPLACE PACKAGE CPI.gipir913a_pkg
AS
   TYPE gipir913a_type IS RECORD (
      line_name         VARCHAR2 (20),
      subline_name      VARCHAR2 (30),
      POLICY            VARCHAR2 (300),
      issue_date        DATE,
      fromdate          VARCHAR2 (300),
      todate            VARCHAR2 (300),
      particulars       VARCHAR2 (4000),
      branch_add        VARCHAR2 (500),
      tel_no            VARCHAR2 (100),
      branch_fax_no     VARCHAR2 (50),
      branch_website    VARCHAR2 (500),
      bill_no           VARCHAR2 (100),
      address           VARCHAR2 (500),
      short_name        VARCHAR2 (3),
      mortg_name        VARCHAR2 (100),
      intm_name         VARCHAR2 (240),
      report_id         VARCHAR2 (12),
      line_cd           VARCHAR2 (2),
      endt_tax          VARCHAR2 (1),
      logo_file         VARCHAR2 (100),
      term              VARCHAR2 (38),
      tot_prem          NUMBER (16, 2),
      old_policy_id     NUMBER (12),
      assd_name         VARCHAR2 (500),
      label_tag         VARCHAR2 (200),
      assd_name2        VARCHAR2 (500),
      policy_id         NUMBER (12),
      currency_rt       NUMBER (12, 9),
      iss_cd            VARCHAR2 (2),
      prem_seq_no       NUMBER (12),
      policy_currency   VARCHAR2 (1),
      pol_flag          VARCHAR2 (100),
      get_policy_no     VARCHAR2 (500)
   );

   TYPE gipir913a_tab IS TABLE OF gipir913a_type;

   TYPE gipir913a_signatory_type IS RECORD (
      signatory   VARCHAR2 (50)
   );

   TYPE gipir913a_signatory_tab IS TABLE OF gipir913a_signatory_type;

   TYPE gipir913a_taxes_type IS RECORD (
      tax_desc             giis_tax_charges.tax_desc%TYPE,
      tax_amt              gipi_inv_tax.tax_amt%TYPE,
      tax_amt_other        NUMBER (16, 2),
      tax_amt_other_desc   giis_tax_charges.tax_desc%TYPE
   );

   TYPE gipir913a_taxes_tab IS TABLE OF gipir913a_taxes_type;

   FUNCTION get_gipir913a_record (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipir913a_tab PIPELINED;

   FUNCTION get_gipir913a_signatory (p_report_id VARCHAR2)
      RETURN gipir913a_signatory_tab PIPELINED;

   FUNCTION get_gipir913a_taxes (
      p_iss_cd            gipi_invoice.iss_cd%TYPE,
      p_line_cd           gipi_polbasic.line_cd%TYPE,
      p_prem_seq_no       gipi_invoice.prem_seq_no%TYPE,
      p_policy_currency   gipi_invoice.policy_currency%TYPE,
      p_currency_rt       gipi_invoice.currency_rt%TYPE
   )
      RETURN gipir913a_taxes_tab PIPELINED;
END;
/



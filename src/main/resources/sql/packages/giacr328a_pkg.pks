CREATE OR REPLACE PACKAGE CPI.GIACR328A_PKG
AS
   TYPE giacr328a_rec_type IS RECORD (
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no           giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd           giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd       giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      invoice_no        giac_aging_prem_paid_ext.invoice_no%TYPE,
      policy_no         giac_aging_prem_paid_ext.policy_no%TYPE,
      iss_cd            giac_aging_prem_paid_ext.iss_cd%TYPE,
      eff_date          giac_aging_prem_paid_ext.eff_date%TYPE,
      incept_date       giac_aging_prem_paid_ext.incept_date%TYPE,
      age               giac_aging_prem_paid_ext.age%TYPE,
      gross_prem_amt    giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      column_title      giis_report_aging.column_title%TYPE,
      prem              giac_aging_prem_paid_ext.prem_amt%TYPE
   );

   TYPE giacr328a_rec_tab IS TABLE OF giacr328a_rec_type;

   TYPE distinct_details_type IS RECORD (
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no           giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd           giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd       giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      iss_cd            giac_aging_prem_paid_ext.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      gross_prem_amt    giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      dummy_total       giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   );

   TYPE distinct_details_tab IS TABLE OF distinct_details_type;

   TYPE column_title_type IS RECORD (
      column_title   giis_report_aging.column_title%TYPE,
      dummy_row      NUMBER
   );

   TYPE column_title_tab IS TABLE OF column_title_type;

   TYPE column_details_type IS RECORD (
      prem_amt         giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no          giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd          giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd      giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      invoice_no       giac_aging_prem_paid_ext.invoice_no%TYPE,
      policy_no        giac_aging_prem_paid_ext.policy_no%TYPE,
      iss_cd           giac_aging_prem_paid_ext.iss_cd%TYPE,
      eff_date         giac_aging_prem_paid_ext.eff_date%TYPE,
      incept_date      giac_aging_prem_paid_ext.incept_date%TYPE,
      age              giac_aging_prem_paid_ext.age%TYPE,
      gross_prem_amt   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_name         giis_issource.iss_name%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE,
      line_name        giis_line.line_name%TYPE,
      column_title     giis_report_aging.column_title%TYPE,
      prem             giac_aging_prem_paid_ext.prem_amt%TYPE
   );

   TYPE column_details_tab IS TABLE OF column_details_type;

   FUNCTION get_giacr328a_rec (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN giacr328a_rec_tab PIPELINED;

   FUNCTION get_distinct_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN distinct_details_tab PIPELINED;

   FUNCTION get_column_title
      RETURN column_title_tab PIPELINED;

   FUNCTION get_column_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN column_details_tab PIPELINED;

   TYPE giacr328_header_type IS RECORD (
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      iss_cd_dummy      VARCHAR2 (100),
      col_no_1          giis_report_aging.column_no%TYPE,
      col_no_2          giis_report_aging.column_no%TYPE,
      col_no_3          giis_report_aging.column_no%TYPE,
      col_no_4          giis_report_aging.column_no%TYPE,
      col_name_1        giis_report_aging.column_title%TYPE,
      col_name_2        giis_report_aging.column_title%TYPE,
      col_name_3        giis_report_aging.column_title%TYPE,
      col_name_4        giis_report_aging.column_title%TYPE,
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      aging_value_1     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_2     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_3     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_4     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      v_flag            VARCHAR2 (1)
   );

   TYPE giacr328_header_tab IS TABLE OF giacr328_header_type;

   TYPE column_type IS RECORD (
      col_no        giis_report_aging.column_no%TYPE,
      col_name      giis_report_aging.column_title%TYPE,
      aging_value   giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   );

   TYPE column_tab IS TABLE OF column_type;

   FUNCTION get_giacr328_header (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN giacr328_header_tab PIPELINED;

   --for matrix
   TYPE aging_values_type IS RECORD (
      col_no_1        giis_report_aging.column_no%TYPE,
      col_no_2        giis_report_aging.column_no%TYPE,
      col_no_3        giis_report_aging.column_no%TYPE,
      col_no_4        giis_report_aging.column_no%TYPE,
      aging_value_1   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_2   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_3   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_4   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_cd          VARCHAR2 (100),
      policy_no       VARCHAR2 (100)
   );

   TYPE aging_values_tab IS TABLE OF aging_values_type;

   FUNCTION get_aging_values (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_line_cd        VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      p_policy_no      VARCHAR2
   )
      RETURN aging_values_tab PIPELINED;

   FUNCTION get_aging_values_total (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   )
      RETURN aging_values_tab PIPELINED;
END GIACR328A_PKG;
/



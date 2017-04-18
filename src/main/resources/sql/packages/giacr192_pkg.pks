CREATE OR REPLACE PACKAGE CPI.giacr192_pkg
AS
   /* report variable */
   cp_date_format   VARCHAR (20);

   TYPE report_header_type IS RECORD (
      company_name        giis_parameters.param_value_v%TYPE,
      company_address     giis_parameters.param_value_v%TYPE,
      print_company       VARCHAR2 (1),
      rundate             VARCHAR2 (20),
      cf_title            giac_parameters.param_value_v%TYPE,
      cf_date_label       giac_parameters.param_value_v%TYPE,
      cf_date             giac_soa_rep_ext.param_date%TYPE,
      cf_date_tag1        VARCHAR2 (300),
      cf_date_tag2        VARCHAR2 (300),
      print_date_tag      VARCHAR2 (1),
      print_user          VARCHAR2 (1),
      print_footer_date   VARCHAR2 (1)
   );

   TYPE report_header_tab IS TABLE OF report_header_type;

   --added by steven 01.13.2015 for matrix
   TYPE title_type IS RECORD (
      dummy       NUMBER(10),
      col_title   giac_soa_title.col_title%TYPE,
      col_no      giac_soa_title.col_no%TYPE
   );

   TYPE title_tab IS TABLE OF title_type;

   FUNCTION cf_company_name
      RETURN VARCHAR2;

   FUNCTION cf_company_address
      RETURN VARCHAR2;

   FUNCTION cf_title
      RETURN VARCHAR2;

   FUNCTION cf_date_label
      RETURN VARCHAR2;

   FUNCTION cf_date (p_user giac_soa_rep_ext.user_id%TYPE)
      RETURN DATE;

   FUNCTION cf_date_tag1 (p_user giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_date_tag2 (p_user giac_soa_rep_ext.user_id%TYPE)
      RETURN VARCHAR2;

   PROCEDURE beforereport;

   FUNCTION get_report_header (p_user giac_soa_rep_ext.user_id%TYPE)
      RETURN report_header_tab PIPELINED;

   TYPE report_details_type IS RECORD (
      branch_cd             giac_soa_rep_ext.branch_cd%TYPE,
      branch_name           giac_branches.branch_name%TYPE,
      assd_no               giac_soa_rep_ext.assd_no%TYPE,
      assd_name             giac_soa_rep_ext.assd_name%TYPE,
      sum_balance_amt_due   NUMBER (18, 2),
      sum_prem_bal_due      NUMBER (18, 2),
      sum_tax_bal_due       NUMBER (18, 2),
      print_branch_totals   VARCHAR2 (1),
      branch_cd_dummy       VARCHAR2 (200),
      dummy                 NUMBER(10),
      /*col_no1               giac_soa_title.col_no%TYPE,
      col_title1            giac_soa_title.col_title%TYPE,
      col_no2               giac_soa_title.col_no%TYPE,
      col_title2            giac_soa_title.col_title%TYPE,
      col_no3               giac_soa_title.col_no%TYPE,
      col_title3            giac_soa_title.col_title%TYPE,
      col_no4               giac_soa_title.col_no%TYPE,
      col_title4            giac_soa_title.col_title%TYPE,
      col_no5               giac_soa_title.col_no%TYPE,
      col_title5            giac_soa_title.col_title%TYPE,*/
      col_no1               giac_soa_rep_ext.column_no%TYPE,
      col_title1            giac_soa_title.col_title%TYPE,
      intmbal1              NUMBER (18, 2),
      intmprem1             NUMBER (18, 2),
      intmtax1              NUMBER (18, 2),
      col_no2               giac_soa_rep_ext.column_no%TYPE,
      col_title2            giac_soa_title.col_title%TYPE,
      intmbal2              NUMBER (18, 2),
      intmprem2             NUMBER (18, 2),
      intmtax2              NUMBER (18, 2),
      col_no3               giac_soa_rep_ext.column_no%TYPE,
      col_title3            giac_soa_title.col_title%TYPE,
      intmbal3              NUMBER (18, 2),
      intmprem3             NUMBER (18, 2),
      intmtax3              NUMBER (18, 2),
      col_no4               giac_soa_rep_ext.column_no%TYPE,
      col_title4            giac_soa_title.col_title%TYPE,
      intmbal4              NUMBER (18, 2),
      intmprem4             NUMBER (18, 2),
      intmtax4              NUMBER (18, 2),
      col_no5               giac_soa_rep_ext.column_no%TYPE,
      col_title5            giac_soa_title.col_title%TYPE,
      intmbal5              NUMBER (18, 2),
      intmprem5             NUMBER (18, 2),
      intmtax5              NUMBER (18, 2),
      no_of_dummy           NUMBER (10)
   );

   TYPE report_details_tab IS TABLE OF report_details_type;

   FUNCTION cf_branch_name (p_branch_cd giac_soa_rep_ext.branch_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_report_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   VARCHAR2,
      p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE
   )
      RETURN report_details_tab PIPELINED;

   TYPE column_header_type IS RECORD (
      dummy       NUMBER(10),   -- added by shan 03.04.2015
      col_no1      giac_soa_title.col_no%TYPE,
      col_title1   giac_soa_title.col_title%TYPE,
      col_no2      giac_soa_title.col_no%TYPE,
      col_title2   giac_soa_title.col_title%TYPE,
      col_no3      giac_soa_title.col_no%TYPE,
      col_title3   giac_soa_title.col_title%TYPE,
      col_no4      giac_soa_title.col_no%TYPE,
      col_title4   giac_soa_title.col_title%TYPE,
      col_no5      giac_soa_title.col_no%TYPE,
      col_title5   giac_soa_title.col_title%TYPE,
      no_of_dummy  NUMBER(10)   -- added by shan 03.04.2015
   );

   TYPE column_header_tab IS TABLE OF column_header_type;

   FUNCTION get_column_header
      RETURN column_header_tab PIPELINED;

   TYPE column_details_type IS RECORD (
      branch_cd      giac_soa_rep_ext.branch_cd%TYPE,
      assd_no        giac_soa_rep_ext.assd_no%TYPE,
      assd_name      giac_soa_rep_ext.assd_name%TYPE,
      col_no         giac_soa_rep_ext.column_no%TYPE,
      column_title   giac_soa_title.col_title%TYPE,
      intmbal        NUMBER (18, 2),
      intmprem       NUMBER (18, 2),
      intmtax        NUMBER (18, 2)
   );

   TYPE column_details_tab IS TABLE OF column_details_type;

   FUNCTION get_column_details (
      p_branch_cd     giac_soa_rep_ext.branch_cd%TYPE,
      p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
      p_inc_overdue   VARCHAR2,
      p_bal_amt_due   giac_soa_rep_ext.balance_amt_due%TYPE,
      p_intm_type     giac_soa_rep_ext.intm_type%TYPE,
      p_user          giac_soa_rep_ext.user_id%TYPE,
      p_column_no     giac_soa_rep_ext.column_no%TYPE
   )
      RETURN column_details_tab PIPELINED;

   TYPE csv_col_type IS RECORD (
      col_name   VARCHAR2 (100)
   );

   TYPE csv_col_tab IS TABLE OF csv_col_type;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;
END giacr192_pkg;
/



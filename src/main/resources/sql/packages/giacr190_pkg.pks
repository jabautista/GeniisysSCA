CREATE OR REPLACE PACKAGE CPI.giacr190_pkg
AS
   TYPE report_type IS RECORD (
      company_name          VARCHAR2 (200),
      company_address       VARCHAR2 (200),
      soa_branch_total_sw   VARCHAR2 (1),
      report_title          VARCHAR2 (200),
      date_label            VARCHAR2 (100),
      report_date           DATE,
      date_tag1             VARCHAR2 (300),
      date_tag2             VARCHAR2 (200),
      date_tag3             VARCHAR2 (300),
      date_tag4             VARCHAR2 (200),
      branch_cd             giac_soa_rep_ext.branch_cd%TYPE,
      iss_name              giis_issource.iss_name%TYPE,
      intm_no               VARCHAR2 (10),
      ref_intm_cd           giis_intermediary.ref_intm_cd%TYPE,
      intm_name             giis_intermediary.intm_name%TYPE,
      prem_bal_due          NUMBER (16, 2),
      tax_bal_due           NUMBER (16, 2),
      balance_amt_due       NUMBER (16, 2),
      user_id               giac_soa_rep_ext.user_id%TYPE,
      branch_cd_dummy       VARCHAR2 (200),
      col_no1               giac_soa_title.col_no%TYPE,
      col_title1            giac_soa_title.col_title%TYPE,
      col_no2               giac_soa_title.col_no%TYPE,
      col_title2            giac_soa_title.col_title%TYPE,
      col_no3               giac_soa_title.col_no%TYPE,
      col_title3            giac_soa_title.col_title%TYPE,
      col_no4               giac_soa_title.col_no%TYPE,
      col_title4            giac_soa_title.col_title%TYPE,
      col_no5               giac_soa_title.col_no%TYPE,
      col_title5            giac_soa_title.col_title%TYPE,
      no_of_dummy           NUMBER (10),
      grp_dummy             NUMBER (10)
   );

   TYPE report_tab IS TABLE OF report_type;

   TYPE intm_bal_type IS RECORD (
      intm_type   VARCHAR2 (10),
      branch_cd   giac_soa_rep_ext.branch_cd%TYPE,
      intm_no     NUMBER (12),
      intm_cd     giis_intermediary.ref_intm_cd%TYPE,
      col_title   giac_soa_title.col_title%TYPE,
      intmbal     NUMBER (18, 2),
      intmprem    NUMBER (18, 2),
      intmtax     NUMBER (18, 2)
   );

   TYPE intm_bal_tab IS TABLE OF intm_bal_type;

   FUNCTION get_giacr190_report (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN report_tab PIPELINED;

   TYPE giacr190_column_type IS RECORD (
      col_title   giac_soa_title.col_title%TYPE,
      col_no      giac_soa_title.col_no%TYPE,
      rep_cd      giac_soa_title.rep_cd%TYPE
   );

   TYPE giacr190_column_tab IS TABLE OF giacr190_column_type;

   FUNCTION get_giacr190_columns
      RETURN giacr190_column_tab PIPELINED;

   TYPE giacr190_type IS RECORD (
      column_title   giac_soa_title.col_title%TYPE,
      col_no         giac_soa_title.col_no%TYPE,
      intm_type      VARCHAR2 (10),
      branch_cd      giac_soa_rep_ext.branch_cd%TYPE,
      intmbal        NUMBER (16, 2),
      intmprem       NUMBER (16, 2),
      intmtax        NUMBER (16, 2),
      intm_no        NUMBER (16, 2),
      intm_name      giis_intermediary.intm_name%TYPE
   );

   TYPE giacr190_tab IS TABLE OF giacr190_type;

   FUNCTION get_giacr190_details (
      p_bal_amt_due   NUMBER,
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_month         VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN giacr190_tab PIPELINED;

   TYPE csv_col_type IS RECORD (
      col_name   VARCHAR2 (100)
   );

   TYPE csv_col_tab IS TABLE OF csv_col_type;

   --added by steven 12.04.2014 for matrix
   TYPE title_type IS RECORD (
      col_title   giac_soa_title.col_title%TYPE,
      col_no      giac_soa_title.col_no%TYPE
   );

   TYPE title_tab IS TABLE OF title_type;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;

   FUNCTION get_intm_bal (
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2,
      p_col_title     VARCHAR2
   )
      RETURN intm_bal_tab PIPELINED;

   FUNCTION get_summary_title_dtl (
      p_branch_cd     VARCHAR2,
      p_inc_overdue   VARCHAR2,
      p_intm_no       VARCHAR2,
      p_intm_type     VARCHAR2,
      p_user          VARCHAR2
   )
      RETURN intm_bal_tab PIPELINED;
END;
/



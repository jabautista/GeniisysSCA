CREATE OR REPLACE PACKAGE CPI.GIACR502_PKG
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      as_of             VARCHAR2 (100),
      branch_name       VARCHAR2 (100),
      mm                VARCHAR2 (100),
      cf_branch_name    VARCHAR2 (100),
      gl_acct_no        VARCHAR2 (200),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit             NUMBER (16, 2),
      credit            NUMBER (16, 2),
      balance           NUMBER (16, 2),
      branch_totals     VARCHAR2 (30),
      fund_cd           giac_finance_yr.fund_cd%TYPE,
      v_header          VARCHAR2 (1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_502_report (
      p_branch_cd   VARCHAR2,
      p_tran_mm     NUMBER,
      p_tran_yr     NUMBER
   )
      RETURN report_tab PIPELINED;
END;
/



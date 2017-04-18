CREATE OR REPLACE PACKAGE CPI.GIACR502D_PKG
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      as_of             VARCHAR2 (100),
      gl_acct_no        VARCHAR2 (200),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      beg_debit         NUMBER (16, 2),
      beg_credit        NUMBER (16, 2),
      trans_debit       NUMBER (16, 2),
      trans_credit      NUMBER (16, 2),
      end_debit         NUMBER (16, 2),
      end_credit        NUMBER (16, 2),
      mm                VARCHAR2 (100)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_502d_report (
      p_tran_mm     NUMBER,
      p_tran_yr     NUMBER
   )
      RETURN report_tab PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.giacr111_pkg
AS
   TYPE report_type IS RECORD (
      co_tin       VARCHAR2 (100),
      co_name      VARCHAR2 (200),
      seq_no       VARCHAR2 (100),
      tin          VARCHAR2 (100),
      NAME         VARCHAR2 (700),
      atc_code     giac_wholding_taxes.bir_tax_cd%TYPE,
      income_amt   giac_taxes_wheld.income_amt%TYPE,
      tax_rt       giac_wholding_taxes.percent_rate%TYPE,
      tax_wh       giac_taxes_wheld.wholding_tax_amt%TYPE,
      as_of_date   VARCHAR2 (100),
      exist        VARCHAR2 (1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giacr_111_report (
      p_date          VARCHAR2,
      p_exclude_tag   VARCHAR2,
      p_module_id     VARCHAR2,
      p_post_tran     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/



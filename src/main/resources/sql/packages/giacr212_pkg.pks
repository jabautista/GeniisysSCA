CREATE OR REPLACE PACKAGE CPI.giacr212_pkg
AS
   TYPE giacr212_record_type IS RECORD (
      company_name    VARCHAR2 (100),
      company_add     giac_parameters.param_value_v%TYPE,
      date_range      VARCHAR2 (100),
      sl_cd           giac_acct_entries.sl_cd%TYPE,
      sl_name         giac_sl_lists.sl_name%TYPE,
      gl_acct_id      VARCHAR2 (100),
      gl_acct_sname   giac_chart_of_accts.gl_acct_sname%TYPE,
      branch_name     VARCHAR2 (100),
      debit_sum       NUMBER (16, 2),
      credit_sum      NUMBER (16, 2),
      is_exists       VARCHAR2(1)
   );

   TYPE giacr212_record_tab IS TABLE OF giacr212_record_type;

   FUNCTION get_giacr212_record (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_date_type   VARCHAR2,
      p_sl_type     VARCHAR2,
      p_user_id     VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN giacr212_record_tab PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.giacr166_pkg
AS
   TYPE giacr166_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      line_name            giis_line.line_name%TYPE,
      gl_acct_sname        giac_chart_of_accts.gl_acct_sname%TYPE,
      debit_amt            giac_acct_entries.debit_amt%TYPE,
      credit_amt           giac_acct_entries.credit_amt%TYPE,
      balance              number(12,2),
      cf_title             giac_eom_rep.rep_title%TYPE
   );

   TYPE giacr166_records_tab IS TABLE OF giacr166_records_type;

   FUNCTION get_giacr166_records (
      p_from_date   DATE,
      p_to_date     DATE,
      p_report      VARCHAR2
   )
      RETURN giacr166_records_tab PIPELINED;
END;
/



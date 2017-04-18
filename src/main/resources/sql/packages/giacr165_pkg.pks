CREATE OR REPLACE PACKAGE CPI.giacr165_pkg
AS
   TYPE giacr165_records_type IS RECORD (
      cf_company           VARCHAR2 (150),
      cf_company_address   VARCHAR2 (500),
      cf_from_date         VARCHAR2 (50),
      cf_to_date           VARCHAR2 (50),
      branch_cd            giac_acctrans.gibr_branch_cd%TYPE,
      line_name            giis_line.line_name%TYPE,
      gl_acct_sname        giac_chart_of_accts.gl_acct_sname%TYPE,
      debit_amt            giac_acct_entries.debit_amt%TYPE,
      credit_amt           giac_acct_entries.credit_amt%TYPE,
      balance              number(12,2),
      cf_title             giac_eom_rep.rep_title%TYPE
   );

   TYPE giacr165_records_tab IS TABLE OF giacr165_records_type;

   FUNCTION get_giacr165_records (
      p_from_date   DATE,
      p_to_date     DATE,
      p_report      VARCHAR2
   )
      RETURN giacr165_records_tab PIPELINED;
END;
/



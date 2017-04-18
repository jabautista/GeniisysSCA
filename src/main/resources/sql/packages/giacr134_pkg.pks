CREATE OR REPLACE PACKAGE CPI.giacr134_pkg
AS
   TYPE get_giacr134_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      tran_date1        VARCHAR2 (200),
      tran_date2        VARCHAR2 (200),
      gl_acct_cd        VARCHAR2 (200),
      gl_acct_name      VARCHAR2 (100),
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE
   );

   TYPE get_giacr134_tab IS TABLE OF get_giacr134_type;

   FUNCTION get_giacr134_dtls (
      p_date         VARCHAR2,
      p_tran_date1   VARCHAR2,
      p_tran_date2   VARCHAR2,
      p_tran_year    VARCHAR2
   )
      RETURN get_giacr134_tab PIPELINED;
END;
/



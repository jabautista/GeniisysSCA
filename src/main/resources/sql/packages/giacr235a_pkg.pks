CREATE OR REPLACE PACKAGE CPI.GIACR235A_PKG
AS
   TYPE get_details_type IS RECORD (
      tran_id           giac_order_of_payts.gacc_tran_id%TYPE,
      or_no             VARCHAR2 (100),
      or_no_2           VARCHAR2 (100),
      or_date           VARCHAR2 (50),
      payor             giac_order_of_payts.payor%TYPE,
      particulars       giac_acctrans.particulars%TYPE,
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE,
      dummy             VARCHAR2(1)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_gl_account_type IS RECORD (
      tran_id           giac_order_of_payts.gacc_tran_id%TYPE,
      gl_acct           VARCHAR2 (100),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE
   );
   
   TYPE get_gl_account_tab IS TABLE OF get_gl_account_type;

   FUNCTION get_details (
        P_FROM_DATE     DATE,
        P_TO_DATE       DATE,
        P_ISS_CD        giis_issource.iss_cd%TYPE,
        P_USER_ID       giis_users.user_id%TYPE
   )
      RETURN get_details_tab PIPELINED;
      
   FUNCTION get_gl_account (
        P_TRAN_ID       giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN get_gl_account_tab PIPELINED;
END;
/



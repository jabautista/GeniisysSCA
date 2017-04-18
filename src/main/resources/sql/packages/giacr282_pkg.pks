CREATE OR REPLACE PACKAGE CPI.giacr282_pkg
AS
   TYPE main_type IS RECORD (
      bank_acct         VARCHAR2 (500),
      bank_acct_no      giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_cd      giac_bank_accounts.bank_acct_cd%TYPE,
      branch_cd         giac_branches.branch_cd%TYPE,
      amount            NUMBER (16, 2),
      company_name      VARCHAR2 (1000),
      company_address   VARCHAR2 (1000),
      from_date         VARCHAR2 (200),
      TO_DATE           VARCHAR2 (100)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main_rep (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE date_type IS RECORD (
      tran_date      DATE,
      posting_date   DATE
   );

   TYPE date_tab IS TABLE OF date_type;

   FUNCTION get_dates (
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_tran_post       VARCHAR2,
      p_bank_acct_cd2   VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no    VARCHAR2
   )
      RETURN date_tab PIPELINED;

   TYPE dcb_no_type IS RECORD (
      dcb_no   VARCHAR2 (100),
      amount   NUMBER (16, 2)
   );

   TYPE dcb_no_tab IS TABLE OF dcb_no_type;

   FUNCTION get_dcb_nos (
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_bank_acct_cd2   VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no    VARCHAR2
   )
      RETURN dcb_no_tab PIPELINED;
      
   TYPE pay_mode_type IS RECORD (
      pay_mode giac_dcb_bank_dep.pay_mode%TYPE,
      amount   NUMBER(16, 3),
      branch_name    giac_branches.branch_name%TYPE, --added by MarkS 7.12.2016 sr-5535
      bank_cd      giac_banks.bank_cd%TYPE,          --added by MarkS 7.12.2016 sr-5535
      bank_name        giac_banks.bank_name%TYPE     --added by MarkS 7.12.2016 sr-5535
   );
   
   TYPE pay_mode_tab IS TABLE OF pay_mode_type;
   
   FUNCTION get_pay_modes (
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_bank_acct_cd2   VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_dcb_no          VARCHAR2
   )
      RETURN pay_mode_tab PIPELINED;
END;
/



CREATE OR REPLACE PACKAGE CPI.giacr281_pkg
AS
   TYPE giacr281_main_type IS RECORD (
      branch_cd      giac_branches.branch_cd%TYPE,
      branch_name    giac_branches.branch_name%TYPE,
      bank_acct      VARCHAR2 (500),
      bank_acct_no   giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE,
      amount         NUMBER(16, 2),
      company_name      VARCHAR2 (1000),
      company_address   VARCHAR2 (1000),
      from_date         VARCHAR2 (200),
      to_date           VARCHAR2 (100)
   );

   TYPE giacr281_main_tab IS TABLE OF giacr281_main_type;

   FUNCTION get_giacr281 (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_module_id      VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN giacr281_main_tab PIPELINED;

   TYPE giacr281_date_type IS RECORD (
      tran_date      DATE,
      posting_date   DATE
   );

   TYPE giacr281_date_tab IS TABLE OF giacr281_date_type;

   FUNCTION get_giacr281_dates (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_bank_acct_cd   VARCHAR2
   )
      RETURN giacr281_date_tab PIPELINED;

   TYPE giacr281_dcb_no_type IS RECORD (
      dcb_no   VARCHAR2 (200)
   );

   TYPE giacr281_dcb_no_tab IS TABLE OF giacr281_dcb_no_type;

   FUNCTION get_giacr281_dcb_nos (
      p_branch_cd      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_tran_date      DATE,
      p_posting_date   DATE
   )
      RETURN giacr281_dcb_no_tab PIPELINED;

   TYPE giacr281_amounts_type IS RECORD (
      pay_mode  giac_dcb_bank_dep.pay_mode%TYPE,
      amount    NUMBER (16, 2),
      branch_name    giac_branches.branch_name%TYPE, --added by MarkS 7.11.2016 sr-5533
      bank_cd      giac_banks.bank_cd%TYPE,          --added by MarkS 7.11.2016 sr-5533
      bank_name        giac_banks.bank_name%TYPE     --added by MarkS 7.11.2016 sr-5533
   );

   TYPE giacr281_amounts_tab IS TABLE OF giacr281_amounts_type;

   FUNCTION get_giacr281_amounts (
      p_branch_cd      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_tran_date      DATE,
      p_posting_date   DATE,
      p_dcb_no         VARCHAR2
   )
      RETURN giacr281_amounts_tab PIPELINED;
      
   TYPE giacr281a_column_type IS RECORD (
      pay_mode  giac_dcb_bank_dep.pay_mode%TYPE  
   );
   
   TYPE giacr281a_column_tab IS TABLE OF giacr281a_column_type;
   
   FUNCTION get_giacr281a_columns (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2
   )
      RETURN giacr281a_column_tab PIPELINED;
      
   TYPE giacr281a_amount_type IS RECORD(
      amount NUMBER(16, 2)
   );
   
   TYPE giacr281a_amount_tab IS TABLE OF giacr281a_amount_type;
   
   FUNCTION get_giacr281a_amounts (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no   VARCHAR2,
      p_tran_date      DATE,
      p_posting_date   DATE,
      p_dcb_no         VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED;
      
   FUNCTION get_account_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no   VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED;
      
   FUNCTION get_branch_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_branch_cd2      VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED;
      
   FUNCTION get_grand_totals (
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_tran_post      VARCHAR2,
      p_bank_acct_cd   VARCHAR2,
      p_branch_cd      VARCHAR2
   )
      RETURN giacr281a_amount_tab PIPELINED;      
      
END;
/



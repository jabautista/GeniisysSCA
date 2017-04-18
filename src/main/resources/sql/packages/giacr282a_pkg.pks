CREATE OR REPLACE PACKAGE CPI.giacr282a_pkg
AS
   TYPE main_type IS RECORD (
      bank_acct         VARCHAR2 (500),
      bank_acct_no      giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_cd      giac_bank_accounts.bank_acct_cd%TYPE,
      branch_cd         giac_dcb_bank_dep.branch_cd%TYPE,
      amount            NUMBER(16, 2),
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
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2
   )
      RETURN date_tab PIPELINED;

   TYPE dcb_no_type IS RECORD (
      dcb_no   VARCHAR2 (100),
      amount   NUMBER(16, 2)
   );

   TYPE dcb_no_tab IS TABLE OF dcb_no_type;

   FUNCTION get_dcb_nos (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE
   )
      RETURN dcb_no_tab PIPELINED;

   TYPE pay_mode_type IS RECORD (
      pay_mode   VARCHAR2 (100),
      amount     NUMBER (16, 2)
   );

   TYPE pay_mode_tab IS TABLE OF pay_mode_type;

   FUNCTION get_pay_modes (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2
   )
      RETURN pay_mode_tab PIPELINED;

   TYPE dep_no_type IS RECORD (
      dep_no   giac_bank_dep_slips.dep_no%TYPE,
      amount   NUMBER (16, 2)
   );

   TYPE dep_no_tab IS TABLE OF dep_no_type;

   FUNCTION get_dep_nos (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2,
      p_pay_mode        VARCHAR2
   )
      RETURN dep_no_tab PIPELINED;

   TYPE ref_type IS RECORD (
      ref_no   VARCHAR2 (100),
      amount   NUMBER (16, 2),
      --edited by MarkS SR5536 7.14.2016 to make the cs used the same package for csv printing
      dcb_no   VARCHAR2 (100),
      dcb_amount   NUMBER(16, 2),
      dcb_year  giac_dcb_bank_dep.dcb_year%TYPE,
      pay_mode   VARCHAR2 (100),
      p_amount     NUMBER (16, 2),
      dep_no   giac_bank_dep_slips.dep_no%TYPE,
      dp_amount   NUMBER (16, 2),
      branch_name    giac_branches.branch_name%TYPE, 
      bank_cd      giac_banks.bank_cd%TYPE,          
      bank_name        giac_banks.bank_name%TYPE     
     --end sr5536
   );
   
   TYPE ref_tab IS TABLE OF ref_type;
   
   FUNCTION get_refs (
      p_bank_acct_cd2   VARCHAR2,
      p_bank_acct_no    VARCHAR2,
      p_branch_cd2      VARCHAR2,
      p_tran_date       DATE,
      p_posting_date    DATE,
      p_dcb_no          VARCHAR2,
      p_pay_mode        VARCHAR2   
   )
      RETURN ref_tab PIPELINED;
   
END;
/

CREATE OR REPLACE PACKAGE CPI.GIACS326_PKG
AS

   TYPE bank_lov_type IS RECORD(
      bank_cd                 GIAC_BANKS.bank_cd%TYPE,
      bank_sname              GIAC_BANKS.bank_sname%TYPE,
      bank_name               GIAC_BANKS.bank_name%TYPE
   );
   TYPE bank_lov_tab IS TABLE OF bank_lov_type;
   
   TYPE bank_acct_type IS RECORD(
      bank_acct_cd            GIAC_BANK_ACCOUNTS.bank_acct_cd%TYPE,
      bank_acct_no            GIAC_BANK_ACCOUNTS.bank_acct_no%TYPE
   );
   TYPE bank_acct_tab IS TABLE OF bank_acct_type;
   
   TYPE check_no_type IS RECORD(
      fund_cd                 GIAC_CHECK_NO.fund_cd%TYPE,
      branch_cd               GIAC_CHECK_NO.branch_cd%TYPE,
      bank_cd                 GIAC_CHECK_NO.bank_cd%TYPE,
      bank_acct_cd            GIAC_CHECK_NO.bank_acct_cd%TYPE,
      chk_prefix              GIAC_CHECK_NO.chk_prefix%TYPE,
      check_seq_no            GIAC_CHECK_NO.check_seq_no%TYPE,
      remarks                 GIAC_CHECK_NO.remarks%TYPE,
      user_id                 GIAC_CHECK_NO.user_id%TYPE,
      last_update             VARCHAR2(30),
      in_use                  VARCHAR2(1),
      old_check_seq_no        GIAC_CHECK_NO.check_seq_no%TYPE
   );
   TYPE check_no_tab IS TABLE OF check_no_type;

   PROCEDURE check_branch(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE
   );
   
   FUNCTION get_bank_lov(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN bank_lov_tab PIPELINED;
     
   FUNCTION get_bank_acct_lov(
      p_bank_cd               GIAC_BANK_ACCOUNTS.bank_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN bank_acct_tab PIPELINED;
     
   FUNCTION get_check_no_list(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE,
      p_check_seq_no          GIAC_CHECK_NO.check_seq_no%TYPE
   )
     RETURN check_no_tab PIPELINED;
     
   PROCEDURE val_del_rec(
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE
   );
   
   PROCEDURE del_rec(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE
   );
   
   PROCEDURE set_rec(
      p_rec                   GIAC_CHECK_NO%ROWTYPE
   );

END GIACS326_PKG;
/



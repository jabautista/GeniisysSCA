CREATE OR REPLACE PACKAGE CPI.giac_bank_accounts_pkg
AS
   TYPE giac_bank_accounts_type IS RECORD (
      bank_cd          giac_bank_accounts.bank_cd%TYPE,
      bank_name           giac_banks.bank_name%TYPE,
      bank_acct_type   giac_bank_accounts.bank_acct_type%TYPE,
      bank_acct_cd     giac_bank_accounts.bank_acct_cd%TYPE,
      bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE,
      branch_cd        giac_bank_accounts.bank_acct_type%TYPE,
      branch_bank      giac_bank_accounts.branch_bank%TYPE,
      pk_dummy         VARCHAR2(100)
   );

   TYPE giac_bank_accounts_tab IS TABLE OF giac_bank_accounts_type;
   FUNCTION get_bank_account_no(p_keyword  VARCHAR2)
      RETURN giac_bank_accounts_tab PIPELINED;
      
   PROCEDURE check_bank (
        p_bank_cd           IN  giac_bank_accounts.bank_cd%TYPE,
        p_bank_acct_cd      IN  giac_bank_accounts.bank_acct_cd%TYPE,
        p_bank_acct_no      OUT giac_bank_accounts.bank_acct_no%TYPE,
        p_bank_sname        OUT GIAC_BANKS.BANK_SNAME%TYPE
   );
  
   FUNCTION get_giacs002_bank_list(
        p_branch_cd         GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE,
        p_module_id         giis_modules.module_id%TYPE,
        p_user_id           giac_disb_vouchers.user_id%TYPE,
        p_mir_branch_cd     GIAC_DISB_VOUCHERS.GIBR_BRANCH_CD%TYPE
   ) RETURN giac_bank_accounts_tab PIPELINED;

   FUNCTION get_bank_acct_no_list(
        p_branch_cd     giac_branches.branch_cd%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
   ) RETURN giac_bank_accounts_tab PIPELINED;
   
   FUNCTION get_giacs054_bank_lov(
        p_fund_cd       giis_funds.fund_cd%TYPE,
        p_branch_cd     giac_bank_accounts.branch_cd%TYPE
        
   )
     RETURN giac_bank_accounts_tab PIPELINED;
--------------------------------------------------------------------   
   TYPE GIACS035_BANK_ACCOUNT_LOV_TYPE IS RECORD ( -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_ACCOUNT_LOV - Start
      BANK_ACCT_CD     GIAC_BANK_ACCOUNTS.BANK_ACCT_CD%TYPE,   
      BANK_ACCT_NO     GIAC_BANK_ACCOUNTS.BANK_ACCT_NO%TYPE,
      BANK_ACCT_TYPE   GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE%TYPE,
      BRANCH_CD        GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE%TYPE
   );

   TYPE GIACS035_BANK_ACCOUNT_LOV_TAB IS TABLE OF GIACS035_BANK_ACCOUNT_LOV_TYPE;
   FUNCTION GET_GIACS035_BANK_ACCOUNT_LOV (
        P_SEARCH              VARCHAR2,
        P_BANK_CD             GIAC_BANK_ACCOUNTS.BANK_CD%TYPE
   ) 
   RETURN GIACS035_BANK_ACCOUNT_LOV_TAB PIPELINED;  -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_ACCOUNT_LOV - End     
      
   FUNCTION get_bank_acct_dtls (p_keyword VARCHAR2) --Deo [01.12.2017]: SR-22489
      RETURN giac_bank_accounts_tab PIPELINED;
END giac_bank_accounts_pkg;
/



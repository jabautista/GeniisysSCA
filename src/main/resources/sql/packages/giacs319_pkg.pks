CREATE OR REPLACE PACKAGE CPI.GIACS319_PKG
AS
    
    TYPE company_type IS RECORD(
        gfun_fund_cd    GIAC_BRANCHES.GFUN_FUND_CD%type,
        fund_desc       GIIS_FUNDS.FUND_DESC%type,
        branch_cd       GIAC_BRANCHES.BRANCH_CD%type,
        branch_name     GIAC_BRANCHES.BRANCH_NAME%type
    );
    
    TYPE company_tab IS TABLE OF company_type;
    
    
    FUNCTION get_company_lov(
        p_user_id       VARCHAR2
    ) RETURN company_tab PIPELINED;
    
    
    TYPE dcb_user_type IS RECORD(
        dcb_user_id     GIAC_USERS.USER_ID%type,
        dcb_user_name   GIAC_USERS.USER_NAME%type
    );
    
    TYPE dcb_user_tab IS TABLE OF dcb_user_type;
    
    
    FUNCTION get_dcb_user_lov   
        RETURN dcb_user_tab PIPELINED;
        
        
    TYPE bank_type IS RECORD(
        bank_cd         giac_bank_accounts.BANK_ACCT_CD%type,
        bank_name       giac_banks.BANK_NAME%type
    );
    
    TYPE bank_tab IS TABLE OF bank_type;
    
    
    FUNCTION get_bank_lov   
        RETURN bank_tab PIPELINED;
        
    
    TYPE bank_acct_type IS RECORD(
        bank_acct_cd        GIAC_BANK_ACCOUNTS.BANK_ACCT_CD%type,
        bank_acct_no        GIAC_BANK_ACCOUNTS.BANK_ACCT_NO%type,
        bank_acct_type      GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE%type,
        branch_cd           GIAC_BANK_ACCOUNTS.BRANCH_CD%type
    );
    
    TYPE bank_acct_tab IS TABLE OF bank_acct_type;
    
    
    FUNCTION get_bank_acct_lov (
        p_bank_cd       GIAC_BANK_ACCOUNTS.BANK_CD%type
    ) RETURN bank_acct_tab PIPELINED;
    
    
    TYPE rec_type IS RECORD(
        gibr_fund_cd        GIAC_DCB_USERS.GIBR_FUND_CD%type,
        gibr_branch_cd      GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        cashier_cd          GIAC_DCB_USERS.CASHIER_CD%type,
        dcb_user_id         GIAC_DCB_USERS.DCB_USER_ID%type,
        dcb_user_name       GIAC_USERS.USER_NAME%type,
        print_name          GIAC_DCB_USERS.PRINT_NAME%type,
        effectivity_dt      GIAC_DCB_USERS.EFFECTIVITY_DT%type,
        expiry_dt           GIAC_DCB_USERS.EXPIRY_DT%type,
        valid_tag           VARCHAR2(3), --GIAC_DCB_USERS.VALID_TAG%type,
        bank_cd             GIAC_DCB_USERS.BANK_CD%type,
        bank_name           GIAC_BANKS.BANK_NAME%type,
        bank_acct_cd        GIAC_DCB_USERS.BANK_ACCT_CD%type,
        bank_acct_no        GIAC_BANK_ACCOUNTS.BANK_ACCT_NO%type,
        remarks             GIAC_DCB_USERS.REMARKS%type,
        user_id             GIAC_DCB_USERS.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    
    FUNCTION get_rec_list(
        p_gfun_fund_cd    GIAC_BRANCHES.GFUN_FUND_CD%type,
        p_branch_cd       GIAC_BRANCHES.BRANCH_CD%type
    ) RETURN rec_tab PIPELINED;
    
    
    PROCEDURE set_rec (p_rec GIAC_DCB_USERS%ROWTYPE);


    PROCEDURE del_rec (
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    );

    PROCEDURE val_del_rec (
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    );
   
    PROCEDURE val_add_rec(
        p_gibr_fund_cd      GIAC_DCB_USERS.GIBR_FUND_CD%type,
        p_gibr_branch_cd    GIAC_DCB_USERS.GIBR_BRANCH_CD%type,
        p_cashier_cd        GIAC_DCB_USERS.CASHIER_CD%type,
        p_dcb_user_id       GIAC_DCB_USERS.DCB_USER_ID%type
    );
    
END GIACS319_PKG;
/

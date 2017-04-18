CREATE OR REPLACE PACKAGE CPI.GIACS241_PKG AS
   
    TYPE fund_type IS RECORD (
        fund_cd     giis_funds.fund_cd%TYPE,
        fund_desc   giis_funds.fund_desc%TYPE
    );
    
    TYPE fund_tab IS TABLE OF fund_type;
    
    TYPE branch_type IS RECORD(
        branch_cd   giac_branches.branch_cd%TYPE,
        branch_name giac_branches.branch_name%TYPE
    );
    
    TYPE branch_tab IS TABLE OF branch_type;
    
    TYPE ouc_type IS RECORD(
        ouc_id      giac_oucs.ouc_id%TYPE,
        ouc_name    giac_oucs.ouc_name%TYPE
    );
    
    TYPE ouc_tab IS TABLE OF ouc_type;
    
    TYPE checks_paid_list_type IS RECORD(
        fund_cd         giac_pd_checks_v.fund_cd%TYPE,
        fund_desc       giac_pd_checks_v.fund_desc%TYPE,
        ouc_id          giac_pd_checks_v.ouc_id%TYPE,
        ouc_name        giac_pd_checks_v.ouc_name%TYPE,
        branch_cd       giac_pd_checks_v.branch_cd%TYPE,
        branch_name     giac_pd_checks_v.branch_name%TYPE,
        payee_class_cd  giac_pd_checks_v.payee_class_cd%TYPE,
        class_desc      giac_pd_checks_v.class_desc%TYPE,
        payee_no        giac_pd_checks_v.payee_no%TYPE,
        payee_name      VARCHAR2(550),
        check_no        giac_pd_checks_v.check_no%TYPE,
        check_date      giac_pd_checks_v.check_date%TYPE,
        dv_amount       giac_pd_checks_v.dv_amt%TYPE,
        particulars     giac_pd_checks_v.particulars%TYPE,
        bank_name       giac_pd_checks_v.bank_name%TYPE,
        bank_acct_no    giac_pd_checks_v.bank_acct_no%TYPE,
        user_id         giac_pd_checks_v.user_id%TYPE,
        last_update     VARCHAR2(50)
    );
    
    TYPE checks_paid_list_tab IS TABLE OF checks_paid_list_type;

    FUNCTION get_fund_list
        RETURN fund_tab PIPELINED;
    
    FUNCTION get_branch_list(
        p_fund_cd   giis_funds.fund_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN branch_tab PIPELINED;
    
    FUNCTION get_ouc_list
        RETURN ouc_tab PIPELINED;

    FUNCTION get_checks_paid_list(
        p_user_id   giis_users.user_id%TYPE,
        p_fund_cd   giis_funds.fund_cd%TYPE,
        p_branch_cd giac_branches.branch_cd%TYPE,
        p_ouc_id    giac_oucs.ouc_id%TYPE,
        p_from_date VARCHAR2,
        p_to_date   VARCHAR2
    )
        RETURN checks_paid_list_tab PIPELINED;
    
END GIACS241_PKG;
/



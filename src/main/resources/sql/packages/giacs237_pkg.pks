CREATE OR REPLACE PACKAGE CPI.GIACS237_PKG AS
    TYPE fund_cd_lov_type IS RECORD(
        fund_cd VARCHAR2(50),
        fund_desc VARCHAR2(200)
    );
    
    TYPE fund_cd_lov_tab IS TABLE OF fund_cd_lov_type;
    
    FUNCTION get_fund_cd_lov
      RETURN fund_cd_lov_tab PIPELINED;
   
    TYPE branch_cd_lov_type IS RECORD(
        branch_cd VARCHAR2(50),
        branch_name VARCHAR2(200)
    );
    
    TYPE branch_cd_lov_tab IS TABLE OF branch_cd_lov_type;
    
    FUNCTION get_branch_cd_lov(
      p_fund_cd VARCHAR2,
      p_user_id VARCHAR2
    )
        RETURN branch_cd_lov_tab PIPELINED;   
        
    TYPE acc_dv_status_type IS RECORD(
        dv_date          giac_disb_vouchers.dv_date%TYPE,
        dv_pref        giac_disb_vouchers.dv_pref%TYPE,
        dv_no          giac_disb_vouchers.dv_no%TYPE,
        chk_date         giac_chk_disbursement.check_date%TYPE,
        req_no         VARCHAR2(100),
        check_pref_suf   giac_chk_disbursement.check_pref_suf%TYPE,
        check_no           giac_chk_disbursement.check_no%TYPE,
        status           cg_ref_codes.rv_meaning%TYPE,
        payee            giac_disb_vouchers.payee%TYPE,
        particulars      giac_disb_vouchers.particulars%TYPE,
        user_id          giac_disb_vouchers.user_id%TYPE,
        last_update      VARCHAR2(250),
        gacc_tran_id     giac_disb_vouchers.gacc_tran_id%TYPE
    );
    
    TYPE acc_dv_status_tab IS TABLE OF acc_dv_status_type;
    
    FUNCTION get_dv_status (
        p_fund_cd       giis_funds.fund_cd%TYPE,
        p_branch_cd     giac_branches.branch_cd%TYPE,
        p_dv_flag       VARCHAR2
     )
        RETURN acc_dv_status_tab PIPELINED;
        
    TYPE status_history_type IS RECORD(
      dv_flag VARCHAR2(1),
      user_id VARCHAR2(100),
      last_update VARCHAR2(250),
      rv_meaning VARCHAR2(100)
    );
    
    TYPE status_history_tab IS TABLE OF status_history_type;
    
    FUNCTION get_status_history (
      p_gacc_tran_id VARCHAR2
    )
      RETURN status_history_tab PIPELINED;
        
END;
/



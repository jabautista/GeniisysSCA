CREATE OR REPLACE PACKAGE CPI.GIACS049_PKG
AS

    TYPE company_lov_type IS RECORD(
        gibr_gfun_fund_cd   giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,     
        fund_desc           giis_funds.FUND_DESC%type
    );
    
    TYPE company_lov_tab IS TABLE OF company_lov_type;
    
    FUNCTION get_company_lov(
        p_keyword   VARCHAR2
    ) RETURN company_lov_tab PIPELINED;
    
    
    TYPE branch_lov_type IS RECORD(
        gibr_branch_cd      giac_disb_vouchers.GIBR_BRANCH_CD%type,
        branch_name         giis_issource.ISS_NAME%type
    );
    
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;
    
    FUNCTION get_branch_lov(
        p_keyword       VARCHAR2,
        p_user_id       giis_users.user_id%TYPE --steven 09.30.2014
    ) RETURN branch_lov_tab PIPELINED;
    
    
    TYPE dv_list_type IS RECORD(
        gacc_tran_id            giac_disb_vouchers.GACC_TRAN_ID%type,
        gibr_gfun_fund_cd       giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        gibr_branch_cd          giac_disb_vouchers.GIBR_BRANCH_CD%type,
        dv_pref                 giac_disb_vouchers.DV_PREF%type,
        dv_no                   giac_disb_vouchers.DV_NO%type,
        check_date              giac_chk_disbursement.CHECK_DATE%type,
        document_cd             giac_payt_requests.DOCUMENT_CD%type,
        branch_cd               giac_payt_requests.BRANCH_CD%type,
        line_cd                 giac_payt_requests.LINE_CD%type,
        doc_year                giac_payt_requests.DOC_YEAR%type,
        doc_mm                  giac_payt_requests.DOC_MM%type,
        doc_seq_no              giac_payt_requests.DOC_SEQ_NO%type,
        check_pref_suf          giac_chk_disbursement.CHECK_PREF_SUF%type,
        check_no                giac_chk_disbursement.CHECK_NO%type,
        chk_no                  VARCHAR2(16),
        payee                   giac_disb_vouchers.PAYEE%type,
        particulars             giac_disb_vouchers.PARTICULARS%type,
        user_id                 giac_chk_disbursement.USER_ID%type,
        last_update             giac_chk_disbursement.LAST_UPDATE%type,
        dsp_last_update         VARCHAR2(50),
        item_no                 giac_chk_disbursement.ITEM_NO%type --added by jeffdojello 12.16.2013
    );
    
    TYPE dv_list_tab IS TABLE OF dv_list_type;
    
    
    FUNCTION GET_DV_LIST(
        p_gibr_gfun_fund_cd     giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd        giac_disb_vouchers.GIBR_BRANCH_CD%type
    ) RETURN dv_list_tab PIPELINED;
        
    
    PROCEDURE VALIDATE_CHECK_PREF_SUF(
        p_gibr_gfun_fund_cd IN      giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      giac_disb_vouchers.GIBR_BRANCH_CD%type,      
        p_check_pref_suf    IN      giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_check_no          IN      giac_chk_disbursement.CHECK_NO%type
    );
    
    
    PROCEDURE VALIDATE_CHECK_NO(
        p_gibr_gfun_fund_cd IN      giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN      giac_disb_vouchers.GIBR_BRANCH_CD%type,      
        p_check_pref_suf    IN OUT  giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_check_no          IN OUT  giac_chk_disbursement.CHECK_NO%type,
        p_chk_no            IN      VARCHAR2
    );

    
    PROCEDURE UPDATE_CHECK_NO(
        p_gibr_gfun_fund_cd IN  giac_disb_vouchers.GIBR_GFUN_FUND_CD%type,
        p_gibr_branch_cd    IN  giac_disb_vouchers.GIBR_BRANCH_CD%type,
        p_gacc_tran_id      IN  giac_chk_disbursement.GACC_TRAN_ID%type,
        p_check_pref_suf    IN  giac_chk_disbursement.CHECK_PREF_SUF%type,
        p_item_no           IN  giac_chk_disbursement.ITEM_NO%type, --added by jeffdojello 12.16.2013
        p_check_no          IN  giac_chk_disbursement.CHECK_NO%type,
        p_chk_no            IN  VARCHAR2,
        p_msg               OUT VARCHAR2
    ) ;
    
    
    TYPE chk_no_history_type IS RECORD(
        gacc_tran_id        giac_disb_vouchers.GACC_TRAN_ID%type,
        dv_pref             giac_disb_vouchers.DV_PREF%type,
        dv_no               giac_disb_vouchers.DV_NO%type,
        old_check_pref      giac_check_no_hist.OLD_CHECK_PREF%type,
        old_check_no        giac_check_no_hist.OLD_CHECK_NO%type,
        new_check_pref      giac_check_no_hist.NEW_CHECK_PREF%type,
        new_check_no        giac_check_no_hist.NEW_CHECK_NO%type,
        user_id             giac_check_no_hist.USER_ID%type,
        last_update         giac_check_no_hist.LAST_UPDATE%type,
        dsp_last_update     VARCHAR2(50)
    );
    
    TYPE chk_no_history_tab IS TABLE OF chk_no_history_type;
    
    
    FUNCTION GET_CHECK_NO_HISTORY(
        p_gacc_tran_id      GIAC_CHECK_NO_HIST.GACC_TRAN_ID%TYPE
    ) RETURN chk_no_history_tab PIPELINED;
    
END GIACS049_PKG;
/



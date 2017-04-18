CREATE OR REPLACE PACKAGE CPI.GIACS070_PKG  
AS  
    FUNCTION when_new_form_instance
        RETURN VARCHAR2;
        
    /*Modified by pjsantos 12/01/2016, for optimization GENQA 5868*/    
    TYPE journal_entries_type IS RECORD(
        count_              NUMBER,
        rownum_             NUMBER,
        tran_id             GIAC_ACCTRANS.TRAN_ID%type,
        gfun_fund_cd        GIAC_ACCTRANS.GFUN_FUND_CD%type,
        fund_desc           GIIS_FUNDS.FUND_DESC%type,
        grac_rac_cd         GIIS_FUNDS.GRAC_RAC_CD%type,
        gibr_branch_cd      GIAC_ACCTRANS.GIBR_BRANCH_CD%type,
        branch_name         GIAC_BRANCHES.BRANCH_NAME%type,
        tran_year           GIAC_ACCTRANS.TRAN_YEAR%type,
        tran_month          GIAC_ACCTRANS.TRAN_MONTH%type,
        tran_seq_no         GIAC_ACCTRANS.TRAN_SEQ_NO%type,
        tran_date           GIAC_ACCTRANS.TRAN_DATE%type,
        tran_class          GIAC_ACCTRANS.TRAN_CLASS%type,
        tran_class_no       GIAC_ACCTRANS.TRAN_CLASS_NO%type,
        mean_tran_class     CG_REF_CODES.RV_MEANING%type,
        posting_date        GIAC_ACCTRANS.POSTING_DATE%type,
        tran_flag           GIAC_ACCTRANS.TRAN_FLAG%type,
        mean_tran_flag      CG_REF_CODES.RV_MEANING%type,
        jv_no               GIAC_ACCTRANS.JV_NO%type,
        jv_pref_suff        GIAC_ACCTRANS.JV_PREF_SUFF%type,
        particulars         GIAC_ACCTRANS.PARTICULARS%type,
        user_id             GIAC_ACCTRANS.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE journal_entries_tab IS TABLE OF journal_entries_type;
    
    
    PROCEDURE CHK_GACC_GACC_GIBR_FK(
        p_field_level       IN  BOOLEAN,
        p_gibr_branch_cd    IN  GIAC_ACCTRANS.GIBR_BRANCH_CD%type,
        p_fund_desc         OUT GIIS_FUNDS.FUND_DESC%type,
        p_grac_rac_cd       OUT GIIS_FUNDS.GRAC_RAC_CD%type,
        p_branch_name       OUT GIAC_BRANCHES.BRANCH_NAME%type
    );
    
    
    FUNCTION get_journal_entries_list(
        p_gfun_fund_cd      GIAC_ACCTRANS.GFUN_FUND_CD%type,
        p_gibr_branch_cd    GIAC_ACCTRANS.GIBR_BRANCH_CD%type,
        p_user_id           VARCHAR2, 
        p_tran_yy           VARCHAR2,
        p_tran_mm           VARCHAR2,
        p_tran_seq_no       VARCHAR2, 
        p_str_tran_date     VARCHAR2, 
        p_posting_date      VARCHAR2,
        p_tran_class        VARCHAR2,
        p_tran_flag         VARCHAR2,
        p_order_by          VARCHAR2,      
        p_asc_desc_flag     VARCHAR2,      
        p_first_row         NUMBER,        
        p_last_row          NUMBER
    ) RETURN journal_entries_tab PIPELINED;
    --pjsantos end
    
    FUNCTION chk_payt_req_dtl(
        p_tran_id   GIAC_ACCTRANS.TRAN_ID%type 
    ) RETURN NUMBER;
    
    
    PROCEDURE get_payt_request_menu(
        p_tran_id       IN      GIAC_ACCTRANS.TRAN_ID%type,
        p_payt_req_menu OUT     VARCHAR2,
        p_document_cd   OUT     VARCHAR2,
        p_cancel_req    OUT     VARCHAR2
    );
    
    
    PROCEDURE get_dv_info( 
        p_tran_id       IN      GIAC_ACCTRANS.TRAN_ID%type,
        p_gacc_tran_id  OUT     GIAC_ACCTRANS.TRAN_ID%type,
        p_dv_tag        OUT     VARCHAR2,
        p_cancel_dv     OUT     VARCHAR2,
        p_formcall      OUT     VARCHAR2,
        p_gprq_ref_id   OUT     giac_payt_requests_dtl.GPRQ_REF_ID%type,
        p_payt_req_menu OUT     VARCHAR2,
        p_document_cd   OUT     VARCHAR2,
        p_cancel_req    OUT     VARCHAR2
    );
    

END GIACS070_PKG;
/



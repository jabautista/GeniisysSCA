CREATE OR REPLACE PACKAGE CPI.GIACS038_PKG
AS

    TYPE fund_lov_type IS RECORD (
        fund_cd         giis_funds.fund_cd%TYPE,
        fund_desc       giis_funds.fund_desc%TYPE
    );

    TYPE fund_lov_tab IS TABLE OF fund_lov_type;
    
    
    TYPE branch_lov_type IS RECORD(
        branch_cd       giac_branches.branch_cd%TYPE,
        branch_name     giac_branches.branch_name%TYPE
    );
    
    
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;
    
    
    TYPE rec_type IS RECORD(
        fund_cd             GIAC_TRAN_MM.FUND_CD%type,
        branch_cd           GIAC_TRAN_MM.BRANCH_CD%type,
        tran_yr             GIAC_TRAN_MM.TRAN_YR%type,
        tran_mm             GIAC_TRAN_MM.TRAN_MM%type,
        dsp_month           VARCHAR2(30),
        closed_tag          GIAC_TRAN_MM.CLOSED_TAG%type,
        dsp_closed          VARCHAR2(30),
        clm_closed_tag      GIAC_TRAN_MM.CLM_CLOSED_TAG%type,
        update_cct          VARCHAR2(1),
        update_ct           VARCHAR2(1),
        chk_tc              VARCHAR2(1),
        chk_cct             VARCHAR2(1),
        remarks             GIAC_TRAN_MM.REMARKS%type,
        user_id             GIAC_TRAN_MM.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    
    FUNCTION get_fund_lov
        RETURN fund_lov_tab PIPELINED;
    
    
    FUNCTION get_branch_lov(
        p_fund_cd       GIIS_FUNDS.fund_cd%TYPE,
        p_user_id       GIAC_BRANCHES.user_id%TYPE
    ) RETURN branch_lov_tab PIPELINED;
    
    
    FUNCTION get_rec_list(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type
    ) RETURN rec_tab PIPELINED;
    
    
    FUNCTION check_function(
        p_user              VARCHAR2,   --user 
        p_module            VARCHAR2,   --module name
        p_function_code     VARCHAR2    --function code
    ) RETURN VARCHAR2;

    
    FUNCTION get_next_tran_yr(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type
    ) RETURN NUMBER;
    
    
    PROCEDURE generate_tran_mm(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_user_id       GIAC_TRAN_MM.USER_ID%type
    );
    
    
    TYPE tranmm_hist_type IS RECORD(
        closed_tag      GIAC_TRANMM_STAT_HIST.CLOSED_TAG%type,
        rv_meaning      CG_REF_CODES.RV_MEANING%type,
        user_id         GIAC_TRANMM_STAT_HIST.USER_ID%type,
        last_update     VARCHAR2(30)
    );
    
    TYPE tranmm_hist_tab IS TABLE OF tranmm_hist_type;
    
    
    FUNCTION get_tranmm_stat_hist(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_tran_mm       GIAC_TRAN_MM.TRAN_MM%type
    ) RETURN tranmm_hist_tab PIPELINED;
    
    
    TYPE clm_tranmm_hist_type IS RECORD(
        clm_closed_tag  GIAC_CLM_TRANMM_STAT_HIST.CLM_CLOSED_TAG%type,
        rv_meaning      CG_REF_CODES.RV_MEANING%type,
        user_id         GIAC_CLM_TRANMM_STAT_HIST.USER_ID%type,
        last_update     VARCHAR2(30)
    );
    
    TYPE clm_tranmm_hist_tab IS TABLE OF clm_tranmm_hist_type;
    
    
    FUNCTION get_clm_tranmm_stat_hist(
        p_fund_cd       GIAC_TRAN_MM.FUND_CD%type,
        p_branch_cd     GIAC_TRAN_MM.BRANCH_CD%type,
        p_tran_yr       GIAC_TRAN_MM.TRAN_YR%type,
        p_tran_mm       GIAC_TRAN_MM.TRAN_MM%type
    ) RETURN clm_tranmm_hist_tab PIPELINED;


    PROCEDURE update_rec (
        p_rec           GIAC_TRAN_MM%ROWTYPE,
        p_update_cct    VARCHAR2,
        p_update_ct     VARCHAR2
    );
    
    
END GIACS038_PKG;
/



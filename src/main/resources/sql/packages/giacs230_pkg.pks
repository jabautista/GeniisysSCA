CREATE OR REPLACE PACKAGE CPI.GIACS230_PKG
AS

    TYPE gl_transaction_list_type IS RECORD(
        gl_acct_id          GIAC_GL_INQUIRY_V.GL_ACCT_ID%type,
        tran_no             GIAC_GL_INQUIRY_V.TRAN_NO%type,
        tran_class          GIAC_GL_INQUIRY_V.TRAN_CLASS%type,
        ref_no              GIAC_GL_INQUIRY_V.REF_NO%type,
        tran_flag           GIAC_GL_INQUIRY_V.TRAN_FLAG%type,
        tran_date           GIAC_GL_INQUIRY_V.TRAN_DATE%type,
        dt_posted           GIAC_GL_INQUIRY_V.DT_POSTED%type,
        debit_amt           GIAC_GL_INQUIRY_V.DEBIT_AMT%type,
        credit_amt          GIAC_GL_INQUIRY_V.CREDIT_AMT%type,
        sl_cd               GIAC_GL_INQUIRY_V.SL_CD%type,
        sl_type_cd          GIAC_GL_INQUIRY_V.SL_TYPE_CD%type,
        sl_source_cd        GIAC_GL_INQUIRY_V.SL_SOURCE_CD%type,
        sl_name             giac_sl_name_v.SL_NAME%TYPE, --VARCHAR2(160),
        gacc_tran_id        GIAC_GL_INQUIRY_V.GACC_TRAN_ID%type,
        fund_cd             GIAC_GL_INQUIRY_V.FUND_CD%type,
        branch_cd           GIAC_GL_INQUIRY_V.BRANCH_CD%type,
        remarks             GIAC_GL_INQUIRY_V.REMARKS%type,
        user_id             GIAC_GL_INQUIRY_V.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE gl_transaction_list_tab IS TABLE OF gl_transaction_list_type;
    
     
    FUNCTION get_gl_acct_tran_list(
        p_gl_acct_id        giac_chart_of_accts.GL_ACCT_ID%type,
        p_gl_acct_type      VARCHAR2,
        p_gl_acct_cat       giac_chart_of_accts.GL_ACCT_CATEGORY%type,
        p_gl_ctrl_acct      giac_chart_of_accts.GL_CONTROL_ACCT%type,
        p_gfun_fund_cd      GIAC_BRANCHES.GFUN_FUND_CD%type,
        p_branch_cd         GIAC_BRANCHES.BRANCH_CD%type,
        p_dt_basis          NUMBER,
        p_from_date         DATE,
        p_to_date           DATE,
        p_tran_open_flag    VARCHAR2,
        p_module_id         GIIS_MODULES.module_id%TYPE,
        p_user              GIIS_USERS.USER_ID%type
    ) RETURN gl_transaction_list_tab PIPELINED;
    
    
    FUNCTION get_sl_summary(
        p_gacc_tran_id  GIAC_GL_INQUIRY_V.GACC_TRAN_ID%type,
        p_fund_cd       GIAC_GL_INQUIRY_V.FUND_CD%type,
        p_branch_cd     GIAC_GL_INQUIRY_V.BRANCH_CD%type,
        p_sl_cd         GIAC_GL_INQUIRY_V.SL_CD%type,
        p_debit_amt     GIAC_GL_INQUIRY_V.DEBIT_AMT%type,
        p_credit_amt    GIAC_GL_INQUIRY_V.CREDIT_AMT%type
    ) RETURN gl_transaction_list_tab PIPELINED;

END GIACS230_PKG;
/



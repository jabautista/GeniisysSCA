CREATE OR REPLACE PACKAGE CPI.GIACS087_PKG
AS
  --Modified by pjsantos 11/8/2016 for optimization,added count_ and rownum_ GENQA 5817
    TYPE main_type IS RECORD (
        count_            NUMBER, 
        rownum_           NUMBER,
        batch_dv_id       giac_batch_dv.batch_dv_id%TYPE,
        fund_cd           giac_batch_dv.fund_cd%TYPE,
        branch_cd         giac_batch_dv.branch_cd%TYPE,
        batch_year        giac_batch_dv.batch_year%TYPE,
        batch_mm          giac_batch_dv.batch_mm%TYPE,
        batch_seq_no      giac_batch_dv.batch_seq_no%TYPE,
        batch_date        giac_batch_dv.BATCH_DATE%type,
        batch_flag        giac_batch_dv.batch_flag%TYPE,
        payee_class_cd    giac_batch_dv.payee_class_cd%TYPE,
        payee_cd          giac_batch_dv.payee_cd%TYPE,
        dsp_payee         VARCHAR2(600), 
        particulars       giac_batch_dv.particulars%TYPE,
        tran_id           giac_batch_dv.tran_id%TYPE,
        paid_amt          giac_batch_dv.paid_amt%TYPE,
        fcurr_amt         giac_batch_dv.fcurr_amt%TYPE,
        currency_cd       giac_batch_dv.currency_cd%TYPE,
        convert_rate      giac_batch_dv.convert_rate%TYPE,
        user_id           giac_batch_dv.user_id%TYPE,
        last_update       giac_batch_dv.last_update%TYPE,
        payee_remarks     giac_batch_dv.payee_remarks%TYPE,
        dsp_ref_no        VARCHAR2(25)
    );
   
    TYPE main_tab IS TABLE OF main_type;
   
    --Modified by pjsantos 11/8/2016,added parameters for optimization GENQA 5817
    FUNCTION get_main_records(  p_filter_dsp_ref_no     VARCHAR2,
                                p_filter_fund_cd        VARCHAR2,
                                p_filter_branch_cd      VARCHAR2,
                                p_filter_batch_year     VARCHAR2,
                                p_filter_batch_mm       VARCHAR2,
                                p_filter_batch_seq_no   VARCHAR2,
                                p_filter_batch_date     VARCHAR2,
                                p_filter_payee_cd       VARCHAR2,
                                p_filter_payee_class_cd VARCHAR2,
                                p_filter_dsp_payee      VARCHAR2,
                                p_filter_batch_flag     VARCHAR2,
                                p_order_by              VARCHAR2,      
                                p_asc_desc_flag         VARCHAR2,      
                                p_first_row             NUMBER,        
                                p_last_row              NUMBER)   
        RETURN main_tab PIPELINED;
        
    
    TYPE batch_details_type IS RECORD(
        batch_dv_id         giac_batch_dv.BATCH_DV_ID%type,
        chk_gen             VARCHAR2(1),
        line_cd             gicl_advice.LINE_CD%type,
        iss_cd              gicl_advice.ISS_CD%type,
        advice_id           gicl_advice.ADVICE_ID%type,
        advice_year         gicl_advice.ADVICE_YEAR%type,
        advice_seq_no       gicl_advice.ADVICE_SEQ_NO%type,
        nbt_clm_line_cd     gicl_claims.LINE_CD%type,
        nbt_clm_subline_cd  gicl_claims.SUBLINE_CD%type,
        nbt_clm_iss_cd      gicl_claims.ISS_CD%type,
        nbt_clm_clm_yy      gicl_claims.CLM_YY%type,
        nbt_clm_clm_seq_no  gicl_claims.CLM_SEQ_NO%type,
        nbt_pol_line_cd     gicl_claims.LINE_CD%type,
        nbt_pol_subline_cd  gicl_claims.SUBLINE_CD%type,
        nbt_pol_pol_iss_cd  gicl_claims.ISS_CD%type,
        nbt_pol_issue_yy    gicl_claims.ISSUE_YY%type,
        nbt_pol_pol_seq_no  gicl_claims.POL_SEQ_NO%type,
        nbt_pol_renew_no    gicl_claims.RENEW_NO%type,
        nbt_assd_no         gicl_claims.ASSD_NO%type,
        nbt_assd_name       gicl_claims.ASSURED_NAME%type,
        nbt_dsp_loss_date   gicl_claims.DSP_LOSS_DATE%type,
        advice_flag         gicl_advice.ADVICE_FLAG%type,
        paid_amt2           gicl_advice.PAID_AMT%type,
        nbt_paid_amt        gicl_advice.PAID_AMT%type,
        paid_fcurr_amt      gicl_advice.PAID_FCURR_AMT%type,
        nbt_paid_fcurr_amt  gicl_advice.PAID_FCURR_AMT%type,
        currency_cd         gicl_advice.CURRENCY_CD%type,
        convert_rate        gicl_advice.CONVERT_RATE%type,
        claim_id            gicl_advice.CLAIM_ID%type,
        apprvd_tag          gicl_advice.APPRVD_TAG%type,
        payee_remarks       gicl_advice.PAYEE_REMARKS%type,
        clm_stat_cd         gicl_claims.CLM_STAT_CD%type,
        nbt_clm_stat_desc   giis_clm_stat.CLM_STAT_DESC%type,
        clm_loss_id         gicl_clm_loss_exp.CLM_LOSS_ID%type,
        payee_class_cd      gicl_clm_loss_exp.PAYEE_CLASS_CD%type,
        payee_cd            gicl_clm_loss_exp.PAYEE_CD%type,
        nbt_payee           VARCHAR2(600),
        payee_type          gicl_clm_loss_exp.PAYEE_TYPE%type,
        paid_amt            gicl_clm_loss_exp.PAID_AMT%type,
        net_amt             gicl_clm_loss_exp.NET_AMT%type,
        loss_curr_cd        gicl_clm_loss_exp.CURRENCY_CD%type,
        user_id             gicl_advice.USER_ID%type,
        last_update         gicl_advice.LAST_UPDATE%type        
    );
    
    TYPE batch_details_tab IS TABLE OF batch_details_type;
    
    FUNCTION get_batch_details(
        p_batch_dv_id       giac_batch_dv.BATCH_DV_ID%type
    ) RETURN batch_details_tab PIPELINED;
    
    
    TYPE acct_entries_type IS RECORD(
        batch_dv_id         giac_batch_dv.BATCH_DV_ID%type,
        tran_id             giac_batch_dv.TRAN_ID%type,
        branch_cd           giac_batch_dv.BRANCH_CD%type,
        ref_no              VARCHAR2(50),        
        particulars         giac_batch_dv.PARTICULARS%type
    );
    
    TYPE acct_entries_tab IS TABLE OF acct_entries_type;
    
    FUNCTION get_acct_entries(
        p_batch_dv_id       giac_batch_dv.BATCH_DV_ID%type
    ) RETURN acct_entries_tab PIPELINED;
    
    
    TYPE acct_entries_dtl_type IS RECORD(        
        gacc_tran_id        giac_acct_entries.GACC_TRAN_ID%type,
        gacc_gfun_fund_cd   giac_acct_entries.GACC_GFUN_FUND_CD%type,
        gacc_gibr_branch_cd giac_acct_entries.GACC_GIBR_BRANCH_CD%type,
        acct_entry_id       giac_acct_entries.ACCT_ENTRY_ID%type,
        gl_acct_id          giac_acct_entries.GL_ACCT_ID%type,
        gl_acct_category    giac_acct_entries.GL_ACCT_CATEGORY%type,
        gl_control_acct     giac_acct_entries.GL_CONTROL_ACCT%type,
        gl_sub_acct_1       giac_acct_entries.GL_SUB_ACCT_1%type,
        gl_sub_acct_2       giac_acct_entries.GL_SUB_ACCT_2%type,
        gl_sub_acct_3       giac_acct_entries.GL_SUB_ACCT_3%type,
        gl_sub_acct_4       giac_acct_entries.GL_SUB_ACCT_4%type,
        gl_sub_acct_5       giac_acct_entries.GL_SUB_ACCT_5%type,
        gl_sub_acct_6       giac_acct_entries.GL_SUB_ACCT_6%type,
        gl_sub_acct_7       giac_acct_entries.GL_SUB_ACCT_7%type,
        gl_acct_no          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.GL_ACCT_NAME%type,
        sl_cd               giac_acct_entries.SL_CD%type,
        debit_amt           giac_acct_entries.DEBIT_AMT%type,
        credit_amt          giac_acct_entries.CREDIT_AMT%type
    );
    
    TYPE acct_entries_dtl_tab IS TABLE OF acct_entries_dtl_type;
    
    FUNCTION get_acct_entries_dtl(
        p_tran_id       giac_batch_dv.TRAN_ID%type
    ) RETURN acct_entries_dtl_tab PIPELINED;
    
END GIACS087_PKG;
/



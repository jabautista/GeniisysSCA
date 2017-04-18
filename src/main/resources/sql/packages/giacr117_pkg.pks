CREATE OR REPLACE PACKAGE CPI.giacr117_PKG
AS
    TYPE giacr117_cash_receipt_reg_type IS RECORD (
        --margin
         --formula columns
        company_name            VARCHAR2(100) := '',
        company_address         GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_tin       		  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
        gen_version				  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
        rundate                 VARCHAR2(20),
        posting_tran            VARCHAR2(70) := '',
        top_date                VARCHAR2(70) := '',
         --Q1
        gibr_branch_cd          GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
        branch_name             GIAC_BRANCHES.BRANCH_NAME%TYPE,
        or_no                   VARCHAR2(70) := '',
        tran_id                 GIAC_ACCTRANS.TRAN_ID%TYPE,
        dcb_no                  GIAC_ORDER_OF_PAYTS.DCB_NO%TYPE,
        or_date                 VARCHAR2(20),
        posting_date            VARCHAR2(20),
        intm_no                 VARCHAR2(50),
        payor                   GIAC_ORDER_OF_PAYTS.PAYOR%TYPE,
        tin                     GIAC_ORDER_OF_PAYTS.TIN%TYPE,
        collection_amt          GIAC_ORDER_OF_PAYTS.COLLECTION_AMT%TYPE,
        particulars             GIAC_ACCTRANS.PARTICULARS%TYPE,
        gl_account              VARCHAR2(72) := '',
        gl_acct_name            GIAC_CHART_OF_ACCTS.GL_ACCT_NAME%TYPE,
        sl_cd                   GIAC_ACCT_ENTRIES.SL_CD%TYPE ,
        debit_amt               GIAC_ACCT_ENTRIES.DEBIT_AMT%TYPE,
        credit_amt              GIAC_ACCT_ENTRIES.CREDIT_AMT%TYPE,
        
        --summary fields
         ---per payor
        --r_db                    NUMBER(12,2) := 0,
        --r_cd                    NUMBER(12,2) := 0,
                
         ---per branch
        --branch_db               NUMBER(12,2) := 0,
        --branch_cd               NUMBER(12,2) := 0,
        dist_or_tran_id         NUMBER(12)   := 0,
        branch_collection_amt   NUMBER(12,2) := 0,
        or_vat_amt              NUMBER(12,2) := 0,
        or_nonvat_amt           NUMBER(12,2) := 0,
        
        prev_payor_value        GIAC_ORDER_OF_PAYTS.PAYOR%TYPE,
        print_details           VARCHAR2(1),                     --added by shan 12.10.2013
        tran_flag               giac_acctrans.tran_flag%TYPE, -- Added by Jerome Bautista 03.09.2016 SR 21536    
        or_flag                 giac_order_of_payts.or_flag%TYPE -- Added by Jerome Bautista 03.09.2016 SR 21536        
    );

    TYPE giacr117_cash_receipt_reg_tab IS TABLE OF giacr117_cash_receipt_reg_type;
    
    
    TYPE giacr117_cr_reg_smmary_type IS RECORD (        
         ---grand total
        smmary_gfun_fund_cd     GIAC_ACCTRANS.GFUN_FUND_CD%TYPE,
        smmary_branch_cd        GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE, 
        smmary_branch_name      GIAC_BRANCHES.BRANCH_NAME%TYPE,
        smmary_gl_acct_no       VARCHAR2(72) := '',
        smmary_gl_acct_name     GIAC_CHART_OF_ACCTS.GL_ACCT_NAME%TYPE,
        smmary_db_amt           NUMBER(12,2) := 0,
        smmary_cd_amt           NUMBER(12,2) := 0,
        smmary_bal_amt          NUMBER(12,2) := 0
        /*smmary_total_db_amt     NUMBER(12,2) := 0,
        smmary_total_cd_amt     NUMBER(12,2) := 0,
        smmary_total_bal_amt    NUMBER(12,2) := 0,
        smmary_grand_db_amt     NUMBER(12,2) := 0,
        smmary_grand_cd_amt     NUMBER(12,2) := 0,
        smmary_grand_bal_amt    NUMBER(12,2) := 0   */  
    );
    
    TYPE giacr117_cr_reg_smmary_tab IS TABLE OF giacr117_cr_reg_smmary_type;
    
     
    FUNCTION get_cr_reg_details (
        p_date                  DATE,
        p_date2                 DATE,
        p_post_tran_toggle      VARCHAR2,
        --p_fund                  VARCHAR2,
        p_branch                GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
        p_tran_class            VARCHAR2,
        p_per_branch            VARCHAR2,
        p_user_id               VARCHAR2
        --p_module_id             GIIS_MODULES_TRAN.MODULE_ID%TYPE
    )
        RETURN giacr117_cash_receipt_reg_tab PIPELINED;
    
    FUNCTION get_cr_reg_dets_smmary (
        p_date                  DATE,
        p_date2                 DATE,
        p_post_tran_toggle      VARCHAR2,
        p_branch                GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
       -- p_module_id             GIIS_MODULES_TRAN.MODULE_ID%TYPE,
        p_per_branch            VARCHAR2,
        p_user_id               VARCHAR2
    )
        RETURN giacr117_cr_reg_smmary_tab PIPELINED;
    
END;
/



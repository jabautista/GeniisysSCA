CREATE OR REPLACE PACKAGE CPI.GIACS231_PKG AS

    TYPE actg_list_transaction_status IS RECORD (
        tran_id             GIAC_ACCTRANS.tran_id%TYPE,
        tran_class          GIAC_ACCTRANS.tran_class%TYPE,
        tran_class_desc     VARCHAR2(100),
        tran_no             VARCHAR2(50),
		tran_date           VARCHAR2(50),
		posting_date        GIAC_ACCTRANS.posting_date%TYPE,
        ref_no              VARCHAR2(50),
		tran_flag           VARCHAR2(10),
		particulars         GIAC_ACCTRANS.particulars%TYPE,
		user_id             GIAC_ACCTRANS.user_id%TYPE,
		last_update         VARCHAR2(50),
        rv_low_value        CG_REF_CODES.rv_low_value%TYPE,
        hist_tran_flag      GIAC_TRAN_STAT_HIST.tran_flag%TYPE,
        hist_rv_meaning     CG_REF_CODES.rv_meaning%TYPE,
        hist_user_id        GIAC_TRAN_STAT_HIST.user_id%TYPE,
        hist_last_update    VARCHAR2(100)
        
    );	
    TYPE actg_list_transaction_tab IS TABLE OF actg_list_transaction_status;

    TYPE branch_lov_type IS RECORD( 
        branch_cd		    VARCHAR2(3),
        branch_name		    GIAC_BRANCHES.branch_name%TYPE
    );
    TYPE branch_lov_tab IS TABLE OF branch_lov_type;

    TYPE tran_status_lov_type IS RECORD( 
        rv_low_value		CG_REF_CODES.rv_low_value%TYPE,
        rv_meaning		    CG_REF_CODES.rv_meaning%TYPE
    );
    TYPE tran_status_lov_tab IS TABLE OF tran_status_lov_type;     
         
    FUNCTION get_actg_transaction_status (
        p_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE,
	    p_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
	    p_tran_flag   GIAC_ACCTRANS.tran_flag%TYPE,
        p_user_id     GIIS_USERS.user_id%TYPE
    ) 
    RETURN actg_list_transaction_tab PIPELINED;
    
    FUNCTION get_tran_stat_hist(
         p_tran_id          GIAC_ACCTRANS.tran_id%TYPE   
    )
    RETURN actg_list_transaction_tab PIPELINED;
    
    FUNCTION get_all_branch( 
        p_module_id     GIIS_MODULES.module_id%TYPE,
        p_branch        GIAC_BRANCHES.branch_name%TYPE,
        p_gfun_fund_cd 	GIAC_ACCTRANS.gfun_fund_cd%TYPE,
        p_user_id       GIIS_USERS.user_id%TYPE)
    RETURN branch_lov_tab PIPELINED;

    FUNCTION get_all_tran_class(
        p_class             CG_REF_CODES.RV_MEANING%TYPE)
    RETURN tran_status_lov_tab PIPELINED;
  
    FUNCTION get_all_status(
        p_status            CG_REF_CODES.RV_MEANING%TYPE)
    RETURN tran_status_lov_tab PIPELINED;
	
    TYPE actg_list_transaction_status2 IS RECORD (
        count_              NUMBER,
        rownum_             NUMBER,
        tran_class          GIAC_ACCTRANS.tran_class%TYPE,
        tran_class_desc     VARCHAR2(100),
        tran_no             VARCHAR2(50),
        tran_date           GIAC_ACCTRANS.tran_date%TYPE,
        posting_date        GIAC_ACCTRANS.posting_date%TYPE,
        tran_id             GIAC_ACCTRANS.tran_id%TYPE,
        tran_flag           VARCHAR2(10),
        particulars         GIAC_ACCTRANS.particulars%TYPE,
        user_id             GIAC_ACCTRANS.user_id%TYPE,
        last_update         VARCHAR2(50),
        rv_low_value        CG_REF_CODES.rv_low_value%TYPE,
        tran_class_no       GIAC_ACCTRANS.tran_class_no%TYPE,
        ref_no              VARCHAR2(50)
    );    
    
    TYPE actg_list_transaction_tab2 IS TABLE OF actg_list_transaction_status2;
    
    FUNCTION get_actg_transaction_status2 (
          p_fund_cd     GIAC_ACCTRANS.gfun_fund_cd%TYPE,   
          p_branch_cd   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
          p_tran_flag   GIAC_ACCTRANS.tran_flag%TYPE,
          p_from        NUMBER,
          p_to          NUMBER,
          p_tran_class  GIAC_ACCTRANS.tran_class%TYPE,
          p_tran_no     VARCHAR2,
          p_tran_date   VARCHAR2,--GIAC_ACCTRANS.tran_date%TYPE,
          p_posting_date  VARCHAR2,--GIAC_ACCTRANS.posting_date%TYPE,
          p_tran_flag2  GIAC_ACCTRANS.tran_flag%TYPE,
          p_ref_no      VARCHAR2,
          p_order_by      	VARCHAR2,
          p_asc_desc_flag   VARCHAR2
    ) 
        RETURN actg_list_transaction_tab2 PIPELINED;
     
END GIACS231_PKG;
/



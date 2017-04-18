CREATE OR REPLACE PACKAGE CPI.GIACS235_PKG AS
    
    TYPE acc_list_or_status_type IS RECORD (
        count_          NUMBER,      -- SR-4722 : shan 06.29.2015
        rownum_         NUMBER,      -- SR-4722 : shan 06.29.2015
        dcb_no          giac_order_of_payts.dcb_no%TYPE,
        payor           giac_order_of_payts.payor%TYPE,
		particulars     giac_order_of_payts.particulars%TYPE,
		user_id         giac_order_of_payts.user_id%TYPE,
        rv_meaning      cg_ref_codes.rv_meaning%TYPE,
        tran_id         giac_order_of_payts.gacc_tran_id%TYPE,
        or_no           VARCHAR2 (50),
        cashier_cd      VARCHAR2 (50),
        or_date         VARCHAR2 (100),
        last_update     VARCHAR(100),
        or_pref         giac_order_of_payts.or_pref_suf%TYPE,
        or_pref_no      giac_order_of_payts.or_no%TYPE,
        rv_low_value    cg_ref_codes.rv_low_value%TYPE
    );
    
    TYPE acc_list_or_status_tab IS TABLE OF acc_list_or_status_type;
    
    TYPE acc_list_or_history_type IS RECORD (
        or_flag         giac_or_stat_hist.or_flag%TYPE,
		user_id         giac_or_stat_hist.user_id%TYPE,
        rv_meaning      cg_ref_codes.rv_meaning%TYPE,
        last_update     VARCHAR(100)
    );
    
    TYPE acc_list_or_history_tab IS TABLE OF acc_list_or_history_type;
    
     TYPE all_or_status_type IS RECORD( 
        rv_meaning		    CG_REF_CODES.rv_meaning%TYPE,
        rv_low_value		CG_REF_CODES.rv_low_value%TYPE
    );
  
    TYPE all_or_status_tab IS TABLE OF all_or_status_type;
    
    FUNCTION get_list_or_status(
		P_FUND_CD       giis_funds.fund_cd%TYPE,
		P_BRANCH_CD     giac_branches.branch_cd%TYPE,
		P_STATUS        giac_order_of_payts.or_flag%TYPE,
        P_OR_DATE       VARCHAR2,
        P_DCB_NO        giac_order_of_payts.DCB_NO%TYPE,        -- start SR-4722 : shan 06.29.2015
        P_OR_NO         VARCHAR2,
        P_PAYOR         giac_order_of_payts.PAYOR%TYPE,
        P_PARTICULARS   giac_order_of_payts.PARTICULARS%TYPE,   -- carlo 8/12/2015 SR19275
        P_CASHIER       VARCHAR2,
        P_RV_MEANING    cg_ref_codes.RV_MEANING%TYPE,
        p_order_by      VARCHAR2,
        p_asc_desc_flag VARCHAR2,
        p_row_from      NUMBER,
        p_row_to        NUMBER,                                 -- end SR-4722 : shan 06.29.2015
        p_user_id       giac_order_of_payts.user_id%TYPE DEFAULT NULL        --added by MarkS SR5694 10.26.2016 optimization 
	)RETURN acc_list_or_status_tab PIPELINED;
    
    FUNCTION get_list_or_history(
		P_TRAN_ID       giac_or_stat_hist.gacc_tran_id%TYPE
	)RETURN acc_list_or_history_tab PIPELINED;
    
    FUNCTION get_all_or_status(
        P_STATUS        cg_ref_codes.rv_meaning%TYPE
    )RETURN all_or_status_tab PIPELINED;
    
END;
/

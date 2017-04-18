CREATE OR REPLACE PACKAGE CPI.GIACS236_PKG AS
   
    TYPE acc_payt_req_status_type IS RECORD (
        ------------ 
        --added by Mark SR-5859 11.25.2016 optimization
        count_                NUMBER,
        rownum_               NUMBER,
        ------------
        fund_cd         GIIS_FUNDS.fund_cd%TYPE,
        request_date    VARCHAR2(50),
        request_no      VARCHAR2(100),
        department      VARCHAR2(200),
        rv_meaning      CG_REF_CODES.rv_meaning%TYPE,
        tran_id         GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE,
        payee           GIAC_PAYT_REQUESTS_DTL.payee%TYPE,    
        particulars     GIAC_PAYT_REQUESTS_DTL.particulars%TYPE,
        user_id         GIAC_PAYT_REQUESTS_DTL.user_id%TYPE,
        last_update     VARCHAR(100),
        status_flag     GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,
        document_cd     GIAC_PAYT_REQUESTS.document_cd%TYPE,
        ref_id          GIAC_PAYT_REQUESTS.ref_id%TYPE
    );
    
    TYPE acc_payt_req_status_tab IS TABLE OF acc_payt_req_status_type;
    
    TYPE acc_payt_req_hist_type IS RECORD (
        tran_id         GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE,
        payt_req_flag   GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,
        rv_meaning      CG_REF_CODES.rv_meaning%TYPE,
        user_id         GIAC_PAYT_REQUESTS_DTL.user_id%TYPE,
        last_update     VARCHAR(100)
    );
    
    TYPE acc_payt_req_hist_tab IS TABLE OF acc_payt_req_hist_type;
    
    FUNCTION get_payt_req_status (
        p_fund_cd       GIIS_FUNDS.fund_cd%TYPE,
        p_branch_cd     GIAC_BRANCHES.branch_cd%TYPE,
        p_status        GIAC_PAYT_REQUESTS_DTL.payt_req_flag%TYPE,
        --------------
        --added by Mark SR-5859 11.25.2016 optimization
        p_filt_reqdate          VARCHAR2,
        p_filt_reqno            VARCHAR2,
        p_filt_dept             VARCHAR2,  
        p_filt_rvmeaning        VARCHAR2,
        p_order_by              VARCHAR2,
        p_asc_desc_flag         VARCHAR2,
        p_from                  NUMBER,
        p_to                    NUMBER
        --------------
     )
        RETURN acc_payt_req_status_tab PIPELINED;

    FUNCTION get_payt_req_hist(
         p_tran_id          GIAC_PAYT_REQUESTS_DTL.tran_id%TYPE   
    )
    RETURN acc_payt_req_hist_tab PIPELINED;  
END;
/

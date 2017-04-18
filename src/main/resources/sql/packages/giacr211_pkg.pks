CREATE OR REPLACE PACKAGE CPI.GIACR211_PKG
AS  
    TYPE report_detail_type IS RECORD(
        tran_id                 GIAC_ACCTRANS.tran_id%TYPE,
        gibr_branch_cd          GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        tran_date               GIAC_ACCTRANS.tran_date%TYPE,
        or_no                   VARCHAR2(50),
        particulars             GIAC_ACCTRANS.particulars%TYPE,
        collection_amt          GIAC_ORDER_OF_PAYTS.collection_amt%TYPE,
        posting_date            GIAC_ACCTRANS.posting_date%TYPE,
        tran_flag               GIAC_ACCTRANS.tran_flag%TYPE,
        company_name            VARCHAR2(100),
        company_add             VARCHAR2(500),
        header_tran_flag        CG_REF_CODES.rv_meaning%TYPE,
        header_tran_class       CG_REF_CODES.rv_meaning%TYPE,
        header_from_date        VARCHAR2(50),
        header_to_date          VARCHAR2(50),
        ref_no                  VARCHAR2(200),
        codes                   VARCHAR2(1000),
        show_hide_col_amt       VARCHAR2(10),
        show_hide_posting_date  VARCHAR2(10),
        show_hide_status        VARCHAR2(10),
        dummy                   VARCHAR2(1)
    );
    TYPE report_detail_tab IS TABLE OF report_detail_type;
    
    FUNCTION get_report_detail(
        p_tran_class            GIAC_ACCTRANS.tran_class%TYPE,
        p_tran_flag             GIAC_ACCTRANS.tran_flag%TYPE,
        p_branch_cd             GIAC_ACCTRANS.gibr_branch_cd%TYPE,
        p_from_date             DATE,
        p_to_date               DATE,
        p_user_id               GIIS_USERS.user_id%TYPE
    )
        RETURN report_detail_tab PIPELINED;
                   
END GIACR211_PKG;
/



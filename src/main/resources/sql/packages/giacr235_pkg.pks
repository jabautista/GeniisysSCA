CREATE OR REPLACE PACKAGE CPI.GIACR235_PKG
AS
     TYPE get_details_type IS RECORD(
        rv_meaning          cg_ref_codes.rv_meaning%TYPE,
        or_no               VARCHAR2(100),
        or_date             VARCHAR2(50),
        cashier_cd          giac_order_of_payts.cashier_cd%TYPE,
        payor               giac_order_of_payts.payor%TYPE,
        particulars         giac_acctrans.particulars%TYPE,
        amount_received     giac_order_of_payts.collection_amt%TYPE,
        iss_name            giis_issource.iss_name%TYPE,
        company_name        VARCHAR2(500),
        company_address     VARCHAR2(500),
        rep_from_date       VARCHAR2(50),
        rep_to_date         VARCHAR2(50),
        iss_cd              giis_issource.iss_cd%TYPE,
        dummy               VARCHAR2(1)
    );
    
    TYPE get_details_tab IS TABLE OF get_details_type;
    
    FUNCTION get_details(
        P_OR_FLAG           giac_order_of_payts.or_flag%TYPE,
        P_ISS_CD            giis_issource.iss_cd%TYPE,
        P_FROM_DATE         DATE,
        P_TO_DATE           DATE,
        P_TRAN_FLAG         giac_acctrans.tran_flag%TYPE,
        P_USER_ID           giis_users.user_id%TYPE
   )
    RETURN get_details_tab PIPELINED;
    
END;
/



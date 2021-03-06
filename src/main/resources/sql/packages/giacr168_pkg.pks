CREATE OR REPLACE PACKAGE CPI.GIACR168_PKG
AS
    TYPE giacr168_off_receipt_reg_type IS RECORD (
        company_name            GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        company_address         GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
        posted                  VARCHAR2(70) := '',
        top_date                VARCHAR2(70) := '',
        
        branch                  VARCHAR2(50) := '',
        or_type                 VARCHAR2(2)  := '',  
        or_no                   VARCHAR2(50) := '', 
        cancel_date             GIAC_ORDER_OF_PAYTS.CANCEL_DATE%TYPE,           
        or_date                 GIAC_ORDER_OF_PAYTS.OR_DATE%TYPE,
        tran_date               GIAC_ACCTRANS.TRAN_DATE%TYPE,
        posting_date            GIAC_ACCTRANS.POSTING_DATE%TYPE,
        
        dcb_no                  GIAC_ORDER_OF_PAYTS.DCB_NO%type,
        cancel_dcb_no           GIAC_ORDER_OF_PAYTS.CANCEL_DCB_NO%type,
        payor                   GIAC_ORDER_OF_PAYTS.PAYOR%TYPE,        
        amt_received            GIAC_COLLECTION_DTL.AMOUNT%TYPE,
        currency                GIIS_CURRENCY.SHORT_NAME%TYPE,
        foreign_curr_amt        GIAC_COLLECTION_DTL.FCURRENCY_AMT%TYPE    
    );
    
    TYPE giacr168_off_receipt_reg_tab IS TABLE OF giacr168_off_receipt_reg_type;
    
    FUNCTION get_off_receipt_reg_all_or (
        p_date          DATE,
        p_date2         DATE,
        p_branch_code   VARCHAR2,
        p_user_id       VARCHAR2
    )
        RETURN giacr168_off_receipt_reg_tab PIPELINED;



END;
/



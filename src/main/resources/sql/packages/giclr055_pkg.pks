CREATE OR REPLACE PACKAGE CPI.GICLR055_PKG AS
    
    TYPE giclr055_acct_entries_type IS RECORD (
        gl_acct_id          GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
        gl_acct             VARCHAR2(30),
        gl_acct_name        GIAC_CHART_OF_ACCTS.gl_acct_name%TYPE,
        debit_amt           GIAC_ACCT_ENTRIES.debit_amt%TYPE,
        credit_amt          GIAC_ACCT_ENTRIES.credit_amt%TYPE,
        gacc_tran_id        GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE,
        
        v_company_name      VARCHAR2(200),
        v_company_address   VARCHAR2(200)  
    );
    
    TYPE giclr055_acct_entries_tab IS TABLE OF giclr055_acct_entries_type;
    
    FUNCTION populate_giclr055 (
        p_tran_id           GIAC_ACCT_ENTRIES.gacc_tran_id%TYPE
    ) RETURN giclr055_acct_entries_tab PIPELINED;

END;
/



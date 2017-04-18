CREATE OR REPLACE PACKAGE CPI.giacr343b_pkg
AS
    TYPE outstanding_balance IS RECORD (
        company_name        VARCHAR2(200),
        company_address     VARCHAR2(200),
        report_title        VARCHAR2(200),
        gl_acct_cd          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        ledger_cd           giac_gl_acct_ref_no.ledger_cd%TYPE,
        transaction_cd      giac_gl_acct_ref_no.transaction_cd%TYPE,
        ledger_desc         giac_gl_account_types.ledger_desc%TYPE,
        transaction_desc    giac_gl_transaction_types.transaction_desc%TYPE,
        setup_amt           NUMBER(12,2),
        knock_off_amt       NUMBER(12,2),
        v_exists            VARCHAR2(8)
    );
    
    TYPE outstanding_balance_tab IS TABLE OF outstanding_balance;
    
    FUNCTION get_outstanding_balance (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE
    )
        RETURN outstanding_balance_tab PIPELINED;
END;
/
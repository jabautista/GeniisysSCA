CREATE OR REPLACE PACKAGE CPI.giacr343c_pkg
AS
    TYPE report_details_type IS RECORD (
        company_name        VARCHAR2(200),
        company_address     VARCHAR2(200),
        report_title        VARCHAR2(200),
        ledger_cd           giac_gl_acct_ref_no.ledger_cd%TYPE,
        ledger_desc         giac_gl_account_types.ledger_desc%TYPE,
        gl_acct_cd          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        subledger_cd        giac_gl_acct_ref_no.subledger_cd%TYPE,
        transaction_cd      giac_gl_transaction_types.transaction_cd%TYPE,
        transaction_desc     giac_gl_transaction_types.transaction_desc%TYPE,
        sl_cd               giac_gl_acct_ref_no.sl_cd%TYPE,
        sl_name             giac_sl_lists.sl_name%TYPE,
        acct_ref_no         giac_acct_entries.acct_ref_no%TYPE,    
        balance             NUMBER(12,2),
        v_exists            VARCHAR2(8)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    FUNCTION get_giacr343c_records (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE,
        p_sl_cd             giac_gl_acct_ref_no.sl_cd%TYPE
    )
        RETURN report_details_tab PIPELINED;
END; 
/


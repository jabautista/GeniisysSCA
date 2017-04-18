CREATE OR REPLACE PACKAGE CPI.CSV_ACCTG_GL
AS
    TYPE giacr343A_csv_type IS RECORD (
        ledger_type         giac_gl_acct_ref_no.ledger_cd%TYPE,
        ledger_desc         giac_gl_account_types.ledger_desc%TYPE,
        gl_acct_cd          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        subledger_cd        giac_gl_acct_ref_no.subledger_cd%TYPE,
        subledger_desc      giac_gl_subaccount_types.subledger_desc%TYPE,
        transaction_cd      giac_gl_acct_ref_no.transaction_cd%TYPE,
        transaction_desc    giac_gl_transaction_types.transaction_desc%TYPE,
        sl_cd               giac_acct_entries.sl_cd%TYPE,
        sl_name             giac_sl_lists.sl_name%TYPE,
        acct_ref_no         giac_acct_entries.acct_ref_no%TYPE,
        particulars         giac_acctrans.particulars%TYPE,
        tran_date           giac_acctrans.tran_date%TYPE,
        tran_ref_no         VARCHAR2(60),
        setup_amt           NUMBER(12,2),
        knock_off_amt       NUMBER(12,2)
    );
    
    TYPE giacr343A_csv_tab IS TABLE OF giacr343A_csv_type;

    TYPE giacr343B_csv_type IS RECORD (
        ledger_type         giac_gl_acct_ref_no.ledger_cd%TYPE,
        ledger_desc         giac_gl_account_types.ledger_desc%TYPE,
        gl_acct_cd          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        transaction_cd      giac_gl_acct_ref_no.transaction_cd%TYPE,
        transaction_desc    giac_gl_transaction_types.transaction_desc%TYPE,
        setup_amt           NUMBER(12,2),
        knock_off_amt       NUMBER(12,2)
    );
    
    TYPE giacr343B_csv_tab IS TABLE OF giacr343B_csv_type;    

    TYPE giacr343C_csv_type IS RECORD (
        gl_type             giac_gl_acct_ref_no.ledger_cd%TYPE,
        gl_description      giac_gl_account_types.ledger_desc%TYPE,
        gl_acct_cd          VARCHAR2(30),
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        group_cd            giac_gl_acct_ref_no.subledger_cd%TYPE,
        transaction_cd      giac_gl_acct_ref_no.transaction_cd%TYPE,
        transaction_desc    giac_gl_transaction_types.transaction_desc%TYPE,
        sl_cd               giac_acct_entries.sl_cd%TYPE,
        sl_name             giac_sl_lists.sl_name%TYPE,
        acct_ref_no         giac_acct_entries.acct_ref_no%TYPE,
        running_balance     NUMBER(12,2)
    );
    
    TYPE giacr343C_csv_tab IS TABLE OF giacr343C_csv_type;      
    
    FUNCTION get_giacr343A_csv (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE,
        p_sl_cd             giac_gl_acct_ref_no.sl_cd%TYPE
    )
        RETURN giacr343A_csv_tab PIPELINED;

    FUNCTION get_giacr343B_csv (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE
    )
        RETURN giacr343B_csv_tab PIPELINED; 

    FUNCTION get_giacr343C_csv (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE,
        p_sl_cd             giac_gl_acct_ref_no.sl_cd%TYPE
    )
        RETURN giacr343C_csv_tab PIPELINED;               
END; 
/


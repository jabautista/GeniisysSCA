CREATE OR REPLACE PACKAGE CPI.GIAC_TREATY_CASH_ACCT_PKG
AS
    TYPE giac_treaty_cash_acct_type IS RECORD (
       summary_id           giac_treaty_cash_acct.summary_id%TYPE,
       prev_balance         giac_treaty_cash_acct.prev_balance%TYPE, 
       prev_balance_dt      VARCHAR2(20),
       balance_as_above     giac_treaty_cash_acct.balance_as_above%TYPE,
       our_remittance       giac_treaty_cash_acct.our_remittance%TYPE, 
       your_remittance      giac_treaty_cash_acct.your_remittance%TYPE,
       cash_call_paid       giac_treaty_cash_acct.cash_call_paid%TYPE,
       cash_bal_in_favor    giac_treaty_cash_acct.cash_bal_in_favor%TYPE,
       prev_resv_balance    giac_treaty_cash_acct.prev_resv_balance%TYPE,
       resv_balance_as_of   VARCHAR2(20),
       prev_resv_bal_dt     VARCHAR2(20),
       resv_balance         giac_treaty_cash_acct.resv_balance%TYPE,
       resv_balance_dt      VARCHAR2(20),
       user_id              giac_treaty_cash_acct.user_id%TYPE,
       last_update          VARCHAR2(20) 
    );
    
    TYPE giac_treaty_cash_acct_tab IS TABLE OF giac_treaty_cash_acct_type;
    
    FUNCTION get_cash_acct_info(
        p_summary_id        GIAC_TREATY_CASH_ACCT.SUMMARY_ID%TYPE,
        p_year              NUMBER,
        p_qtr               NUMBER
    ) RETURN giac_treaty_cash_acct_tab PIPELINED;
    
    PROCEDURE update_cash_acct_info(
        p_cash          GIAC_TREATY_CASH_ACCT%ROWTYPE
    );
    
    PROCEDURE updatE_resv_balance(
        p_summary_id            GIAC_TREATY_CASH_ACCT.summary_id%TYPE,
        p_new_resv_balance      GIAC_TREATY_CASH_ACCT.resv_balance%TYPE
    );
    
    
END GIAC_TREATY_CASH_ACCT_PKG;
/



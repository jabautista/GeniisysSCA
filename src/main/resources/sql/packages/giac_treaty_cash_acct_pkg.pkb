CREATE OR REPLACE PACKAGE BODY CPI.GIAC_TREATY_CASH_ACCT_PKG
AS

    FUNCTION get_cash_acct_info(
        p_summary_id        GIAC_TREATY_CASH_ACCT.SUMMARY_ID%TYPE,
        p_year              NUMBER,
        p_qtr               NUMBER
    ) RETURN giac_treaty_cash_acct_tab PIPELINED
    IS
        v_acct      giac_treaty_cash_acct_type;
    BEGIN
    
        FOR rec IN (SELECT summary_id,
                           prev_balance, prev_balance_dt,
                           balance_as_above,
                           our_remittance, your_remittance,
                           cash_call_paid,
                           cash_bal_in_favor,
                           prev_resv_balance, prev_resv_bal_dt,
                           resv_balance, resv_balance_dt,
                           user_id, last_update
                      FROM GIAC_TREATY_CASH_ACCT
                     WHERE summary_id = p_summary_id)
        LOOP
        
            v_acct.summary_id           := rec.summary_id;
            v_acct.prev_balance         := rec.prev_balance;
            v_acct.prev_balance_dt      := TO_CHAR(rec.prev_balance_dt, 'mm-dd-yyyy');
            v_acct.balance_as_above     := rec.balance_as_above;
            v_acct.our_remittance       := rec.our_remittance;
            v_acct.your_remittance      := rec.your_remittance;
            v_acct.cash_call_paid       := rec.cash_call_paid;
            v_acct.cash_bal_in_favor    := rec.cash_bal_in_favor;
            v_acct.prev_resv_balance    := rec.prev_resv_balance;
            v_acct.prev_resv_bal_dt     := TO_CHAR(rec.prev_resv_bal_dt, 'mm-dd-yyyy');
            v_acct.resv_balance         := rec.resv_balance;
            v_acct.resv_balance_dt      := TO_CHAR(rec.resv_balance_dt, 'mm-dd-yyyy');
            v_acct.user_id              := rec.user_id;
            v_acct.last_update          := TO_CHAR(rec.last_update, 'mm-dd-yyyy');
            v_acct.resv_balance_as_of   := TO_CHAR(LAST_DAY(TO_DATE(TO_CHAR(p_qtr * 3,'09')||'-01-'||TO_CHAR(p_year,'9999'),'MM-DD-YYYY')), 'mm-dd-yyyy');
            
            PIPE ROW(v_acct);
        END LOOP;
    
    END get_cash_acct_info;
    
    
    PROCEDURE update_cash_acct_info(
        p_cash          GIAC_TREATY_CASH_ACCT%ROWTYPE
    ) IS
    BEGIN
    
        UPDATE GIAC_TREATY_CASH_ACCT
           SET prev_balance         = p_cash.prev_balance,
               prev_balance_dt      = p_cash.prev_balance_dt,
               our_remittance       = p_cash.our_remittance,
               your_remittance      = p_cash.your_remittance,
               cash_call_paid       = p_cash.cash_call_paid,
               cash_bal_in_favor    = p_cash.cash_bal_in_favor,
               prev_resv_balance    = p_cash.prev_resv_balance,
               prev_resv_bal_dt     = p_cash.prev_resv_bal_dt,
               resv_balance         = p_cash.resv_balance,
               resv_balance_dt      = p_cash.resv_balance_dt                 
         WHERE summary_id           = p_cash.summary_id;      
    
    END update_cash_acct_info;
    
    
    
    PROCEDURE updatE_resv_balance(
        p_summary_id            GIAC_TREATY_CASH_ACCT.summary_id%TYPE,
        p_new_resv_balance      GIAC_TREATY_CASH_ACCT.resv_balance%TYPE
    ) IS    
    BEGIN
    
        UPDATE GIAC_TREATY_CASH_ACCT
           SET resv_balance = p_new_resv_balance
         WHERE summary_id = p_summary_id; 
         
    END updatE_resv_balance;
    
    

END GIAC_TREATY_CASH_ACCT_PKG;
/



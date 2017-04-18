CREATE OR REPLACE PACKAGE CPI.GIAC_SPOILED_CHECK_PKG
AS

    TYPE giac_spoiled_check_type IS RECORD (
        gacc_tran_id        giac_spoiled_check.gacc_tran_id%TYPE,
        item_no             giac_spoiled_check.item_no%TYPE,
        bank_cd             giac_spoiled_check.bank_cd%TYPE,
        bank_acct_cd        giac_spoiled_check.bank_acct_cd%TYPE,    
        check_date          giac_spoiled_check.check_date%TYPE,
        check_no            giac_spoiled_check.check_no%TYPE,
        check_stat          giac_spoiled_check.check_stat%TYPE,
        currency_cd         giac_spoiled_check.currency_cd%TYPE,
        currency_rt         giac_spoiled_check.currency_rt%TYPE,
        amount              giac_spoiled_check.amount%TYPE,
        print_dt            giac_spoiled_check.print_dt%TYPE,
        check_pref_suf      giac_spoiled_check.check_pref_suf%TYPE,
        check_class         giac_spoiled_check.check_class%TYPE,
        fcurrency_amt       giac_spoiled_check.fcurrency_amt%TYPE,
        user_id             giac_spoiled_check.user_id%TYPE,
        last_update         giac_spoiled_check.last_update%TYPE
    );
    
    TYPE giac_spoiled_check_tab IS TABLE OF giac_spoiled_check_type;
    
    PROCEDURE insert_spoiled_check(p_check IN giac_spoiled_check%ROWTYPE); 
    
    
END GIAC_SPOILED_CHECK_PKG;
/



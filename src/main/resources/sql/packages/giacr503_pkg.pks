CREATE OR REPLACE PACKAGE CPI.GIACR503_PKG AS

    TYPE trial_balance_type IS RECORD (
        get_gl_acct_no_gl_acct_id           VARCHAR2(30),
        gl_acct_name                        GIAC_tb_sl_ext.gl_acct_name%TYPE,
        sl_cd                               GIAC_tb_sl_ext.sl_cd%TYPE,
        sl_name                             GIAC_tb_sl_ext.sl_name%TYPE,
        beg_debit                           NUMBER,
        beg_credit                          NUMBER,
        trans_debit                         NUMBER,
        trans_credit                        NUMBER,
        end_debit                           NUMBER,
        end_credit                          NUMBER,
        cf_company_name                     giis_parameters.param_value_v%TYPE,
        cf_company_add                      giis_parameters.param_value_v%TYPE,
        cf_1                                DATE,
        cf_as_of                            VARCHAR2(40)  
    );
    
    TYPE trial_balance_tab IS TABLE OF trial_balance_type;
    
    FUNCTION get_trial_balance(
        p_tran_mm       GIAC_tb_sl_ext.tran_mm%TYPE,
        p_tran_year     GIAC_tb_sl_ext.tran_year%TYPE
    ) RETURN trial_balance_tab PIPELINED;
    
    FUNCTION cf_as_ofFormula(
        p_tran_mm       GIAC_tb_sl_ext.tran_mm%TYPE,
        p_tran_year     GIAC_tb_sl_ext.tran_year%TYPE
    ) RETURN VARCHAR;

END GIACR503_PKG;
/



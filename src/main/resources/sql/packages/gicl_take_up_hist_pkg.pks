CREATE OR REPLACE PACKAGE CPI.gicl_take_up_hist_pkg
AS

    PROCEDURE reversal_next_day(
        p_dsp_date      giac_acctrans.tran_date%TYPE,
        p_user_id       giac_acctrans.user_id%TYPE
    );
    
    PROCEDURE reversal_next_month(
        p_dsp_date      giac_acctrans.tran_date%TYPE,
        p_user_id       giac_acctrans.user_id%TYPE
    );
    
    PROCEDURE extract_os_details(p_tran_id     gicl_clm_res_hist.tran_id%TYPE);
    
    PROCEDURE validate_tran_date(
        p_dsp_date     IN  giac_acctrans.tran_date%TYPE,
        p_msg         OUT  VARCHAR2
    );
    
    PROCEDURE reverse_all_giclb001(
        p_dsp_date   IN    giac_acctrans.tran_date%TYPE,
        p_user_id    IN    gicl_take_up_hist.user_id%TYPE,
        p_ctr       OUT    NUMBER
    );
    
    PROCEDURE book_os_giclb001(
        p_module_name   IN  giac_modules.module_name%TYPE,
        p_dsp_date      IN  giac_acctrans.tran_date%TYPE,
        p_user_id       IN  giac_acctrans.user_id%TYPE,
        p_message      OUT  VARCHAR2,
        p_message_type OUT  VARCHAR2,
        p_ctr          OUT    NUMBER
    );

END gicl_take_up_hist_pkg;
/



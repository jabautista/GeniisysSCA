CREATE OR REPLACE PACKAGE CPI.GIAC_BATCH_ACCT_ENTRY_PKG
AS

     TYPE validate_prod_date_type IS RECORD(
        batch_date      VARCHAR2(10),
        giacb001        NUMBER,  
        giacb002        NUMBER,
        giacb003        NUMBER, 
        giacb004        NUMBER,
        giacb001_sc     NUMBER,
        giacb005        NUMBER,
        giacb006        NUMBER,
        giacb007        NUMBER, --benjo 10.13.2016 SR-5512
        enter_advanced_payt VARCHAR2(1),
        enter_prepaid_comm  VARCHAR2(1),
        cnt             NUMBER
    );
    TYPE validate_prod_date_tab IS TABLE OF validate_prod_date_type;
    
    FUNCTION  validate_prod_date(p_prod_date  DATE) 
        RETURN validate_prod_date_tab PIPELINED;
        
    PROCEDURE data_check (p_prod_date    IN  DATE,
                          p_report       OUT VARCHAR2,
                          p_log          OUT VARCHAR2,
                          p_error_msg    OUT VARCHAR2);
                          
    PROCEDURE  update_allow_spoilage;
                          
    PROCEDURE validate_when_exit;
    
    PROCEDURE prod_sum_rep_and_peril_ext(p_prod_date   IN  DATE,
                                         p_log         OUT VARCHAR2);
END;
/



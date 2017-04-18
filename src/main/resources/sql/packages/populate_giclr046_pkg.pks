CREATE OR REPLACE PACKAGE CPI.populate_giclr046_pkg
AS

    TYPE populate_reports_type IS RECORD (
        wrd_payee_last_name     VARCHAR2(200),
        wrd_paid_amt            VARCHAR2(200),            
        wrd_company_name        VARCHAR2(200),      
        wrd_policy_no           VARCHAR2(200),         
        wrd_date1               VARCHAR2(200),
        wrd_time                VARCHAR2(200),
        wrd_location            VARCHAR2(200),
        wrd_date                VARCHAR2(200),
        wrd_place               VARCHAR2(200),
        wrd_witness1            VARCHAR2(200),
        wrd_witness2            VARCHAR2(200),
        wrd_witness3            VARCHAR2(200),    
        wrd_witness4            VARCHAR2(200));
        
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;

FUNCTION populate_giclr046_dfault(
    p_claim_id                  GICL_CLAIMS.claim_id%TYPE,             
    p_c011_payee_last_name      VARCHAR2,
    p_total_stl_paid_amt        VARCHAR2,
    p_paid_amt                  GICL_CLM_LOSS_EXP.PAID_AMT%TYPE,
    p_gido_date                 VARCHAR2,
    p_gido_place                VARCHAR2,
    p_item_no                   VARCHAR2,
    p_grouped_item_no           VARCHAR2,
    p_gido_witness1             VARCHAR2,
    p_gido_witness2             VARCHAR2,    
    p_gido_witness3             VARCHAR2,
    p_gido_witness4             VARCHAR2
    )
    RETURN populate_reports_tab PIPELINED;

END populate_giclr046_pkg;
/



CREATE OR REPLACE PACKAGE CPI.populate_giclr045_pkg
AS
    TYPE populate_reports_type IS RECORD (
        wrd_company_name        VARCHAR2(200),
        wrd_company_address     VARCHAR2(200),
        wrd_paid_amt            VARCHAR2(200),
        wrd_date                VARCHAR2(200),
        wrd_claim_no            VARCHAR2(200),
        wrd_paid_amt1           VARCHAR2(200),
        wrd_policy_no           VARCHAR2(200),
        wrd_date2               VARCHAR2(200),
        wrd_assured             GICL_CLAIMS.assured_name%TYPE,
        wrd_witness1            VARCHAR2(200),
        wrd_witness2            VARCHAR2(200),
        wrd_witness3            VARCHAR2(200),    
        wrd_witness4            VARCHAR2(200)
        );
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;
    
FUNCTION populate_giclr045_dfault (
    p_claim_id                  GICL_CLAIMS.claim_id%TYPE,
    p_gido_date                 VARCHAR2,
    p_c007_item_no              GICL_ITEM_PERIL.item_no%TYPE,
    p_c007_grouped_item_no      GICL_ITEM_PERIL.grouped_item_no%TYPE,
    p_total_stl_paid_amt        VARCHAR2,
    p_c011_paid_amt             GICL_CLM_LOSS_EXP.PAID_AMT%TYPE,
    p_gido_witness1             VARCHAR2,
    p_gido_witness2             VARCHAR2,    
    p_gido_witness3             VARCHAR2,
    p_gido_witness4             VARCHAR2
    )
 
    RETURN populate_reports_tab PIPELINED;


END populate_giclr045_pkg;
/



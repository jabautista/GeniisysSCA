CREATE OR REPLACE PACKAGE CPI.populate_giclr041_pkg
AS

    TYPE populate_reports_type IS RECORD (
        wrd_company_name        VARCHAR2(200), 
        wrd_company_address     VARCHAR2(200),
        wrd_company_company     VARCHAR2(200),
        wrd_paid_amt            VARCHAR2(200), 
        wrd_policy_no           VARCHAR2(200),
        wrd_place               VARCHAR2(200),
        wrd_date                VARCHAR2(200),
        wrd_assured             GICL_CLAIMS.assured_name%TYPE,
        wrd_claim_no            VARCHAR2(200),
        wrd_item_title          GIIS_LOSS_CTGRY.loss_cat_des%TYPE
        );
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;

FUNCTION populate_giclr041_UCPB(
    p_total_stl_paid_amt      VARCHAR2,
    p_c011_paid_amt           VARCHAR2,
    p_claim_id                GICL_CLAIMS.claim_id%TYPE,
    p_gido_place              VARCHAR2,
    p_gido_date               VARCHAR2  
    )
    RETURN populate_reports_tab PIPELINED;

END populate_giclr041_pkg;
/



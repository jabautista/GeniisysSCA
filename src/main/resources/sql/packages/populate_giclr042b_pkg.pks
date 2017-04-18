CREATE OR REPLACE PACKAGE CPI.populate_giclr042B_pkg
AS
    TYPE populate_reports_type IS RECORD(
        wrd_paid_amt            VARCHAR2(50),
        wrd_payee1              VARCHAR2(200),      
        wrd_payee_remarks       VARCHAR2(500),
        wrd_company_name1       VARCHAR2(200),
        wrd_grp_item1           VARCHAR2(50),
        wrd_line_name           VARCHAR2(200),
        wrd_policy_no           VARCHAR2(200),
        wrd_grp_item2           VARCHAR2(50),
        wrd_company_name2           VARCHAR2(200),
        wrd_grp_item3           VARCHAR2(50),
        wrd_grp_item4           VARCHAR2(50),
        wrd_company_name3       VARCHAR2(200),
        wrd_payee2              VARCHAR2(200),        
        wrd_witness1            VARCHAR2(200),
        wrd_witness2            VARCHAR2(200),
        wrd_yr                  VARCHAR2(10)
        );
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;
FUNCTION populate_giclr042B_dfault(
    p_claim_id              GICL_CLAIMS.claim_id%TYPE,
    p_advice_id             GICL_CLM_LOSS_EXP.advice_id%TYPE,
    p_line_cd               GICL_CLAIMS.line_cd%TYPE,
    p_total_stl_paid_amt    VARCHAR2,
    p_c011_paid_amt         VARCHAR2,
    p_payee_last_name       VARCHAR2,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_witness1              VARCHAR2,
    p_witness2              VARCHAR2
    )
RETURN populate_reports_tab PIPELINED;

END populate_giclr042B_pkg;
/



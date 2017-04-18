CREATE OR REPLACE PACKAGE CPI.populate_giclr047_pkg
AS
    TYPE populate_reports_type IS RECORD(
        wrd_paid_amt            VARCHAR2(50),       
        wrd_payee_last_name     VARCHAR2(200),
        wrd_mail_addrs          VARCHAR2(200),
        wrd_company_name        VARCHAR2(200),
        wrd_cargo_desc          VARCHAR2(200),
        wrd_yr                  VARCHAR2(50)
        );
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;
    
FUNCTION populate_giclr047_dfault(
    p_claim_id              GICL_CLAIMS.claim_id%TYPE,
    p_total_stl_paid_amt    VARCHAR2,
    p_c011_paid_amt         VARCHAR2,
    p_payee_last_name       VARCHAR2,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE
    )
RETURN populate_reports_tab PIPELINED;

END;
/



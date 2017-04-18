CREATE OR REPLACE PACKAGE CPI.populate_giclr042_pkg
AS
    TYPE populate_reports_type IS RECORD(
        wrd_label2         VARCHAR2(200),
        wrd_at             VARCHAR2(200),          
        wrd_role3          VARCHAR2(200),
        wrd_role2          VARCHAR2(200),
        wrd_role1          VARCHAR2(200),
        wrd_claim_no       VARCHAR2(200),
        wrd_policy_no      VARCHAR2(200),
        wrd_cur            VARCHAR2(100),
        wrd_paid_amt       VARCHAR2(100),
        wrd_company        VARCHAR2(2000),
        wrd_loss_date      VARCHAR2(50),
        wrd_assd1          GIIS_ASSURED.assd_name%TYPE, 
        wrd_assd2          GIIS_ASSURED.assd_name%TYPE, 
        wrd_witness1       VARCHAR2(100),
        wrd_witness2       VARCHAR2(100),
        wrd_yr             VARCHAR2(10)     
     );
    
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;

FUNCTION populate_giclr042_UCPB(
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_c011_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_c011_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_witness1                   VARCHAR2,
    p_witness2                     VARCHAR2,
    p_claim_id                   GICL_CLAIMS.claim_id%TYPE,
    p_c007_item_no               GICL_ITEM_PERIL.item_no%TYPE,
    p_c007_grouped_item_no       GICL_ITEM_PERIL.grouped_item_no%TYPE,
    p_total_stl_paid_amt         GICL_CLM_LOSS_EXP.paid_amt%TYPE,
    p_c011_paid_amt              GICL_CLM_LOSS_EXP.paid_amt%TYPE)
    
    RETURN populate_reports_tab PIPELINED;
    
END populate_giclr042_pkg;
/



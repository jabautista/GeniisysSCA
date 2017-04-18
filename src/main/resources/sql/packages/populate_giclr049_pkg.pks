CREATE OR REPLACE PACKAGE CPI.populate_giclr049_pkg
AS
    TYPE populate_reports_type IS RECORD (
        wrd_role1            VARCHAR2(200),
        wrd_role2            VARCHAR2(200),
        wrd_role3            VARCHAR2(200),
        wrd_assd1            GIIS_ASSURED.assd_name%TYPE,
        wrd_assd2            GIIS_ASSURED.assd_name%TYPE,
        wrd_label2           VARCHAR2(200),
        wrd_at               VARCHAR2(200),
        wrd_amt              VARCHAR2(200),   
        wrd_company          VARCHAR2(2000),
        wrd_policy           VARCHAR2(200),
        wrd_losscat          VARCHAR2(200),
        wrd_location         VARCHAR2(2000),   
        wrd_witness1         VARCHAR2(200),   
        wrd_witness2         VARCHAR2(200)   
    );
    
    TYPE populate_reports_tab IS TABLE OF populate_reports_type;
    
FUNCTION populate_giclr049_UCPB(
    p_claim_id                   GICL_CLAIMS.claim_id%TYPE,
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_total_stl_paid_amt         VARCHAR2,
    p_c011_paid_amt              VARCHAR2,
    p_policy_no                  VARCHAR2,
    p_loss_ctgry                 VARCHAR2,
    p_dsp_loss_date              VARCHAR2,
    p_witness1                   VARCHAR2,
    p_witness2                   VARCHAR2)
    
RETURN populate_reports_tab PIPELINED;

END populate_giclr049_pkg;
/



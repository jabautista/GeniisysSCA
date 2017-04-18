CREATE OR REPLACE PACKAGE CPI.populate_giclr036_pkg 
AS

    TYPE populate_reports_type IS RECORD (
        wrd_tp_name        VARCHAR2(2000),    
        wrd_tp_add         VARCHAR2(2000),   
        wrd_assured        GIIS_ASSURED.assd_name%TYPE,       
        wrd_plate_no       GICL_CLAIMS.plate_no%TYPE,  
        wrd_item_title     VARCHAR2(50), 
        wrd_tp_name2       VARCHAR2(100),
        wrd_loss_date      VARCHAR2(50), 
        wrd_loss_loc       VARCHAR2(500), 
        wrd_place          VARCHAR2(500),      
        wrd_payee2         VARCHAR2(2000),   
        wrd_role2          VARCHAR2(200),  
        wrd_payee1         VARCHAR2(2000),    
        wrd_role1          VARCHAR2(200),    
        wrd_label2         VARCHAR2(200),    
        wrd_at             VARCHAR2(100),    
        wrd_role3          VARCHAR2(100),    
        wrd_witness1       VARCHAR2(100),
        wrd_witness2       VARCHAR2(100),
        wrd_yr2            VARCHAR2(10)
    );
   
   TYPE populate_reports_tab IS TABLE OF populate_reports_type;

FUNCTION populate_giclr036_UCPB (
    p_sel_payee_cl_cd            GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_c011_payee_class_cd        GICL_CLM_LOSS_EXP.payee_class_cd%TYPE,
    p_sel_payee_cd               GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_c011_payee_cd              GICL_CLM_LOSS_EXP.payee_cd%TYPE,
    p_gido_affofdesist_wit1      VARCHAR2,
    p_gido_affofdesist_wit2      VARCHAR2,
    p_c003_claim_id              GICL_CLAIMS.claim_id%TYPE )  
    
  RETURN populate_reports_tab PIPELINED;
   
END populate_giclr036_pkg;
/



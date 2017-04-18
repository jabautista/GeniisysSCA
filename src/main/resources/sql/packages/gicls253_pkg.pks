CREATE OR REPLACE PACKAGE CPI.GICLS253_PKG
AS
   TYPE clm_list_per_motorshop_type IS RECORD (
    payee_cd            GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
    payee_name          VARCHAR2(500),
    claim_number        VARCHAR2 (30),
    assured_name        GICL_MOTSHOP_LISTING_V.assured_name%TYPE,
    loa_number          VARCHAR2 (30),
    policy_number       VARCHAR2 (30),
    clm_file_date       GICL_MOTSHOP_LISTING_V.clm_file_date%TYPE,
    plate_no            GICL_MOTSHOP_LISTING_V.plate_no%TYPE,
    clm_stat_cd         GICL_MOTSHOP_LISTING_V.clm_stat_cd%TYPE,
    clm_stat_desc       VARCHAR(30),
    loss_reserve        GICL_MOTSHOP_LISTING_V.loss_reserve%TYPE,
    dsp_loss_date       GICL_MOTSHOP_LISTING_V.dsp_loss_date%TYPE,
    paid_amt            GICL_MOTSHOP_LISTING_V.paid_amt%TYPE,
    tot_loss_reserve    GICL_MOTSHOP_LISTING_V.loss_reserve%TYPE,
    tot_paid_amt        GICL_MOTSHOP_LISTING_V.paid_amt%TYPE,
    loss_cat_des        GIIS_LOSS_CTGRY.loss_cat_des%TYPE
   );
   
   TYPE clm_list_per_motorshop_tab IS TABLE OF clm_list_per_motorshop_type;
   
   FUNCTION populate_per_motortype_details(
    p_payee_cd         GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
    p_from_date        VARCHAR2,
    p_to_date          VARCHAR2,
    p_as_of_date       VARCHAR2,
    p_search_by        VARCHAR2
   )
    RETURN clm_list_per_motorshop_tab PIPELINED;
    
   TYPE gicls253_motorshop_lov_type IS RECORD (
        payee_no        NUMBER(12),
        payee_name      VARCHAR2(600)
   );
   
   TYPE gicls253_motorshop_lov_tab IS TABLE OF gicls253_motorshop_lov_type;
   
   FUNCTION gicls253_motorshop_lov
    RETURN gicls253_motorshop_lov_tab PIPELINED;
    
   FUNCTION validate_motorshop(
    p_payee_name         VARCHAR2
   )
    RETURN VARCHAR2;
    
END GICLS253_PKG;
/

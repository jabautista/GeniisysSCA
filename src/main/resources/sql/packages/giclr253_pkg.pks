CREATE OR REPLACE PACKAGE CPI.GICLR253_PKG AS 
    
  TYPE giclr253_type IS RECORD (
    company_name    GIIS_PARAMETERS.param_value_v%TYPE,
    company_address GIIS_PARAMETERS.param_value_v%TYPE,
    date_type      VARCHAR2 (100)
  );

  TYPE giclr253_tab IS TABLE OF giclr253_type;
    
    
    FUNCTION populate_giclr253 (
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN giclr253_tab PIPELINED;

  TYPE giclr253_details_type IS RECORD (
  
    payee_cd        gicl_loss_exp_payees.payee_cd%TYPE,
    payee_name      VARCHAR2(500),
    claim_number    VARCHAR2 (30),
    assured_name    gicl_motshop_listing_v.assured_name%TYPE,
    loa_number      VARCHAR2 (30),
    policy_number   VARCHAR2 (30),
    clm_file_date   gicl_motshop_listing_v.clm_file_date%TYPE,
    plate_no        gicl_motshop_listing_v.plate_no%TYPE,
    clm_stat_cd     gicl_motshop_listing_v.clm_stat_cd%TYPE,
    clm_stat_desc   VARCHAR(30),
    loss_reserve    gicl_motshop_listing_v.loss_reserve%TYPE,
    dsp_loss_date   gicl_motshop_listing_v.dsp_loss_date%TYPE,
    paid_amt        gicl_motshop_listing_v.paid_amt%TYPE
  );

  TYPE giclr253_details_tab IS TABLE OF giclr253_details_type;
  
 FUNCTION populate_giclr253_details (
      P_PAYEE_CD         VARCHAR2,
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN giclr253_details_tab PIPELINED;  

END GICLR253_PKG;
/



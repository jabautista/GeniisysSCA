CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_MSHOP_GICLR253 AS 
    
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
  
    motorshop       VARCHAR2(550),  
    claim_number    VARCHAR2 (30),
    policy_number   VARCHAR2 (100),
    assured         gicl_motshop_listing_v.assured_name%TYPE,
    claim_status    VARCHAR(30),
    loa_number      VARCHAR2 (30),
    loss_date       VARCHAR2 (50),
    file_date       VARCHAR2 (50),
    plate_no        gicl_motshop_listing_v.plate_no%TYPE,
    loss_reserve    gicl_motshop_listing_v.loss_reserve%TYPE,
    loa_amount      gicl_motshop_listing_v.paid_amt%TYPE
    
  );

  TYPE giclr253_details_tab IS TABLE OF giclr253_details_type;
  
 FUNCTION csv_giclr253 (
      P_PAYEE_CD         VARCHAR2,
      P_FROM_DATE       VARCHAR2,
      P_TO_DATE         VARCHAR2,
      P_AS_OF_DATE      VARCHAR2,
      P_SEARCH_BY       VARCHAR2
    )
       RETURN giclr253_details_tab PIPELINED;  

END CSV_CLM_PER_MSHOP_GICLR253;
/

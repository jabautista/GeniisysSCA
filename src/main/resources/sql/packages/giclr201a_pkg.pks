CREATE OR REPLACE PACKAGE CPI.giclr201a_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_sw           VARCHAR2(10),
      date_title        VARCHAR2(500),
      date_coverage     VARCHAR2(500),
      claim_id          GICL_CLAIMS.CLAIM_ID%TYPE,
      acct_tran_id      GICL_RECOVERY_PAYT.ACCT_TRAN_ID%TYPE,
      claim_no          VARCHAR2 (100),
      assd_no           GIIS_ASSURED.ASSD_NO%TYPE,
      assd_name         GIIS_ASSURED.ASSD_NAME%TYPE,
      payor_cd          GICL_RECOVERY_PAYOR.PAYOR_CD%TYPE,
      payor_class_cd    GICL_RECOVERY_PAYOR.PAYOR_CLASS_CD%TYPE,
      recovery_id       GICL_CLM_RECOVERY.RECOVERY_ID%TYPE,
      recoverable_amt   NUMBER(16,2),
      net_retention     NUMBER(16,2),
      facultative       NUMBER(16,2),
      treaty            NUMBER(16,2),
      xol               NUMBER(16,2),
      line_cd           VARCHAR2(50),
      rec_type_cd       VARCHAR2(50),
      print_details     VARCHAR2(1)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_201_a_report (
      p_date_sw         VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_line_cd         VARCHAR2,
      p_rec_type_cd     VARCHAR2,
      p_user_id         VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
   TYPE giclr201a_type IS RECORD (
      ref_no            VARCHAR2(50),
      intm_name         INTERMEDIARY.INTM_NAME%TYPE
   );
   
   TYPE giclr201a_tab IS TABLE OF giclr201a_type;

  FUNCTION get_giclr_201_a_details_report (
      p_claim_id         NUMBER,
      p_acct_tran_id     VARCHAR2
   )
      RETURN giclr201a_tab PIPELINED;
      
   TYPE giclr201a_2type IS RECORD (
      payor             VARCHAR2(850)
   );
   
   TYPE giclr201a_2tab IS TABLE OF giclr201a_2type;

  FUNCTION get_giclr_201_a_2_report (
      p_payor_cd          GICL_RECOVERY_PAYOR.PAYOR_CD%TYPE,
      p_payor_class_cd    GICL_RECOVERY_PAYOR.PAYOR_CLASS_CD%TYPE
   )
      RETURN giclr201a_2tab PIPELINED;
      
   TYPE giclr201a_3type IS RECORD (
      recoverable_amt       NUMBER(16,2),
      net_retention         NUMBER(16,2),
      facultative           NUMBER(16,2),
      treaty                NUMBER(16,2),
      xol                   NUMBER(16,2)
   );
   
   TYPE giclr201a_3tab IS TABLE OF giclr201a_3type;

  FUNCTION get_giclr_201_a_3_report (
      p_claim_id         NUMBER,
      p_recovery_id      NUMBER,
      p_acct_tran_id     NUMBER
   )
      RETURN giclr201a_3tab PIPELINED;
  
   TYPE giclr201a_treaty_type IS RECORD (
      trty_name         VARCHAR2(500), 
      trty_dist         NUMBER(16,2)
   );
   
   TYPE giclr201a_treaty_tab IS TABLE OF giclr201a_treaty_type;

  FUNCTION get_giclr_201_a_treaty_report (
      p_line_cd        VARCHAR2,
      p_rec_type_cd    VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2
   )
      RETURN giclr201a_treaty_tab PIPELINED;
        
END;
/



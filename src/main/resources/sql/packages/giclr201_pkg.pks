CREATE OR REPLACE PACKAGE CPI.giclr201_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_title        VARCHAR2(500),
      date_coverage     VARCHAR2(500),
      claim_id          GICL_CLAIMS.CLAIM_ID%TYPE,
      recovery_id       GICL_CLM_RECOVERY.RECOVERY_ID%TYPE,
      line_cd           GICL_CLAIMS.LINE_CD%TYPE,
      iss_cd            VARCHAR2 (50),
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      assd_no           GIIS_ASSURED.ASSD_NO%TYPE,
      assd_name         GIIS_ASSURED.ASSD_NAME%TYPE,
      intm_name         INTERMEDIARY.INTM_NAME%TYPE,
      cancel_tag        GICL_CLM_RECOVERY.CANCEL_TAG%TYPE,
      lawyer_cd         GICL_CLM_RECOVERY.LAWYER_CD%TYPE,
      lawyer_class_cd   GICL_CLM_RECOVERY.LAWYER_CLASS_CD%TYPE,
      acct_tran_id      GICL_RECOVERY_PAYT.ACCT_TRAN_ID%TYPE,
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      date_sw           VARCHAR2(10),
      recoverable_amt   NUMBER(16,2),
      recovered_amt     NUMBER(16,2),
      print_details     VARCHAR2(1)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_201_report (
      p_user_id         VARCHAR2,
      p_date_sw         VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_intm_no         VARCHAR2,
      p_line_cd         VARCHAR2,
      p_rec_type_cd     VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
      TYPE giclr201_detail3_type IS RECORD (
      tran_date         GICL_RECOVERY_PAYT.TRAN_DATE%TYPE,
      ref_no            VARCHAR2(50),
      acct_tran_id      GICL_RECOVERY_PAYT.ACCT_TRAN_ID%TYPE
   );

   TYPE giclr201_detail3_tab IS TABLE OF giclr201_detail3_type;

    FUNCTION get_giclr201_3details (
     p_claim_id         NUMBER,
     p_recovery_id      NUMBER,
     p_acct_tran_id     VARCHAR2
   )
      RETURN giclr201_detail3_tab PIPELINED;
    
   TYPE giclr201_details_type IS RECORD(
     recovery_no        VARCHAR2(200),
     rec_file_date      DATE,
     rec_type_desc      VARCHAR2(200),
     cancel_tag         VARCHAR2(10),
     rec_status         VARCHAR2(100),
     lawyer             VARCHAR2(850),
     lawyer_cd          GICL_CLM_RECOVERY.LAWYER_CD%TYPE,
     lawyer_class_cd    GICL_CLM_RECOVERY.LAWYER_CLASS_CD%TYPE,
     recoverable_amt    GICL_CLM_RECOVERY.RECOVERABLE_AMT%TYPE,
     recovered_amt      NUMBER(16,2)
   );
   TYPE giclr201_details_tab IS TABLE OF giclr201_details_type;
     
   FUNCTION get_giclr201_details(
     p_claim_id         NUMBER,
     p_recovery_id      NUMBER
   )
     RETURN giclr201_details_tab PIPELINED;
     
   TYPE giclr201_detail2_type IS RECORD (
      payor             VARCHAR2(850),
      recovered_amt     NUMBER (16,2),
      payor_cd          GICL_RECOVERY_PAYOR.PAYOR_CD%TYPE,
      payor_class_cd    GICL_RECOVERY_PAYOR.PAYOR_CLASS_CD%TYPE
   );

   TYPE giclr201_detail2_tab IS TABLE OF giclr201_detail2_type;

   FUNCTION get_giclr201_2details (
     p_claim_id         NUMBER,
     p_recovery_id      NUMBER
   )
      RETURN giclr201_detail2_tab PIPELINED;
        
END;
/



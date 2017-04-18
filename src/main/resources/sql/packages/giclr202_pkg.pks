CREATE OR REPLACE PACKAGE CPI.giclr202_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_sw           VARCHAR2(100),
      claim_id          GICL_CLAIMS.CLAIM_ID%TYPE,
      recovery_id       GICL_CLM_RECOVERY.RECOVERY_ID%TYPE,
      lawyer_cd         GICL_CLM_RECOVERY.LAWYER_CD%TYPE,
      lawyer_class_cd   GICL_CLM_RECOVERY.LAWYER_CLASS_CD%TYPE,
      cancel_tag        GICL_CLM_RECOVERY.CANCEL_TAG%TYPE,
      rec_type_cd       GICL_CLM_RECOVERY.REC_TYPE_CD%TYPE,
      rec_file_date     GICL_CLM_RECOVERY.REC_FILE_DATE%TYPE,
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      assd_no           GIIS_ASSURED.ASSD_NO%TYPE,
      assd_name         GIIS_ASSURED.ASSD_NAME%TYPE,
      dsp_loss_date     GICL_CLAIMS.DSP_LOSS_DATE%TYPE,
      clm_file_date     GICL_CLAIMS.CLM_FILE_DATE%TYPE,
      print_details     VARCHAR2(1)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_202_report (
      p_user_id         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_line_cd         VARCHAR2,
      p_iss_cd          VARCHAR2,
      p_rec_type_cd     VARCHAR2
   )
      RETURN report_tab PIPELINED;
      
  TYPE giclr202_type IS RECORD (
      recovery_no       VARCHAR2 (100),
      rec_type_desc     VARCHAR2 (100),
      rec_status        VARCHAR2 (100),
      lawyer            VARCHAR2 (850),
      recoverable_amt   NUMBER(16,2)
   );
   
   TYPE giclr202_tab IS TABLE OF giclr202_type;

  FUNCTION get_giclr_202_details_report (
      p_claim_id        VARCHAR2,
      p_recovery_id     VARCHAR2,
      p_rec_file_date   VARCHAR2,
      p_rec_type_cd     VARCHAR2,
      p_cancel_tag      VARCHAR2,
      p_lawyer_cd       VARCHAR2,
      p_lawyer_class_cd VARCHAR2
   )
      RETURN giclr202_tab PIPELINED;
        
END;
/



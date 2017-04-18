CREATE OR REPLACE PACKAGE CPI.GICLS258_PKG AS
TYPE clm_list_per_recovery_type IS RECORD ( 
        claim_id        gicl_claims.claim_id%TYPE,
        line_cd         gicl_claims.line_cd%TYPE,
        recovery_id     gicl_clm_recovery.recovery_id%TYPE,
        recovery_no     VARCHAR2(20),
        payor_class     VARCHAR2(50),
        payor_name      VARCHAR2(600),
        clm_file_date   VARCHAR(100),
        loss_date       VARCHAR(100),
        claim_no        VARCHAR2(30),
        policy_no       VARCHAR2(30),
        assd_name    giis_assured.assd_name%TYPE,
        claim_status    giis_clm_stat.clm_stat_desc%TYPE,
        recovery_det_count NUMBER(10)
    );
    
    TYPE clm_list_per_recovery_tab IS TABLE OF clm_list_per_recovery_type;
  
    FUNCTION get_clm_list_per_recovery_type (
      p_user_id          VARCHAR2,
      p_rec_type_cd      VARCHAR2,
      p_search_by_opt    VARCHAR2,
      p_date_as_of       VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_recovery_no      VARCHAR2,
      p_payor_class      VARCHAR2,
      p_payor_name       VARCHAR2,
      p_clm_file_date    VARCHAR2,
      p_loss_date        VARCHAR2
    )
      RETURN clm_list_per_recovery_tab PIPELINED;
    
    TYPE recovery_details_type IS RECORD (
      recovery_id       gicl_clm_recovery.recovery_id%TYPE,
      recovery_no       VARCHAR2 (50),
      recoverable_amt   gicl_clm_recovery.recoverable_amt%TYPE,
      recovered_amt     gicl_clm_recovery.recovered_amt%TYPE,
      lawyer            VARCHAR2 (255),
      plate_no          gicl_clm_recovery.plate_no%TYPE,
      status            VARCHAR2 (50),
      tp_item_desc      gicl_clm_recovery.tp_item_desc%TYPE
   );

   TYPE recovery_details_tab IS TABLE OF recovery_details_type;
      
    FUNCTION get_recovery_details (
      p_claim_id gicl_clm_recovery.claim_id%TYPE,
      p_line_cd  gicl_claims.line_cd%TYPE,
      p_recovery_id gicl_clm_recovery.recovery_id%TYPE
      )
      RETURN recovery_details_tab PIPELINED;

   TYPE payor_details_type IS RECORD (
      class_desc      giis_payee_class.class_desc%TYPE,
      payor           VARCHAR2 (255),
      recovered_amt   gicl_recovery_payor.recovered_amt%TYPE
   );

   TYPE payor_details_tab IS TABLE OF payor_details_type;

   FUNCTION get_payor_details (
      p_claim_id      gicl_recovery_payor.claim_id%TYPE,
      p_recovery_id   gicl_recovery_payor.recovery_id%TYPE
   )
      RETURN payor_details_tab PIPELINED;

   TYPE history_type IS RECORD (
      rec_hist_no     gicl_rec_hist.rec_hist_no%TYPE,
      rec_stat_cd     gicl_rec_hist.rec_stat_cd%TYPE,
      rec_stat_desc   VARCHAR2 (255),
      remarks         gicl_rec_hist.remarks%TYPE,
      user_id         gicl_rec_hist.user_id%TYPE,
      last_update     VARCHAR2 (255)
   );

   TYPE history_tab IS TABLE OF history_type;

   FUNCTION get_history (p_recovery_id gicl_rec_hist.recovery_id%TYPE)
      RETURN history_tab PIPELINED;  
END;
/



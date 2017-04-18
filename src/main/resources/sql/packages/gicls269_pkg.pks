CREATE OR REPLACE PACKAGE CPI.gicls269_pkg
AS
/*
**  Created by   : Windell Valle
**  Date Created : June 10, 2013
**  Description  : Populate GICLS269 - Recovery Status
*/
   TYPE recovery_status_type IS RECORD (
      claim_id          NUMBER,
      recovery_id       NUMBER,
      recovery_no       VARCHAR2 (50),
      claim_no          VARCHAR2 (50),
      loss_category     VARCHAR2 (50),
      recovery_status   VARCHAR2 (50),
      policy_no         VARCHAR2 (50),
      assured_name      gicl_claims.assured_name%TYPE,
      loss_date         gicl_claims.dsp_loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      lawyer_cd         gicl_clm_recovery.lawyer_cd%TYPE,
      lawyer            VARCHAR2 (400),
      tp_item_desc      gicl_clm_recovery.tp_item_desc%TYPE,
      recoverable_amt   gicl_clm_recovery.recoverable_amt%TYPE,
      recovered_amt_r   gicl_clm_recovery.recovered_amt%TYPE,
      plate_no          gicl_clm_recovery.plate_no%TYPE
   );

   TYPE recovery_status_tab IS TABLE OF recovery_status_type;

   TYPE recovery_detail_type IS RECORD (
      payor_class_cd     gicl_recovery_payor.payor_class_cd%TYPE,
      payee_class_desc   giis_payee_class.class_desc%TYPE,
      payor_cd           gicl_recovery_payor.payor_cd%TYPE,
      payee_name         VARCHAR2 (400),
      recovered_amt_p    gicl_recovery_payor.recovered_amt%TYPE
   );

   TYPE recovery_detail_tab IS TABLE OF recovery_detail_type;

   TYPE recovery_history_type IS RECORD (
      rec_hist_no     gicl_rec_hist.rec_hist_no%TYPE,
      rec_stat_cd     gicl_rec_hist.rec_stat_cd%TYPE,
      rec_stat_desc   giis_recovery_status.rec_stat_desc%TYPE,
      remarks         giis_recovery_status.remarks%TYPE,
      user_id         gicl_rec_hist.user_id%TYPE,
      last_update     VARCHAR2 (20)
   );

   TYPE recovery_history_tab IS TABLE OF recovery_history_type;

   FUNCTION get_recovery_status (
      p_line_cd         giis_line.line_cd%TYPE,
      p_iss_cd          giis_issource.iss_cd%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_rec_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      p_search_by       VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN recovery_status_tab PIPELINED;

   FUNCTION get_recovery_details (p_claim_id NUMBER, p_recovery_id NUMBER)
      RETURN recovery_detail_tab PIPELINED;

   FUNCTION get_recovery_history (p_recovery_id NUMBER)
      RETURN recovery_history_tab PIPELINED;
END;
/



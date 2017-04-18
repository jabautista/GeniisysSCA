CREATE OR REPLACE PACKAGE CPI.gipi_user_events_pkg
AS
   TYPE gipi_user_events_type IS RECORD (
      event_cd             gipi_user_events.event_cd%TYPE,
      event_desc           giis_events.event_desc%TYPE,
      event_type           giis_events.event_type%TYPE,
      tran_cnt             NUMBER,
      new_tran_cnt         NUMBER,
      tran_cnt_display     VARCHAR2 (20),
      multiple_assign_sw   giis_events.multiple_assign_sw%TYPE,
      receiver_tag         giis_events.receiver_tag%TYPE
   );

   TYPE gipi_user_events_tab IS TABLE OF gipi_user_events_type;

   FUNCTION get_gipi_user_events_listing (
      p_userid       gipi_user_events.userid%TYPE,
      p_event_desc   giis_events.event_desc%TYPE
   )
      RETURN gipi_user_events_tab PIPELINED;

   TYPE event_detail_type IS RECORD (
      tran_dtl         VARCHAR2 (100),
      event_user_mod   gipi_user_events.event_user_mod%TYPE,
      event_col_cd     gipi_user_events.event_col_cd%TYPE,
      tran_id          gipi_user_events.tran_id%TYPE,
      col_value        gipi_user_events.col_value%TYPE,
      SWITCH           gipi_user_events.SWITCH%TYPE,
      sender           gipi_user_events_hist.old_userid%TYPE,
      date_received    gipi_user_events_hist.date_received%TYPE,
      remarks          gipi_user_events.remarks%TYPE,
      event_cd         gipi_user_events.event_cd%TYPE,
      event_mod_cd     gipi_user_events.event_mod_cd%TYPE,
      recipient        gipi_user_events.userid%TYPE,
      status           gipi_user_events.status%TYPE,
      status_desc      cg_ref_codes.rv_meaning%TYPE,
      date_due         gipi_user_events.date_due%TYPE
   );

   TYPE event_detail_tab IS TABLE OF event_detail_type;

   FUNCTION get_event_detail_listing (
      p_event_cd        gipi_user_events.event_cd%TYPE,
      p_user_id         gipi_user_events.user_id%TYPE  
   )
      RETURN event_detail_tab PIPELINED;

   TYPE tran_list_type IS RECORD (
      col_value   VARCHAR2 (200),
      tran_dtl    VARCHAR2 (1000)
   );

   TYPE tran_list_tab IS TABLE OF tran_list_type;

   FUNCTION get_tran_list (p_event_cd gipi_user_events.event_cd%TYPE)
      RETURN tran_list_tab PIPELINED;

   PROCEDURE set_workflow_gicls010 (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_stat_cd   gicl_claims.clm_stat_cd%TYPE
   );
   
   FUNCTION get_sent_events_by_date_sent (p_user_id      GIIS_USERS.user_id%TYPE,
                                          p_date         VARCHAR2,
                                          p_event_desc   GIIS_EVENTS.event_desc%TYPE) 
     RETURN gipi_user_events_tab PIPELINED;
   
   
   FUNCTION get_sent_events_by_date_range (p_user_id      GIIS_USERS.user_id%TYPE,
                                           p_date_from    VARCHAR2,
                                           p_date_to      VARCHAR2,
                                           p_event_desc   GIIS_EVENTS.event_desc%TYPE) 
     RETURN gipi_user_events_tab PIPELINED;
   
END gipi_user_events_pkg;
/



CREATE OR REPLACE PACKAGE CPI.GISM_MESSAGES_RECEIVED_PKG
AS

   TYPE gism_messages_received_type IS RECORD(
      sender                  GISM_MESSAGES_RECEIVED.sender%TYPE,
      cellphone_no            GISM_MESSAGES_RECEIVED.cellphone_no%TYPE,
      date_received           GISM_MESSAGES_RECEIVED.date_received%TYPE,
      message                 GISM_MESSAGES_RECEIVED.message%TYPE,
      recipient               GISM_MESSAGES_RECEIVED.recipient%TYPE,
      recipient_grp           GISM_MESSAGES_RECEIVED.recipient_grp%TYPE,
      user_id                 GISM_MESSAGES_RECEIVED.user_id%TYPE,
      last_update             GISM_MESSAGES_RECEIVED.last_update%TYPE,
      error_sw                GISM_MESSAGES_RECEIVED.error_sw%TYPE,
      keyword                 GISM_MESSAGES_RECEIVED.keyword%TYPE,
      error_msg_id            GISM_MESSAGES_RECEIVED.error_msg_id%TYPE,
      upload_sw               GISM_MESSAGES_RECEIVED.upload_sw%TYPE,
      dsp_date_received       VARCHAR2(25),
      dsp_last_update         VARCHAR2(25)
   );
   TYPE gism_messages_received_tab IS TABLE OF gism_messages_received_type;
   
   TYPE message_detail_type IS RECORD(
      msg_id                  GISM_MESSAGES_SENT.msg_id%TYPE,
      message                 GISM_MESSAGES_SENT.message%TYPE,
      message_status          GISM_MESSAGES_SENT.message_status%TYPE,
      dsp_message_status      VARCHAR2(20),
      dsp_set_date            VARCHAR2(25)
   );
   TYPE message_detail_tab IS TABLE OF message_detail_type;
   
   FUNCTION get_messages_received(
      p_sender                GISM_MESSAGES_RECEIVED.sender%TYPE,
      p_cellphone_no          GISM_MESSAGES_RECEIVED.cellphone_no%TYPE,
      p_date_received         VARCHAR2,
      p_message               GISM_MESSAGES_RECEIVED.message%TYPE
   )
     RETURN gism_messages_received_tab PIPELINED;
     
   FUNCTION get_message_detail(
      p_message_id            GISM_MESSAGES_RECEIVED.error_msg_id%TYPE
   )
     RETURN message_detail_tab PIPELINED;
     
   PROCEDURE reply_to_message(
      p_message               VARCHAR2,
      p_sender                GISM_MESSAGES_RECEIVED.sender%TYPE,
      p_cellphone_no          GISM_MESSAGES_RECEIVED.cellphone_no%TYPE,
      p_date_received         VARCHAR2
   );
   
   TYPE sms_error_log_type IS RECORD (
      date_received  gism_messages_received.date_received%TYPE,
      cellphone_no   gism_messages_received.cellphone_no%TYPE,
      name           VARCHAR2(100),
      keyword        gism_messages_received.keyword%TYPE,
      message        gism_messages_received.message%TYPE,
      class_cd       VARCHAR2(1),
      intm_no        giis_intermediary.intm_no%TYPE,
      assd_no        giis_assured.assd_no%TYPE
   );
   
   TYPE sms_error_log_tab IS TABLE OF sms_error_log_type;
   
   FUNCTION get_sms_error_log
      RETURN sms_error_log_tab PIPELINED;
      
   PROCEDURE get_gisms008_name (
      p_message   IN VARCHAR2,
      p_name      OUT VARCHAR2,
      p_class_cd  OUT VARCHAR2
   );
      
   PROCEDURE get_cell_type (
      cel_no   IN VARCHAR2,
      cel_type IN VARCHAR2,
      v_flag   IN OUT boolean
   );
   
   PROCEDURE gisms008_assign(
      p_no           VARCHAR2,
      p_cellphone_no VARCHAR2,
      p_keyword      VARCHAR2,
      p_message      VARCHAR2,
      p_class_cd     VARCHAR2
   );
   
   PROCEDURE gisms008_purge(
      p_cellphone_no VARCHAR2,
      p_keyword      VARCHAR2,
      p_message      VARCHAR2
   );

END;
/



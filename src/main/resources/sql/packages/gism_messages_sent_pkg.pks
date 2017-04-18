CREATE OR REPLACE PACKAGE CPI.GISM_MESSAGES_SENT_PKG
AS

   TYPE gism_messages_sent_type IS RECORD(
      msg_id                     GISM_MESSAGES_SENT.msg_id%TYPE,
      message                    GISM_MESSAGES_SENT.message%TYPE,
      date_sent                  GISM_MESSAGES_SENT.date_sent%TYPE,
      message_status             GISM_MESSAGES_SENT.message_status%TYPE,
      priority                   GISM_MESSAGES_SENT.priority%TYPE,
      set_date                   GISM_MESSAGES_SENT.set_date%TYPE,
      remarks                    GISM_MESSAGES_SENT.remarks%TYPE,
      sched_date                 GISM_MESSAGES_SENT.sched_date%TYPE,
      last_update                GISM_MESSAGES_SENT.last_update%TYPE,
      user_id                    GISM_MESSAGES_SENT.user_id%TYPE,
      bday_sw                    GISM_MESSAGES_SENT.bday_sw%TYPE,
      priority_desc              VARCHAR2(10),
      status_desc                VARCHAR2(20),
      dsp_sched_date             VARCHAR2(30),
      dsp_set_date               VARCHAR2(30),
      dsp_last_update            VARCHAR2(30)
   );
   TYPE gism_messages_sent_tab IS TABLE OF gism_messages_sent_type;
   
   TYPE gism_messages_sent_dtl_type IS RECORD(
      user_group                 GISM_RECIPIENT_GROUP.group_name%TYPE,
      recipient_name             GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      cellphone_no               GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      status_desc                VARCHAR2(5)
   );
   TYPE gism_messages_sent_dtl_tab IS TABLE OF gism_messages_sent_dtl_type;
   
   TYPE created_messages_type IS RECORD(
      msg_id                     GISM_MESSAGES_SENT.msg_id%TYPE,
      dsp_set_date               VARCHAR2(20),
      dsp_set_time               VARCHAR2(20),
      message                    GISM_MESSAGES_SENT.message%TYPE,
      sched_date                 VARCHAR2(30),
      priority                   GISM_MESSAGES_SENT.priority%TYPE,
      priority_desc              VARCHAR2(10),
      remarks                    GISM_MESSAGES_SENT.remarks%TYPE,
      last_update                VARCHAR2(30),
      user_id                    GISM_MESSAGES_SENT.user_id%TYPE,
      bday_sw                    GISM_MESSAGES_SENT.bday_sw%TYPE
   );
   TYPE created_messages_tab IS TABLE OF created_messages_type;
   
   TYPE created_messages_dtl_type IS RECORD(
      msg_id                     GISM_MESSAGES_SENT.msg_id%TYPE,
      dtl_id                     GISM_MESSAGES_SENT_DTL.dtl_id%TYPE,
      status_sw                  GISM_MESSAGES_SENT_DTL.status_sw%TYPE,
      group_cd                   GISM_MESSAGES_SENT_DTL.group_cd%TYPE,
      group_name                 GISM_RECIPIENT_GROUP.group_name%TYPE,
      recipient_name             GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      cellphone_no               GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      pk_column_value            GISM_MESSAGES_SENT_DTL.pk_column_value%TYPE
   );
   TYPE created_messages_dtl_tab IS TABLE OF created_messages_dtl_type;
   
   FUNCTION get_gism_messages_sent(
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE,
      p_status                   VARCHAR2,
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_priority_desc            VARCHAR2,
      p_sched_date               VARCHAR2,
      p_set_date                 VARCHAR2,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_remarks                  GISM_MESSAGES_SENT.remarks%TYPE
   )
     RETURN gism_messages_sent_tab PIPELINED;
     
   FUNCTION get_message_details(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE
   )
     RETURN gism_messages_sent_dtl_tab PIPELINED;
     
   PROCEDURE resend_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE
   );
   
   FUNCTION get_created_messages(
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_sched_date               VARCHAR2,
      p_priority_desc            VARCHAR2
   )
     RETURN created_messages_tab PIPELINED;
     
   FUNCTION get_created_messages_dtl(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE
   )
     RETURN created_messages_dtl_tab PIPELINED;
     
   PROCEDURE cancel_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_user_id                  GISM_MESSAGES_SENT.user_id%TYPE
   );
   
   PROCEDURE set_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_message                  GISM_MESSAGES_SENT.message%TYPE,
      p_priority                 GISM_MESSAGES_SENT.priority%TYPE,
      p_remarks                  GISM_MESSAGES_SENT.remarks%TYPE,
      p_sched_date               VARCHAR2,
      p_bday_sw                  GISM_MESSAGES_SENT.bday_sw%TYPE
   );
   
   PROCEDURE delete_message(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE
   );
   
   PROCEDURE set_detail(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_detail_id                GISM_MESSAGES_SENT_DTL.dtl_id%TYPE,
      p_group_cd                 GISM_MESSAGES_SENT_DTL.group_cd%TYPE,
      p_pk_column_value          GISM_MESSAGES_SENT_DTL.pk_column_value%TYPE,
      p_recipient_name           GISM_MESSAGES_SENT_DTL.recipient_name%TYPE,
      p_cellphone_no             GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      p_status_sw                GISM_MESSAGES_SENT_DTL.status_sw%TYPE
   );
   
   PROCEDURE delete_detail(
      p_message_id               GISM_MESSAGES_SENT.msg_id%TYPE,
      p_detail_id                GISM_MESSAGES_SENT_DTL.dtl_id%TYPE
   );
   
   FUNCTION validate_mobile_number(
      p_mobile_no                GISM_MESSAGES_SENT_DTL.cellphone_no%TYPE,
      p_provider                 VARCHAR2
   )
     RETURN NUMBER;
   
END;
/



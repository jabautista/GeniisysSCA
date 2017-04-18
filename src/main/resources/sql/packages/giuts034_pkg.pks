CREATE OR REPLACE PACKAGE CPI.giuts034_pkg
AS
   TYPE giuts034_dtls_type IS RECORD (
      note_type      gipi_reminder.note_type%TYPE,
      note_subject   gipi_reminder.note_subject%TYPE,
      note_text      gipi_reminder.note_text%TYPE,
      alarm_flag     gipi_reminder.alarm_flag%TYPE,
      renew_flag     gipi_reminder.renew_flag%TYPE,
      alarm_user     gipi_reminder.alarm_user%TYPE,
      alarm_date     gipi_reminder.alarm_date%TYPE,
      ack_date       gipi_reminder.ack_date%TYPE,
      user_id        gipi_reminder.user_id%TYPE,
      last_update    VARCHAR2 (50),
      db_tag         VARCHAR2 (1)
   );

   TYPE giuts034_dtls_tab IS TABLE OF giuts034_dtls_type;

   FUNCTION get_reminder_list (
      p_par_id     gipi_parlist.par_id%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giuts034_dtls_tab PIPELINED;

   TYPE alarm_users_lov_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE
   );

   TYPE alarm_users_lov_tab IS TABLE OF alarm_users_lov_type;

   FUNCTION get_alarm_users_lov (p_alarm_user VARCHAR2)
      RETURN alarm_users_lov_tab PIPELINED;

   PROCEDURE insert_reminder (p_reminder gipi_reminder%ROWTYPE);

   TYPE validate_alarm_user_type IS RECORD (
      COUNT     VARCHAR2 (1),
      user_id   giis_users.user_id%TYPE
   );

   TYPE validate_alarm_user_tab IS TABLE OF validate_alarm_user_type;

   FUNCTION validate_alarm_user (p_alarm_user giis_users.user_id%TYPE)
      RETURN validate_alarm_user_tab PIPELINED;
    
    -- start SR-19555 : shan 07.07.2015
    FUNCTION get_claim_par_id(
        p_claim_id      GICL_CLAIMS.CLAIM_ID%TYPE
    ) RETURN NUMBER;
    -- end SR-19555 : shan 07.07.2015
END;
/



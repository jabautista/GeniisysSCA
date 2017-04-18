CREATE OR REPLACE PACKAGE CPI.gipis208_pkg
AS
   TYPE rec_type IS RECORD (
      note_subject      gipi_reminder.note_subject%TYPE,
      dsp_type_status   VARCHAR2 (30),
      alarm_user        gipi_reminder.alarm_user%TYPE,
      alarm_date        VARCHAR2 (30),
      user_id           gipi_reminder.user_id%TYPE,
      last_update       VARCHAR2 (30),
      ack_date          VARCHAR2 (30),
      policy_no         VARCHAR2 (50),
      policy_id         gipi_vehicle.policy_id%TYPE,
      par_id            gipi_reminder.par_id%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_note_subject   gipi_reminder.note_subject%TYPE,
      p_date_opt       VARCHAR2,
      p_as_of_date     VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_note_type      gipi_reminder.note_type%TYPE,
      p_alarm_flag     gipi_reminder.alarm_flag%TYPE,
      p_par_id         gipi_reminder.par_id%TYPE
   )
      RETURN rec_tab PIPELINED;
END;
/



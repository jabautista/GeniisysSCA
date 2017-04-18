CREATE OR REPLACE PACKAGE CPI.GIPI_REMINDER_PKG AS

  TYPE gipi_reminder_type IS RECORD (
    par_id          GIPI_REMINDER.par_id%TYPE,
    claim_id        GIPI_REMINDER.claim_id%TYPE,
    item            NUMBER,
    note_type       GIPI_REMINDER.note_type%TYPE,
    note_subject    GIPI_REMINDER.note_subject%TYPE,
    note_text       GIPI_REMINDER.note_text%TYPE,
    alarm_user      GIPI_REMINDER.alarm_user%TYPE,
    alarm_flag      GIPI_REMINDER.alarm_flag%TYPE,
    alarm_date      GIPI_REMINDER.alarm_date%TYPE,
    date_created    GIPI_REMINDER.date_created%TYPE,
    user_id         GIPI_REMINDER.user_id%TYPE);

  TYPE gipi_reminder_tab IS TABLE OF gipi_reminder_type;

  FUNCTION get_gipi_reminder_listing(p_user_id GIPI_REMINDER.alarm_user%TYPE)
    RETURN gipi_reminder_tab PIPELINED;

END GIPI_REMINDER_PKG;
/



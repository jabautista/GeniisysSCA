CREATE OR REPLACE PACKAGE CPI.gipir208_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       VARCHAR2 (50),
      cf_com_address   VARCHAR2 (200),
      cf_date          VARCHAR2 (70),
      par_id           gipi_reminder.par_id%TYPE,
      note_type        gipi_reminder.note_type%TYPE,
      note_subject     gipi_reminder.note_subject%TYPE,
      note_text        gipi_reminder.note_text%TYPE,
      alarm_flag       gipi_reminder.alarm_flag%TYPE,
      alarm_date       gipi_reminder.alarm_date%TYPE,
      alarm_user       gipi_reminder.alarm_user%TYPE,
      policy_id        gipi_reminder.policy_id%TYPE,
      claim_id         gipi_reminder.claim_id%TYPE,
      claim_flag       VARCHAR2 (1),
      renew_flag       VARCHAR2 (1),
      par_no           VARCHAR2 (26),
      claim_no         VARCHAR2 (25),
      policy_no        VARCHAR2 (29)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   FUNCTION get_details (
      p_date_opt     VARCHAR2,
      p_as_of_date   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_note_type    VARCHAR2,
      p_alarm_flag   VARCHAR2,
      p_par_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED;
END;
/



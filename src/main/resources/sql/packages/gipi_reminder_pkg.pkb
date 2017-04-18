CREATE OR REPLACE PACKAGE BODY CPI.GIPI_REMINDER_PKG AS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 12, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Function to get mini reminder listing of records
*/
  FUNCTION get_gipi_reminder_listing(p_user_id GIPI_REMINDER.alarm_user%TYPE)
    RETURN gipi_reminder_tab PIPELINED IS

    v_reminder gipi_reminder_type;

  BEGIN
    FOR i IN (
      SELECT par_id, claim_id, 1 item, note_type, note_subject, note_text,
             alarm_user, alarm_flag, alarm_date, date_created, user_id
        FROM gipi_reminder
       WHERE UPPER (alarm_user) = UPPER (p_user_id)
         AND note_type = 'R'
         AND alarm_flag = 'N'
       UNION ALL
      SELECT quote_id, NULL claim_id, 2 item, note_type, note_subject, note_text,
             alarm_user, alarm_flag, alarm_date, date_created, user_id
        FROM gipi_quote_reminder
       WHERE UPPER (alarm_user) = UPPER (p_user_id)
         AND note_type = 'R'
         AND alarm_flag = 'N')
    LOOP
      v_reminder.par_id         := i.par_id;
      v_reminder.claim_id       := i.claim_id;
      v_reminder.item           := i.item;
      v_reminder.note_type      := i.note_type;
      v_reminder.note_subject   := i.note_subject;
      v_reminder.note_text      := i.note_text;
      v_reminder.alarm_user     := i.alarm_user;
      v_reminder.alarm_flag     := i.alarm_flag;
      v_reminder.alarm_date     := i.alarm_date;
      v_reminder.date_created   := i.date_created;
      v_reminder.user_id        := i.user_id;

      PIPE ROW(v_reminder);
    END LOOP;
    RETURN;
  END get_gipi_reminder_listing;

END GIPI_REMINDER_PKG;
/



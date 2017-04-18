CREATE OR REPLACE PACKAGE BODY CPI.gipis208_pkg
AS
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
      RETURN rec_tab PIPELINED
   IS
      v_rec           rec_type;
      v_flag          VARCHAR2 (20);
      v_type          VARCHAR2 (20);
      v_date_filter   VARCHAR2 (32767);
      v_note_type     VARCHAR2 (32767);
      v_alarm_flag    VARCHAR2 (32767);
      v_where         VARCHAR2 (32767);
      v_query         VARCHAR2 (30000);

      TYPE v_bulk_type IS RECORD (
         note_subject   gipi_reminder.note_subject%TYPE,
         alarm_user     gipi_reminder.alarm_user%TYPE,
         alarm_date     gipi_reminder.alarm_date%TYPE,
         user_id        gipi_reminder.user_id%TYPE,
         last_update    gipi_reminder.last_update%TYPE,
         ack_date       gipi_reminder.ack_date%TYPE,
         note_type      gipi_reminder.note_type%TYPE,
         alarm_flag     gipi_reminder.alarm_flag%TYPE,
         policy_no      VARCHAR2 (50),
         policy_id      gipi_vehicle.policy_id%TYPE
      );

      TYPE v_bulk_tab IS TABLE OF v_bulk_type;

      v_rec_bulk      v_bulk_tab;
   BEGIN
      BEGIN
         v_date_filter :=
               '((DECODE ('''
            || p_date_opt
            || ''',
                                       ''dateCreated'', TRUNC (a.date_created),
                                       ''dateAcknowledged'', TRUNC (a.ack_date),
                                       ''alarmDate'', TRUNC (a.alarm_date)
                                     ) >=
                                        TO_DATE ('''
            || p_from_date
            || ''', ''MM-DD-YYYY'')
                            AND (DECODE ('''
            || p_date_opt
            || ''',
                                          ''dateCreated'', TRUNC (a.date_created),
                                          ''dateAcknowledged'', TRUNC (a.ack_date),
                                          ''alarmDate'', TRUNC (a.alarm_date)
                                          ) <=
                                             TO_DATE ('''
            || p_to_date
            || ''', ''MM-DD-YYYY'')
                                  )
                             )
                          OR (DECODE ('''
            || p_date_opt
            || ''',
                                      ''dateCreated'', TRUNC (a.date_created),
                                          ''dateAcknowledged'', TRUNC (a.ack_date),
                                          ''alarmDate'', TRUNC (a.alarm_date)
                                     ) <= TO_DATE ('''
            || p_as_of_date
            || ''', ''MM-DD-YYYY'')
                             )
                         ) AND ';
      END;

      BEGIN
         IF p_note_type = 'R'
         THEN
            v_note_type := 'a.note_type = ''R'' AND ';
         ELSIF p_note_type = 'N'
         THEN
            v_note_type := 'a.note_type = ''N'' AND ';
         ELSE
            v_note_type := 'a.note_type = a.note_type AND ';
         END IF;

         v_where := v_date_filter || v_note_type;
      END;

      BEGIN
         IF p_alarm_flag = 'Y'
         THEN
            v_alarm_flag := 'a.alarm_flag = ''Y''';
         ELSIF p_alarm_flag = 'N'
         THEN
            v_alarm_flag := 'a.alarm_flag = ''N''';
         ELSE
            v_alarm_flag := 'a.alarm_flag = a.alarm_flag';
         END IF;

         v_where := v_where || v_alarm_flag;
      END;

      BEGIN
         IF p_par_id IS NOT NULL
         THEN
            v_where := v_where ||' AND a.par_id = '||p_par_id;       
         END IF;
      END;

      v_query :=
            'SELECT a.note_subject, a.alarm_user, a.alarm_date, a.user_id,
                       a.last_update, a.ack_date, a.note_type, a.alarm_flag,
                          b.line_cd
                       || ''-''
                       || b.subline_cd
                       || ''-''
                       || b.iss_cd
                       || ''-''
                       || TO_CHAR (b.issue_yy, ''09'')
                       || ''-''
                       || TO_CHAR (b.pol_seq_no, ''0000009'')
                       || ''-''
                       || TO_CHAR (b.renew_no, ''09'') policy_no, b.policy_id
                  FROM gipi_reminder a, gipi_polbasic b
                 WHERE a.policy_id = b.policy_id
                        AND UPPER (a.note_subject) LIKE UPPER (NVL ('''
         || p_note_subject
         || ''', ''%'')) AND '
         || v_where;

      EXECUTE IMMEDIATE v_query
      BULK COLLECT INTO v_rec_bulk;

      IF v_rec_bulk.LAST > 0
      THEN
         FOR i IN v_rec_bulk.FIRST .. v_rec_bulk.LAST
         LOOP
            v_rec.policy_id := v_rec_bulk (i).policy_id;
            v_rec.policy_no := v_rec_bulk (i).policy_no;
            v_rec.note_subject := v_rec_bulk (i).note_subject;
            v_rec.alarm_user := v_rec_bulk (i).alarm_user;
            v_rec.alarm_date :=
                            TO_CHAR (v_rec_bulk (i).alarm_date, 'MM-DD-YYYY');
            v_rec.ack_date := TO_CHAR (v_rec_bulk (i).ack_date, 'MM-DD-YYYY');
            v_rec.user_id := v_rec_bulk (i).user_id;
            v_rec.last_update :=
               TO_CHAR (v_rec_bulk (i).last_update, 'MM-DD-YYYY HH:MI:SS AM');

            IF v_rec_bulk (i).note_type = 'R'
            THEN
               v_type := 'Reminder';
            ELSE
               v_type := 'Note';
            END IF;

            IF v_rec_bulk (i).alarm_flag = 'Y'
            THEN
               v_flag := 'Ok /Acknowledged';
            ELSIF v_rec_bulk (i).alarm_flag = 'N'
            THEN
               v_flag := 'New';
            ELSE
               v_flag := NULL;
            END IF;

            v_rec.dsp_type_status := v_type || '/' || v_flag;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;

      RETURN;
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giuts034_pkg
AS
   FUNCTION get_reminder_list (
      p_par_id     gipi_parlist.par_id%TYPE,
      p_claim_id   gicl_claims.claim_id%TYPE
   )
      RETURN giuts034_dtls_tab PIPELINED
   AS
      v_list   giuts034_dtls_type;
   BEGIN
      FOR i IN (SELECT   alarm_flag, renew_flag, note_type, note_subject,
                         note_text, alarm_user, alarm_date, ack_date,
                         user_id, last_update
                    FROM gipi_reminder
                   WHERE 1 = 1 AND par_id = p_par_id OR claim_id = p_claim_id
                ORDER BY note_id)
      LOOP
         v_list.note_type := i.note_type;
         v_list.alarm_flag := i.alarm_flag;
         v_list.renew_flag := i.renew_flag;
         v_list.note_subject := i.note_subject;
         v_list.note_text := i.note_text;
         v_list.alarm_user := i.alarm_user;
         v_list.alarm_date := i.alarm_date;
         v_list.ack_date := i.ack_date;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                          TO_CHAR (i.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
         v_list.db_tag := 'Y';
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_reminder_list;

   FUNCTION get_alarm_users_lov (p_alarm_user VARCHAR2)
      RETURN alarm_users_lov_tab PIPELINED
   AS
      v_list   alarm_users_lov_type;
   BEGIN
      FOR i IN (SELECT user_id, user_name
                  FROM giis_users
                 WHERE     active_flag = 'Y'
                       AND workflow_tag = 'Y'
                       AND UPPER (user_id) LIKE
                                    UPPER (NVL (p_alarm_user || '%', user_id))
                    OR UPPER (user_name) LIKE
                                  UPPER (NVL (p_alarm_user || '%', user_name)))
      LOOP
         v_list.user_id := i.user_id;
         v_list.user_name := i.user_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_alarm_users_lov;

   PROCEDURE insert_reminder (p_reminder gipi_reminder%ROWTYPE)
   IS
      v_reminder   VARCHAR2 (2);
      v_note_id    gipi_reminder.note_id%TYPE;
      v_policy_id  gipi_reminder.policy_id%TYPE;    -- SR-19555 : shan 07.07.2015
   BEGIN
        -- based on GIPI_REMINDER PRE_INSERT trigger in fmb 3/19/2015 11:19:00 version ::: SR-19555 : shan 07.07.2015
        IF p_reminder.claim_id IS NOT NULL AND p_reminder.policy_id IS NULL THEN
            BEGIN	
                SELECT policy_id 
                  INTO v_policy_id 
                  FROM gipi_polbasic 
                 WHERE par_id = p_reminder.PAR_ID; 
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_policy_id :=NULL;   
            END;
        END IF;
        -- end 07.07.2015
      
      BEGIN
         SELECT NVL (MAX (note_id) + 1, 1)
           INTO v_note_id
           FROM gipi_reminder;
      END;

      INSERT INTO gipi_reminder
                  (par_id, claim_id, note_id,
                   note_type, note_subject,
                   note_text, alarm_user,
                   alarm_date, alarm_flag, date_created, renew_flag
                   , policy_id) -- based on GIPI_REMINDER PRE_INSERT trigger in fmb 3/19/2015 11:19:00 version ::: SR-19555 : shan 07.07.2015
           VALUES (p_reminder.par_id, p_reminder.claim_id, v_note_id,
                   p_reminder.note_type, p_reminder.note_subject,
                   p_reminder.note_text, p_reminder.alarm_user,
                   p_reminder.alarm_date, 'N', SYSDATE, p_reminder.renew_flag
                   , v_policy_id);  -- based on GIPI_REMINDER PRE_INSERT trigger in fmb 3/19/2015 11:19:00 version ::: SR-19555 : shan 07.07.2015
   END insert_reminder;

   FUNCTION validate_alarm_user (p_alarm_user giis_users.user_id%TYPE)
      RETURN validate_alarm_user_tab PIPELINED
   IS
      v_list   validate_alarm_user_type;
   BEGIN
      BEGIN
         SELECT DISTINCT user_id, '1'
                    INTO v_list.user_id, v_list.COUNT
                    FROM giis_users
                   WHERE     active_flag = 'Y'
                         AND workflow_tag = 'Y'
                         AND UPPER (user_id) LIKE
                                           UPPER (NVL (p_alarm_user, user_id))
                      OR UPPER (user_name) LIKE
                                         UPPER (NVL (p_alarm_user, user_name));
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.user_id := '';
            v_list.COUNT := 0;
         WHEN TOO_MANY_ROWS
         THEN
            v_list.user_id := '';
            v_list.COUNT := 0;
      END;

      PIPE ROW (v_list);
      RETURN;
   END validate_alarm_user;
  
   
    -- start SR-19555 : shan 07.07.2015
    FUNCTION get_claim_par_id(
        p_claim_id      GICL_CLAIMS.CLAIM_ID%TYPE
    ) RETURN NUMBER
    AS
        v_par_id    GIPI_POLBASIC.PAR_ID%TYPE;
    BEGIN
        FOR i IN (SELECT par_id
                    FROM GICL_CLAIMS a,
                         GIPI_POLBASIC b
                   WHERE a.claim_id = p_claim_id
                     AND a.LINE_CD = b.LINE_CD
                     AND a.SUBLINE_CD = b.SUBLINE_CD
                     AND a.POL_ISS_CD = b.ISS_CD
                     AND a.ISSUE_YY = b.ISSUE_YY
                     AND a.POL_SEQ_NO = b.POL_SEQ_NO
                     AND a.RENEW_NO = b.RENEW_NO
                     AND b.ENDT_SEQ_NO = 0 )
        LOOP
            v_par_id    := i.par_id;
        END LOOP;
        
        RETURN v_par_id;
    END get_claim_par_id;
    -- end SR-19555 : shan 07.07.2015
END;
/



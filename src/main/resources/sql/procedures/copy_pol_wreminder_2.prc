DROP PROCEDURE CPI.COPY_POL_WREMINDER_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wreminder_2(
    p_old_pol_id    gipi_reminder.policy_id%TYPE,
    p_new_par_id    gipi_reminder.par_id%TYPE,
    p_user          gipi_reminder.user_id%TYPE
)
IS
   v_row        NUMBER;
   item_exist   VARCHAR2 (1) := 'N';
   note_id      NUMBER       := 0;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wreminder program unit 
  */
   FOR wc IN (SELECT note_type, note_subject, note_text, renew_flag
                FROM gipi_reminder
               WHERE policy_id = p_old_pol_id
                 AND renew_flag = 'Y'
                 AND note_type = 'N')
   LOOP
      note_id := note_id + 1;
      item_exist := 'N';

      FOR chk IN (SELECT note_type, note_subject, note_text, renew_flag
                    FROM gipi_reminder
                   WHERE par_id = p_new_par_id)
      LOOP
         item_exist := 'Y';
      END LOOP;

      IF item_exist = 'N'
      THEN
         FOR wc2 IN (SELECT note_type, note_subject, note_text, renew_flag
                       FROM gipi_reminder
                      WHERE policy_id = p_old_pol_id
                        AND renew_flag = 'Y'
                        AND note_type = 'N')
         LOOP
            wc.note_type := wc2.note_type;
            wc.note_subject := wc2.note_subject;
            wc.note_text := wc2.note_text;
            wc.renew_flag := wc2.renew_flag;
         END LOOP;

         INSERT INTO gipi_reminder
                     (par_id, note_id, note_type,
                      note_subject, note_text, renew_flag, date_created,
                      user_id, last_update
                     )
              VALUES (p_new_par_id, note_id, wc.note_type,
                      wc.note_subject, wc.note_text, wc.renew_flag, SYSDATE,
                      p_user, SYSDATE
                     );
      --CLEAR_MESSAGE;
      --MESSAGE('Copying policy notes ...',NO_ACKNOWLEDGE);
      --SYNCHRONIZE;
      END IF;
   END LOOP;
END;
/



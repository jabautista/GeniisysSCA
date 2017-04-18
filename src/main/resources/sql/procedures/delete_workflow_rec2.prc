DROP PROCEDURE CPI.DELETE_WORKFLOW_REC2;

CREATE OR REPLACE PROCEDURE CPI.delete_workflow_rec2 (
   p_module_id   IN   VARCHAR2,
   p_user        IN   VARCHAR2,
   p_col_value   IN   VARCHAR2
)
IS
   v_tran_id   gipi_user_events.tran_id%TYPE;
BEGIN
   /*
   **  Created by   : Irwin tabisora
   **  Date Created : April 11, 2011
   **  Reference By : WORKLIB library
   **  Description  : DELETE_WORKFLOW_REC program unit
   */
   FOR a_rec IN (SELECT b.event_user_mod, c.event_col_cd
                   FROM giis_events_column c,
                        giis_event_mod_users b,
                        giis_event_modules a
                  WHERE 1 = 1
                    AND c.event_cd = a.event_cd
                    AND c.event_mod_cd = a.event_mod_cd
                    AND b.event_mod_cd = a.event_mod_cd
                    --AND b.userid = p_user
                    AND a.module_id = p_module_id)
   LOOP
      FOR b_rec IN (SELECT b.col_value, b.tran_id, b.event_col_cd,
                           b.event_user_mod, b.SWITCH, b.user_id
                      FROM gipi_user_events b
                     WHERE b.event_user_mod = a_rec.event_user_mod
                       AND b.event_col_cd = a_rec.event_col_cd)
      LOOP
         IF b_rec.col_value = p_col_value
         THEN
            BEGIN
               INSERT INTO gipi_user_events_hist
                           (event_user_mod, event_col_cd,
                            tran_id, col_value, date_received, old_userid,
                            new_userid
                           )
                    VALUES (b_rec.event_user_mod, b_rec.event_col_cd,
                            b_rec.tran_id, b_rec.col_value, SYSDATE, USER,
                            '-'
                           );

               DELETE FROM gipi_user_events
                     WHERE event_user_mod = b_rec.event_user_mod
                       AND event_col_cd = b_rec.event_col_cd
                       AND tran_id = b_rec.tran_id;
            END;
         ELSE
            IF b_rec.SWITCH = 'N' AND b_rec.user_id = p_user
            THEN
               UPDATE gipi_user_events
                  SET SWITCH = 'Y'
                WHERE event_user_mod = b_rec.event_user_mod
                  AND event_col_cd = b_rec.event_col_cd
                  AND tran_id = b_rec.tran_id;
            END IF;
         END IF;
      END LOOP;
   END LOOP;
END;
/



DROP PROCEDURE CPI.CREATE_TRANSFER_WORKFLOW_REC2;

CREATE OR REPLACE PROCEDURE CPI.create_transfer_workflow_rec2 (
   p_event_cd    IN       GIPI_USER_EVENTS.event_cd%TYPE,
   p_user        IN       VARCHAR2,
   p_col_value   IN       VARCHAR2,
   p_remarks     IN       GIPI_USER_EVENTS.remarks%TYPE,
   p_status      IN       GIPI_USER_EVENTS.status%TYPE,
   p_date_due    IN       GIPI_USER_EVENTS.date_due%TYPE,
   p_tran_dtl    IN       VARCHAR2,
   p_tran_id     IN OUT   NUMBER,
   p_message     OUT      VARCHAR2
)
IS
   v_event_user_mod       gipi_user_events.event_user_mod%TYPE;
   v_event_col_cd         gipi_user_events.event_col_cd%TYPE;
   v_event_user_mod_old   gipi_user_events.event_user_mod%TYPE;
   v_event_col_cd_old     gipi_user_events.event_col_cd%TYPE;
   v_tran_id              gipi_user_events.tran_id%TYPE;
   v_event_mod_cd         giis_event_modules.event_mod_cd%TYPE;   
   v_count                NUMBER;
   v_msgr                 NUMBER                 := giisp.v ('WORKFLOW_MSGR');
   v_attach               VARCHAR2 (32000);
   
   v_date_received        DATE;   
   v_event_type           GIIS_EVENTS.event_type%TYPE;
   v_event_desc           GIIS_EVENTS.event_desc%TYPE;
   v_multiple_assign_sw   GIIS_EVENTS.multiple_assign_sw%TYPE;
BEGIN
   SELECT event_type, event_desc, multiple_assign_sw
     INTO v_event_type, v_event_desc, v_multiple_assign_sw
     FROM giis_events
    WHERE event_cd = p_event_cd;

   BEGIN
      FOR x IN
         (
--edited by jeff 11/06/2007 @ FPAC transform ordinary select statement into for statement
          SELECT b.event_user_mod event_user_mod,
                 c.event_col_cd event_col_cd
            -- INTO v_event_user_mod, v_event_col_cd
          FROM   giis_events_column c,
                 giis_event_mod_users b,
                 giis_event_modules a,
                 giis_events d
           WHERE 1 = 1
             AND c.event_cd = a.event_cd
             AND c.event_mod_cd = a.event_mod_cd
             AND b.event_mod_cd = a.event_mod_cd
             --AND b.userid = p_user  --A.R.C. 01.27.2006
             AND b.passing_userid = NVL(giis_users_pkg.app_user, USER)                   --A.R.C. 01.27.2006
             AND NVL (b.userid, p_user) = p_user           --A.R.C. 01.27.2006
             AND a.event_cd = d.event_cd
             AND d.event_cd = p_event_cd)
      LOOP
         v_event_user_mod := x.event_user_mod;
         v_event_col_cd := x.event_col_cd;
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_message := 'Invalid user.';
         RETURN;
   --RAISE FORM_TRIGGER_FAILURE;
   END;

   BEGIN
      --A.R.C. 08.07.2006
      IF p_tran_id IS NULL
      THEN
         SELECT workflow_tran_id_s.NEXTVAL
           INTO v_tran_id
           FROM DUAL;
         p_tran_id := v_tran_id;
      ELSE
         v_tran_id := p_tran_id;
         --p_tran_id := NULL;
      END IF;
   END;

   BEGIN
      /*    SELECT COUNT(*)
        INTO v_count
        FROM gipi_user_events
       WHERE event_user_mod = v_event_user_mod
         AND event_col_cd = v_event_col_cd
         AND col_value = p_col_value
         AND rownum = 1;*/ --change count(*) to select 1 ging071307
      SELECT 1
        INTO v_count
        FROM gipi_user_events
       WHERE event_user_mod = v_event_user_mod
         AND event_col_cd = v_event_col_cd
         AND col_value = p_col_value
         AND ROWNUM = 1;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_count := 0;
   END;

   IF v_count = 0
   THEN
      v_date_received := DELAY (v_event_user_mod_old, v_event_col_cd_old, v_tran_id);
                                                          --A.R.C. 01.15.2007
      --A.R.C. 02.07.2007
      --add status and date_due
      --pass value to v_disp_tran_id to be used in displaying the message transaction completed
      --p_disp_tran_id := v_tran_id;

      INSERT INTO gipi_user_events
                  (event_user_mod, event_col_cd, tran_id, SWITCH,
                   col_value, remarks, status, date_due
                  )
           VALUES (v_event_user_mod, v_event_col_cd, v_tran_id, 'N',
                   p_col_value, p_remarks, p_status, p_date_due
                  );

      BEGIN
         FOR y IN
            (
--edited by jeff 11/06/2007 @ FPAC transform ordinary select statement into for statement
             SELECT b.event_user_mod event_user_mod,
                    c.event_col_cd event_col_cd
               --INTO v_event_user_mod_old, v_event_col_cd_old
             FROM   giis_events_column c,
                    giis_event_mod_users b,
                    giis_event_modules a,
                    giis_events d
              WHERE 1 = 1
                AND c.event_cd = a.event_cd
                AND c.event_mod_cd = a.event_mod_cd
                AND b.event_mod_cd = a.event_mod_cd
                --AND b.userid = USER  --A.R.C. 01.27.2006
                AND b.passing_userid =
                        NVL (giis_users_pkg.app_user, USER)
                                                           --A.R.C. 01.27.2006
                AND NVL (b.userid, p_user) = p_user        --A.R.C. 01.27.2006
                AND a.event_cd = d.event_cd
                AND d.event_cd = p_event_cd)
         LOOP
            v_event_user_mod_old := y.event_user_mod;
            v_event_col_cd_old := y.event_col_cd;
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_message := 'Invalid user.';
            RETURN;
      --RAISE FORM_TRIGGER_FAILURE;
      END;

      INSERT INTO gipi_user_events_hist
                  (event_user_mod, event_col_cd, tran_id,
                   col_value, date_received, old_userid,
                   new_userid, remarks
                  )
           VALUES (v_event_user_mod_old, v_event_col_cd_old, v_tran_id,
                   p_col_value, SYSDATE, NVL (giis_users_pkg.app_user, USER),
                   p_user, p_remarks
                  );

      --CREATE_FILE(:event_list.event_cd||','||p_user||', '||p_col_value);
      IF v_event_type IN (3,4,5) AND NVL(v_multiple_assign_sw,'Y') = 'N' THEN
        EXECUTE IMMEDIATE(WF.WORKFLOW_UPDATE_USER(p_event_cd,p_user,p_col_value));      
        --update_user (p_event_cd, p_user, p_col_value);
      END IF;

      --A.R.C. 04.24.2006
      IF giisp.v ('WORKFLOW_MSGR') IS NOT NULL
      THEN
         --SHOW_VIEW('WARNING');
         IF v_event_type = 5
            AND wf.get_workflow_tran_list (p_event_cd) IS NULL
         THEN
            /** A.R.C. mod1 03.07.2007
            * replaced the code to include option for e-mail
            */
            --HOST(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_user||' "'||user||' assigned a new transaction.'||' - '||:event_list.event_desc||'" -noactivate');
            IF (v_msgr IN (1, 3))
            THEN
--               HOST (   wf.get_popup_dir
--                     || 'realpopup.exe -send '
--                     || p_user
--                     || ' "'
--                     || USER
--                     || ' assigned a new transaction.'
--                     || ' - '
--                     || v_event_desc
--                     || '" -noactivate'
--                    );
                null;
            END IF;

            IF (v_msgr IN (2, 3))
            THEN
               FOR c1 IN (SELECT    giisp.v ('WF_PATH')
                                 || tran_id
                                 || '\'
                                 || file_name attach
                            FROM gue_attach
                           WHERE tran_id = v_tran_id)
               LOOP
                  IF v_attach IS NULL
                  THEN
                     v_attach := c1.attach;
                  ELSE
                     v_attach := v_attach || '///' || c1.attach;
                  END IF;
               END LOOP;

--               send_email (get_email (p_user),
--                           get_email (USER),
--                           NULL,
--                           NULL,
--                           v_event_desc,
--                              USER
--                           || ' assigned a new transaction.'
--                           || ' - '
--                           || v_event_desc
--                           || ' '
--                           || CHR (13)
--                           || 'Transaction ID is '
--                           || v_tran_id
--                           || CHR (13)
--                           || p_remarks,
--                           v_attach
--                          );
            END IF;
         --end of mod1 03.07.2007
         ELSE
               /** A.R.C. mod2 03.07.2007
               * replaced the code to include option for e-mail
               */
            --HOST(WF.GET_POPUP_DIR||'realpopup.exe -send '||p_user||' "'||user||' assigned a new transaction.'||' - '||:event_list.event_desc||' '||:list_blk.tran_dtl||'" -noactivate');
            IF (v_msgr IN (1, 3))
            THEN
--               HOST (   wf.get_popup_dir
--                     || 'realpopup.exe -send '
--                     || p_user
--                     || ' "'
--                     || USER
--                     || ' assigned a new transaction.'
--                     || ' - '
--                     || v_event_desc
--                     || ' '
--                     || p_tran_dtl
--                     || '" -noactivate'
--                    );
                NULL;
            END IF;

            IF (v_msgr IN (2, 3))
            THEN
               FOR c1 IN (SELECT    giisp.v ('WF_PATH')
                                 || tran_id
                                 || '\'
                                 || file_name attach
                            FROM gue_attach
                           WHERE tran_id = v_tran_id)
               LOOP
                  IF v_attach IS NULL
                  THEN
                     v_attach := c1.attach;
                  ELSE
                     v_attach := v_attach || '///' || c1.attach;
                  END IF;
               END LOOP;

               --Send_Mail( get_email(p_user),get_email(user),:event_list.event_desc,user||' assigned a new transaction.'||' - '||:event_list.event_desc||' '||CHR(13)||variable.v_remarks );
--               send_email (get_email (p_user),
--                           get_email (USER),
--                           NULL,
--                           NULL,
--                           v_event_desc,
--                              USER
--                           || ' assigned a new transaction.'
--                           || ' - '
--                           || v_event_desc
--                           || ' '
--                           || CHR (13)
--                           || 'Transaction ID is '
--                           || v_tran_id
--                           || CHR (13)
--                           || p_remarks,
--                           v_attach
--                          );
            END IF;
         --end of mod2 03.07.2007
         END IF;

         --HIDE_VIEW ('WARNING');
      END IF;
   END IF;
END;
/



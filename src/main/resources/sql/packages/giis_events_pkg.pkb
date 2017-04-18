CREATE OR REPLACE PACKAGE BODY CPI.giis_events_pkg
AS
/**
* Created by: Andrew Robes
* Date Created : 07.07.2011
* Referenced By : (WORKFLOW - Workflow)
* Description : Retrieves the giis_events records
*/
   FUNCTION get_giis_events_listing (p_find_text VARCHAR2)
      RETURN giis_events_tab PIPELINED
   IS
      v_events   giis_events_type;
   BEGIN
      FOR i IN (SELECT   a.event_cd, a.event_desc, a.event_type,
                         a.multiple_assign_sw
                    FROM giis_events a
                   WHERE a.event_type IN (3, 4, 5)
                     AND (   TO_CHAR (a.event_cd) LIKE
                                                 NVL (p_find_text, a.event_cd)
                          OR UPPER (a.event_desc) LIKE
                                       UPPER (NVL (p_find_text, a.event_desc))
                         )
                ORDER BY a.event_desc)
      LOOP
         v_events.event_cd := i.event_cd;
         v_events.event_desc := i.event_desc;
         v_events.event_type := i.event_type;
         v_events.multiple_assign_sw := i.multiple_assign_sw;
         PIPE ROW (v_events);
      END LOOP;

      RETURN;
   END get_giis_events_listing;

/**
* Created by: Andrew Robes
* Date Created : 07.12.2011
* Referenced By : (WORKFLOW - Workflow)
* Description : Retrieves the giis_events records
*/
   FUNCTION get_giis_events_listing2
      RETURN giis_events_tab PIPELINED
   IS
      v_events   giis_events_type;
   BEGIN
      FOR i IN (SELECT   a.event_cd, a.event_desc, a.event_type,
                         a.receiver_tag, c.rv_meaning receiver_tag_desc,
                         a.user_id, a.last_update,
                         b.rv_meaning event_type_desc, multiple_assign_sw,
                         remarks
                    FROM giis_events a, cg_ref_codes b, cg_ref_codes c
                   WHERE b.rv_domain = 'GIIS_EVENTS.EVENT_TYPE'
                     AND b.rv_low_value = a.event_type
                     AND c.rv_domain = 'GIIS_EVENTS.RECEIVER_TAG'
                     AND c.rv_low_value = a.receiver_tag
                ORDER BY a.event_cd)
      LOOP
         v_events.event_cd := i.event_cd;
         v_events.event_desc := i.event_desc;
         v_events.event_type := i.event_type;
         v_events.receiver_tag := i.receiver_tag;
         v_events.receiver_tag_desc := i.receiver_tag_desc;
         v_events.event_type_desc := i.event_type_desc;
         v_events.multiple_assign_sw := i.multiple_assign_sw;
         v_events.remarks := i.remarks;
         v_events.user_id := i.user_id;
         v_events.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_events.event_module_cond := 'N';

         FOR a IN (SELECT 1
                     FROM giis_event_modules
                    WHERE event_cd = NVL (i.event_cd, event_cd))
         LOOP
            v_events.event_module_cond := 'Y';
            EXIT;
         END LOOP;

         PIPE ROW (v_events);
      END LOOP;

      RETURN;
   END get_giis_events_listing2;

/**
* Created by: Andrew Robes
* Date Created : 07.25.2011
* Referenced By : (WORKFLOW - Workflow)
* Description : Insert the new event record or updates the record if existing
*/
   PROCEDURE set_giis_event (p_event giis_events%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_events
         USING DUAL
         ON (event_cd = p_event.event_cd)
         WHEN NOT MATCHED THEN
            INSERT (event_desc, event_type, remarks, multiple_assign_sw,
                    receiver_tag, user_id, last_update)
            VALUES (p_event.event_desc, p_event.event_type, p_event.remarks,
                    p_event.multiple_assign_sw, p_event.receiver_tag,
                    p_event.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET event_desc = p_event.event_desc,
                   event_type = p_event.event_type,
                   remarks = p_event.remarks,
                   multiple_assign_sw = p_event.multiple_assign_sw,
                   receiver_tag = p_event.receiver_tag,
                   user_id = p_event.user_id, last_update = SYSDATE
            ;
   END set_giis_event;

/**
* Created by: Andrew Robes
* Date Created : 07.25.2011
* Referenced By : (WORKFLOW - Workflow)
* Description : Procedure to delete an event record with the specified event_cd
*/
   PROCEDURE del_giis_event (p_event_cd giis_events.event_cd%TYPE)
   IS
   BEGIN
      DELETE FROM giis_events
            WHERE event_cd = p_event_cd;
   END del_giis_event;

/**
* Created by: Andrew Robes
* Date Created : 03.06.2012
* Referenced By :
* Description : Function to call the create_transfer_workflow_rec depending on the parameters: module_id, user_id, event_desc
*/
   PROCEDURE create_transfer_events (
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_event_desc         giis_events.event_desc%TYPE,
      p_col_value          VARCHAR2,
      p_info               VARCHAR2,
      p_delimiter          VARCHAR2,
      p_messages     OUT   VARCHAR2
   )
   IS
      v_msg             VARCHAR2 (2000);
      v_msg_alert       VARCHAR2 (1000);
      v_workflow_msgr   giis_parameters.param_value_v%TYPE
                                                 := giisp.v ('WORKFLOW_MSGR');
      v_popup_dir       VARCHAR2 (500)                    := wf.get_popup_dir;
   BEGIN
      FOR c1 IN (SELECT b.userid, d.event_desc
                   FROM giis_events_column c,
                        giis_event_mod_users b,
                        giis_event_modules a,
                        giis_events d
                  WHERE 1 = 1
                    AND c.event_cd = a.event_cd
                    AND c.event_mod_cd = a.event_mod_cd
                    AND b.event_mod_cd = a.event_mod_cd
                    AND b.passing_userid = p_user_id
                    AND a.module_id = p_module_id
                    AND a.event_cd = d.event_cd
                    AND UPPER (d.event_desc) = UPPER (p_event_desc))
      LOOP
         create_transfer_workflow_rec (c1.event_desc,
                                       p_module_id,
                                       c1.userid,
                                       p_col_value,
                                       p_info,
                                       v_msg_alert,
                                       v_msg,
                                       p_user_id
                                      );

         IF v_msg_alert IS NOT NULL
         THEN
            raise_application_error (-20001, v_msg_alert);
         ELSE
            IF v_workflow_msgr IS NOT NULL
            THEN
               p_messages := p_messages || c1.userid || p_delimiter;
            END IF;
         END IF;
      END LOOP;
   END;

   PROCEDURE val_del_giis_events (p_event_cd giis_events.event_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT 1
                    FROM giis_events_column
                   WHERE event_cd = p_event_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_EVENTS while dependent record(s) in GIIS_EVENTS_COLUMN exists.'
            );
      END IF;
   END;

   FUNCTION get_giis_events_column (p_event_cd giis_events.event_cd%TYPE)
      RETURN giis_events_column_tab PIPELINED
   IS
      v_rec   giis_events_column_type;
   BEGIN
      FOR i IN (SELECT DISTINCT event_cd, event_col_cd, table_name,
                                column_name, remarks, user_id, last_update
                           FROM giis_events_column
                          WHERE event_cd = p_event_cd)
      LOOP
         v_rec.event_cd := i.event_cd;
         v_rec.event_col_cd := i.event_col_cd;
         v_rec.table_name := i.table_name;
         v_rec.column_name := i.column_name;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.col_module_cond := 'N';

         FOR j IN (SELECT 1
                     FROM giis_dsp_column
                    WHERE 1 = 1
                      AND table_name = i.table_name
                      AND column_name = i.column_name)
         LOOP
            v_rec.col_module_cond := 'Y';
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_all_tab_cols_list (p_keyword VARCHAR2)
      RETURN all_tab_cols_tab PIPELINED
   IS
      v_rec   all_tab_cols_type;
   BEGIN
      FOR i IN (SELECT table_name, column_name
                  FROM all_tab_cols
                 WHERE owner = 'CPI'
                   AND hidden_column = 'NO'
                   AND (   UPPER (table_name) LIKE
                              '%' || UPPER (NVL (p_keyword, table_name))
                              || '%'
                        OR UPPER (column_name) LIKE
                              '%' || UPPER (NVL (p_keyword, column_name))
                              || '%'
                       ))
      LOOP
         v_rec.table_name := i.table_name;
         v_rec.column_name := i.column_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_all_tab_cols_list2 (p_table_name VARCHAR2, p_keyword VARCHAR2)
      RETURN all_tab_cols_tab PIPELINED
   IS
      v_rec   all_tab_cols_type;
   BEGIN
      FOR i IN (SELECT column_name
                  FROM all_tab_cols
                 WHERE owner = 'CPI'
                   AND hidden_column = 'NO'
                   AND table_name LIKE p_table_name
                   AND (UPPER (column_name) LIKE
                             '%' || UPPER (NVL (p_keyword, column_name))
                             || '%'
                       ))
      LOOP
         v_rec.column_name := i.column_name;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_giis_events_column (p_rec giis_events_column%ROWTYPE)
   IS
      v_event_col_cd   NUMBER (10);
      v_count          NUMBER      := 1;
   BEGIN
      IF p_rec.table_name IS NOT NULL AND p_rec.column_name IS NOT NULL
      THEN
         BEGIN
            SELECT COUNT (*)
              INTO v_count
              FROM giis_events_column
             WHERE event_cd = p_rec.event_cd
               AND table_name = p_rec.table_name
               AND column_name = p_rec.column_name;
         END;

         IF v_count = 0
         THEN
            FOR a IN (SELECT events_col_cd_seq.NEXTVAL event_col_cd
                        FROM DUAL)
            LOOP
               v_event_col_cd := a.event_col_cd;
            END LOOP;

            FOR a IN (SELECT event_cd, event_mod_cd
                        FROM giis_event_modules
                       WHERE event_cd = p_rec.event_cd)
            LOOP
               INSERT INTO giis_events_column
                           (event_col_cd, event_mod_cd, event_cd,
                            table_name, column_name,
                            remarks
                           )
                    VALUES (v_event_col_cd, a.event_mod_cd, p_rec.event_cd,
                            p_rec.table_name, p_rec.column_name,
                            p_rec.remarks
                           );
            END LOOP;
         END IF;
      END IF;
   END;

   PROCEDURE del_giis_events_column (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_events_column
            WHERE event_col_cd = p_event_col_cd;
   END;

   PROCEDURE val_del_giis_events_column (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT 1
                    FROM giis_events_display
                   WHERE event_col_cd = p_event_col_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_EVENTS_COLUMN while dependent record(s) in GIIS_EVENTS_DISPLAY exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_giis_events_column (
      p_table_name    giis_events_column.table_name%TYPE,
      p_column_name   giis_events_column.column_name%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_events_column
                 WHERE table_name = p_table_name
                   AND column_name = p_column_name)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same table_name and column_name.'
            );
      END IF;
   END;

   FUNCTION get_giis_events_display (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   )
      RETURN giis_events_display_tab PIPELINED
   IS
      v_rec   giis_events_display_type;
   BEGIN
      FOR i IN (SELECT DISTINCT dsp_col_id, event_col_cd
                           FROM giis_events_display
                          WHERE event_col_cd = p_event_col_cd)
      LOOP
         v_rec.dsp_col_id := i.dsp_col_id;
         v_rec.event_col_cd := i.event_col_cd;
         v_rec.rv_meaning := NULL;

         FOR j IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = 'GIIS_DSP_COLUMN.DSP_COL_ID'
                      AND rv_low_value = i.dsp_col_id)
         LOOP
            v_rec.rv_meaning := j.rv_meaning;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_giis_events_display (
      p_event_col_cd   giis_events_display.event_col_cd%TYPE,
      p_dsp_col_id     giis_events_display.dsp_col_id%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_events_display
                 WHERE dsp_col_id = p_dsp_col_id
                   AND event_col_cd = p_event_col_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same dsp_col_id.'
            );
      END IF;
   END;

   PROCEDURE set_giis_events_display (p_rec giis_events_display%ROWTYPE)
   IS
   BEGIN
      INSERT INTO giis_events_display
                  (event_col_cd, dsp_col_id
                  )
           VALUES (p_rec.event_col_cd, p_rec.dsp_col_id
                  );
   END;

   PROCEDURE del_giis_events_display (
      p_event_col_cd   giis_events_display.event_col_cd%TYPE,
      p_dsp_col_id     giis_events_display.dsp_col_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_events_display
            WHERE event_col_cd = p_event_col_cd AND dsp_col_id = p_dsp_col_id;
   END;
END giis_events_pkg;
/



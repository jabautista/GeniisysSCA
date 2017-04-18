CREATE OR REPLACE PACKAGE BODY CPI.giiss168_pkg
AS
   FUNCTION get_events_lov
      RETURN events_lov_tab PIPELINED
   IS
      v_list events_lov_type;
   BEGIN
      FOR i IN (SELECT event_cd, event_desc, receiver_tag
                  FROM giis_events
              ORDER BY 1)
      LOOP
         v_list.event_cd := i.event_cd;
         v_list.event_desc := i.event_desc;
         v_list.receiver_tag := i.receiver_tag;
         PIPE ROW(v_list);
      END LOOP;
   END get_events_lov;
   
   FUNCTION get_giis_event_modules(p_event_cd VARCHAR2)
      RETURN event_module_tab PIPELINED
    IS
      v_list event_module_type;
    BEGIN
       FOR i IN (
          SELECT *
            FROM giis_event_modules 
         WHERE event_cd = p_event_cd
      ORDER BY 1)
      LOOP
         v_list.event_mod_cd := i.event_mod_cd;
         v_list.event_cd := i.event_cd;
         v_list.module_id := i.module_id;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.accpt_mod_id := i.accpt_mod_id;
         
         BEGIN
            SELECT module_desc
              INTO v_list.module_desc
              FROM giis_modules
             WHERE module_id = i.module_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.module_desc := NULL;
         END;
         
         BEGIN
            SELECT module_desc
              INTO v_list.accpt_mod_desc
              FROM giis_modules
             WHERE module_id = i.accpt_mod_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.accpt_mod_desc := NULL;
         END;
        
         PIPE ROW(v_list);
      END LOOP;
      RETURN;
    END get_giis_event_modules; 
    
    FUNCTION get_module_lov
       RETURN module_tab PIPELINED
    IS
      v_list module_type;
    BEGIN
      FOR i IN (SELECT module_id, module_desc
                  FROM giis_modules
              ORDER BY module_id)
      LOOP
         v_list.module_id := i.module_id;
         v_list.module_desc := i.module_desc;
         PIPE ROW(v_list);
      END LOOP;
    END get_module_lov;
    
    FUNCTION get_selected_modules (p_event_cd VARCHAR2)
       RETURN VARCHAR2
    IS
      v_temp VARCHAR2(32767);
    BEGIN
      FOR i IN (SELECT module_id
                  FROM giis_event_modules
                 WHERE event_cd = p_event_cd)
      LOOP
         v_temp := TRIM(v_temp) || TRIM(i.module_id) || ',';
      END LOOP;
      RETURN v_temp;
    END get_selected_modules;
    
    PROCEDURE save_event_modules (p_rec giis_event_modules%ROWTYPE)
    IS
      v_event_mod_cd NUMBER(10);
    BEGIN
      
      IF p_rec.event_mod_cd = 0 THEN
         BEGIN
            SELECT events_mod_seq.NEXTVAL
              INTO v_event_mod_cd
              FROM DUAL;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#E#There is no value fetched in events_mod_seq.NEXTVAL');        
         END;
         
         INSERT INTO giis_event_modules
              VALUES (v_event_mod_cd, p_rec.event_cd, 
                      p_rec.module_id, p_rec.user_id, SYSDATE,
                      p_rec.accpt_mod_id);
      ELSE
         UPDATE giis_event_modules
            SET module_id = p_rec.module_id,
                user_id = p_rec.user_id,
                last_update = SYSDATE,
                accpt_mod_id = p_rec.accpt_mod_id
          WHERE event_mod_cd = p_rec.event_mod_cd;
      END IF;
    
    END save_event_modules;
    
   FUNCTION get_passing_user (p_event_mod_cd VARCHAR2)
      RETURN passing_user_tab PIPELINED
   IS
      v_list passing_user_type;
   BEGIN
      FOR i IN (SELECT DISTINCT b.event_mod_cd, b.passing_userid, a.user_name
                  FROM giis_event_mod_users b, giis_users a
                 WHERE a.user_id = b.passing_userid
                   AND b.event_mod_cd = p_event_mod_cd
              ORDER BY 2)
      LOOP
         v_list.event_mod_cd := i.event_mod_cd;
         v_list.passing_userid := i.passing_userid;
         v_list.user_name := i.user_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_passing_user;
   
   FUNCTION get_receiving_user (p_event_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN receiving_user_tab PIPELINED
   IS
      v_list receiving_user_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_event_mod_users
                 WHERE event_mod_cd = p_event_cd
                   AND passing_userid = p_passing_userid
                   AND userid IS NOT NULL
              ORDER BY 2)
      LOOP
         v_list.passing_userid := i.passing_userid;
         v_list.userid := i.userid;
         v_list.active_tag := i.active_tag;
         v_list.event_user_mod := i.event_user_mod;
         
         BEGIN
            SELECT user_name
              INTO v_list.user_name
              FROM giis_users
             WHERE user_id = i.userid;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.user_name := NULl;
         END;
         
         PIPE ROW(v_list);
      END LOOP;
   END get_receiving_user;
   
   FUNCTION get_passing_user_lov (p_event_cd VARCHAR2)
      RETURN passing_user_lov_tab PIPELINED
   IS
      v_list passing_user_lov_type;
   BEGIN
      FOR i IN (SELECT   a.user_id, a.user_name
                  FROM giis_users a
                 WHERE a.active_flag = 'Y'
                   AND a.workflow_tag = 'Y'
--                   AND NOT EXISTS (SELECT 1
--                                     FROM giis_event_mod_users z
--                                    WHERE z.passing_userid = a.user_id
--                                      AND z.event_mod_cd = p_event_cd)
                                 ORDER BY a.user_id)
      LOOP
         v_list.user_id := i.user_id;
         v_list.user_name := i.user_name;
         PIPE ROW(v_list);
      END LOOP;
   END get_passing_user_lov;
   
   FUNCTION get_event_user_lov (p_event_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN passing_user_lov_tab PIPELINED
   IS
      v_list passing_user_lov_type;
   BEGIN
      FOR i IN (SELECT a.user_id, a.user_name
                  FROM giis_users a
                 WHERE a.active_flag = 'Y'
                   AND a.workflow_tag = 'Y'
                   AND check_user_access2('GIISS168', a.user_id) != 2
--                   AND NOT EXISTS (SELECT 1
--                                     FROM giis_event_mod_users z
--                                    WHERE z.userid = a.user_id
--                                      AND z.passing_userid = p_passing_userid
--                                      AND z.event_mod_cd = p_event_cd)
                                 ORDER BY a.user_id)
      LOOP
         v_list.user_id := i.user_id;
         v_list.user_name := i.user_name;
         PIPE ROW(v_list); 
      END LOOP;
   END get_event_user_lov;
   
   FUNCTION get_selected_passing_users (p_event_mod_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN VARCHAR2
   IS
      v_temp VARCHAR2(32767);
   BEGIN
      FOR i IN (SELECT DISTINCT passing_userid
                  FROM giis_event_mod_users
                 WHERE event_mod_cd = p_event_mod_cd
                   AND passing_userid LIKE NVL(p_passing_userid, '%'))
      LOOP
         v_temp := TRIM(v_temp) || TRIM(i.passing_userid) || ',';
      END LOOP;
      RETURN v_temp;   
   END get_selected_passing_users;
   
   FUNCTION get_selected_receiving_users (p_event_cd VARCHAR2, p_passing_userid VARCHAR2)
      RETURN VARCHAR2
   IS
      v_temp VARCHAR2(32767);
   BEGIN
      FOR i IN (SELECT userid
                  FROM giis_event_mod_users 
                 WHERE passing_userid = p_passing_userid
                   AND event_mod_cd = p_event_cd)
      LOOP
         v_temp := TRIM(v_temp) || TRIM(i.userid) || ',';
      END LOOP;
      RETURN v_temp;
   END get_selected_receiving_users;
   
   PROCEDURE set_passing_users(
      p_event_user_mod   IN OUT VARCHAR2,
      p_event_mod_cd     IN VARCHAR2,
      p_user_id          IN VARCHAR2,
      p_passing_userid   IN VARCHAR2        
   )
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
--      BEGIN
--         SELECT 'Y'
--           INTO v_exists
--           FROM giis_event_mod_users
--          WHERE event_user_mod = p_rec.event_user_mod;
--      EXCEPTION WHEN NO_DATA_FOUND THEN
--         v_exists := 'N';          
--      END;

      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_event_mod_users
          WHERE passing_userid = p_passing_userid
            AND event_mod_cd = p_event_mod_cd
            AND ROWNUM = 1;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';              
      END;
      
      IF v_exists = 'N' THEN
--         BEGIN
--            SELECT event_mod_users_seq.NEXTVAL
--              INTO p_event_user_mod
--	           FROM dual;
--         EXCEPTION WHEN NO_DATA_FOUND THEN
--            raise_application_error(-20001, 'Geniisys Exception#E#No value found in event_mod_users_seq');      
--         END;
         
         BEGIN
            INSERT INTO giis_event_mod_users
                        (event_mod_cd, active_tag,
                         user_id, last_update, passing_userid
                        )
                 VALUES (p_event_mod_cd, 'Y',
                         p_user_id, SYSDATE, p_passing_userid
                        );
                        
            SELECT MAX(event_user_mod)
              INTO p_event_user_mod
              FROM giis_event_mod_users;                         
         END;
      ELSE
         BEGIN
            UPDATE giis_event_mod_users
               SET user_id = p_user_id,
                   last_update = SYSDATE,
                   passing_userid = p_passing_userid
             WHERE passing_userid = p_passing_userid
               AND event_mod_cd = p_event_mod_cd;    
         END;
      END IF;
      
   END set_passing_users;
   
   PROCEDURE val_del_passing_users (
      p_event_mod_cd          IN VARCHAR2,
      p_passing_userid  IN VARCHAR2
   )
   IS
      v_exists VARCHAR2(1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exists
           FROM giis_event_mod_users
          WHERE passing_userid = p_passing_userid
            AND event_mod_cd = p_event_mod_cd
            AND userid IS NULL;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';               
      END;
      
      IF v_exists != 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record while dependent record(s) exists.');
      END IF;
      
   END val_del_passing_users;
   
   PROCEDURE set_receiving_users(
      p_event_user_mod  IN VARCHAR2,
      p_event_mod_cd    IN VARCHAR2,
      p_userid          IN VARCHAR2,
      p_user_id         IN VARCHAR2,
      p_passing_userid  IN VARCHAR2   
   )
   IS
      v_exists VARCHAR2(1) := 'N';
   BEGIN
      IF p_event_user_mod IS NULL THEN
      
         BEGIN
            SELECT 'Y'
              INTO v_exists
              FROM giis_event_mod_users
             WHERE userid IS NULL
               AND event_mod_cd = p_event_mod_cd
               AND passing_userid = p_passing_userid;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_exists := 'N';       
         END;
      
         IF v_exists = 'N' THEN
            BEGIN
               INSERT INTO giis_event_mod_users
                           (event_mod_cd, userid, active_tag, user_id, last_update, passing_userid)
                    VALUES (p_event_mod_cd, p_userid, 'Y', p_user_id, SYSDATE, p_passing_userid);
            END;
         ELSE
            BEGIN
               UPDATE giis_event_mod_users
                  SET userid = p_userid,
                      user_id = p_user_id,
                      last_update = SYSDATE
                WHERE userid IS NULL
                  AND event_mod_cd = p_event_mod_cd
                  AND passing_userid = p_passing_userid; 
            END;   
         END IF;
      
         
      ELSE
         BEGIN
            UPDATE giis_event_mod_users
               SET userid = p_userid,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE event_user_mod = p_event_user_mod; 
         END;   
      END IF;
   END set_receiving_users;
   
   PROCEDURE delete_receiving_users(
      p_event_user_mod  IN VARCHAR2
   )
   IS
   BEGIN
      DELETE FROM giis_event_mod_users
       WHERE event_user_mod = p_event_user_mod;
   END delete_receiving_users;                       
        
END;
/



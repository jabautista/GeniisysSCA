CREATE OR REPLACE PACKAGE BODY CPI.giacs313_pkg
AS
   FUNCTION get_giis_users
      RETURN giis_user_tab PIPELINED
   IS
      v_user   giis_user_type;
   BEGIN
      FOR a IN (SELECT   user_id, user_name
                    FROM giis_users
                ORDER BY user_id)
      LOOP
         v_user.giac_user_id := a.user_id;
         v_user.user_name := a.user_name;
         PIPE ROW (v_user);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rec_list (
      p_giac_user_id   giac_users.user_id%TYPE,
      p_user_name      giac_users.user_name%TYPE,
      p_designation    giac_users.designation%TYPE,
      p_active_dt      VARCHAR2,
      p_inactive_dt    VARCHAR2,
      p_active_tag     VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec          rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giac_users
                   WHERE UPPER (user_id) LIKE
                                             UPPER (NVL (p_giac_user_id, '%'))
                     AND UPPER (user_name) LIKE UPPER (NVL (p_user_name, '%'))
                     AND UPPER (designation) LIKE
                                              UPPER (NVL (p_designation, '%'))
                     AND TO_CHAR (active_dt, 'MM-DD-YYYY') LIKE
                                                        NVL (p_active_dt, '%')
                     AND NVL (TO_CHAR (inactive_dt, 'MM-DD-YYYY'), '%') LIKE
                                                      NVL (p_inactive_dt, '%')
                     AND decode(active_tag, 'Y', 'YES',
                                            'NO') LIKE
                                               UPPER (NVL (p_active_tag, '%'))
                ORDER BY user_name)
      LOOP
         v_rec.giac_user_id := i.user_id;
         v_rec.user_name := i.user_name;
         v_rec.designation := i.designation;
         v_rec.active_dt := TO_CHAR (i.active_dt, 'MM-DD-YYYY');
         v_rec.inactive_dt := TO_CHAR (i.inactive_dt, 'MM-DD-YYYY');
         v_rec.active_tag := i.active_tag;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.tran_user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_users%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giac_users
         USING DUAL
         ON (user_id = p_rec.user_id)
         WHEN NOT MATCHED THEN
            INSERT (user_id, user_name, designation, active_dt, inactive_dt,
                    active_tag, remarks, tran_user_id, last_update)
            VALUES (p_rec.user_id, p_rec.user_name, p_rec.designation,
                    p_rec.active_dt, p_rec.inactive_dt, p_rec.active_tag,
                    p_rec.remarks, p_rec.tran_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET user_name = p_rec.user_name,
                   designation = p_rec.designation,
                   active_dt = p_rec.active_dt,
                   inactive_dt = p_rec.inactive_dt,
                   active_tag = p_rec.active_tag, remarks = p_rec.remarks,
                   tran_user_id = p_rec.tran_user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_giac_user_id giac_users.user_id%TYPE)
   AS
   BEGIN
      DELETE FROM giac_users
            WHERE user_id = p_giac_user_id;
   END;

   PROCEDURE val_del_rec (p_giac_user_id giac_users.user_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM giac_dcb_users
                   WHERE dcb_user_id = p_giac_user_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_USERS while dependent record(s) in GIAC_DCB_USERS exists.'
            );
      END IF;

      FOR rec IN (SELECT '1'
                    FROM giac_user_functions
                   WHERE user_id = p_giac_user_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_USERS while dependent record(s) in GIAC_USER_FUNCTIONS exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_giac_user_id giac_users.user_id%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_users a
                 WHERE a.user_id = p_giac_user_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same user_id.'
            );
      END IF;
   END;
END;
/



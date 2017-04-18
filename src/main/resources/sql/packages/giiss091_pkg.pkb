CREATE OR REPLACE PACKAGE BODY CPI.giiss091_pkg
AS
   FUNCTION get_rec_list (
      p_line_cd     giis_policy_type.line_cd%TYPE,
      p_type_cd     giis_policy_type.type_cd%TYPE,
      p_type_desc   giis_policy_type.type_desc%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_policy_type a
                   WHERE UPPER (a.line_cd) LIKE UPPER (NVL (p_line_cd, '%'))
                     AND UPPER (a.type_cd) LIKE UPPER (NVL (p_type_cd, '%'))
                     AND UPPER (a.type_desc) LIKE
                                                UPPER (NVL (p_type_desc, '%'))
                     AND check_user_per_line2 (a.line_cd,
                                               NULL,
                                               'GIISS091',
                                               p_user_id
                                              ) = 1
                ORDER BY a.line_cd, a.type_cd, a.type_desc)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.type_cd := i.type_cd;
         v_rec.type_desc := i.type_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (
      p_line_cd     giis_policy_type.line_cd%TYPE,
      p_type_cd     giis_policy_type.type_cd%TYPE,
      p_type_desc   giis_policy_type.type_desc%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_policy_type a
                 WHERE a.line_cd = p_line_cd AND a.type_cd = p_type_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same line_cd, type_cd.'
            );
      END LOOP;
      
      
      FOR i IN (SELECT '1'
                  FROM giis_policy_type a
                 WHERE a.type_desc = p_type_desc)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Type description entered must be unique.'
            );
      END LOOP;
   END;

   PROCEDURE val_del_rec (
      p_line_cd   giis_policy_type.line_cd%TYPE,
      p_type_cd   giis_policy_type.type_cd%TYPE
   )
   AS
   BEGIN
      FOR i IN (SELECT 'gw'
                  FROM gipi_wpolbas a
                 WHERE a.line_cd = p_line_cd AND a.type_cd = p_type_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_POLICY_TYPE while dependent record(s) in GIPI_WPOLBAS exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 'gp'
                  FROM gipi_polbasic a
                 WHERE a.line_cd = p_line_cd AND a.type_cd = p_type_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_POLICY_TYPE while dependent record(s) in GIPI_POLBASIC exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 'gpte'
                  FROM giac_policy_type_entries a
                 WHERE a.line_cd = p_line_cd AND a.type_cd = p_type_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_POLICY_TYPE while dependent record(s) in GIAC_POLICY_TYPE_ENTRIES exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_rec (
      p_rec             giis_policy_type%ROWTYPE,
      p_dummy_line_cd   giis_policy_type.line_cd%TYPE
   )
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_policy_type
                 WHERE line_cd = p_dummy_line_cd AND type_cd = p_rec.type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_policy_type
            SET line_cd = p_rec.line_cd,
                type_desc = p_rec.type_desc,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE line_cd = p_dummy_line_cd AND type_cd = p_rec.type_cd;
      ELSE
         INSERT INTO giis_policy_type
                     (line_cd, type_cd, type_desc,
                      remarks, user_id, last_update
                     )
              VALUES (p_rec.line_cd, p_rec.type_cd, p_rec.type_desc,
                      p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_line_cd   giis_policy_type.line_cd%TYPE,
      p_type_cd   giis_policy_type.type_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giis_policy_type
            WHERE line_cd = p_line_cd AND type_cd = p_type_cd;
   END;

   PROCEDURE val_type_desc (p_type_desc giis_policy_type.type_desc%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT type_desc
                  FROM giis_policy_type
                 WHERE type_desc = p_type_desc)
      LOOP
         raise_application_error
             (-20001,
              'Geniisys Exception#E#Type description entered must be unique.'
             );
         EXIT;
      END LOOP;
   END;
   
   FUNCTION get_all_line_type_cd RETURN rec_tab PIPELINED
   IS
      v_rec rec_type;
   BEGIN
      FOR i IN(SELECT line_cd, type_cd
                 FROM giis_policy_type)
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.type_cd := i.type_cd;
         
         PIPE ROW(v_rec);
      END LOOP;
      
      RETURN;
   END;
   
   FUNCTION get_all_type_desc RETURN rec_tab PIPELINED
   IS 
      v_rec rec_type;
   BEGIN
      FOR i IN(SELECT type_desc
                 FROM giis_policy_type)
      LOOP
         v_rec.type_desc := i.type_desc;
         
         PIPE ROW(v_rec);
      END LOOP;
      
      RETURN;
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss075_pkg
AS
   FUNCTION get_rec_list (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_iss_name       giis_issource.iss_name%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE,
      p_type_name      giis_co_intrmdry_types.type_name%TYPE,
      p_user_id        VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.iss_cd, b.iss_name, a.co_intm_type, a.type_name,
                   a.remarks, a.user_id, a.last_update
              FROM giis_co_intrmdry_types a, giis_issource b
             WHERE a.iss_cd = b.iss_cd
               AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, '%'))
               AND UPPER (b.iss_name) LIKE UPPER (NVL (p_iss_name, '%'))
               AND UPPER (a.co_intm_type) LIKE
                                             UPPER (NVL (p_co_intm_type, '%'))
               AND UPPER (a.type_name) LIKE UPPER (NVL (p_type_name, '%'))
               AND check_user_per_iss_cd2 (NULL,
                                           a.iss_cd,
                                           'GIISS075',
                                           p_user_id
                                          ) = 1
          ORDER BY a.iss_cd, a.co_intm_type, a.type_name)
      LOOP
         v_rec.iss_cd := i.iss_cd;
         v_rec.iss_name := i.iss_name;
         v_rec.co_intm_type := i.co_intm_type;
         v_rec.type_name := i.type_name;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION show_issue_source_lov (p_user_id VARCHAR2)
      RETURN issue_source_lov_tab PIPELINED
   IS
      v_list   issue_source_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE check_user_per_iss_cd2 (NULL,
                                               iss_cd,
                                               'GIISS075',
                                               p_user_id
                                              ) = 1)
      LOOP
         v_list.iss_cd := i.iss_cd;
         v_list.iss_name := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_issue_source_lov;

   PROCEDURE set_rec (p_rec giis_co_intrmdry_types%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_co_intrmdry_types
         USING DUAL
         ON (iss_cd = p_rec.iss_cd AND co_intm_type = p_rec.co_intm_type)
         WHEN NOT MATCHED THEN
            INSERT (iss_cd, co_intm_type, type_name, remarks, user_id,
                    last_update)
            VALUES (p_rec.iss_cd, p_rec.co_intm_type, p_rec.type_name,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET type_name = p_rec.type_name, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
               WHERE     iss_cd = p_rec.iss_cd
                     AND co_intm_type = p_rec.co_intm_type
            ;
   END;

   PROCEDURE delete_rec (p_rec giis_co_intrmdry_types%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giis_co_intrmdry_types
            WHERE iss_cd = p_rec.iss_cd AND co_intm_type = p_rec.co_intm_type;
   END;

   PROCEDURE val_del_rec (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_intermediary a
                 WHERE a.iss_cd = p_iss_cd
                       AND a.co_intm_type = p_co_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CO_INTRMDRY_TYPES while dependent record(s) in GIIS_INTERMEDIARY exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_intm_type_comrt a
                 WHERE a.iss_cd = p_iss_cd AND a.co_intm_type = p_co_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CO_INTRMDRY_TYPES while dependent record(s) in GIIS_INTM_TYPE_COMRT exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_co_intrmdry_types a
                 WHERE a.iss_cd = p_iss_cd
                       AND a.co_intm_type = p_co_intm_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same iss_cd and co_intm_type.'
            );
         RETURN;
      END IF;
   END;
END;
/



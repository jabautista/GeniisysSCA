CREATE OR REPLACE PACKAGE BODY CPI.giiss025_pkg
AS
   FUNCTION get_rec_list (
      p_ri_type        giis_reinsurer_type.ri_type%TYPE,
      p_ri_type_desc   giis_reinsurer_type.ri_type_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.ri_type, a.ri_type_desc, a.remarks, a.user_id,
                         a.last_update
                    FROM giis_reinsurer_type a
                   WHERE UPPER (a.ri_type) LIKE UPPER (NVL (p_ri_type, '%'))
                     AND UPPER (a.ri_type_desc) LIKE
                                             UPPER (NVL (p_ri_type_desc, '%'))
                ORDER BY a.ri_type, a.ri_type_desc)
      LOOP
         v_rec.ri_type := i.ri_type;
         v_rec.ri_type_desc := i.ri_type_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_reinsurer_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_reinsurer_type
         USING DUAL
         ON (ri_type = p_rec.ri_type)
         WHEN NOT MATCHED THEN
            INSERT (ri_type, ri_type_desc, remarks, user_id, last_update)
            VALUES (p_rec.ri_type, p_rec.ri_type_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET ri_type_desc = p_rec.ri_type_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE)
   AS
   BEGIN
      DELETE FROM giis_reinsurer_type
            WHERE ri_type = p_ri_type;
   END;

   PROCEDURE val_del_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE)
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_ri_type_docs a
                 WHERE a.ri_type = p_ri_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_REINSURER_TYPE while dependent record(s) in GIIS_RI_TYPE_DOCS exists.'
            );
      ELSIF v_exists = 'N'
      THEN
         FOR i IN (SELECT '1'
                     FROM giis_reinsurer a
                    WHERE a.ri_type = p_ri_type)
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;

         IF v_exists = 'Y'
         THEN
            raise_application_error
               (-20001,
                'Geniisys Exception#E#Cannot delete record from GIIS_REINSURER_TYPE while dependent record(s) in GIIS_REINSURER exists.'
               );
         END IF;
      END IF;
   END;

   PROCEDURE val_add_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_reinsurer_type a
                 WHERE a.ri_type = p_ri_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same ri_type.'
            );
      END IF;
   END;
END;
/



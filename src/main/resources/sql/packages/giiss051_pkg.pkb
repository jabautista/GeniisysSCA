CREATE OR REPLACE PACKAGE BODY CPI.giiss051_pkg
AS
   FUNCTION get_rec_list (
      p_cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      p_cargo_class_desc   giis_cargo_class.cargo_class_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.cargo_class_cd, a.cargo_class_desc, a.remarks,
                   a.user_id, a.last_update
              FROM giis_cargo_class a
             WHERE a.cargo_class_cd =
                                     NVL (p_cargo_class_cd, a.cargo_class_cd)
               AND UPPER (a.cargo_class_desc) LIKE
                                         UPPER (NVL (p_cargo_class_desc, '%'))
          ORDER BY a.cargo_class_cd, a.cargo_class_desc)
      LOOP
         v_rec.cargo_class_cd := i.cargo_class_cd;
         v_rec.cargo_class_desc := i.cargo_class_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_cargo_class%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_cargo_class
         USING DUAL
         ON (cargo_class_cd = p_rec.cargo_class_cd)
         WHEN NOT MATCHED THEN
            INSERT (cargo_class_cd, cargo_class_desc, remarks, user_id,
                    last_update)
            VALUES (p_rec.cargo_class_cd, p_rec.cargo_class_desc,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET cargo_class_desc = p_rec.cargo_class_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_cargo_class_cd giis_cargo_class.cargo_class_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_cargo_class
            WHERE cargo_class_cd = p_cargo_class_cd;
   END;

   PROCEDURE val_del_rec (
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_cargo_type a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CARGO_CLASS while dependent record(s) in GIIS_CARGO_TYPE exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_cargo a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CARGO_CLASS while dependent record(s) in GIPI_CARGO exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wcargo a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CARGO_CLASS while dependent record(s) in GIPI_WCARGO exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_open_cargo a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CARGO_CLASS while dependent record(s) in GIPI_OPEN_CARGO exists.'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_wopen_cargo a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_CARGO_CLASS while dependent record(s) in GIPI_WOPEN_CARGO exists.'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_cargo_class_cd   giis_cargo_class.cargo_class_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_cargo_class a
                 WHERE a.cargo_class_cd = p_cargo_class_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same cargo_class_cd.'
            );
      END IF;
   END;
END;
/



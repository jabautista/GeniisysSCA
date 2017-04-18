CREATE OR REPLACE PACKAGE BODY CPI.giiss077_pkg
AS
   FUNCTION get_rec_list (
      p_vestype_cd     giis_vestype.vestype_cd%TYPE,
      p_vestype_desc   giis_vestype.vestype_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.vestype_cd, a.vestype_desc, a.remarks, a.user_id,
                         a.last_update
                    FROM giis_vestype a
                   WHERE UPPER (a.vestype_cd) LIKE
                                              UPPER (NVL (p_vestype_cd, '%'))
                     AND UPPER (a.vestype_desc) LIKE
                                             UPPER (NVL (p_vestype_desc, '%'))
                ORDER BY a.vestype_cd)
      LOOP
         v_rec.vestype_cd := i.vestype_cd;
         v_rec.vestype_desc := i.vestype_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_vestype%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_vestype
         USING DUAL
         ON (vestype_cd = p_rec.vestype_cd)
         WHEN NOT MATCHED THEN
            INSERT (vestype_cd, vestype_desc, remarks, user_id, last_update)
            VALUES (p_rec.vestype_cd, p_rec.vestype_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET vestype_desc = p_rec.vestype_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_vestype_cd giis_vestype.vestype_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_vestype
            WHERE vestype_cd = p_vestype_cd;
   END;

   PROCEDURE val_del_rec (p_vestype_cd giis_vestype.vestype_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_vessel a
                 WHERE a.vestype_cd = p_vestype_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_VESTYPE while dependent record(s) in GIIS_VESSEL exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_vestype_cd giis_vestype.vestype_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_vestype a
                 WHERE a.vestype_cd = p_vestype_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same Vessel Code.'
            );
      END IF;
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss094_pkg
AS
   FUNCTION get_rec_list (
      p_ca_trty_type   giis_ca_trty_type.ca_trty_type%TYPE,
      p_trty_sname     giis_ca_trty_type.trty_sname%TYPE,
      p_trty_lname     giis_ca_trty_type.trty_lname%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.ca_trty_type, a.trty_sname, a.trty_lname, a.remarks,
                       a.user_id, a.last_update
                  FROM giis_ca_trty_type a
                 WHERE a.ca_trty_type = NVL (p_ca_trty_type, a.ca_trty_type)
                   AND UPPER (a.trty_sname) LIKE
                                               UPPER (NVL (p_trty_sname, '%'))
                   AND UPPER (a.trty_lname) LIKE
                                               UPPER (NVL (p_trty_lname, '%')))
      LOOP
         v_rec.ca_trty_type := i.ca_trty_type;
         v_rec.trty_sname := i.trty_sname;
         v_rec.trty_lname := i.trty_lname;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_ca_trty_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_ca_trty_type
         USING DUAL
         ON (ca_trty_type = p_rec.ca_trty_type)
         WHEN NOT MATCHED THEN
            INSERT (ca_trty_type, trty_sname, trty_lname, remarks, user_id,
                    last_update)
            VALUES (p_rec.ca_trty_type, p_rec.trty_sname, p_rec.trty_lname,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET trty_sname = p_rec.trty_sname,
                   trty_lname = p_rec.trty_lname, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_ca_trty_type giis_ca_trty_type.ca_trty_type%TYPE)
   AS
   BEGIN
      DELETE FROM giis_ca_trty_type
            WHERE ca_trty_type = p_ca_trty_type;
   END;

   PROCEDURE val_add_rec (p_ca_trty_type giis_ca_trty_type.ca_trty_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_ca_trty_type a
                 WHERE a.ca_trty_type = p_ca_trty_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same ca_trty_type.'
            );
      END IF;
   END;
END;
/



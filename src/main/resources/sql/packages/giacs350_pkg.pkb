CREATE OR REPLACE PACKAGE BODY CPI.giacs350_pkg
AS
   FUNCTION get_rec_list (
      p_rep_cd      giac_eom_rep.rep_cd%TYPE,
      p_rep_title   giac_eom_rep.rep_title%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_eom_rep a
                 WHERE UPPER (a.rep_cd) LIKE UPPER (NVL (p_rep_cd, '%'))
                   AND UPPER (a.rep_title) LIKE UPPER (NVL (p_rep_title, '%')))
      LOOP
         v_rec.rep_cd := i.rep_cd;
         v_rec.rep_title := i.rep_title;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_eom_rep a
                 WHERE a.rep_cd = p_rep_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same rep_cd.'
            );
      END IF;
   END;

   PROCEDURE val_del_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_eom_rep_dtl a
                 WHERE a.rep_cd = p_rep_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_EOM_REP while dependent record(s) in GIAC_EOM_REP_DTL exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE del_rec (p_rep_cd giac_eom_rep.rep_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_eom_rep
            WHERE rep_cd = p_rep_cd;
   END;

   PROCEDURE set_rec (p_rec giac_eom_rep%ROWTYPE)
   IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_eom_rep
                 WHERE rep_cd = p_rec.rep_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giac_eom_rep
            SET rep_title = p_rec.rep_title,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE rep_cd = p_rec.rep_cd;
      ELSE
         INSERT INTO giac_eom_rep
                     (rep_cd, rep_title, remarks,
                      user_id, last_update
                     )
              VALUES (p_rec.rep_cd, p_rec.rep_title, p_rec.remarks,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;
END;
/



CREATE OR REPLACE PACKAGE BODY CPI.giacs352_pkg
AS
   FUNCTION get_rec_list (
      p_eom_script_no       giac_eom_checking_scripts.eom_script_no%TYPE,
      p_eom_script_title    giac_eom_checking_scripts.eom_script_title%TYPE,
      p_eom_script_text_1   giac_eom_checking_scripts.eom_script_text_1%TYPE,
      p_eom_script_text_2   giac_eom_checking_scripts.eom_script_text_2%TYPE,
      p_eom_script_soln     giac_eom_checking_scripts.eom_script_soln%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   *
              FROM giac_eom_checking_scripts a
             WHERE 1 = 1
               AND eom_script_no = NVL (p_eom_script_no, eom_script_no)
               AND UPPER (a.eom_script_title) LIKE
                                         UPPER (NVL (p_eom_script_title, '%'))
               AND UPPER (a.eom_script_text_1) LIKE
                                        UPPER (NVL (p_eom_script_text_1, '%'))
               AND UPPER (NVL (a.eom_script_text_2, '%')) LIKE
                                        UPPER (NVL (p_eom_script_text_2, '%'))
               AND UPPER (NVL (a.eom_script_soln, '%')) LIKE
                                          UPPER (NVL (p_eom_script_soln, '%'))
          ORDER BY 1)
      LOOP
         v_rec.eom_script_no := i.eom_script_no;
         v_rec.eom_script_title := i.eom_script_title;
         v_rec.eom_script_text_1 := i.eom_script_text_1;
         v_rec.eom_script_text_2 := i.eom_script_text_2;
         v_rec.eom_script_soln := i.eom_script_soln;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_eom_checking_scripts%ROWTYPE)
   IS
      v_exists      VARCHAR2 (1);
      v_script_no   giac_eom_checking_scripts.eom_script_no%TYPE;
   BEGIN
      SELECT NVL (MAX (eom_script_no), 0) + 1
        INTO v_script_no
        FROM giac_eom_checking_scripts;

      FOR i IN (SELECT *
                  FROM giac_eom_checking_scripts
                 WHERE eom_script_no = p_rec.eom_script_no)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giac_eom_checking_scripts
            SET eom_script_title = p_rec.eom_script_title,
                eom_script_text_1 = p_rec.eom_script_text_1,
                eom_script_text_2 = p_rec.eom_script_text_2,
                eom_script_soln = p_rec.eom_script_soln,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE eom_script_no = p_rec.eom_script_no;
      ELSE
         INSERT INTO giac_eom_checking_scripts
                     (eom_script_no, eom_script_title,
                      eom_script_text_1, eom_script_text_2,
                      eom_script_soln, remarks, user_id,
                      last_update
                     )
              VALUES (v_script_no, p_rec.eom_script_title,
                      p_rec.eom_script_text_1, p_rec.eom_script_text_2,
                      p_rec.eom_script_soln, p_rec.remarks, p_rec.user_id,
                      SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_eom_script_no   giac_eom_checking_scripts.eom_script_no%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_eom_checking_scripts
            WHERE eom_script_no = p_eom_script_no;
   END;
END;
/



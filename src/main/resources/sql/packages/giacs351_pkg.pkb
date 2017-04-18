CREATE OR REPLACE PACKAGE BODY CPI.giacs351_pkg
AS
   FUNCTION get_rec_list (
      p_rep_cd         giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_name   giac_chart_of_accts.gl_acct_name%TYPE,
      p_gl_acct_no     VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT b.rep_cd, a.rep_title, b.gl_acct_id, c.gl_acct_name,
                 b.gl_acct_category, b.gl_control_acct, b.gl_sub_acct_1,
                 b.gl_sub_acct_2, b.gl_sub_acct_3, b.gl_sub_acct_4,
                 b.gl_sub_acct_5, b.gl_sub_acct_6, b.gl_sub_acct_7,
                 b.remarks, b.user_id, b.last_update,
                    LTRIM (TO_CHAR (c.gl_acct_category))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')) gl_acct_no
            FROM giac_eom_rep a, giac_eom_rep_dtl b, giac_chart_of_accts c
           WHERE a.rep_cd = b.rep_cd
             AND b.gl_acct_id = c.gl_acct_id
             AND b.rep_cd = p_rep_cd
             AND UPPER (c.gl_acct_name) LIKE UPPER (NVL (p_gl_acct_name, '%'))
             AND    LTRIM (TO_CHAR (c.gl_acct_category))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')) LIKE
                                               UPPER (NVL (p_gl_acct_no, '%')))
      LOOP
         v_rec.rep_cd := i.rep_cd;
         v_rec.rep_title := i.rep_title;
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.gl_acct_category := i.gl_acct_category;
         v_rec.gl_control_acct := i.gl_control_acct;
         v_rec.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_rec.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_rec.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_rec.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_rec.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_rec.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_rec.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_rec.gl_acct_no := i.gl_acct_no;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_rep_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN rep_lov_tab PIPELINED
   IS
      v_rec   rep_lov_type;
   BEGIN
      FOR i IN (SELECT   rep_cd, rep_title
                    FROM giac_eom_rep
                   WHERE 1 = 1
                     AND (   UPPER (rep_cd) LIKE
                                               UPPER (NVL (p_keyword, rep_cd))
                          OR UPPER (rep_title) LIKE
                                            UPPER (NVL (p_keyword, rep_title))
                         )
                ORDER BY 2)
      LOOP
         v_rec.rep_cd := i.rep_cd;
         v_rec.rep_title := i.rep_title;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE val_glacctno_rec (
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_chart_of_accts
                 WHERE gl_acct_category = p_gl_acct_category
                   AND gl_control_acct = p_gl_control_acct
                   AND gl_sub_acct_1 = p_gl_sub_acct_1
                   AND gl_sub_acct_2 = p_gl_sub_acct_2
                   AND gl_sub_acct_3 = p_gl_sub_acct_3
                   AND gl_sub_acct_4 = p_gl_sub_acct_4
                   AND gl_sub_acct_5 = p_gl_sub_acct_5
                   AND gl_sub_acct_6 = p_gl_sub_acct_6
                   AND gl_sub_acct_7 = p_gl_sub_acct_7)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists != 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Account ID does not exist in giac_chart_of_accts.'
            );
      END IF;
   END;

   FUNCTION get_glacctno_lov (
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_keyword            VARCHAR2,
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   )
      RETURN gl_lov_tab PIPELINED
   IS
      v_rec   gl_lov_type;
   BEGIN
      FOR i IN
         (SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                 gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                 gl_sub_acct_6, gl_sub_acct_7, gl_acct_id, gl_acct_name,
                    LTRIM (TO_CHAR (gl_acct_category))
                 || '-'
                 || LTRIM (TO_CHAR (gl_control_acct, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                 || '-'
                 || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) gl_acct_no
            FROM giac_chart_of_accts
           WHERE leaf_tag = 'Y'
             AND gl_acct_category = NVL (p_gl_acct_category, gl_acct_category)
             AND gl_control_acct = NVL (p_gl_control_acct, gl_control_acct)
             AND gl_sub_acct_1 = NVL (p_gl_sub_acct_1, gl_sub_acct_1)
             AND gl_sub_acct_2 = NVL (p_gl_sub_acct_2, gl_sub_acct_2)
             AND gl_sub_acct_3 = NVL (p_gl_sub_acct_3, gl_sub_acct_3)
             AND gl_sub_acct_4 = NVL (p_gl_sub_acct_4, gl_sub_acct_4)
             AND gl_sub_acct_5 = NVL (p_gl_sub_acct_5, gl_sub_acct_5)
             AND gl_sub_acct_6 = NVL (p_gl_sub_acct_6, gl_sub_acct_6)
             AND gl_sub_acct_7 = NVL (p_gl_sub_acct_7, gl_sub_acct_7)
             AND (   UPPER (gl_acct_name) LIKE UPPER (NVL (p_keyword, '%'))
                  OR    LTRIM (TO_CHAR (gl_acct_category))
                     || '-'
                     || LTRIM (TO_CHAR (gl_control_acct, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_1, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_2, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_3, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_4, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_5, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_6, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (gl_sub_acct_7, '09')) LIKE
                                                  UPPER (NVL (p_keyword, '%'))
                 ))
      LOOP
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.gl_acct_no := i.gl_acct_no;
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.gl_acct_category := i.gl_acct_category;
         v_rec.gl_control_acct := i.gl_control_acct;
         v_rec.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_rec.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_rec.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_rec.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_rec.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_rec.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_rec.gl_sub_acct_7 := i.gl_sub_acct_7;
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_lov_tab PIPELINED
   IS
      v_list   gl_lov_type;
   BEGIN
      FOR i IN
         (SELECT   gicoa.gl_acct_category,
                   LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
                   LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                   LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                   LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                   LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                   LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                   LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                   LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7,
                   gicoa.gl_acct_name, gicoa.gl_acct_id
              FROM giac_chart_of_accts gicoa
             WHERE gicoa.leaf_tag = 'Y'
               AND (      gicoa.gl_acct_category
                       || LPAD (gicoa.gl_control_acct, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_1, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_2, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_3, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_4, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_5, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_6, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_7, 2, '0') LIKE
                                                       NVL (p_find, '%')     
                   )
          ORDER BY gicoa.gl_acct_category,
                   gicoa.gl_control_acct,
                   gicoa.gl_sub_acct_1,
                   gicoa.gl_sub_acct_2,
                   gicoa.gl_sub_acct_3,
                   gicoa.gl_sub_acct_4,
                   gicoa.gl_sub_acct_5,
                   gicoa.gl_sub_acct_6,
                   gicoa.gl_sub_acct_7)
      LOOP
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.gl_acct_id := i.gl_acct_id;
         PIPE ROW (v_list);
      END LOOP;
   END;

   PROCEDURE val_addglacctno_rec (
      p_rep_cd             giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE,
      p_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE
   )
   IS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_eom_rep_dtl
                 WHERE rep_cd = p_rep_cd
                   AND gl_acct_category = p_gl_acct_category
                   AND gl_control_acct = p_gl_control_acct
                   AND gl_sub_acct_1 = p_gl_sub_acct_1
                   AND gl_sub_acct_2 = p_gl_sub_acct_2
                   AND gl_sub_acct_3 = p_gl_sub_acct_3
                   AND gl_sub_acct_4 = p_gl_sub_acct_4
                   AND gl_sub_acct_5 = p_gl_sub_acct_5
                   AND gl_sub_acct_6 = p_gl_sub_acct_6
                   AND gl_sub_acct_7 = p_gl_sub_acct_7)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same rep_cd and gl_acct_id.'
            );
      END IF;
   END;

   PROCEDURE set_rec (p_rec giac_eom_rep_dtl%ROWTYPE)
   IS
      v_exists             VARCHAR2 (1);
      v_gl_acct_category   giac_eom_rep_dtl.gl_acct_category%TYPE;
      v_gl_control_acct    giac_eom_rep_dtl.gl_control_acct%TYPE;
      v_gl_sub_acct_1      giac_eom_rep_dtl.gl_sub_acct_1%TYPE;
      v_gl_sub_acct_2      giac_eom_rep_dtl.gl_sub_acct_2%TYPE;
      v_gl_sub_acct_3      giac_eom_rep_dtl.gl_sub_acct_3%TYPE;
      v_gl_sub_acct_4      giac_eom_rep_dtl.gl_sub_acct_4%TYPE;
      v_gl_sub_acct_5      giac_eom_rep_dtl.gl_sub_acct_5%TYPE;
      v_gl_sub_acct_6      giac_eom_rep_dtl.gl_sub_acct_6%TYPE;
      v_gl_sub_acct_7      giac_eom_rep_dtl.gl_sub_acct_7%TYPE;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_eom_rep_dtl
                 WHERE rep_cd = p_rec.rep_cd
                       AND gl_acct_id = p_rec.gl_acct_id)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giac_eom_rep_dtl
            SET remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE rep_cd = p_rec.rep_cd AND gl_acct_id = p_rec.gl_acct_id;
      ELSE
         FOR gl IN (SELECT *
                      FROM giac_chart_of_accts
                     WHERE gl_acct_id = p_rec.gl_acct_id)
         LOOP
            v_gl_acct_category := gl.gl_acct_category;
            v_gl_control_acct := gl.gl_control_acct;
            v_gl_sub_acct_1 := gl.gl_sub_acct_1;
            v_gl_sub_acct_2 := gl.gl_sub_acct_2;
            v_gl_sub_acct_3 := gl.gl_sub_acct_3;
            v_gl_sub_acct_4 := gl.gl_sub_acct_4;
            v_gl_sub_acct_5 := gl.gl_sub_acct_5;
            v_gl_sub_acct_6 := gl.gl_sub_acct_6;
            v_gl_sub_acct_7 := gl.gl_sub_acct_7;
            EXIT;
         END LOOP;

         INSERT INTO giac_eom_rep_dtl
                     (rep_cd, gl_acct_id, gl_acct_category,
                      gl_control_acct, gl_sub_acct_1, gl_sub_acct_2,
                      gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5,
                      gl_sub_acct_6, gl_sub_acct_7, remarks,
                      user_id, last_update
                     )
              VALUES (p_rec.rep_cd, p_rec.gl_acct_id, v_gl_acct_category,
                      v_gl_control_acct, v_gl_sub_acct_1, v_gl_sub_acct_2,
                      v_gl_sub_acct_3, v_gl_sub_acct_4, v_gl_sub_acct_5,
                      v_gl_sub_acct_6, v_gl_sub_acct_7, p_rec.remarks,
                      p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (
      p_rep_cd       giac_eom_rep_dtl.rep_cd%TYPE,
      p_gl_acct_id   giac_eom_rep_dtl.gl_acct_id%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_eom_rep_dtl
            WHERE rep_cd = p_rep_cd AND gl_acct_id = p_gl_acct_id;
   END;
END;
/



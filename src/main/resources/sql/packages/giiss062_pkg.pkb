CREATE OR REPLACE PACKAGE BODY CPI.giiss062_pkg
AS
   FUNCTION get_giis_class_list
      RETURN giis_class_tab PIPELINED
   AS
      v_class_rec   giis_class_type;
   BEGIN
      FOR i IN (SELECT   class_cd, class_desc, user_id, last_update, remarks,
                         cpi_rec_no, cpi_branch_cd
                    FROM giis_class
                ORDER BY class_cd, class_desc)
      LOOP
         v_class_rec.class_cd := i.class_cd;
         v_class_rec.class_desc := i.class_desc;
         v_class_rec.user_id := i.user_id;
         v_class_rec.last_update := i.last_update;
         v_class_rec.remarks := i.remarks;
         v_class_rec.cpi_rec_no := i.cpi_rec_no;
         v_class_rec.cpi_branch_cd := i.cpi_branch_cd;
         PIPE ROW (v_class_rec);
      END LOOP;
   END get_giis_class_list;

   FUNCTION get_giis_peril_class_list (
      p_class_cd    giis_class.class_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giis_peril_class_tab PIPELINED
   IS
      v_peril_class_rec   giis_peril_class_type;
   BEGIN
      FOR i IN (SELECT   peril_name, peril_sname, z.line_cd, line_name,
                         z.remarks, z.class_cd, z.peril_cd, z.user_id,
                         z.last_update, z.cpi_rec_no, z.cpi_branch_cd
                    FROM (SELECT y.line_name, x.class_cd, x.remarks,
                                 x.line_cd, x.last_update, x.cpi_rec_no,
                                 x.user_id, x.cpi_branch_cd, x.peril_cd
                            FROM giis_peril_class x, giis_line y
                           WHERE x.line_cd = y.line_cd) z,
                         (SELECT b.peril_sname, b.peril_name, a.class_cd,
                                 a.line_cd, a.peril_cd
                            FROM giis_peril b, giis_peril_class a
                           WHERE a.peril_cd = b.peril_cd
                             AND a.line_cd = b.line_cd) c
                   WHERE z.class_cd = p_class_cd
                     AND z.class_cd = c.class_cd
                     AND z.line_cd = c.line_cd
                     AND z.peril_cd = c.peril_cd
                     AND check_user_per_line2 (z.line_cd,
                                               NULL,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                ORDER BY z.line_cd)
      LOOP
         v_peril_class_rec.class_cd := i.class_cd;
         v_peril_class_rec.line_cd := i.line_cd;
         v_peril_class_rec.line_name := i.line_name;
         v_peril_class_rec.peril_cd := i.peril_cd;
         v_peril_class_rec.peril_sname := i.peril_sname;
         v_peril_class_rec.peril_name := i.peril_name;
         v_peril_class_rec.user_id := i.user_id;
         v_peril_class_rec.last_update := i.last_update;
         v_peril_class_rec.remarks := i.remarks;
         v_peril_class_rec.cpi_rec_no := i.cpi_rec_no;
         v_peril_class_rec.cpi_branch_cd := i.cpi_branch_cd;
         PIPE ROW (v_peril_class_rec);
      END LOOP;

      RETURN;
   END get_giis_peril_class_list;

   FUNCTION get_giis_peril_sname_name (p_line_cd giis_peril.line_cd%TYPE)
      RETURN giis_peril_sname_name_tab PIPELINED
   IS
      v_peril_name_rec   giis_peril_sname_name_type;
   BEGIN
      FOR i IN (SELECT   line_cd, peril_cd, peril_sname, peril_name
                    FROM giis_peril
                   WHERE line_cd = p_line_cd
                ORDER BY peril_cd)
      LOOP
         v_peril_name_rec.line_cd := i.line_cd;
         v_peril_name_rec.peril_cd := i.peril_cd;
         v_peril_name_rec.peril_sname := i.peril_sname;
         v_peril_name_rec.peril_name := i.peril_name;
         PIPE ROW (v_peril_name_rec);
      END LOOP;
   END get_giis_peril_sname_name;

   PROCEDURE delete_giis_peril_class (
      p_class_cd   giis_peril_class.class_cd%TYPE,
      p_line_cd    giis_peril_class.line_cd%TYPE,
      p_peril_cd   giis_peril_class.peril_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_peril_class
            WHERE class_cd = p_class_cd
              AND line_cd = p_line_cd
              AND peril_cd = p_peril_cd;
   END delete_giis_peril_class;

   PROCEDURE set_giis_peril_class (p_peril_class giis_peril_class%ROWTYPE)
   IS
   BEGIN
      INSERT INTO giis_peril_class
                  (class_cd, line_cd,
                   peril_cd, remarks
                  )
           VALUES (p_peril_class.class_cd, p_peril_class.line_cd,
                   p_peril_class.peril_cd, p_peril_class.remarks
                  );
   END set_giis_peril_class;

   FUNCTION validate_peril_class (
      p_class_cd   giis_peril_class.class_cd%TYPE,
      p_line_cd    giis_peril_class.line_cd%TYPE,
      p_peril_cd   giis_peril_class.peril_cd%TYPE
   )
      RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (2);
   BEGIN
      SELECT '1'
        INTO v_exists
        FROM giis_peril_class
       WHERE class_cd = p_class_cd
         AND line_cd = p_line_cd
         AND peril_cd = p_peril_cd;
    RETURN v_exists;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         v_exists := '0';
         RETURN v_exists;
   END validate_peril_class;

   FUNCTION get_giis_line_list (
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED
   IS
      v_giis_line   line_listing_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               NULL,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                ORDER BY line_name)
      LOOP
         v_giis_line.line_cd := i.line_cd;
         v_giis_line.line_name := i.line_name;
         PIPE ROW (v_giis_line);
      END LOOP;

      RETURN;
   END get_giis_line_list;
   
END giiss062_pkg;
/



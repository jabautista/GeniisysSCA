CREATE OR REPLACE PACKAGE BODY CPI.giiss113_pkg
AS
   FUNCTION get_rec_list (
      p_coverage_cd     giis_coverage.coverage_cd%TYPE,
      p_coverage_desc   giis_coverage.coverage_desc%TYPE,
      p_line_cd         giis_coverage.line_cd%TYPE,
      p_subline_cd      giis_coverage.subline_cd%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.*, b.line_name, c.subline_name
              FROM giis_coverage a, giis_line b, giis_subline c
             WHERE 1 = 1
               AND a.line_cd = b.line_cd(+)
               AND a.line_cd = c.line_cd(+) --added by Wilmar 09/09/2015
               AND a.subline_cd = c.subline_cd(+)
               AND a.coverage_cd LIKE (NVL (p_coverage_cd, a.coverage_cd))
               AND UPPER (a.coverage_desc) LIKE
                                            UPPER (NVL (p_coverage_desc, '%'))
               AND UPPER (NVL (a.line_cd, '%')) LIKE
                                                  UPPER (NVL (p_line_cd, '%'))
               AND UPPER (NVL (a.subline_cd, '%')) LIKE
                                               UPPER (NVL (p_subline_cd, '%'))
          ORDER BY coverage_cd)
      LOOP
         v_rec.coverage_cd := i.coverage_cd;
         v_rec.coverage_desc := i.coverage_desc;
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         v_rec.cpi_branch_cd := i.cpi_branch_cd;
         v_rec.cpi_rec_no := i.cpi_rec_no;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_all_coverage_desc
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT   a.coverage_desc
                    FROM giis_coverage a, giis_line b, giis_subline c
                   WHERE 1 = 1 AND a.line_cd = b.line_cd(+)
                         AND a.subline_cd = c.subline_cd(+)
                ORDER BY coverage_cd)
      LOOP
         v_rec.coverage_desc := i.coverage_desc;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE val_add_rec (p_coverage_desc giis_coverage.coverage_desc%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 'Y'
                  FROM giis_coverage a
                 WHERE UPPER (a.coverage_desc) = UPPER (p_coverage_desc))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same coverage_desc.'
            );
      END IF;
   END;

   PROCEDURE val_del_rec (p_coverage_cd giis_coverage.coverage_cd%TYPE)
   AS
   BEGIN
      FOR i IN (SELECT 'gi'
                  FROM gipi_item a
                 WHERE a.coverage_cd = p_coverage_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_COVERAGE while dependent record(s) in GIPI_ITEM exists.'
            );
         EXIT;
      END LOOP;

      FOR i IN (SELECT 'gw'
                  FROM gipi_witem a
                 WHERE a.coverage_cd = p_coverage_cd)
      LOOP
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_COVERAGE while dependent record(s) in GIPI_WITEM exists.'
            );
         EXIT;
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giis_coverage%ROWTYPE)
   IS
      v_exists        VARCHAR2 (1);
      v_coverage_cd   giis_coverage.coverage_cd%TYPE;
   BEGIN
      SELECT coverage_coverage_cd_s.NEXTVAL
        INTO v_coverage_cd
        FROM DUAL;

      FOR i IN (SELECT *
                  FROM giis_coverage
                 WHERE coverage_cd = p_rec.coverage_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         UPDATE giis_coverage
            SET coverage_desc = p_rec.coverage_desc,
                line_cd = p_rec.line_cd,
                subline_cd = p_rec.subline_cd,
                remarks = p_rec.remarks,
                user_id = p_rec.user_id,
                last_update = SYSDATE
          WHERE coverage_cd = p_rec.coverage_cd;
      ELSE
         INSERT INTO giis_coverage
                     (coverage_cd, coverage_desc, line_cd,
                      subline_cd, remarks, user_id, last_update
                     )
              VALUES (v_coverage_cd, p_rec.coverage_desc, p_rec.line_cd,
                      p_rec.subline_cd, p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END IF;
   END;

   PROCEDURE del_rec (p_coverage_cd giis_coverage.coverage_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_coverage
            WHERE coverage_cd = p_coverage_cd;
   END;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v_list   line_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS113',
                                               p_user_id
                                              ) = 1
                     AND (   UPPER (line_cd) LIKE
                                              UPPER (NVL (p_keyword, line_cd))
                          OR UPPER (line_name) LIKE
                                            UPPER (NVL (p_keyword, line_name))
                         )
                ORDER BY line_cd)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_subline_lov (
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2,
      p_line_cd   VARCHAR2
   )
      RETURN subline_lov_tab PIPELINED
   IS
      v_list   subline_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = p_line_cd
                     AND (   UPPER (subline_cd) LIKE
                                           UPPER (NVL (p_keyword, subline_cd))
                          OR UPPER (subline_name) LIKE
                                         UPPER (NVL (p_keyword, subline_name))
                         )
                ORDER BY subline_cd)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;
   END;
END;
/

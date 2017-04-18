CREATE OR REPLACE PACKAGE BODY CPI.giiss096_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.06.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description  : Populate Package Line Coverage List
*/
   FUNCTION show_pkg_line_cvrg (p_user_id giis_users.user_id%TYPE)
      RETURN pkg_line_cvrg_tab PIPELINED
   IS
      v_list   pkg_line_cvrg_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE pack_pol_flag = 'Y'
                   AND check_user_per_line2 (line_cd,
                                             NULL,
                                             'GIISS096',
                                             p_user_id
                                            ) = 1)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_pkg_line_cvrg;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.06.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description  : Populate Tackage Line/Subline Coverage List
*/
   FUNCTION show_pkg_line_subline_cvrg (
      p_line_cd   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN pkg_line_subline_cvrg_tab PIPELINED
   IS
      v_list   pkg_line_subline_cvrg_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_line_subline_coverages
                   WHERE line_cd = p_line_cd
                     AND check_user_per_line2 (pack_line_cd,
                                               NULL,
                                               'GIISS096',
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd,
                         pack_line_cd,
                         pack_subline_cd,
                         required_flag,
                         remarks,
                         user_id,
                         last_update)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.pack_line_cd := i.pack_line_cd;
         v_list.pack_subline_cd := i.pack_subline_cd;
         v_list.required_flag := i.required_flag;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_list.remarks := i.remarks;

         FOR j IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = i.pack_line_cd)
         LOOP
            v_list.pack_line_name := j.line_name;
            EXIT;
         END LOOP;

         FOR j IN (SELECT subline_name
                     FROM giis_subline
                    WHERE line_cd = i.pack_line_cd
                      AND subline_cd = i.pack_subline_cd)
         LOOP
            v_list.pack_subline_name := j.subline_name;
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_pkg_line_subline_cvrg;

   FUNCTION get_pkg_line_cvrg_lov (p_user_id giis_users.user_id%TYPE)
      RETURN pkg_line_cvrg_lov_tab PIPELINED
   IS
      v_list   pkg_line_cvrg_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, line_name
                    FROM giis_line
                   WHERE line_cd NOT IN (
                                        SELECT param_value_v
                                          FROM giis_parameters
                                         WHERE param_name =
                                                           'SURETY LINE CODE')
                     AND pack_pol_flag = 'N'
                     AND check_user_per_line2 (line_cd,
                                               NULL,
                                               'GIISS096',
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd ASC)
      LOOP
         v_list.pack_line_cd := i.line_cd;
         v_list.pack_line_name := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_pkg_line_cvrg_lov;

   FUNCTION get_pkg_subline_cvrg_lov (p_pack_line_cd VARCHAR2)
      RETURN pkg_subline_cvrg_lov_tab PIPELINED
   IS
      v_list   pkg_subline_cvrg_lov_type;
   BEGIN
      FOR i IN (SELECT   subline_cd, subline_name
                    FROM giis_subline
                   WHERE line_cd = NVL (p_pack_line_cd, line_cd)
                     AND op_flag = 'N'
                     AND open_policy_sw = 'N'
                ORDER BY subline_cd ASC)
      LOOP
         v_list.pack_subline_cd := i.subline_cd;
         v_list.pack_subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_pkg_subline_cvrg_lov;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.09.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description     : Insert or update record in giis_line_subline_coverages
*/
   PROCEDURE set_pkg_line_subline_cvrg (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE,
      p_required_flag     giis_line_subline_coverages.required_flag%TYPE,
      p_remarks           giis_line_subline_coverages.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_line_subline_coverages
         USING DUAL
         ON (    line_cd = p_line_cd
             AND pack_line_cd = p_pack_line_cd
             AND pack_subline_cd = p_pack_subline_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, pack_line_cd, pack_subline_cd, required_flag,
                    remarks, last_update)
            VALUES (p_line_cd, p_pack_line_cd, p_pack_subline_cd,
                    p_required_flag, p_remarks, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET required_flag = p_required_flag, remarks = p_remarks,
                   last_update = SYSDATE
            ;
   END set_pkg_line_subline_cvrg;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.09.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description     : Delete record in giis_line_subline_coverages
*/
   PROCEDURE dlt_in_pkg_line_subline_cvrg (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_line_subline_coverages
            WHERE line_cd = p_line_cd
              AND pack_line_cd = p_pack_line_cd
              AND pack_subline_cd = p_pack_subline_cd;
   END dlt_in_pkg_line_subline_cvrg;

   PROCEDURE val_del_rec (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wpack_line_subline a
                 WHERE line_cd = p_line_cd
                   AND pack_line_cd = p_pack_line_cd
                   AND pack_subline_cd = p_pack_subline_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE_SUBLINE_COVERAGES while dependent record(s) in GIPI_WPACK_LINE_SUBLINE exists.#'
            );
         RETURN;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_pack_line_subline a
                 WHERE line_cd = p_line_cd
                   AND pack_line_cd = p_pack_line_cd
                   AND pack_subline_cd = p_pack_subline_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_LINE_SUBLINE_COVERAGES while dependent record(s) in GIPI_PACK_LINE_SUBLINE exists.#'
            );
         RETURN;
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_line_subline_coverages a
                 WHERE line_cd = p_line_cd
                   AND pack_line_cd = p_pack_line_cd
                   AND pack_subline_cd = p_pack_subline_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same pack_line_cd and pack_subline_cd.#'
            );
         RETURN;
      END IF;
   END;
END giiss096_pkg;
/



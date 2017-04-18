CREATE OR REPLACE PACKAGE BODY CPI.GIISS020_PKG
AS
   FUNCTION get_rec_list(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_from_menu             VARCHAR2
   ) RETURN rec_tab PIPELINED
   IS
      v_rec    rec_type;
      v_access VARCHAR2(1) := 'N';
   BEGIN
      IF p_from_menu = 'Y' THEN
         FOR i IN (SELECT line_cd
                     FROM giis_line
                    WHERE (line_cd = 'CA' 
                           OR menu_line_cd = 'CA'))
         LOOP 
            IF check_user_per_line2(i.line_cd, NULL, p_module_id, p_user_id) = 1 THEN
               v_access := 'Y';
               EXIT;
            END IF;
         END LOOP;
         
         IF v_access = 'N' THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You do not have access to any Casualty Line');
         END IF;
      END IF;
   
      FOR i IN (SELECT *
                  FROM giis_section_or_hazard
                 WHERE check_user_per_line2(section_line_cd, NULL, p_module_id, p_user_id) = 1
                 ORDER BY section_line_cd, section_subline_cd, section_or_hazard_cd)
      LOOP
         v_rec.section_line_cd := i.section_line_cd;
         v_rec.section_subline_cd := i.section_subline_cd;
         v_rec.section_or_hazard_cd := i.section_or_hazard_cd;
         v_rec.section_or_hazard_title := i.section_or_hazard_title;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         SELECT line_name
           INTO v_rec.line_name
           FROM giis_line
          WHERE line_cd = i.section_line_cd;
          
         SELECT subline_name
           INTO v_rec.subline_name
           FROM giis_subline
          WHERE subline_cd = i.section_subline_cd;
         
         PIPE ROW (v_rec);
      END LOOP;
   END;
   
   FUNCTION get_line_lov(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN line_lov_tab PIPELINED AS
      v_list                  line_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, line_name
                  FROM giis_line
                 WHERE (line_cd='CA'
                        OR menu_line_cd='CA')
                   AND check_user_per_line2(line_cd, NULL, p_module_id, p_user_id) = 1
                   AND (UPPER(line_cd) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(line_name) LIKE NVL(UPPER(p_keyword), '%')))
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.line_name := i.line_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_subline_lov(
      p_line_cd               giis_line.line_cd%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN subline_lov_tab PIPELINED AS
      v_list                  subline_lov_type;
   BEGIN
      FOR i IN (SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd
                   AND (UPPER(subline_cd) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(subline_name) LIKE NVL(UPPER(p_keyword), '%')))
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   FUNCTION get_line_subline_lov(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN subline_lov_tab PIPELINED AS
      v_list                  subline_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, subline_cd, subline_name
		            FROM giis_subline
		           WHERE check_user_per_line2(line_cd, NULL, p_module_id, p_user_id) = 1
		             AND line_cd IN (SELECT line_cd FROM giis_line 
   				                     WHERE line_cd = 'CA'
    				                        OR NVL(menu_line_cd, line_cd) = 'CA')
                   AND (UPPER(subline_cd) LIKE NVL(UPPER(p_keyword), '%')
                        OR UPPER(subline_name) LIKE NVL(UPPER(p_keyword), '%')))
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         
         SELECT line_name
           INTO v_list.line_name
           FROM giis_line
          WHERE line_cd = i.line_cd;
         
         PIPE ROW(v_list);
      END LOOP;
   END;

   PROCEDURE set_rec (p_rec giis_section_or_hazard%ROWTYPE) 
   IS
   BEGIN
      MERGE INTO giis_section_or_hazard
         USING DUAL
         ON (section_line_cd = p_rec.section_line_cd
             AND section_subline_cd = p_rec.section_subline_cd
             AND section_or_hazard_cd = p_rec.section_or_hazard_cd)
         WHEN NOT MATCHED THEN
            INSERT (section_line_cd, section_subline_cd, section_or_hazard_cd,
                    section_or_hazard_title, remarks, user_id, last_update)
            VALUES (p_rec.section_line_cd, p_rec.section_subline_cd, p_rec.section_or_hazard_cd,
                    p_rec.section_or_hazard_title, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET section_or_hazard_title = p_rec.section_or_hazard_title,
                   remarks = p_rec.remarks,
                   user_id = p_rec.user_id,
                   last_update = SYSDATE;
   END;

   PROCEDURE del_rec (p_rec giis_section_or_hazard%ROWTYPE)
   AS
   BEGIN
      DELETE FROM giis_section_or_hazard
            WHERE section_line_cd = p_rec.section_line_cd
              AND section_subline_cd = p_rec.section_subline_cd
              AND section_or_hazard_cd = p_rec.section_or_hazard_cd;
   END;

   PROCEDURE val_add_rec(
      p_line_cd               giis_section_or_hazard.section_line_cd%TYPE,
      p_subline_cd            giis_section_or_hazard.section_subline_cd%TYPE,
      p_section_or_hazard_cd  giis_section_or_hazard.section_or_hazard_cd%TYPE
   ) AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_section_or_hazard
                 WHERE section_line_cd = p_line_cd
                   AND section_subline_cd = p_subline_cd
                   AND section_or_hazard_cd = p_section_or_hazard_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same section_line_cd, section_subline_cd and section_or_hazard_cd.');
      END IF;
   END;
   
   PROCEDURE val_del_rec(
      p_line_cd               giis_section_or_hazard.section_line_cd%TYPE,
      p_subline_cd            giis_section_or_hazard.section_subline_cd%TYPE,
      p_section_or_hazard_cd  giis_section_or_hazard.section_or_hazard_cd%TYPE
   ) AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_casualty_item
                 WHERE section_line_cd = p_line_cd
                   AND section_subline_cd = p_subline_cd
                   AND section_or_hazard_cd = p_section_or_hazard_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_SECTION_OR_HAZARD while dependent record(s) in GIPI_CASUALTY_ITEM exists.');
      END IF;
      
      FOR i IN (SELECT '1'
                  FROM gipi_wcasualty_item
                 WHERE section_line_cd = p_line_cd
                   AND section_subline_cd = p_subline_cd
                   AND section_or_hazard_cd = p_section_or_hazard_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_SECTION_OR_HAZARD while dependent record(s) in GIPI_WCASUALTY_ITEM exists.');
      END IF;
   END;
END;
/



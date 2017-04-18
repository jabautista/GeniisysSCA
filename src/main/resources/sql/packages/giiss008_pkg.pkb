CREATE OR REPLACE PACKAGE BODY CPI.giiss008_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.16.2013
**  Reference By    : (GIISS008 - Underwriting - File Maintenance - Marine Cargo - Cargo Type)
**  Description  : Populate Cargo Class List
*/
   FUNCTION show_cargo_class
      RETURN cargo_class_tab PIPELINED
   IS
      v_list   cargo_class_type;
   BEGIN
      FOR i IN (SELECT cargo_class_cd, cargo_class_desc
                  FROM giis_cargo_class)
      LOOP
         v_list.cargo_class_cd := i.cargo_class_cd;
         v_list.cargo_class_desc := i.cargo_class_desc;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_cargo_class;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.16.2013
**  Reference By    : (GIISS008 - Underwriting - File Maintenance - Marine Cargo - Cargo Type)
**  Description  : Populate Cargo Type List
*/
   FUNCTION show_cargo_type (p_cargo_class_cd VARCHAR2)
      RETURN cargo_type_tab PIPELINED
   IS
      v_list   cargo_type_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_cargo_type
                   WHERE cargo_class_cd = TO_NUMBER (p_cargo_class_cd)
                ORDER BY cargo_type, cargo_type_desc)
      LOOP
         v_list.cargo_class_cd := i.cargo_class_cd;
         v_list.cargo_type := i.cargo_type;
         v_list.cargo_type_desc := i.cargo_type_desc;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_cargo_type;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.16.2013
**  Reference By    : (GIISS008 - Underwriting - File Maintenance - Marine Cargo - Cargo Type)
**  Description     : Insert or update record in giis_cargo_type
*/
   PROCEDURE set_cargo_type (
      p_cargo_class_cd    giis_cargo_type.cargo_class_cd%TYPE,
      p_cargo_type        giis_cargo_type.cargo_type%TYPE,
      p_cargo_type_desc   giis_cargo_type.cargo_type_desc%TYPE,
      p_remarks           giis_cargo_type.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_cargo_type
         USING DUAL
         ON (cargo_class_cd = p_cargo_class_cd AND cargo_type = p_cargo_type)
         WHEN NOT MATCHED THEN
            INSERT (cargo_class_cd, cargo_type, cargo_type_desc, remarks)
            VALUES (p_cargo_class_cd, p_cargo_type, p_cargo_type_desc,
                    p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET cargo_type_desc = p_cargo_type_desc, remarks = p_remarks
            ;
   END set_cargo_type;

/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.16.2013
**  Reference By    : (GIISS008 - Underwriting - File Maintenance - Marine Cargo - Cargo Type)
**  Description     : Delete record in giis_cargo_type
*/
   PROCEDURE delete_in_cargo_type (
      p_cargo_class_cd   giis_cargo_type.cargo_class_cd%TYPE,
      p_cargo_type       giis_cargo_type.cargo_type%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_cargo_type
            WHERE cargo_class_cd = p_cargo_class_cd
              AND cargo_type = p_cargo_type;
   END delete_in_cargo_type;

   FUNCTION validate_cargo_type (p_cargo_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_cargo_type
                 WHERE cargo_type = p_cargo_type)
      LOOP
         v_result := 'Record already exists with the same cargo_type.';
         EXIT;
      END LOOP;

      RETURN v_result;
   END validate_cargo_type;

   FUNCTION chk_delete_giiss008_cargo_type (p_cargo_type VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
      v_count1   NUMBER         := 0;
      v_count2   NUMBER         := 0;
      v_count3   NUMBER         := 0;
   BEGIN
      FOR i IN (SELECT cargo_type
                  FROM gipi_cargo
                 WHERE cargo_type = p_cargo_type)
      LOOP
         v_result :=
            'Cannot delete record from GIIS_CARGO_TYPE while dependent record(s) in GIPI_CARGO exists.';
      END LOOP;

      IF v_result = 'TRUE'
      THEN
         FOR i IN (SELECT cargo_type
                     FROM gipi_wcargo
                    WHERE cargo_type = p_cargo_type)
         LOOP
            v_result :=
               'Cannot delete record from GIIS_CARGO_TYPE while dependent record(s) in GIPI_WCARGO exists.';
         END LOOP;
      END IF;

      IF v_result = 'TRUE'
      THEN
         FOR i IN (SELECT cargo_type
                     FROM gipi_quote_cargo
                    WHERE cargo_type = p_cargo_type)
         LOOP
            v_result :=
               'Cannot delete record from GIIS_CARGO_TYPE while dependent record(s) in GIPI_QUOTE_CARGO exists.';
         END LOOP;
      END IF;

      RETURN v_result;
   END chk_delete_giiss008_cargo_type;
END giiss008_pkg;
/



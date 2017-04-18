CREATE OR REPLACE PACKAGE BODY CPI.giiss080_pkg
AS
/*
**  Created by    : Ildefonso Ellarina
**  Date Created  : 09.11.2013
**  Reference By  : (GIISS080 - Underwriting - File Maintenance - Multi Line Package - Geography Class)
**  Description   : Populate Geography Class List
*/
   FUNCTION show_geog_class
      RETURN geog_class_tab PIPELINED
   IS
      v_list   geog_class_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_geog_class
                ORDER BY geog_cd, geog_desc, class_type)
      LOOP
         v_list.geog_cd := i.geog_cd;
         v_list.geog_desc := i.geog_desc;
         v_list.class_type := i.class_type;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := i.last_update;

         BEGIN
            SELECT DISTINCT SUBSTR (rv_meaning, 1, 8) rv_meaning
                       INTO v_list.mean_class_type
                       FROM cg_ref_codes
                      WHERE rv_domain = 'GIIS_GEOG_CLASS.CLASS_TYPE'
                        AND SUBSTR (rv_low_value, 1, 1) = i.class_type;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_geog_class;

   FUNCTION validate_geog_cd_input (p_input_string VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_geog_class
                 WHERE geog_cd = p_input_string)
      LOOP
         v_result := 'Geography code must be unique.';
         EXIT;
      END LOOP;

      RETURN v_result;
   END validate_geog_cd_input;

   FUNCTION validate_geog_desc_input (p_input_string VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_geog_class
                 WHERE geog_desc = p_input_string)
      LOOP
         v_result := 'Geography Classification Description already exists.';
         EXIT;
      END LOOP;

      RETURN v_result;
   END validate_geog_desc_input;

   FUNCTION validate_before_delete (p_geog_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
      v_count1   NUMBER;
      v_count2   NUMBER;
      v_count3   NUMBER;
      v_count4   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO v_count1
           FROM gipi_wopen_liab
          WHERE geog_cd = p_geog_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_count1 := 0;
      END;

      BEGIN
         SELECT COUNT (*)
           INTO v_count2
           FROM gipi_wcargo
          WHERE geog_cd = p_geog_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_count2 := 0;
      END;

      BEGIN
         SELECT COUNT (*)
           INTO v_count3
           FROM gipi_open_liab
          WHERE geog_cd = p_geog_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_count3 := 0;
      END;

      BEGIN
         SELECT COUNT (*)
           INTO v_count4
           FROM gipi_cargo
          WHERE geog_cd = p_geog_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_count4 := 0;
      END;

      IF (   (v_count1 > 0)
          OR (v_count2 > 0)
          OR (v_count3 > 0)
          OR (v_count4 > 0)
         )
      THEN
         v_result :=
            'Cannot delete this record while dependent exists in some tables.';
      END IF;

      RETURN v_result;
   END validate_before_delete;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.12.2013
**  Reference By    : (GIISS080 - Underwriting - File Maintenance - Marine Cargo - Geography Class)
**  Description     : Insert or update record in giis_geog_class
*/
   PROCEDURE set_geog_class (
      p_geog_cd      giis_geog_class.geog_cd%TYPE,
      p_geog_desc    giis_geog_class.geog_desc%TYPE,
      p_class_type   giis_geog_class.class_type%TYPE,
      p_remarks      giis_geog_class.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_geog_class
         USING DUAL
         ON (geog_cd = p_geog_cd)
         WHEN NOT MATCHED THEN
            INSERT (geog_cd, geog_desc, class_type, remarks)
            VALUES (p_geog_cd, p_geog_desc, p_class_type, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET geog_desc = p_geog_desc, class_type = p_class_type,
                   remarks = p_remarks
            ;
   END set_geog_class;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.12.2013
**  Reference By    : (GIISS080 - Underwriting - File Maintenance - Marine Cargo - Geography Class)
**  Description     : Delete record in giis_geog_class
*/
   PROCEDURE delete_in_geog_class (p_geog_cd giis_geog_class.geog_cd%TYPE)
   IS
   BEGIN
      DELETE FROM giis_geog_class
            WHERE geog_cd = p_geog_cd;
   END delete_in_geog_class;
END giiss080_pkg;
/



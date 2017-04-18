CREATE OR REPLACE PACKAGE BODY CPI.giiss052_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.02.2013
**  Reference By    : (GIISS052 - Underwriting - File Maintenance -Fire - Typhoon Zone)
**  Description  : Populate Typhoon Zone List
*/
   FUNCTION show_typhoon_zone
      RETURN typhoon_zone_tab PIPELINED
   IS
      v_list   typhoon_zone_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_typhoon_zone
                ORDER BY typhoon_zone)
      LOOP
         v_list.zone_grp_desc := NULL;
         v_list.typhoon_zone := i.typhoon_zone;
         v_list.typhoon_zone_desc := i.typhoon_zone_desc;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         v_list.remarks := i.remarks;
         v_list.zone_grp := i.zone_grp;

         FOR j IN (SELECT rv_low_value, rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = 'ZONE_GROUP'
                      AND rv_low_value = i.zone_grp)
         LOOP
            v_list.zone_grp_desc := j.rv_meaning;
            EXIT;
         END LOOP;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_typhoon_zone;

   FUNCTION validate_typhoon_zone_input (
      p_txt_field      VARCHAR2,
      p_input_string   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
      v_count    NUMBER;
   BEGIN
      IF p_txt_field = 'Typhoon Zone'
      THEN
         BEGIN
            SELECT COUNT (typhoon_zone)
              INTO v_count
              FROM giis_typhoon_zone
             WHERE typhoon_zone = p_input_string;

            IF v_count <> 0
            THEN
               v_result := 'Typhoon zone already exists. ';
            END IF;
         END;
      ELSIF p_txt_field = 'Typhoon Zone Description'
      THEN
         BEGIN
            SELECT COUNT (typhoon_zone_desc)
              INTO v_count
              FROM giis_typhoon_zone
             WHERE typhoon_zone_desc = p_input_string;

            IF v_count <> 0
            THEN
               v_result := 'Typhoon Zone Description already exists. ';
            END IF;
         END;
      END IF;

      RETURN v_result;
   END validate_typhoon_zone_input;

   FUNCTION validate_delete_typhoon_zone (p_typhoon_zone VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
      v_count    NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (typhoon_zone)
           INTO v_count
           FROM gipi_wfireitm
          WHERE typhoon_zone = p_typhoon_zone;

         IF v_count <> 0
         THEN
            v_result :=
               'Cannot delete Typhoon Zones while dependent GIPI_WFIREITM exists';
         END IF;
      END;

      IF v_result = 'TRUE'
      THEN
         BEGIN
            SELECT COUNT (typhoon_zone)
              INTO v_count
              FROM gipi_fireitem
             WHERE typhoon_zone = p_typhoon_zone;

            IF v_count <> 0
            THEN
               v_result :=
                  'Cannot delete Typhoon Zones while dependent Fire Item exists';
            END IF;
         END;
      END IF;

      RETURN v_result;
   END validate_delete_typhoon_zone;

   FUNCTION show_zone_group_lov
      RETURN zone_group_lov_tab PIPELINED
   IS
      v_list   zone_group_lov_type;
   BEGIN
      FOR i IN (SELECT rv_low_value, rv_meaning
                  FROM cg_ref_codes
                 WHERE rv_domain = 'ZONE_GROUP')
      LOOP
         v_list.zone_grp := i.rv_low_value;
         v_list.zone_grp_desc := i.rv_meaning;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_zone_group_lov;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.04.2013
**  Reference By    : (GIISS052 - Underwriting - File Maintenance -Fire - Typhoon Zone)
**  Description     : Insert or update record in giis_typhoon_zone
*/
   PROCEDURE set_typhoon_zone (
      p_typhoon_zone        giis_typhoon_zone.typhoon_zone%TYPE,
      p_zone_grp            giis_typhoon_zone.zone_grp%TYPE,
      p_typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE,
      p_remarks             giis_typhoon_zone.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_typhoon_zone
         USING DUAL
         ON (typhoon_zone = p_typhoon_zone)
         WHEN NOT MATCHED THEN
            INSERT (typhoon_zone, zone_grp, typhoon_zone_desc, remarks)
            VALUES (p_typhoon_zone, p_zone_grp, p_typhoon_zone_desc,
                    p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET zone_grp = p_zone_grp,
                   typhoon_zone_desc = p_typhoon_zone_desc,
                   remarks = p_remarks
            ;
   END set_typhoon_zone;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.04.2013
**  Reference By    : (GIISS052 - Underwriting - File Maintenance -Fire - Typhoon Zone)
**  Description     : Delete record in giis_typhoon_zone
*/
   PROCEDURE delete_in_typhoon_zone (
      p_typhoon_zone   giis_typhoon_zone.typhoon_zone%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_typhoon_zone
            WHERE typhoon_zone = p_typhoon_zone;
   END delete_in_typhoon_zone;
END giiss052_pkg;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss055_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.24.2013
**  Reference By    : (GIISS055 - Underwriting - File Maintenance - Motor Car - Motor Type)
**  Description  : Populate Motor Type List
*/
   FUNCTION get_subline (p_user_id VARCHAR2)
      RETURN subline_tab PIPELINED
   IS
      v_list   subline_type;
   BEGIN
      FOR i IN (SELECT DISTINCT subline_cd, subline_name
                           FROM giis_subline
                          WHERE 1 = 1
                            AND line_cd IN (
                                   SELECT line_cd
                                     FROM giis_line
                                    WHERE (   line_cd = 'MC'
                                           OR menu_line_cd = 'MC'
                                          )
                                      AND check_user_per_line2 (line_cd,
                                                                NULL,
                                                                'GIISS055',
                                                                p_user_id
                                                               ) = 1)
                       ORDER BY subline_cd)
      LOOP
         v_list.subline_cd := i.subline_cd;
         v_list.subline_name := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_subline;

   FUNCTION get_motor_type (p_subline_cd VARCHAR2)
      RETURN motor_type_tab PIPELINED
   IS
      v_list   motor_type_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_motortype
                 WHERE subline_cd = p_subline_cd)
      LOOP
         v_list.type_cd := i.type_cd;
         v_list.motor_type_desc := i.motor_type_desc;
         v_list.subline_cd := i.subline_cd;
         v_list.unladen_wt := i.unladen_wt;
         v_list.motor_type_rate := i.motor_type_rate;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                          TO_CHAR (i.last_update, 'MM-DD-YYYY   HH:MI:SS AM');
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_motor_type;

   FUNCTION validate_giiss055_motor_type (
      p_type_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_motortype
                 WHERE type_cd = p_type_cd AND subline_cd = p_subline_cd)
      LOOP
         v_result :=
                   'Record already exists with the same type_cd and subline_cd.';
      END LOOP;

      RETURN v_result;
   END validate_giiss055_motor_type;

   FUNCTION chk_delete_giiss055_motor_type (
      p_type_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_exists   VARCHAR2 (1);
      v_result   VARCHAR2 (500) := 'TRUE';
      v_count1   NUMBER;
      v_count2   NUMBER;
      v_count3   NUMBER;
      v_count4   NUMBER;
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wvehicle a
                 WHERE a.subline_cd = p_subline_cd AND a.mot_type = p_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         v_result :=
            'Cannot delete record from GIIS_MOTORTYPE while dependent record(s) in GIPI_WVEHICLE exists.';
         RETURN v_result;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_vehicle a
                 WHERE a.subline_cd = p_subline_cd AND a.mot_type = p_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         v_result :=
            'Cannot delete record from GIIS_MOTORTYPE while dependent record(s) in GIPI_VEHICLE exists.';
         RETURN v_result;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_mc_peril_rate a
                 WHERE a.subline_cd = p_subline_cd
                   AND a.motortype_cd = p_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         v_result :=
            'Cannot delete record from GIIS_MOTORTYPE while dependent record(s) in GIIS_MC_PERIL_RATE exists.';
         RETURN v_result;
      END IF;

      FOR i IN (SELECT '1'
                  FROM giis_tariff_rates_hdr a
                 WHERE a.subline_cd = p_subline_cd
                   AND a.motortype_cd = p_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         v_result :=
            'Cannot delete record from GIIS_MOTORTYPE while dependent record(s) in GIIS_TARIFF_RATES_HDR exists.';
         RETURN v_result;
      END IF;

      FOR i IN (SELECT '1'
                  FROM gipi_quote_item_mc a
                 WHERE a.subline_cd = p_subline_cd AND a.mot_type = p_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         v_result :=
            'Cannot delete record from GIIS_MOTORTYPE while dependent record(s) in GIPI_QUOTE_ITEM_MC exists.';
         RETURN v_result;
      END IF;

      RETURN v_result;
   END chk_delete_giiss055_motor_type;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.09.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description     : Insert or update record in giis_line_subline_coverages
*/
   PROCEDURE set_motor_type (
      p_subline_cd        giis_motortype.subline_cd%TYPE,
      p_type_cd           giis_motortype.type_cd%TYPE,
      p_motor_type_desc   giis_motortype.motor_type_desc%TYPE,
      p_unladen_wt        giis_motortype.unladen_wt%TYPE,
      p_remarks           giis_motortype.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_motortype
         USING DUAL
         ON (subline_cd = p_subline_cd AND type_cd = p_type_cd)
         WHEN NOT MATCHED THEN
            INSERT (subline_cd, type_cd, motor_type_desc, unladen_wt,
                    remarks)
            VALUES (p_subline_cd, p_type_cd, p_motor_type_desc, p_unladen_wt,
                    p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET motor_type_desc = p_motor_type_desc,
                   unladen_wt = p_unladen_wt, remarks = p_remarks
            ;
   END set_motor_type;

/*
**  Created by       :Fons Ellarina
**  Date Created    : 09.09.2013
**  Reference By    : (GIISS096 - Underwriting - File Maintenance - Multi Line Package - Package Line/Subline Coverage)
**  Description     : Delete record in giis_line_subline_coverages
*/
   PROCEDURE delete_in_motor_type (
      p_subline_cd   giis_motortype.subline_cd%TYPE,
      p_type_cd      giis_motortype.type_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM giis_motortype
            WHERE subline_cd = p_subline_cd AND type_cd = p_type_cd;
   END delete_in_motor_type;
END giiss055_pkg;
/



CREATE OR REPLACE PACKAGE BODY CPI.giiss047_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created    : 09.23.2013
**  Reference By    : (GIISS008 - Underwriting - File Maintenance - Marine Hull - Vessel Classification)
**  Description  : Populate Vessel Classification List
*/
   FUNCTION show_vessel_classification
      RETURN vess_class_tab PIPELINED
   IS
      v_list   vess_class_type;
   BEGIN
      FOR i IN (SELECT   *
                    FROM giis_vess_class
                ORDER BY vess_class_cd)
      LOOP
         v_list.vess_class_cd := i.vess_class_cd;
         v_list.vess_class_desc := i.vess_class_desc;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         v_list.remarks := i.remarks;
         v_list.cpi_rec_no := i.cpi_rec_no;
         v_list.cpi_branch_cd := i.cpi_branch_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_vessel_classification;

   FUNCTION validate_giiss047_vessel_class (p_vess_class_cd VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result   VARCHAR2 (500) := 'TRUE';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_vess_class
                 WHERE vess_class_cd = p_vess_class_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same vess_class_cd.');
      END LOOP;

      RETURN v_result;
   END validate_giiss047_vessel_class;

     /*
   **  Created by   : Ildefonso Ellarina
   **  Date Created    : 09.20.2013
   **  Reference By    : (GIISS030 - Underwriting - File Maintenance - Reinsurance - Reinsurer)
   **  Description     : Insert or update record in giis_reinsurer
   */
   PROCEDURE set_vess_class (
      p_vess_class_cd     giis_vess_class.vess_class_cd%TYPE,
      p_vess_class_desc   giis_vess_class.vess_class_desc%TYPE,
      p_remarks           giis_vess_class.remarks%TYPE,
      p_cpi_rec_no        giis_vess_class.cpi_rec_no%TYPE,
      p_cpi_branch_cd     giis_vess_class.cpi_branch_cd%TYPE
   )
   IS
   BEGIN
      MERGE INTO giis_vess_class
         USING DUAL
         ON (vess_class_cd = p_vess_class_cd)
         WHEN NOT MATCHED THEN
            INSERT (vess_class_cd, vess_class_desc, remarks)
            VALUES (p_vess_class_cd, p_vess_class_desc, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET vess_class_desc = p_vess_class_desc, remarks = p_remarks,
                   cpi_rec_no = p_cpi_rec_no,
                   cpi_branch_cd = p_cpi_branch_cd
            ;
   END set_vess_class;
   
   PROCEDURE val_del_rec(
      p_vess_class_cd      giis_vess_class.vess_class_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_vessel
                WHERE vess_class_cd = p_vess_class_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_VESS_CLASS while dependent record(s) in GIIS_VESSEL exists.');
      END LOOP;
   END;
   
   PROCEDURE del_rec(
      p_vess_class_cd      giis_vess_class.vess_class_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_vess_class
       WHERE vess_class_cd = p_vess_class_cd;
   END;
END giiss047_pkg;
/



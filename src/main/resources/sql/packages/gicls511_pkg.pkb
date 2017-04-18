CREATE OR REPLACE PACKAGE BODY CPI.gicls511_pkg
AS
/*
**  Created by   : Ildefonso Ellarina
**  Date Created : 8.30.2013
**  Reference By    : (GICLS511 - Table Maintenance Driver Occupation)
**  Description  : Populate Driver Occupation List
*/
   FUNCTION show_drvr_occptn
      RETURN drvr_occptn_tab PIPELINED
   IS
      v_list   drvr_occptn_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_drvr_occptn)
      LOOP
         v_list.drvr_occ_cd := i.drvr_occ_cd;
         v_list.occ_desc := i.occ_desc;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END show_drvr_occptn;

   FUNCTION validate_drvr_occptn_input (p_input_string VARCHAR2)
      RETURN VARCHAR2
   IS
      v_result    VARCHAR2 (500) := 'TRUE';
      v_drvr_cd   NUMBER;
   BEGIN
      BEGIN
         SELECT COUNT (drvr_occ_cd)
           INTO v_drvr_cd
           FROM gicl_drvr_occptn
          WHERE drvr_occ_cd = p_input_string;

         IF v_drvr_cd <> 0
         THEN
            v_result := 'Driver occupation code must be unique';
         END IF;
      END;

      RETURN v_result;
   END validate_drvr_occptn_input;

        /*
   **  Created by       :Fons Ellarina
   **  Date Created    : 09.02.2013
   **  Reference By    : (GICLS511 - Table Maintenance - Driver Occupation)
   **  Description     : Insert or update record in gicl_drvr_occptn
   */
   PROCEDURE set_drvr_occptn (
      p_drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE,
      p_occ_desc      gicl_drvr_occptn.occ_desc%TYPE,
      p_remarks       gicl_drvr_occptn.remarks%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_drvr_occptn
         USING DUAL
         ON (drvr_occ_cd = p_drvr_occ_cd)
         WHEN NOT MATCHED THEN
            INSERT (drvr_occ_cd, occ_desc, remarks)
            VALUES (p_drvr_occ_cd, p_occ_desc, p_remarks)
         WHEN MATCHED THEN
            UPDATE
               SET occ_desc = p_occ_desc, remarks = p_remarks
            ;
   END set_drvr_occptn;

       /*
   **  Created by       :Fons Ellarina
   **  Date Created    : 09.02.2013
   **  Reference By    : (GICLS511 - Table Maintenance - Driver Occupation)
   **  Description     : Delete record in gicl_drvr_occptn
   */
   PROCEDURE delete_in_drvr_occptn (
      p_drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_drvr_occptn
            WHERE drvr_occ_cd = p_drvr_occ_cd;
   END delete_in_drvr_occptn;
END gicls511_pkg;
/



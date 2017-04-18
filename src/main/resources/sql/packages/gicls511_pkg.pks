CREATE OR REPLACE PACKAGE CPI.gicls511_pkg
AS
   TYPE drvr_occptn_type IS RECORD (
      drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE,
      occ_desc      gicl_drvr_occptn.occ_desc%TYPE,
      remarks       gicl_drvr_occptn.remarks%TYPE,
      user_id       gicl_drvr_occptn.user_id%TYPE,
      last_update   VARCHAR2 (200)
   );

   TYPE drvr_occptn_tab IS TABLE OF drvr_occptn_type;

   FUNCTION show_drvr_occptn
      RETURN drvr_occptn_tab PIPELINED;

   FUNCTION validate_drvr_occptn_input (p_input_string VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE set_drvr_occptn (
      p_drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE,
      p_occ_desc      gicl_drvr_occptn.occ_desc%TYPE,
      p_remarks       gicl_drvr_occptn.remarks%TYPE
   );

   PROCEDURE delete_in_drvr_occptn (
      p_drvr_occ_cd   gicl_drvr_occptn.drvr_occ_cd%TYPE
   );
END;
/



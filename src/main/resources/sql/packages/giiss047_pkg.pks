CREATE OR REPLACE PACKAGE CPI.giiss047_pkg
AS
   TYPE vess_class_type IS RECORD (
      vess_class_cd     giis_vess_class.vess_class_cd%TYPE,
      vess_class_desc   giis_vess_class.vess_class_desc%TYPE,
      user_id           giis_vess_class.user_id%TYPE,
      last_update       VARCHAR2 (200),
      remarks           giis_vess_class.remarks%TYPE,
      cpi_rec_no        giis_vess_class.cpi_rec_no%TYPE,
      cpi_branch_cd     giis_vess_class.cpi_branch_cd%TYPE
   );

   TYPE vess_class_tab IS TABLE OF vess_class_type;

   FUNCTION show_vessel_classification
      RETURN vess_class_tab PIPELINED;

   FUNCTION validate_giiss047_vessel_class (p_vess_class_cd VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE set_vess_class (
      p_vess_class_cd     giis_vess_class.vess_class_cd%TYPE,
      p_vess_class_desc   giis_vess_class.vess_class_desc%TYPE,
      p_remarks           giis_vess_class.remarks%TYPE,
      p_cpi_rec_no        giis_vess_class.cpi_rec_no%TYPE,
      p_cpi_branch_cd     giis_vess_class.cpi_branch_cd%TYPE
   );
   
   PROCEDURE val_del_rec(
      p_vess_class_cd      giis_vess_class.vess_class_cd%TYPE
   );
   
   PROCEDURE del_rec(
      p_vess_class_cd      giis_vess_class.vess_class_cd%TYPE
   );
END;
/



CREATE OR REPLACE PACKAGE CPI.giiss008_pkg
AS
   TYPE cargo_class_type IS RECORD (
      cargo_class_cd     giis_cargo_class.cargo_class_cd%TYPE,
      cargo_class_desc   giis_cargo_class.cargo_class_desc%TYPE
   );

   TYPE cargo_class_tab IS TABLE OF cargo_class_type;

   TYPE cargo_type_type IS RECORD (
      cargo_class_cd    giis_cargo_type.cargo_class_cd%TYPE,
      cargo_type        giis_cargo_type.cargo_type%TYPE,
      cargo_type_desc   giis_cargo_type.cargo_type_desc%TYPE,
      remarks           giis_cargo_type.remarks%TYPE,
      user_id           giis_cargo_type.user_id%TYPE,
      last_update       VARCHAR2 (200),
      cpi_rec_no        giis_cargo_type.cpi_rec_no%TYPE,
      cpi_branch_cd     giis_cargo_type.cpi_branch_cd%TYPE
   );

   TYPE cargo_type_tab IS TABLE OF cargo_type_type;

   FUNCTION show_cargo_class
      RETURN cargo_class_tab PIPELINED;

   FUNCTION show_cargo_type (p_cargo_class_cd VARCHAR2)
      RETURN cargo_type_tab PIPELINED;

   PROCEDURE set_cargo_type (
      p_cargo_class_cd    giis_cargo_type.cargo_class_cd%TYPE,
      p_cargo_type        giis_cargo_type.cargo_type%TYPE,
      p_cargo_type_desc   giis_cargo_type.cargo_type_desc%TYPE,
      p_remarks           giis_cargo_type.remarks%TYPE
   );

   PROCEDURE delete_in_cargo_type (
      p_cargo_class_cd   giis_cargo_type.cargo_class_cd%TYPE,
      p_cargo_type       giis_cargo_type.cargo_type%TYPE
   );

   FUNCTION validate_cargo_type (p_cargo_type VARCHAR2)
      RETURN VARCHAR2;

   FUNCTION chk_delete_giiss008_cargo_type (p_cargo_type VARCHAR2)
      RETURN VARCHAR2;
END;
/



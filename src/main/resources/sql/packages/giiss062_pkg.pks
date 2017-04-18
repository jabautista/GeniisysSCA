CREATE OR REPLACE PACKAGE CPI.giiss062_pkg
AS
   TYPE giis_class_type IS RECORD (
      class_cd        giis_class.class_cd%TYPE,
      class_desc      giis_class.class_desc%TYPE,
      user_id         giis_class.user_id%TYPE,
      last_update     giis_class.last_update%TYPE,
      remarks         giis_class.remarks%TYPE,
      cpi_rec_no      giis_class.cpi_rec_no%TYPE,
      cpi_branch_cd   giis_class.cpi_branch_cd%TYPE
   );

   TYPE giis_class_tab IS TABLE OF giis_class_type;

   TYPE giis_peril_class_type IS RECORD (
      class_cd        giis_peril_class.class_cd%TYPE,
      line_cd         giis_peril_class.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      peril_cd        giis_peril_class.peril_cd%TYPE,
      peril_sname     giis_peril.peril_sname%TYPE,
      peril_name      giis_peril.peril_name%TYPE,
      user_id         giis_peril_class.user_id%TYPE,
      last_update     giis_peril_class.last_update%TYPE,
      remarks         giis_peril_class.remarks%TYPE,
      cpi_rec_no      giis_peril_class.cpi_rec_no%TYPE,
      cpi_branch_cd   giis_peril_class.cpi_branch_cd%TYPE
   );

   TYPE giis_peril_class_tab IS TABLE OF giis_peril_class_type;

   TYPE giis_peril_sname_name_type IS RECORD (
      line_cd       giis_peril.line_cd%TYPE,
      peril_cd      giis_peril.peril_cd%TYPE,
      peril_sname   giis_peril.peril_sname%TYPE,
      peril_name    giis_peril.peril_name%TYPE
   );

   TYPE giis_peril_sname_name_tab IS TABLE OF giis_peril_sname_name_type;

   TYPE line_listing_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;

   FUNCTION get_giis_class_list
      RETURN giis_class_tab PIPELINED;

   FUNCTION get_giis_peril_class_list (
      p_class_cd    giis_class.class_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giis_peril_class_tab PIPELINED;

   FUNCTION get_giis_peril_sname_name (p_line_cd giis_peril.line_cd%TYPE)
      RETURN giis_peril_sname_name_tab PIPELINED;

   PROCEDURE delete_giis_peril_class (
      p_class_cd   giis_peril_class.class_cd%TYPE,
      p_line_cd    giis_peril_class.line_cd%TYPE,
      p_peril_cd   giis_peril_class.peril_cd%TYPE
   );

   PROCEDURE set_giis_peril_class (p_peril_class giis_peril_class%ROWTYPE);

   FUNCTION validate_peril_class (
      p_class_cd   giis_peril_class.class_cd%TYPE,
      p_line_cd    giis_peril_class.line_cd%TYPE,
      p_peril_cd   giis_peril_class.peril_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_giis_line_list (
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;
END;
/



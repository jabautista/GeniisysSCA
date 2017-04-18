CREATE OR REPLACE PACKAGE CPI.giiss096_pkg
AS
   TYPE pkg_line_subline_cvrg_type IS RECORD (
      line_cd             giis_line_subline_coverages.line_cd%TYPE,
      pack_line_cd        giis_line_subline_coverages.pack_line_cd%TYPE,
      pack_subline_cd     giis_line_subline_coverages.pack_subline_cd%TYPE,
      required_flag       giis_line_subline_coverages.required_flag%TYPE,
      user_id             giis_line_subline_coverages.user_id%TYPE,
      last_update         VARCHAR2 (200),
      remarks             giis_line_subline_coverages.remarks%TYPE,
      pack_line_name      giis_line.line_name%TYPE,
      pack_subline_name   giis_subline.subline_name%TYPE
   );

   TYPE pkg_line_subline_cvrg_tab IS TABLE OF pkg_line_subline_cvrg_type;

   TYPE pkg_line_cvrg_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE pkg_line_cvrg_tab IS TABLE OF pkg_line_cvrg_type;

   TYPE pkg_line_cvrg_lov_type IS RECORD (
      pack_line_cd     giis_line.line_cd%TYPE,
      pack_line_name   giis_line.line_name%TYPE
   );

   TYPE pkg_line_cvrg_lov_tab IS TABLE OF pkg_line_cvrg_lov_type;

   TYPE pkg_subline_cvrg_lov_type IS RECORD (
      pack_subline_cd     giis_subline.subline_cd%TYPE,
      pack_subline_name   giis_subline.subline_name%TYPE
   );

   TYPE pkg_subline_cvrg_lov_tab IS TABLE OF pkg_subline_cvrg_lov_type;

   FUNCTION show_pkg_line_cvrg (p_user_id giis_users.user_id%TYPE)
      RETURN pkg_line_cvrg_tab PIPELINED;

   FUNCTION show_pkg_line_subline_cvrg (
      p_line_cd   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN pkg_line_subline_cvrg_tab PIPELINED;

   FUNCTION get_pkg_line_cvrg_lov (p_user_id giis_users.user_id%TYPE)
      RETURN pkg_line_cvrg_lov_tab PIPELINED;

   FUNCTION get_pkg_subline_cvrg_lov (p_pack_line_cd VARCHAR2)
      RETURN pkg_subline_cvrg_lov_tab PIPELINED;

   PROCEDURE set_pkg_line_subline_cvrg (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE,
      p_required_flag     giis_line_subline_coverages.required_flag%TYPE,
      p_remarks           giis_line_subline_coverages.remarks%TYPE
   );

   PROCEDURE dlt_in_pkg_line_subline_cvrg (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   );
   
   PROCEDURE val_add_rec (
      p_line_cd           giis_line_subline_coverages.line_cd%TYPE,
      p_pack_line_cd      giis_line_subline_coverages.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE
   );
END;
/



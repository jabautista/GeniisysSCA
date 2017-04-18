CREATE OR REPLACE PACKAGE CPI.GIISS020_PKG
AS
   TYPE rec_type IS RECORD (
      section_line_cd         giis_section_or_hazard.section_line_cd%TYPE,
      line_name               giis_line.line_name%TYPE,
      section_subline_cd      giis_section_or_hazard.section_subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE,
      section_or_hazard_cd    giis_section_or_hazard.section_or_hazard_cd%TYPE,
      section_or_hazard_title giis_section_or_hazard.section_or_hazard_title%TYPE,
      remarks                 giis_section_or_hazard.remarks%TYPE,
      user_id                 giis_section_or_hazard.user_id%TYPE,
      last_update             VARCHAR2(30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_from_menu             VARCHAR2
   ) RETURN rec_tab PIPELINED;
   
   TYPE line_lov_type IS RECORD (
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE
   );
   
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   FUNCTION get_line_lov(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN line_lov_tab PIPELINED;
   
   TYPE subline_lov_type IS RECORD (
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE,
      subline_cd              giis_subline.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE
   );
   
   TYPE subline_lov_tab IS TABLE OF subline_lov_type;
   
   FUNCTION get_subline_lov(
      p_line_cd               giis_line.line_cd%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN subline_lov_tab PIPELINED;
   
   FUNCTION get_line_subline_lov(
      p_module_id             giis_modules.module_id%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_keyword               VARCHAR2
   ) RETURN subline_lov_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_section_or_hazard%ROWTYPE);

   PROCEDURE del_rec (p_rec giis_section_or_hazard%ROWTYPE);

   PROCEDURE val_add_rec(
      p_line_cd               giis_section_or_hazard.section_line_cd%TYPE,
      p_subline_cd            giis_section_or_hazard.section_subline_cd%TYPE,
      p_section_or_hazard_cd  giis_section_or_hazard.section_or_hazard_cd%TYPE
   );
   
   PROCEDURE val_del_rec(
      p_line_cd               giis_section_or_hazard.section_line_cd%TYPE,
      p_subline_cd            giis_section_or_hazard.section_subline_cd%TYPE,
      p_section_or_hazard_cd  giis_section_or_hazard.section_or_hazard_cd%TYPE
   );
END;
/



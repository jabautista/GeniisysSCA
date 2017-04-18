
CREATE OR REPLACE PACKAGE CPI.giiss056_pkg
AS
   TYPE main_type IS RECORD (
      subline_cd             giis_mc_subline_type.subline_cd%TYPE,
      subline_type_cd        giis_mc_subline_type.subline_type_cd%TYPE,
      subline_type_desc      giis_mc_subline_type.subline_type_desc%TYPE,
      remarks                giis_mc_subline_type.remarks%TYPE,
      user_id                giis_mc_subline_type.user_id%TYPE,
      last_update            VARCHAR2 (50)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main
      RETURN main_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov
      RETURN subline_lov_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_subline_cd              VARCHAR2,
      p_old_subline_type_cd     VARCHAR2,
      p_new_subline_type_cd     VARCHAR2,
      p_action                  VARCHAR2,
      p_old_subline_type_desc   VARCHAR2,
      p_new_subline_type_desc   VARCHAR2
   );

   PROCEDURE save_rec (p_rec giis_mc_subline_type%ROWTYPE);
   
   PROCEDURE val_del_rec (p_subline_type_cd VARCHAR2);

   PROCEDURE del_rec (p_subline_cd VARCHAR2, p_subline_type_cd VARCHAR2);
  
 
END;
/
CREATE OR REPLACE PACKAGE CPI.giiss114_pkg
AS
   TYPE rec_type IS RECORD (
      basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      basic_color      giis_mc_color.basic_color%TYPE,
      color_cd         giis_mc_color.color_cd%TYPE,
      color            giis_mc_color.color%TYPE,
      remarks          giis_mc_color.remarks%TYPE,
      user_id          giis_mc_color.user_id%TYPE,
      last_update      VARCHAR2 (30),
      count_rec        NUMBER
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_basic_color_rec_list (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_basic_color      giis_mc_color.basic_color%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_rec_list (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_color_cd         giis_mc_color.color_cd%TYPE,
      p_color            giis_mc_color.color%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION generate_color_cd (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   )
      RETURN NUMBER;

   PROCEDURE set_rec (p_rec giis_mc_color%ROWTYPE);

   PROCEDURE del_rec (p_rec giis_mc_color%ROWTYPE);

   PROCEDURE del_rec_basic (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   );

   PROCEDURE val_del_rec_basic (
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE
   );

   PROCEDURE val_del_rec (p_color_cd giis_mc_color.color_cd%TYPE);

   PROCEDURE val_add_rec_basic (
      p_action           VARCHAR2, -- andrew - 08052015 - SR 19241
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_basic_color      giis_mc_color.basic_color%TYPE
   );

   PROCEDURE val_add_rec (
      p_action           VARCHAR2, -- andrew - 08052015 - SR 19241
      p_basic_color_cd   giis_mc_color.basic_color_cd%TYPE,
      p_color_cd   giis_mc_color.color_cd%TYPE, -- andrew - 08052015 - SR 19241
      p_color            giis_mc_color.color%TYPE
   );

   PROCEDURE update_basic_rec (p_rec giis_mc_color%ROWTYPE);
END;
/



CREATE OR REPLACE PACKAGE CPI.gicls104_pkg
AS
   TYPE rec_type IS RECORD (
      line_cd               giis_loss_exp.line_cd%TYPE,
      menu_line_cd          giis_line.menu_line_cd%TYPE,
      loss_exp_cd           giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc         giis_loss_exp.loss_exp_desc%TYPE,
      loss_exp_type         giis_loss_exp.loss_exp_type%TYPE,
      loss_exp_type_sp      VARCHAR2 (10),
      old_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE,
      comp_sw               giis_loss_exp.comp_sw%TYPE,
      part_sw               giis_loss_exp.part_sw%TYPE,
      lps_sw                giis_loss_exp.lps_sw%TYPE,
      peril_cd              giis_loss_exp.peril_cd%TYPE,
      peril_name            GIIS_PERIL.PERIL_NAME%TYPE,
      subline_cd            giis_loss_exp.subline_cd%TYPE,
      remarks               giis_loss_exp.remarks%TYPE,
      user_id               giis_loss_exp.user_id%TYPE,
      last_update           VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   TYPE peril_type IS RECORD (
        peril_cd            giis_peril.peril_cd%TYPE,
        peril_name          giis_peril.peril_name%TYPE
   );
   
   TYPE peril_tab IS TABLE OF peril_type;

   FUNCTION get_rec_list (
      p_line_cd             giis_loss_exp.line_cd%TYPE,
      p_loss_exp_cd         giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc       giis_loss_exp.loss_exp_desc%TYPE,
      p_loss_exp_type       VARCHAR2,
      p_peril_cd            NUMBER,
      p_comp_sw             VARCHAR2,
      p_part_sw             VARCHAR2 --added by Pol, used when gicls104 was called via gicls171
   )  RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (
      --p_rec giis_loss_exp%ROWTYPE
      p_line_cd               giis_loss_exp.line_cd%TYPE,
      p_loss_exp_cd           giis_loss_exp.loss_exp_cd%TYPE,
      p_loss_exp_desc         giis_loss_exp.loss_exp_desc%TYPE,
      p_loss_exp_type         giis_loss_exp.loss_exp_type%TYPE,
      p_old_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE,
      p_comp_sw               giis_loss_exp.comp_sw%TYPE,
      p_part_sw               giis_loss_exp.part_sw%TYPE,
      p_lps_sw                giis_loss_exp.lps_sw%TYPE,
      p_peril_cd              giis_loss_exp.peril_cd%TYPE,
      p_subline_cd            giis_loss_exp.subline_cd%TYPE,
      p_remarks               giis_loss_exp.remarks%TYPE,
      p_user_id               giis_loss_exp.user_id%TYPE
   );

   PROCEDURE del_rec (
        p_line_cd            giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd        giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type      giis_loss_exp.loss_exp_type%TYPE
   );

   PROCEDURE val_del_rec (
        p_line_cd        giis_loss_exp.line_cd%TYPE,
        p_subline_cd     giis_loss_exp.subline_cd%TYPE,
        p_loss_exp_cd    giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type  giis_loss_exp.loss_exp_type%TYPE
   );
   
   PROCEDURE val_add_rec(
        p_line_cd           giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE
   );
   
   PROCEDURE validate_part_sw(
        p_loss_exp_cd   IN       giis_loss_exp.loss_exp_cd%TYPE,
        p_part_var      OUT      VARCHAR2,
        p_part_exists   OUT      VARCHAR2,
        p_lps_exists    OUT      VARCHAR2
   );
   
   FUNCTION validate_lps_sw(
        p_loss_exp_cd  giis_loss_exp.loss_exp_cd%TYPE
   ) RETURN VARCHAR2;
   
   PROCEDURE validate_comp_sw(
        p_line_cd           IN      giis_loss_exp.line_cd%TYPE,
        p_loss_exp_cd       IN      giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_desc     IN      giis_loss_exp.loss_exp_desc%TYPE,
        p_loss_exp_type     IN      giis_loss_exp.loss_exp_type%TYPE,
        p_var               OUT     VARCHAR2,
        p_comp_sw           OUT     VARCHAR2
   );
   
   FUNCTION validate_loss_exp_type(
        p_line_cd           giis_loss_exp.line_cd%TYPE,
        p_subline_cd        giis_loss_exp.subline_cd%TYPE,
        p_loss_exp_cd       giis_loss_exp.loss_exp_cd%TYPE,
        p_loss_exp_type     giis_loss_exp.loss_exp_type%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION get_peril_lov(
        p_line_cd       giis_loss_exp.line_cd%TYPE,
        p_keyword       VARCHAR2
   ) RETURN peril_tab PIPELINED;
   
END;
/



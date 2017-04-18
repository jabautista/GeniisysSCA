CREATE OR REPLACE PACKAGE CPI.gicls059_pkg
AS
   TYPE subline_listing_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_listing_tab IS TABLE OF subline_listing_type;

   TYPE loss_exp_listing_type IS RECORD (
      loss_exp_cd     giis_loss_exp.loss_exp_cd%TYPE,
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE
   );

   TYPE loss_exp_listing_tab IS TABLE OF loss_exp_listing_type;

   TYPE rec_type IS RECORD (
      special_part_cd   gicl_mc_depreciation.special_part_cd%TYPE,
      loss_exp_desc     giis_loss_exp.loss_exp_desc%TYPE,
      mc_year_fr        gicl_mc_depreciation.mc_year_fr%TYPE,
      orig_mc_year_fr   gicl_mc_depreciation.mc_year_fr%TYPE,
      rate              gicl_mc_depreciation.rate%TYPE,
      subline_cd        gicl_mc_depreciation.subline_cd%TYPE,
      remarks           gicl_mc_depreciation.remarks%TYPE,
      user_id           gicl_mc_depreciation.user_id%TYPE,
      last_update       VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_giis_subline_list (p_keyword VARCHAR2)
      RETURN subline_listing_tab PIPELINED;

   FUNCTION get_giis_loss_exp_list (p_keyword VARCHAR2)
      RETURN loss_exp_listing_tab PIPELINED;

   FUNCTION get_rec_list (p_subline_cd giis_subline.subline_cd%TYPE)
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (
      p_rec               gicl_mc_depreciation%ROWTYPE,
      p_orig_mc_year_fr   gicl_mc_depreciation.mc_year_fr%TYPE
   );

   PROCEDURE del_rec (
      p_subline_cd        gicl_mc_depreciation.subline_cd%TYPE,
      p_special_part_cd   gicl_mc_depreciation.special_part_cd%TYPE,
      p_orig_mc_year_fr   gicl_mc_depreciation.mc_year_fr%TYPE
   );

   PROCEDURE val_add_rec (
      p_subline_cd        gicl_mc_depreciation.subline_cd%TYPE,
      p_special_part_cd   gicl_mc_depreciation.special_part_cd%TYPE,
      p_mc_year_fr        gicl_mc_depreciation.mc_year_fr%TYPE
   );
END;
/



CREATE OR REPLACE PACKAGE CPI.giiss219_pkg
AS
   TYPE line_listing_type IS RECORD (
      line_cd        giis_line.line_cd%TYPE,
      pack_line_cd   giis_line_subline_coverages.pack_line_cd%TYPE,
      line_name      giis_line.line_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;

   TYPE subline_listing_type IS RECORD (
      subline_cd        giis_subline.subline_cd%TYPE,
      pack_subline_cd   giis_line_subline_coverages.pack_subline_cd%TYPE,
      subline_name      giis_subline.subline_name%TYPE
   );

   TYPE subline_listing_tab IS TABLE OF subline_listing_type;

   TYPE peril_listing_type IS RECORD (
      line_cd      giis_line.line_cd%TYPE,
      subline_cd   giis_subline.subline_cd%TYPE,
      peril_type   giis_peril.peril_type%TYPE,
      peril_cd     giis_peril.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE
   );

   TYPE peril_listing_tab IS TABLE OF peril_listing_type;

   TYPE rec_type IS RECORD (
      plan_cd           giis_plan.plan_cd%TYPE,
      plan_desc         giis_plan.plan_desc%TYPE,
      line_name         giis_line.line_name%TYPE,
      subline_name      giis_subline.subline_name%TYPE,
      line_cd           giis_plan.line_cd%TYPE,
      subline_cd        giis_plan.subline_cd%TYPE,
      pack_line_cd      giis_pack_plan_cover.pack_line_cd%TYPE,
      pack_subline_cd   giis_pack_plan_cover.pack_subline_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      peril_cd          giis_plan_dtl.peril_cd%TYPE,
      peril_type        giis_peril.peril_type%TYPE,
      prem_rt           giis_plan_dtl.prem_rt%TYPE,
      prem_amt          giis_plan_dtl.prem_amt%TYPE,
      no_of_days        giis_plan_dtl.no_of_days%TYPE,
      base_amt          giis_plan_dtl.base_amt%TYPE,
      tsi_amt           giis_plan_dtl.tsi_amt%TYPE,
      total_tsi         NUMBER(32,2),
      aggregate_sw      giis_plan_dtl.aggregate_sw%TYPE,
      remarks           giis_plan.remarks%TYPE,
      user_id           giis_plan.user_id%TYPE,
      last_update       VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_giis_line_list (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giis_subline_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED;

   FUNCTION get_giis_peril_list (
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_keyword      VARCHAR2
   )
      RETURN peril_listing_tab PIPELINED;

   FUNCTION get_giis_line_pack_list (
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giis_subline_pack_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED;

   FUNCTION get_giis_pack_line_list (
      p_line_cd   giis_line.line_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE,
      p_keyword   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giis_pack_subline_list (
      p_line_cd        giis_line.line_cd%TYPE,
      p_pack_line_cd   giis_line_subline_coverages.pack_line_cd%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN subline_listing_tab PIPELINED;

   FUNCTION get_giis_pack_peril_list (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_keyword           VARCHAR2
   )
      RETURN peril_listing_tab PIPELINED;

   FUNCTION get_rec_list_regular (
      p_user_id        giis_users.user_id%TYPE,
      p_plan_cd        giis_plan.plan_cd%TYPE,
      p_plan_desc      giis_plan.plan_desc%TYPE,
      p_line_name      giis_line.line_name%TYPE,
      p_subline_name   giis_subline.subline_name%TYPE,
      p_peril_name     giis_peril.peril_name%TYPE,
      p_mode           VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_rec_list_package (
      p_user_id           giis_users.user_id%TYPE,
      p_plan_cd           giis_pack_plan.plan_cd%TYPE,
      p_plan_desc         giis_pack_plan.plan_desc%TYPE,
      p_pack_line_cd      giis_pack_plan_cover.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover.pack_subline_cd%TYPE,
      p_line_name         giis_line.line_name%TYPE,
      p_subline_name      giis_subline.subline_name%TYPE,
      p_peril_name        giis_peril.peril_name%TYPE,
      p_mode              VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_giis_plan (
      p_plan_cd      IN OUT   giis_plan.plan_cd%TYPE,
      p_plan_desc    IN       giis_plan.plan_desc%TYPE,
      p_line_cd      IN       giis_plan.line_cd%TYPE,
      p_subline_cd   IN       giis_plan.subline_cd%TYPE,
      p_remarks      IN       giis_plan.remarks%TYPE,
      p_user_id      IN       giis_plan.user_id%TYPE
   );

   PROCEDURE set_giis_plan_dtl (p_rec giis_plan_dtl%ROWTYPE);

   PROCEDURE set_giis_pack_plan (
      p_plan_cd      IN OUT   giis_plan.plan_cd%TYPE,
      p_plan_desc    IN       giis_plan.plan_desc%TYPE,
      p_line_cd      IN       giis_plan.line_cd%TYPE,
      p_subline_cd   IN       giis_plan.subline_cd%TYPE,
      p_remarks      IN       giis_plan.remarks%TYPE,
      p_user_id      IN       giis_plan.user_id%TYPE
   );

   PROCEDURE set_giis_pack_plan_cover (p_rec giis_pack_plan_cover%ROWTYPE);

   PROCEDURE set_giis_pack_plan_cover_dtl (
      p_rec   giis_pack_plan_cover_dtl%ROWTYPE
   );

   PROCEDURE del_giis_plan (p_plan_cd giis_plan.plan_cd%TYPE);

   PROCEDURE del_giis_plan_dtl (
      p_peril_cd   giis_plan_dtl.peril_cd%TYPE,
      p_plan_cd    giis_plan_dtl.plan_cd%TYPE
   );

   PROCEDURE del_giis_pack_plan (p_plan_cd giis_pack_plan.plan_cd%TYPE);

   PROCEDURE del_giis_pack_plan_cover (
      p_plan_cd           giis_pack_plan_cover.plan_cd%TYPE,
      p_pack_line_cd      giis_pack_plan_cover.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover.pack_subline_cd%TYPE
   );

   PROCEDURE del_giis_pack_plan_cover_dtl (
      p_peril_cd          giis_pack_plan_cover_dtl.peril_cd%TYPE,
      p_plan_cd           giis_pack_plan_cover_dtl.plan_cd%TYPE,
      p_pack_line_cd      giis_pack_plan_cover_dtl.pack_line_cd%TYPE,
      p_pack_subline_cd   giis_pack_plan_cover_dtl.pack_subline_cd%TYPE
   );

   PROCEDURE val_del_rec (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd            VARCHAR2
   );

   PROCEDURE val_add_rec (
      p_pack_line_cd      giis_line.line_cd%TYPE,
      p_pack_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd            VARCHAR2,
      p_rec_cd2           VARCHAR2,
      p_mode              VARCHAR2
   );
END;
/



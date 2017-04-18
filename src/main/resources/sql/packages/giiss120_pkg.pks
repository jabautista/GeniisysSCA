CREATE OR REPLACE PACKAGE CPI.giiss120_pkg
AS
   TYPE line_listing_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;

   TYPE subline_listing_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_listing_tab IS TABLE OF subline_listing_type;

   TYPE peril_listing_type IS RECORD (
      peril_cd     giis_peril.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE
   );

   TYPE peril_listing_tab IS TABLE OF peril_listing_type;

   TYPE rec_type IS RECORD (
      pack_ben_cd    giis_package_benefit.pack_ben_cd%TYPE,
      package_cd     giis_package_benefit.package_cd%TYPE,
      line_cd        giis_package_benefit.line_cd%TYPE,
      subline_cd     giis_package_benefit.subline_cd%TYPE,
      peril_name     giis_peril.peril_name%TYPE,
      peril_cd       giis_package_benefit_dtl.peril_cd%TYPE,
      prem_pct       giis_package_benefit_dtl.prem_pct%TYPE,
      prem_amt       giis_package_benefit_dtl.prem_amt%TYPE,
      no_of_days     giis_package_benefit_dtl.no_of_days%TYPE,
      benefit        giis_package_benefit_dtl.benefit%TYPE,
      aggregate_sw   giis_package_benefit_dtl.aggregate_sw%TYPE,
      remarks        giis_province.remarks%TYPE,
      user_id        giis_package_benefit.user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_giis_line_list (
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
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

   FUNCTION get_rec_list (
      p_line_cd       giis_line.line_cd%TYPE,
      p_subline_cd    giis_subline.subline_cd%TYPE,
      p_package_cd    giis_package_benefit.package_cd%TYPE,
      p_pack_ben_cd   giis_package_benefit.pack_ben_cd%TYPE,
      p_peril_name    giis_peril.peril_name%TYPE,
      p_mode          VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_giis_package_benefit (
      p_pack_ben_cd   IN OUT   giis_package_benefit.pack_ben_cd%TYPE,
      p_package_cd    IN       giis_package_benefit.package_cd%TYPE,
      p_line_cd       IN       giis_package_benefit.line_cd%TYPE,
      p_subline_cd    IN       giis_package_benefit.subline_cd%TYPE,
      p_user_id       IN       giis_package_benefit.user_id%TYPE
   );

   PROCEDURE set_giis_package_benefit_dtl (
      p_rec   giis_package_benefit_dtl%ROWTYPE
   );

   PROCEDURE del_giis_package_benefit (
      p_pack_ben_cd   giis_package_benefit.pack_ben_cd%TYPE
   );

   PROCEDURE del_giis_package_benefit_dtl (
      p_peril_cd      giis_package_benefit_dtl.peril_cd%TYPE,
      p_pack_ben_cd   giis_package_benefit_dtl.pack_ben_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_line_cd      giis_line.line_cd%TYPE,
      p_subline_cd   giis_subline.subline_cd%TYPE,
      p_rec_cd       VARCHAR2,
      p_rec_cd2      VARCHAR2,
      p_mode         VARCHAR2
   );

   PROCEDURE val_del_rec (p_rec_cd VARCHAR2);
END;
/



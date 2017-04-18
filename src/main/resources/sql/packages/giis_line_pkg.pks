CREATE OR REPLACE PACKAGE CPI.giis_line_pkg
AS
   FUNCTION get_line_cd (p_line_name IN giis_line.line_name%TYPE)
      RETURN VARCHAR2;

   /*FUNCTION get_line_name (p_line_cd IN GIIS_LINE.line_cd%TYPE)
   RETURN VARCHAR2;*/
   FUNCTION get_pack_pol_flag (p_line_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2;

   -- moved from giis_lines_pkg
   TYPE line_listing_type IS RECORD (
      line_cd         giis_line.line_cd%TYPE,
      line_name       giis_line.line_name%TYPE,
      menu_line_cd    giis_line.menu_line_cd%TYPE,
      --andrew - 10.05.2010 - added this line
      pack_pol_flag   giis_line.pack_pol_flag%TYPE,
      iss_cd          giis_issource.iss_cd%TYPE,
      iss_name        giis_issource.iss_name%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;

   FUNCTION get_checked_line_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_line_listing (p_module_id giis_modules.module_id%TYPE)
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_pack_line_list (
      p_line_cd   giis_line_subline_coverages.line_cd%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giis_line_list
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_line_name (p_line_cd IN giis_line.line_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_line_code (v_line_name VARCHAR2)
      RETURN VARCHAR2;

   PROCEDURE get_param_line_cd (
      v_quote_fire_cd       OUT   giis_line.line_cd%TYPE,
      v_quote_motor_cd      OUT   giis_line.line_cd%TYPE,
      v_quote_accident_cd   OUT   giis_line.line_cd%TYPE,
      v_quote_hull_cd       OUT   giis_line.line_cd%TYPE,
      v_quote_cargo_cd      OUT   giis_line.line_cd%TYPE,
      v_quote_casualty_cd   OUT   giis_line.line_cd%TYPE,
      v_quote_engrng_cd     OUT   giis_line.line_cd%TYPE,
      v_quote_surety_cd     OUT   giis_line.line_cd%TYPE,
      v_quote_aviation_cd   OUT   giis_line.line_cd%TYPE
   );

   FUNCTION get_pack_line_list1 (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_checked_line_issource_list (
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_menu_line_cd (p_line_cd giis_line.line_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_line_list_lostbid (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_pol_lines_for_assd (p_assd_no giis_assured.assd_no%TYPE)
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_line_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_package_line_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_checked_pack_line_issource (
      p_user_id     VARCHAR2,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_pack_line_listing (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_line_cd_flag (
      p_user_id     giis_users.user_id%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   PROCEDURE validate_pol_line_cd (
      p_pol_line_cd          IN       giis_line.line_cd%TYPE,
      p_pol_subline_cd       IN       giis_subline.subline_cd%TYPE,
      p_pol_iss_cd           IN       giis_user_grp_line.iss_cd%TYPE,
      p_line_cd              IN       giis_user_grp_line.line_cd%TYPE,
      p_iss_cd               IN       giis_user_grp_line.iss_cd%TYPE,
      p_user_id              IN       giis_users.user_id%TYPE,
      p_module_id            IN       giis_user_grp_modules.module_id%TYPE,
      p_line_pack_pol_flag   OUT      giis_line.pack_pol_flag%TYPE,
      p_msg                  OUT      VARCHAR2
   );

   FUNCTION get_all_line_list (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2, --joanne
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_polbasic_line_list (    -- parameters added by shan 10.14.2013
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   PROCEDURE validate_purge_line_cd (
      p_line_cd        IN       giis_line.line_cd%TYPE,
      p_subline_cd     IN OUT   giis_subline.subline_cd%TYPE,
      p_subline_name   OUT      giis_subline.subline_name%TYPE,
      p_iss_cd         IN       giis_issource.iss_cd%TYPE,
      p_line_name      OUT      giis_line.line_name%TYPE,
      p_module_id      IN       giis_modules.module_id%TYPE,
      p_found          OUT      VARCHAR2
   );

   --bonok :: 04.10.2012 :: line LOV for GIEXS006
   FUNCTION get_exp_rep_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE,
      p_user_id     GIIS_USERS.USER_ID%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   --bonok :: 04.17.2012 :: validate line for GIEXS006
   FUNCTION validate_line_cd_giexs006 (
      p_line_cd     giis_line.line_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_user_grp_modules.module_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   -- Dwight :: 06.15.2012 :: get all records.
   TYPE giis_line_group_type IS RECORD (
      pack_pol_flag     giis_line.pack_pol_flag%TYPE,
      prof_comm_tag     giis_line.prof_comm_tag%TYPE,
      non_renewal_tag   giis_line.non_renewal_tag%TYPE,
      special_dist_sw   giis_line.special_dist_sw%TYPE,
      enrollee_tag      giis_line.enrollee_tag%TYPE,
      edst_sw           giis_line.edst_sw%TYPE,
      line_cd           giis_line.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      acct_line_cd      giis_line.acct_line_cd%TYPE,
      menu_line_cd      giis_line.menu_line_cd%TYPE,
      recaps_line_cd    giis_line.recaps_line_cd%TYPE,
      min_prem_amt      giis_line.min_prem_amt%TYPE,
      remarks           giis_line.remarks%TYPE,
      user_id           giis_fire_construction.user_id%TYPE,
      last_update       VARCHAR2 (30),
	  other_cert_tag    giis_line.other_cert_tag%TYPE --robert 01.06.15
   );

   TYPE giis_line_group_tab IS TABLE OF giis_line_group_type;

   FUNCTION get_giis_line_group (
      p_line_cd          giis_line.line_cd%TYPE,
      p_line_name        giis_line.line_name%TYPE,
      p_acct_line_cd     giis_line.acct_line_cd%TYPE,
      p_menu_line_cd     giis_line.menu_line_cd%TYPE,
      p_recaps_line_cd   giis_line.recaps_line_cd%TYPE,
      p_min_prem_amt     giis_line.min_prem_amt%TYPE,
      p_remarks          giis_line.remarks%TYPE
   )
      RETURN giis_line_group_tab PIPELINED;

   --added by steven 12.11.2013
   TYPE giiss001_line_listing_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giiss001_line_listing_tab IS TABLE OF giiss001_line_listing_type;

   PROCEDURE set_giiss001 (p_rec giis_line%ROWTYPE);

   PROCEDURE val_del_giiss001 (p_line_cd giis_line.line_cd%TYPE);

   PROCEDURE val_add_giiss001 (
      p_line_cd        giis_line.line_cd%TYPE,
      p_acct_line_cd   giis_line.acct_line_cd%TYPE
   );

   PROCEDURE val_menu_line_cd_giiss001 (p_line_cd giis_line.line_cd%TYPE);

   FUNCTION get_giiss001_menu_line_cd
      RETURN giiss001_line_listing_tab PIPELINED;

   FUNCTION get_giiss001_recap_line_cd (p_keyword VARCHAR2)
      RETURN giiss001_line_listing_tab PIPELINED;

   --end steven 12.11.2013
   PROCEDURE delete_giis_line_group (p_line_cd giis_line.line_cd%TYPE);

   PROCEDURE set_giis_line_group (
      p_line_cd           giis_line.line_cd%TYPE,
      p_line_name         giis_line.line_name%TYPE,
      p_acct_line_cd      giis_line.acct_line_cd%TYPE,
      p_menu_line_cd      giis_line.menu_line_cd%TYPE,
      p_recaps_line_cd    giis_line.recaps_line_cd%TYPE,
      p_min_prem_amt      giis_line.min_prem_amt%TYPE,
      p_remarks           giis_line.remarks%TYPE,
      p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
      p_prof_comm_tag     giis_line.prof_comm_tag%TYPE,
      p_non_renewal_tag   giis_line.non_renewal_tag%TYPE
   );

   FUNCTION validate_line_cd (
      p_pol_iss_cd   VARCHAR2,
      p_module_id    giis_modules.module_id%TYPE,
      p_line_cd      giis_line.line_cd%TYPE
   )
      RETURN VARCHAR2;

   -- shan 03.15.2013
   PROCEDURE get_line_name_gicls201 (
      p_module_id   IN       giis_modules.module_id%TYPE,
      p_line_cd     IN       giis_line.line_cd%TYPE,
      p_user        IN       giis_users.user_id%TYPE,
      p_line_name   OUT      giis_line.line_name%TYPE,
      p_found       OUT      VARCHAR2
   );

   FUNCTION get_all_non_pack_line_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   --Kenneth L. 04.24.2013
   FUNCTION get_line_lov_giuts022 (
      p_search    VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   -- shan 05.15.2013 for GIRIS051 (Expiry PPW Line LOV)
   FUNCTION get_giris051_line_ppw_lov (
      p_module_id   VARCHAR2,
      p_user        giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_line_cd_lov
      RETURN line_listing_tab PIPELINED;

   FUNCTION validate_line_cd2 (p_line_cd VARCHAR2)
      RETURN VARCHAR2;

   --added by : Kenneth L. 07.16.2013 :for giacs286
   FUNCTION get_giacs286_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN line_listing_tab PIPELINED;

   -- added by Kris 07.29.2013
   FUNCTION get_gicls051_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giacs056_line_lov (p_find_text VARCHAR2)
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giacs102_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_find_text   VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;

   PROCEDURE validate_giacs102_line_cd (
      p_line_cd     IN OUT   giis_line.line_cd%TYPE,
      p_line_name   IN OUT   giis_line.line_name%TYPE
   );

   FUNCTION get_submaintain_line_list (p_user_id giis_users.user_id%TYPE)
      RETURN line_listing_tab PIPELINED;

   TYPE gicls254_line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE gicls254_line_tab IS TABLE OF gicls254_line_type;

   FUNCTION get_gicls254_line_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN gicls254_line_tab PIPELINED;

   TYPE giiss091_line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE giiss091_line_tab IS TABLE OF giiss091_line_type;

   FUNCTION get_giiss091_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN giiss091_line_tab PIPELINED;

   FUNCTION get_giacs299_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_gicls104_line_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;

   FUNCTION get_giuts009_line_lov (
      p_module_id    giis_modules.module_id%TYPE,
      p_pol_iss_cd   VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;
      
   FUNCTION validate_gicls010_line(
      p_pol_iss_cd   VARCHAR2,
      p_module_id    giis_modules.module_id%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;
      
END giis_line_pkg;
/



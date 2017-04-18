CREATE OR REPLACE PACKAGE CPI.giiss003_pkg
AS
   TYPE peril_list_type IS RECORD (
      line_cd            giis_line.line_cd%TYPE,
      peril_cd           giis_peril.peril_cd%TYPE,
      SEQUENCE           giis_peril.SEQUENCE%TYPE,
      peril_sname        giis_peril.peril_sname%TYPE,
      prt_flag           giis_peril.prt_flag%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      peril_type         giis_peril.peril_type%TYPE,
      subline_cd         giis_peril.subline_cd%TYPE,
      ri_comm_rt         giis_peril.ri_comm_rt%TYPE,
      basc_perl_cd       giis_peril.basc_perl_cd%TYPE,
      prof_comm_tag      giis_peril.prof_comm_tag%TYPE,
      peril_lname        giis_peril.peril_lname%TYPE,
      remarks            giis_peril.remarks%TYPE,
      zone_type          giis_peril.zone_type%TYPE,
      eval_sw            giis_peril.eval_sw%TYPE,
      default_tag        giis_peril.default_tag%TYPE,
      default_rate       giis_peril.default_rate%TYPE,
      default_tsi        giis_peril.default_tsi%TYPE,
      user_id            giis_peril.user_id%TYPE,
      last_update        VARCHAR2 (100),
      eq_zone_type       giis_peril.eq_zone_type%TYPE --edgar 03/10/2015
   );

   TYPE peril_list_tab IS TABLE OF peril_list_type;

   TYPE giis_subline_list_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE giis_subline_list_tab IS TABLE OF giis_subline_list_type;

   TYPE line_listing_type IS RECORD (
      line_cd       giis_line.line_cd%TYPE,
      line_name     giis_line.line_name%TYPE,
      menu_line_cd  giis_line.menu_line_cd%TYPE
   );

   TYPE line_listing_tab IS TABLE OF line_listing_type;

   TYPE tariff_list_type IS RECORD (
       
      tarf_cd            giis_tariff.tarf_cd%TYPE,
      tarf_desc          giis_tariff.tarf_desc%TYPE,
      user_id            giis_peril.user_id%TYPE,
      last_update        VARCHAR2 (100)
   );

   TYPE tariff_list_tab IS TABLE OF tariff_list_type;

   TYPE giis_zone_type_list_type IS RECORD (
      rv_low_value  cg_ref_codes.rv_low_value%TYPE,
      rv_meaning    cg_ref_codes.rv_meaning%TYPE
   );

   TYPE giis_zone_type_list_tab IS TABLE OF giis_zone_type_list_type;
   --added edgar 03/10/2015
   TYPE giis_eqzone_type_list_type IS RECORD (
      rv_low_value  cg_ref_codes.rv_low_value%TYPE,
      rv_meaning    cg_ref_codes.rv_meaning%TYPE
   );

   TYPE giis_eqzone_type_list_tab IS TABLE OF giis_eqzone_type_list_type;   
   
   TYPE warr_cla_list_type IS RECORD (
      main_wc_cd         giis_warrcla.main_wc_cd%TYPE,
      wc_title           giis_warrcla.wc_title%TYPE,
      user_id            giis_peril.user_id%TYPE,
      last_update        VARCHAR2 (100)
   );

   TYPE warr_cla_list_tab IS TABLE OF warr_cla_list_type;
   
   PROCEDURE insert_update_peril (p_peril giis_peril%ROWTYPE);
   
   PROCEDURE delete_peril (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   );

   FUNCTION get_peril_listgiiss003 (p_line_cd giis_line.line_cd%TYPE)
      RETURN peril_list_tab PIPELINED;

   FUNCTION get_giis_subline_list (p_line_cd giis_subline.line_cd%TYPE, p_subline_name giis_subline.subline_name%TYPE)
      RETURN giis_subline_list_tab PIPELINED;
      
   FUNCTION get_basic_peril_cd_list (p_line_cd giis_subline.line_cd%TYPE, p_basic_name giis_peril.peril_name%TYPE )
      RETURN peril_list_tab PIPELINED;
      
   FUNCTION get_giis_zone_type_fi_list(p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_zone_type_list_tab PIPELINED;
   --added edgar 03/10/2015   
   FUNCTION get_giis_eqzone_type_fi_list(p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_eqzone_type_list_tab PIPELINED;      
      
   FUNCTION get_giis_zone_type_mc_list(p_zone_name cg_ref_codes.rv_meaning%TYPE)
      RETURN giis_zone_type_list_tab PIPELINED;
      
   FUNCTION get_giis_line_list(
      p_user_id    giis_users.user_id%TYPE
   )
      RETURN line_listing_tab PIPELINED;
   
   FUNCTION validate_delete_peril (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR;

   FUNCTION peril_sname_exist (
      p_line_cd       giis_line.line_cd%TYPE,
      p_peril_sname   giis_peril.peril_sname%TYPE
   )
      RETURN VARCHAR;

   FUNCTION peril_is_exist (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR;
      
   FUNCTION peril_name_exist (
      p_line_cd      giis_line.line_cd%TYPE,
      p_peril_name   giis_peril.peril_name%TYPE
   )
      RETURN VARCHAR;
      
   FUNCTION get_giis_warr_cla (
      p_line_cd    IN   giis_line.line_cd%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   )
      RETURN warr_cla_list_tab PIPELINED;
   
   FUNCTION get_giis_warrcla_list(
      p_line_cd giis_peril.line_cd%TYPE,
      p_peril_cd giis_peril.peril_cd%TYPE,
      p_find_cd giis_warrcla.main_wc_cd%TYPE,
      p_find_title giis_warrcla.wc_title%TYPE
   )
      RETURN warr_cla_list_tab PIPELINED;
   
   PROCEDURE set_warrcla (p_peril_clauses giis_peril_clauses%ROWTYPE);
   
   PROCEDURE delete_warrcla (
      p_line_cd     giis_peril.line_cd%TYPE,
      p_peril_cd    giis_peril.peril_cd%TYPE,
      p_main_wc_cd  giis_peril_clauses.main_wc_cd%TYPE
   );
   
   FUNCTION get_tariff (
      p_line_cd    IN   giis_line.line_cd%TYPE,
      p_peril_cd   IN   giis_peril.peril_cd%TYPE
   )
      RETURN tariff_list_tab PIPELINED;
         
   FUNCTION get_giis_tariff_list(p_line_cd giis_peril.line_cd%TYPE,
      p_peril_cd giis_peril.peril_cd%TYPE, 
      p_find_cd giis_warrcla.main_wc_cd%TYPE, 
      p_find_title giis_warrcla.wc_title%TYPE
   )
      RETURN tariff_list_tab PIPELINED;
   
   PROCEDURE set_tariff (p_peril_tariff giis_peril_tariff%ROWTYPE);
   
   PROCEDURE delete_tariff (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_tarf_cd    giis_tariff.tarf_cd%TYPE
   );
   
    FUNCTION validate_delete_tariff (
      p_line_cd    giis_peril.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE,
      p_tarf_cd    giis_tariff.tarf_cd%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION check_default_tsi (
      p_line_cd      giis_line.line_cd%TYPE,    
      p_peril_cd     giis_peril.peril_cd%TYPE,
      p_default_tsi  giis_peril.default_tsi%TYPE,
      p_basc_perl_cd            giis_peril.basc_perl_cd%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION get_sublinecd_name (
      p_line_cd     giis_line.line_cd%TYPE,
      p_subline_cd  giis_peril.subline_cd%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION get_basicperilcd_name (
      p_line_cd           giis_line.line_cd%TYPE,
      p_basic_peril_cd    giis_peril.peril_cd%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION get_zonenamefi_name (
      p_zone_type     giis_peril.zone_type%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION get_zonenamemc_name (
      p_zone_type     giis_peril.zone_type%TYPE
   )
      RETURN VARCHAR;
      
    FUNCTION check_available_warrcla (
      p_line_cd     giis_line.line_cd%TYPE
   )
      RETURN VARCHAR;
      
    PROCEDURE validate_delete_peril2 (
      p_line_cd    giis_line.line_cd%TYPE,
      p_peril_cd   giis_peril.peril_cd%TYPE
   );
END giiss003_pkg;
/



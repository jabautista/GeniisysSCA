CREATE OR REPLACE PACKAGE CPI.gipi_wfireitm_pkg
AS
   TYPE gipi_wfireitm_type IS RECORD (
      par_id                   gipi_witem.par_id%TYPE,
      item_no                  gipi_witem.item_no%TYPE,
      item_title               gipi_witem.item_title%TYPE,
      item_grp                 gipi_witem.item_grp%TYPE,
      item_desc                gipi_witem.item_desc%TYPE,
      item_desc2               gipi_witem.item_desc2%TYPE,
      tsi_amt                  gipi_witem.tsi_amt%TYPE,
      prem_amt                 gipi_witem.prem_amt%TYPE,
      ann_prem_amt             gipi_witem.ann_prem_amt%TYPE,
      ann_tsi_amt              gipi_witem.ann_tsi_amt%TYPE,
      rec_flag                 gipi_witem.rec_flag%TYPE,
      currency_cd              gipi_witem.currency_cd%TYPE,
      currency_rt              gipi_witem.currency_rt%TYPE,
      group_cd                 gipi_witem.group_cd%TYPE,
      from_date                gipi_witem.from_date%TYPE,
      TO_DATE                  gipi_witem.TO_DATE%TYPE,
      pack_line_cd             gipi_witem.pack_line_cd%TYPE,
      pack_subline_cd          gipi_witem.pack_subline_cd%TYPE,
      discount_sw              gipi_witem.discount_sw%TYPE,
      coverage_cd              gipi_witem.coverage_cd%TYPE,
      other_info               gipi_witem.other_info%TYPE,
      surcharge_sw             gipi_witem.surcharge_sw%TYPE,
      region_cd                gipi_witem.region_cd%TYPE,
      changed_tag              gipi_witem.changed_tag%TYPE,
      prorate_flag             gipi_witem.prorate_flag%TYPE,
      comp_sw                  gipi_witem.comp_sw%TYPE,
      short_rt_percent         gipi_witem.short_rt_percent%TYPE,
      pack_ben_cd              gipi_witem.pack_ben_cd%TYPE,
      payt_terms               gipi_witem.payt_terms%TYPE,
      risk_no                  gipi_witem.risk_no%TYPE,
      risk_item_no             gipi_witem.risk_item_no%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      coverage_desc            giis_coverage.coverage_desc%TYPE,
      district_no              gipi_wfireitm.district_no%TYPE,
      eq_zone                  gipi_wfireitm.eq_zone%TYPE,
      tarf_cd                  gipi_wfireitm.tarf_cd%TYPE,
      block_no                 gipi_wfireitm.block_no%TYPE,
      fr_item_type             gipi_wfireitm.fr_item_type%TYPE,
      loc_risk1                gipi_wfireitm.loc_risk1%TYPE,
      loc_risk2                gipi_wfireitm.loc_risk2%TYPE,
      loc_risk3                gipi_wfireitm.loc_risk3%TYPE,
      tariff_zone              gipi_wfireitm.tariff_zone%TYPE,
      typhoon_zone             gipi_wfireitm.typhoon_zone%TYPE,
      construction_cd          gipi_wfireitm.construction_cd%TYPE,
      construction_remarks     gipi_wfireitm.construction_remarks%TYPE,
      front                    gipi_wfireitm.front%TYPE,
      RIGHT                    gipi_wfireitm.RIGHT%TYPE,
      LEFT                     gipi_wfireitm.LEFT%TYPE,
      rear                     gipi_wfireitm.rear%TYPE,
      occupancy_cd             gipi_wfireitm.occupancy_cd%TYPE,
      occupancy_remarks        gipi_wfireitm.occupancy_remarks%TYPE,
      assignee                 gipi_wfireitm.assignee%TYPE,
      flood_zone               gipi_wfireitm.flood_zone%TYPE,
      block_id                 gipi_wfireitm.block_id%TYPE,
      risk_cd                  gipi_wfireitm.risk_cd%TYPE,
      city                     giis_block.city%TYPE,
      province_cd              giis_province.province_cd%TYPE,
      province_desc            giis_province.province_desc%TYPE,
      itmperl_grouped_exists   VARCHAR2 (1),
      latitude                 gipi_wfireitm.latitude%TYPE, --Added by Jerome 11.10.2016 SR 5749
      longitude                gipi_wfireitm.longitude%TYPE --Added by Jerome 11.10.2016 SR 5749
   );

   TYPE gipi_wfireitm_tab IS TABLE OF gipi_wfireitm_type;

   TYPE gipi_wfireitm_par_type IS RECORD (
      par_id                 gipi_wfireitm.par_id%TYPE,
      item_no                gipi_wfireitm.item_no%TYPE,
      district_no            gipi_wfireitm.district_no%TYPE,
      eq_zone                gipi_wfireitm.eq_zone%TYPE,
      eq_desc                giis_eqzone.eq_desc%TYPE,
      tarf_cd                gipi_wfireitm.tarf_cd%TYPE,
      block_no               gipi_wfireitm.block_no%TYPE,
      fr_item_type           gipi_wfireitm.fr_item_type%TYPE,
      loc_risk1              gipi_wfireitm.loc_risk1%TYPE,
      loc_risk2              gipi_wfireitm.loc_risk2%TYPE,
      loc_risk3              gipi_wfireitm.loc_risk3%TYPE,
      tariff_zone            gipi_wfireitm.tariff_zone%TYPE,
      typhoon_zone           gipi_wfireitm.typhoon_zone%TYPE,
      typhoon_zone_desc      giis_typhoon_zone.typhoon_zone_desc%TYPE,
      construction_cd        gipi_wfireitm.construction_cd%TYPE,
      construction_remarks   gipi_wfireitm.construction_remarks%TYPE,
      front                  gipi_wfireitm.front%TYPE,
      RIGHT                  gipi_wfireitm.RIGHT%TYPE,
      LEFT                   gipi_wfireitm.LEFT%TYPE,
      rear                   gipi_wfireitm.rear%TYPE,
      occupancy_cd           gipi_wfireitm.occupancy_cd%TYPE,
      occupancy_desc         giis_fire_occupancy.occupancy_desc%TYPE,
      occupancy_remarks      gipi_wfireitm.occupancy_remarks%TYPE,
      assignee               gipi_wfireitm.assignee%TYPE,
      flood_zone             gipi_wfireitm.flood_zone%TYPE,
      flood_zone_desc        giis_flood_zone.flood_zone_desc%TYPE,
      block_id               gipi_wfireitm.block_id%TYPE,
      risk_cd                gipi_wfireitm.risk_cd%TYPE,
      city_cd                giis_block.city_cd%TYPE,
      province_cd            giis_province.province_cd%TYPE,
      province_desc          giis_province.province_desc%TYPE,
      city                   giis_block.city%TYPE,
      district_desc          giis_block.district_desc%TYPE,
      risk_desc              giis_risks.risk_desc%TYPE,
      latitude               gipi_wfireitm.latitude%TYPE, --Added by Jerome 11.10.2016 SR 5749
      longitude              gipi_wfireitm.longitude%TYPE --Added by Jerome 11.10.2016 SR 5749
   );

   TYPE gipi_wfireitm_par_tab IS TABLE OF gipi_wfireitm_par_type;
   
   TYPE gipi_wfireitm_value IS RECORD (
      occupancy_cd           giis_fire_occupancy.occupancy_cd%TYPE,
      occupancy_desc         giis_fire_occupancy.occupancy_desc%TYPE,
      tariff_zone            giis_tariff_zone.tariff_zone%TYPE,
      tariff_zone_desc       giis_tariff_zone.tariff_zone_desc%TYPE
   );
   
   TYPE gipi_wfireitm_value_tab IS TABLE OF gipi_wfireitm_value;

   FUNCTION get_gipi_wfireitems (p_par_id gipi_wfireitm.par_id%TYPE)
      RETURN gipi_wfireitm_tab PIPELINED;

   FUNCTION get_gipi_wfireitems1 (
      p_par_id    IN   gipi_wfireitm.par_id%TYPE,
      p_item_no   IN   gipi_wfireitm.item_no%TYPE
   )
      RETURN gipi_wfireitm_par_tab PIPELINED;

   PROCEDURE set_gipi_wfireitm (
      p_par_id                 gipi_wfireitm.par_id%TYPE,
      p_item_no                gipi_wfireitm.item_no%TYPE,
      p_district_no            gipi_wfireitm.district_no%TYPE,
      p_eq_zone                gipi_wfireitm.eq_zone%TYPE,
      p_tarf_cd                gipi_wfireitm.tarf_cd%TYPE,
      p_block_no               gipi_wfireitm.block_no%TYPE,
      p_fr_item_type           gipi_wfireitm.fr_item_type%TYPE,
      p_loc_risk1              gipi_wfireitm.loc_risk1%TYPE,
      p_loc_risk2              gipi_wfireitm.loc_risk2%TYPE,
      p_loc_risk3              gipi_wfireitm.loc_risk3%TYPE,
      p_tariff_zone            gipi_wfireitm.tariff_zone%TYPE,
      p_typhoon_zone           gipi_wfireitm.typhoon_zone%TYPE,
      p_construction_cd        gipi_wfireitm.construction_cd%TYPE,
      p_construction_remarks   gipi_wfireitm.construction_remarks%TYPE,
      p_front                  gipi_wfireitm.front%TYPE,
      p_right                  gipi_wfireitm.RIGHT%TYPE,
      p_left                   gipi_wfireitm.LEFT%TYPE,
      p_rear                   gipi_wfireitm.rear%TYPE,
      p_occupancy_cd           gipi_wfireitm.occupancy_cd%TYPE,
      p_occupancy_remarks      gipi_wfireitm.occupancy_remarks%TYPE,
      p_assignee               gipi_wfireitm.assignee%TYPE,
      p_flood_zone             gipi_wfireitm.flood_zone%TYPE,
      p_block_id               gipi_wfireitm.block_id%TYPE,
      p_risk_cd                gipi_wfireitm.risk_cd%TYPE,
      p_latitude               gipi_wfireitm.latitude%TYPE, --Added by Jerome 11.10.2016 SR 5749
      p_longitude              gipi_wfireitm.longitude%TYPE --Added by Jerome 11.10.2016 SR 5749
   );

   TYPE gipi_wfireitm_cur IS REF CURSOR
      RETURN gipi_wfireitm_type;

   PROCEDURE del_gipi_wfireitm (
      p_par_id    gipi_wfireitm.par_id%TYPE,
      p_item_no   gipi_wfireitm.item_no%TYPE
   );

   PROCEDURE del_gipi_wfireitm (p_par_id IN gipi_wfireitm.par_id%TYPE);

   PROCEDURE get_gipis039_basic_var_values (
      p_par_id                   IN       gipi_wfireitm.par_id%TYPE,
      p_par_type                 IN       VARCHAR2,
      p_assd_no                  IN       giis_assured.assd_no%TYPE,
      p_gipi_par_iss_cd          IN       giis_parameters.param_name%TYPE,
      p_line_cd                  IN       gipi_wpolbas.line_cd%TYPE,
      p_subline_cd               IN       gipi_wpolbas.subline_cd%TYPE,
      p_iss_cd                   IN       gipi_wpolbas.iss_cd%TYPE,
      p_issue_yy                 IN       gipi_wpolbas.issue_yy%TYPE,
      p_pol_seq_no               IN       gipi_wpolbas.pol_seq_no%TYPE,
      p_renew_no                 IN       gipi_wpolbas.renew_no%TYPE,
      p_eff_date                 IN       gipi_wpolbas.eff_date%TYPE,
      p_expiry_date              IN       gipi_wpolbas.expiry_date%TYPE,
      p_iss_cd_ri                OUT      VARCHAR2,
      p_param_by_iss_cd          OUT      VARCHAR2,
      p_deductible_exist         OUT      VARCHAR2,
      p_display_risk             OUT      VARCHAR2,
      p_allow_update_curr_rate   OUT      VARCHAR2,
      p_buildings                OUT      VARCHAR2,
      p_new_endt_address_1       OUT      gipi_polbasic.address1%TYPE,
      p_new_endt_address_2       OUT      gipi_polbasic.address2%TYPE,
      p_new_endt_address_3       OUT      gipi_polbasic.address3%TYPE,
      p_mail_address_1           OUT      giis_assured.mail_addr1%TYPE,
      p_mail_address_2           OUT      giis_assured.mail_addr2%TYPE,
      p_mail_address_3           OUT      giis_assured.mail_addr3%TYPE,
      p_wfireitm_list            OUT      gipi_wfireitm_pkg.gipi_wfireitm_cur
   );

   FUNCTION get_gipi_wfireitm_pack_pol (
      p_par_id    IN   gipi_wfireitm.par_id%TYPE,
      p_item_no   IN   gipi_wfireitm.item_no%TYPE
   )
      RETURN gipi_wfireitm_par_tab PIPELINED;

   /****
    * Date: March 7, 2012
    * Added by: Irwin C. Tabisora
    * Description: Added to accomodate the latest changes in the module revision date: 03-01-2012 

12:46PM
   */
   FUNCTION get_tarf_cd_pre_commit (
      p_occupancy_cd   gipi_wfireitm.occupancy_cd%TYPE,
      p_tariff_zone    gipi_wfireitm.tariff_zone%TYPE,
      p_tarf_cd        gipi_wfireitm.tarf_cd%TYPE
   )
      RETURN gipi_wfireitm.tarf_cd%TYPE;

 PROCEDURE validate_tariff_cd (
      p_occupancy_cd              gipi_wfireitm.occupancy_cd%TYPE,
      p_tariff_zone               gipi_wfireitm.tariff_zone%TYPE,
      p_tarf_cd          IN OUT   gipi_wfireitm.tarf_cd%TYPE,
      p_message          OUT      VARCHAR2
   );

   FUNCTION get_tariff_zone_occupancy_val (
      p_tarf_cd            IN         gipi_wfireitm.tarf_cd%TYPE
   )
      RETURN gipi_wfireitm_value_tab PIPELINED;
END gipi_wfireitm_pkg;
/

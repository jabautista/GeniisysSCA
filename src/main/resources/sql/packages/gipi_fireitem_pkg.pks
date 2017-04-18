CREATE OR REPLACE PACKAGE CPI.gipi_fireitem_pkg
AS
   FUNCTION get_fi_tariff_zone (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_tarf_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_construction_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE gipi_fireitem_type IS RECORD (
      policy_id              gipi_fireitem.policy_id%TYPE,
      item_no                gipi_fireitem.item_no%TYPE,
      district_no            gipi_fireitem.district_no%TYPE,
      eq_zone                gipi_fireitem.eq_zone%TYPE,
      eq_desc                giis_eqzone.eq_desc%TYPE,
      tarf_cd                gipi_fireitem.tarf_cd%TYPE,
      block_no               gipi_fireitem.block_no%TYPE,
      fr_item_type           gipi_fireitem.fr_item_type%TYPE,
      loc_risk1              gipi_fireitem.loc_risk1%TYPE,
      loc_risk2              gipi_fireitem.loc_risk2%TYPE,
      loc_risk3              gipi_fireitem.loc_risk3%TYPE,
      tariff_zone            gipi_fireitem.tariff_zone%TYPE,
      typhoon_zone           gipi_fireitem.typhoon_zone%TYPE,
      typhoon_zone_desc      giis_typhoon_zone.typhoon_zone_desc%TYPE,
      construction_cd        gipi_fireitem.construction_cd%TYPE,
      construction_remarks   gipi_fireitem.construction_remarks%TYPE,
      front                  gipi_fireitem.front%TYPE,
      RIGHT                  gipi_fireitem.RIGHT%TYPE,
      LEFT                   gipi_fireitem.LEFT%TYPE,
      rear                   gipi_fireitem.rear%TYPE,
      occupancy_cd           gipi_fireitem.occupancy_cd%TYPE,
      occupancy_desc         giis_fire_occupancy.occupancy_desc%TYPE,
      occupancy_remarks      gipi_fireitem.occupancy_remarks%TYPE,
      assignee               gipi_fireitem.assignee%TYPE,
      flood_zone             gipi_fireitem.flood_zone%TYPE,
      flood_zone_desc        giis_flood_zone.flood_zone_desc%TYPE,
      block_id               gipi_fireitem.block_id%TYPE,
      risk_cd                gipi_fireitem.risk_cd%TYPE,
      city_cd                giis_block.city_cd%TYPE,
      province_cd            giis_province.province_cd%TYPE,
      province_desc          giis_province.province_desc%TYPE,
      city                   giis_block.city%TYPE,
      district_desc          giis_block.district_desc%TYPE,
      risk_desc              giis_risks.risk_desc%TYPE,
      latitude               gipi_fireitem.latitude%TYPE, --Added by Jerome 11.14.2016 SR 5749
      longitude              gipi_fireitem.longitude%TYPE --Added by Jerome 11.14.2016 SR 5749
   );

   TYPE gipi_fireitem_tab IS TABLE OF gipi_fireitem_type;

   FUNCTION get_gipi_fireitems (
      p_policy_id   IN   gipi_fireitem.policy_id%TYPE,
      p_item_no     IN   gipi_fireitem.item_no%TYPE
   )
      RETURN gipi_fireitem_tab PIPELINED;
      
   TYPE fireitem_info_type IS RECORD(
    
     policy_id               gipi_fireitem.policy_id%TYPE,
     item_no                 gipi_fireitem.item_no%TYPE,
     assignee                gipi_fireitem.assignee%TYPE,
     block_id                gipi_fireitem.block_id%TYPE,
     block_no                gipi_fireitem.block_no%TYPE,
     eq_zone                 gipi_fireitem.eq_zone%TYPE,
     right                   gipi_fireitem.right%TYPE,
     front                   gipi_fireitem.front%TYPE,
     rear                    gipi_fireitem.rear%TYPE,
     left                    gipi_fireitem.left%TYPE,
     tarf_cd                 gipi_fireitem.tarf_cd%TYPE,
     loc_risk1               gipi_fireitem.loc_risk1%TYPE,
     loc_risk2               gipi_fireitem.loc_risk2%TYPE,
     loc_risk3               gipi_fireitem.loc_risk3%TYPE,
     flood_zone              gipi_fireitem.flood_zone%TYPE,
     district_no             gipi_fireitem.district_no%TYPE,
     occupancy_cd             gipi_fireitem.occupancy_cd%TYPE,
     tariff_zone             gipi_fireitem.tariff_zone%TYPE,
     typhoon_zone            gipi_fireitem.typhoon_zone%TYPE,
     fr_item_type            gipi_fireitem.fr_item_type%TYPE,
     construction_cd         gipi_fireitem.construction_cd%TYPE,
     occupancy_remarks       gipi_fireitem.occupancy_remarks%TYPE,
     construction_remarks    gipi_fireitem.construction_remarks%TYPE,
     latitude                gipi_fireitem.latitude%TYPE, -- Added by Jerome 11.15.2016 SR 5749
     longitude               gipi_fireitem.longitude%TYPE, -- Added by Jerome 11.15.2016 SR 5749

     construction_desc       giis_fire_construction.construction_desc%TYPE,
     typhoon_zone_desc       giis_typhoon_zone.typhoon_zone_desc%TYPE,
     occupancy_desc          giis_fire_occupancy.occupancy_desc%TYPE,
     tariff_zone_desc        giis_tariff_zone.tariff_zone_desc%TYPE,
     flood_zone_desc         giis_flood_zone.flood_zone_desc%TYPE,
     fr_item_desc            giis_fi_item_type.fr_itm_tp_ds%TYPE,
     province_desc           giis_province.province_desc%TYPE,
     risk_item_no            gipi_item.risk_item_no%TYPE,
     tarf_desc               giis_tariff.tarf_desc%TYPE,
     item_title              gipi_item.item_title%TYPE,
     from_date               gipi_item.from_date%TYPE,
     eq_desc                 giis_eqzone.eq_desc%TYPE,
     to_date                 gipi_item.to_date%TYPE,
     risk_no                 gipi_item.risk_no%TYPE,
     city                    giis_block.city%TYPE
    
   );
    
   TYPE fireitem_info_tab IS TABLE OF fireitem_info_type;
    
   FUNCTION get_fireitem_info (
      p_policy_id   gipi_fireitem.policy_id%TYPE,
      p_item_no     gipi_fireitem.item_no%TYPE
   )
      RETURN fireitem_info_tab PIPELINED;
END gipi_fireitem_pkg;
/



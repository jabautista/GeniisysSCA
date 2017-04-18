CREATE OR REPLACE PACKAGE CPI.GIPIS155_PKG
AS

    TYPE fireitem_type IS RECORD(
        policy_id           gipi_fireitem.POLICY_ID%type,
        item_no             gipi_fireitem.ITEM_NO%type,
        block_id            gipi_fireitem.BLOCK_ID%type,
        province_cd         giis_block.PROVINCE_CD%type,
        province_desc       giis_province.PROVINCE_DESC%type,
        city_cd             giis_block.CITY_CD%type,           
        city                giis_block.CITY%type,           
        district_no         gipi_fireitem.DISTRICT_NO%type,
        nb_district_no      giis_block.DISTRICT_NO%type,
        district_desc       giis_block.DISTRICT_DESC%type,
        block_no            gipi_fireitem.BLOCK_NO%type,
        nb_block_no         giis_block.BLOCK_NO%type,
        block_desc          giis_block.BLOCK_DESC%type,
        risk_cd             gipi_fireitem.RISK_CD%type,
        risk_desc           giis_risks.RISK_DESC%type,
        eq_zone             gipi_fireitem.EQ_ZONE%type,
        eq_zone_desc        giis_eqzone.EQ_DESC%type,
        flood_zone          gipi_fireitem.FLOOD_ZONE%type,
        flood_zone_desc     giis_flood_zone.FLOOD_ZONE_DESC%type,
        typhoon_zone        gipi_fireitem.TYPHOON_ZONE%type,      
        typhoon_zone_desc   giis_typhoon_zone.TYPHOON_ZONE_DESC%type,
        tarf_cd             GIPI_FIREITEM.TARF_CD%type,
        tarf_desc           giis_tariff.TARF_DESC%type,
        tariff_zone         gipi_fireitem.TARIFF_ZONE%type,           
        tariff_zone_desc    giis_tariff_zone.TARIFF_ZONE_DESC%type,
        user_id             gipi_fireitem.USER_ID%type,    
        last_update         VARCHAR2(100)
    );

    TYPE fireitem_tab IS TABLE OF fireitem_type;
    
    FUNCTION get_fireitem_listing(
        p_policy_id             VARCHAR2
    ) RETURN fireitem_tab PIPELINED;
    
    
    TYPE tarf_hist_type IS RECORD(
        policy_id           gipi_tarf_hist.POLICY_ID%type,
        block_id            gipi_tarf_hist.BLOCK_ID%type,
        item_no             gipi_tarf_hist.ITEM_NO%type,
        old_tarf_cd         gipi_tarf_hist.OLD_TARF_CD%type,
        new_tarf_cd         gipi_tarf_hist.NEW_TARF_CD%type,
        user_id             gipi_tarf_hist.USER_ID%type,
        last_update         VARCHAR2(50),
        arc_ext_data        gipi_tarf_hist.ARC_EXT_DATA%type
    );
    
    TYPE tarf_hist_tab IS TABLE OF tarf_hist_type;
    
    
    FUNCTION get_tarf_hist_listing(
        p_policy_id     gipi_tarf_hist.POLICY_ID%type,
        p_item_no       gipi_tarf_hist.ITEM_NO%type,
        p_block_id      gipi_tarf_hist.BLOCK_ID%type
    ) RETURN tarf_hist_tab PIPELINED;
    

END GIPIS155_PKG;
/



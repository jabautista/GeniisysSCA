CREATE OR REPLACE PACKAGE CPI.Gixx_Fireitem_Pkg
AS	
	TYPE fire_item_type IS RECORD (
		extract_id						GIXX_ITEM.extract_id%TYPE,
		item_item_no					GIXX_ITEM.item_no%TYPE,
		item_item_title					GIXX_ITEM.item_title%TYPE,
		item_desc						GIXX_ITEM.item_desc%TYPE,
		item_desc2						GIXX_ITEM.item_desc2%TYPE,
		item_coverage_cd				GIXX_ITEM.coverage_cd%TYPE,
		item_currency_desc				GIIS_CURRENCY.currency_desc%TYPE,
		item_other_info					GIXX_ITEM.other_info%TYPE,
		item_from_date					GIXX_ITEM.from_date%TYPE,
		item_to_date					GIXX_ITEM.TO_DATE%TYPE,
		item_currency_rt				GIXX_ITEM.currency_rt%TYPE,
		fitem_item_no					GIXX_FIREITEM.item_no%TYPE,
		fitem_assignee					GIXX_FIREITEM.assignee%TYPE,
		fitem_location_of_risk1			GIXX_FIREITEM.loc_risk1%TYPE,
		fitem_location_of_risk2 		GIXX_FIREITEM.loc_risk2%TYPE,
		fitem_location_of_risk3			GIXX_FIREITEM.loc_risk3%TYPE,
		fitem_fr_item_type				GIIS_FI_ITEM_TYPE.FR_ITM_TP_DS%TYPE,
		block_block_desc				GIIS_BLOCK.block_desc%TYPE,
		fitem_tarf_cd					GIXX_FIREITEM.tarf_cd%TYPE,
		fitem_eq_zone					GIXX_FIREITEM.eq_zone%TYPE,
		fitem_typhoon_zone				GIXX_FIREITEM.typhoon_zone%TYPE,
		fitem_flood_zone				GIXX_FIREITEM.flood_zone%TYPE,
		ficonstruct_construction_desc	GIIS_FIRE_CONSTRUCTION.construction_desc%TYPE,
		fitem_construction_remarks		GIXX_FIREITEM.construction_remarks%TYPE,
		fiocc_occupancy_desc			GIIS_FIRE_OCCUPANCY.occupancy_desc%TYPE,
		fitem_occupancy_remarks			GIXX_FIREITEM.occupancy_remarks%TYPE,
		fitem_tariff_zone				GIXX_FIREITEM.tariff_zone%TYPE,
		fitem_front						GIXX_FIREITEM.front%TYPE,
		fitem_right						GIXX_FIREITEM.RIGHT%TYPE,
		fitem_left						GIXX_FIREITEM.LEFT%TYPE,
		fitem_rear						GIXX_FIREITEM.rear%TYPE,
		fitem_block_id					GIXX_FIREITEM.block_id%TYPE,
		fitem_block_no					GIXX_FIREITEM.block_no%TYPE,
		fitem_district_no				GIXX_FIREITEM.district_no%TYPE,
		block_desc						GIIS_BLOCK.block_desc%TYPE,
        item_risk_no					GIXX_ITEM.risk_no%TYPE,
		f_item_short_name				VARCHAR2(10),
		show_boundary					VARCHAR2(1),
		show_earthquake_zone			VARCHAR2(1),
		show_typhoon_zone				VARCHAR2(1),
		show_flood_zone					VARCHAR2(1),
        show_tariff                     VARCHAR2(1),
		detail_count					NUMBER,
        policy_id                       number,
        block                           VARCHAR2(500));
	
	TYPE fire_item_table IS TABLE OF fire_item_type;
	
	FUNCTION get_report_details (
		p_extract_id IN GIXX_ITEM.extract_id%TYPE,
		p_print_tariff_zone IN VARCHAR2,
		p_print_zone IN VARCHAR2)
	RETURN fire_item_table PIPELINED;
	
	FUNCTION show_pol_doc_fire_boundary (
		p_front	IN GIXX_FIREITEM.front%TYPE,
		p_right	IN GIXX_FIREITEM.RIGHT%TYPE,
		p_left	IN GIXX_FIREITEM.LEFT%TYPE,
		p_rear	IN GIXX_FIREITEM.rear%TYPE,
		p_print_tariff_zone	GIIS_DOCUMENT.text%TYPE)
	RETURN VARCHAR2;
	
	FUNCTION show_pol_doc_fire_xxx_zone (
		p_print_zone IN VARCHAR2,		
		p_xxx_zone IN VARCHAR2,
		p_front IN GIXX_FIREITEM.front%TYPE,
		p_rear IN GIXX_FIREITEM.rear%TYPE,
		p_left IN GIXX_FIREITEM.LEFT%TYPE,
		p_right IN GIXX_FIREITEM.RIGHT%TYPE)
	RETURN VARCHAR2;
	
	FUNCTION get_record_count(p_extract_id IN GIXX_FIREITEM.extract_id%TYPE)
	RETURN NUMBER;
    
    FUNCTION get_pack_fi_report_details (
		p_extract_id IN GIXX_ITEM.extract_id%TYPE,
        p_policy_id  IN GIXX_ITEM.policy_id%TYPE,
		p_print_tariff_zone IN VARCHAR2,
		p_print_zone IN VARCHAR2)
	RETURN fire_item_table PIPELINED;
    
    
    -- added by Kris 03.05.2013 for GIPIS101
    TYPE fire_item_type2 IS RECORD (
        extract_id              gixx_fireitem.extract_id%TYPE,
        item_no                 gixx_fireitem.item_no%TYPE,
        fr_item_type            gixx_fireitem.fr_item_type%TYPE,
--        province_cd             gixx_fireitem.province_cd%TYPE,        
        block_id                gixx_fireitem.block_id%TYPE,
        eq_zone                 gixx_fireitem.eq_zone%TYPE, 
        typhoon_zone            gixx_fireitem.typhoon_zone%TYPE, 
        flood_zone              gixx_fireitem.flood_zone%TYPE, 
        tarf_cd                 gixx_fireitem.tarf_cd%TYPE,
        construction_cd         gixx_fireitem.construction_cd%TYPE, 
        tariff_zone             gixx_fireitem.tariff_zone%TYPE, 
        occupancy_cd            gixx_fireitem.occupancy_cd%TYPE,
        assignee                gixx_fireitem.assignee%TYPE, 
        district_no             gixx_fireitem.district_no%TYPE, 
        block_no                gixx_fireitem.block_no%TYPE,
        construction_remarks    gixx_fireitem.construction_remarks%TYPE, 
        occupancy_remarks       gixx_fireitem.occupancy_remarks%TYPE,
        loc_risk1               gixx_fireitem.loc_risk1%TYPE, 
        loc_risk2               gixx_fireitem.loc_risk2%TYPE, 
        loc_risk3               gixx_fireitem.loc_risk3%TYPE,
        front                   gixx_fireitem.front%TYPE, 
        right                   gixx_fireitem.right%TYPE, 
        left                    gixx_fireitem.left%TYPE, 
        rear                    gixx_fireitem.rear%TYPE,
        latitude                gixx_fireitem.latitude%TYPE, --benjo 01.10.2017 SR-5749
        longitude               gixx_fireitem.latitude%TYPE, --benjo 01.10.2017 SR-5749
        fr_item_desc        giis_fi_item_type.fr_itm_tp_ds%TYPE,
        province            giis_province.province_desc%TYPE,
        city                giis_block.city%TYPE,
        eq_desc             giis_eqzone.eq_desc%TYPE,
        typhoon_zone_desc   giis_typhoon_zone.typhoon_zone_desc%TYPE,
        flood_zone_desc     giis_flood_zone.flood_zone_desc%TYPE,
        tarf_desc           giis_tariff.tarf_desc%TYPE,
        construction_desc   giis_fire_construction.construction_desc%TYPE,
        tariff_zone_desc    giis_tariff_zone.tariff_zone_desc%TYPE,
        occupancy_desc      giis_fire_occupancy.occupancy_desc%TYPE,
        from_date           gixx_item.from_date%TYPE,
        to_date             gixx_item.to_date%TYPE
    );
    
    TYPE fire_item_tab2 IS TABLE OF fire_item_type2;
    
    FUNCTION get_fire_item_info (
        p_extract_id    gixx_fireitem.extract_id%TYPE,
        p_item_no       gixx_fireitem.item_no%TYPE
    ) RETURN fire_item_tab2 PIPELINED;
    -- end 03.05.2013 for GIPIS101  
    
END Gixx_Fireitem_Pkg;
/



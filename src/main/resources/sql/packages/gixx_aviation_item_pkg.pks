CREATE OR REPLACE PACKAGE CPI.GIXX_AVIATION_ITEM_PKG
AS
	TYPE aviation_item_type IS RECORD (
		extract_id			GIXX_ITEM.extract_id%TYPE,
		item_no				GIXX_ITEM.item_no%TYPE,
		item_title			GIXX_ITEM.item_title%TYPE,
		item_desc			GIXX_ITEM.item_desc%TYPE,
		item_desc2			GIXX_ITEM.item_desc2%TYPE,
		item_coverage_cd	GIXX_ITEM.coverage_cd%TYPE,
		item_currency_desc	GIIS_CURRENCY.currency_desc%TYPE,
		item_other_info		GIXX_ITEM.other_info%TYPE,
		item_from_date		GIXX_ITEM.from_date%TYPE,
		item_to_date		GIXX_ITEM.TO_DATE%TYPE,
		item_currency_rt	GIXX_ITEM.currency_rt%TYPE,
		av_total_fly_time	GIXX_AVIATION_ITEM.total_fly_time%TYPE,
		av_qualification	GIXX_AVIATION_ITEM.qualification%TYPE,
		av_purpose			GIXX_AVIATION_ITEM.purpose%TYPE,
		av_geog_limit		GIXX_AVIATION_ITEM.geog_limit%TYPE,
		av_deduct_txt		GIXX_AVIATION_ITEM.deduct_text%TYPE,
		av_vessel_cd		GIXX_AVIATION_ITEM.vessel_cd%TYPE,
		av_prev_util_hrs	GIXX_AVIATION_ITEM.prev_util_hrs%TYPE,
		av_est_util_hrs		GIXX_AVIATION_ITEM.est_util_hrs%TYPE,
		av_vessel_name		GIIS_VESSEL.vessel_name%TYPE,
		av_rpc_no			GIIS_VESSEL.rpc_no%TYPE);
		
	TYPE aviation_item_tab IS TABLE OF aviation_item_type;
	
	FUNCTION get_pol_doc_records (p_extract_id GIXX_ITEM.extract_id%TYPE)
	RETURN aviation_item_tab PIPELINED;
    
    
    
    -- added by Kris 03.04.2013 for GIPIS101
    TYPE aviation_item_type2 IS RECORD (
        extract_id          gixx_aviation_item.extract_id%TYPE,
        item_no             gixx_aviation_item.item_no%TYPE,
        item_title          gixx_item.item_title%TYPE,
        vessel_cd           gixx_aviation_item.vessel_cd%TYPE,
        prev_util_hrs       gixx_aviation_item.prev_util_hrs%TYPE,
        est_util_hrs        gixx_aviation_item.est_util_hrs%TYPE,
        total_fly_time      gixx_aviation_item.total_fly_time%TYPE,
        qualification       gixx_aviation_item.qualification%TYPE,
        purpose             gixx_aviation_item.purpose%TYPE,
        deduct_text         gixx_aviation_item.deduct_text%TYPE,
        geog_limit          gixx_aviation_item.geog_limit%TYPE,
        
        vessel_name         giis_vessel.vessel_name%TYPE,
        air_desc            giis_air_type.air_desc%TYPE,
        rpc_no              giis_vessel.rpc_no%TYPE
    );
    
    TYPE aviation_item_tab2 IS TABLE OF aviation_item_type2;
    
    FUNCTION get_aviation_item_info(
        p_extract_id        gixx_aviation_item.extract_id%TYPE,
        p_item_no           gixx_aviation_item.item_no%TYPE
    ) RETURN aviation_item_tab2 PIPELINED;
    -- end 03.04.2013: for GIPIS101
		
	
END GIXX_AVIATION_ITEM_PKG;
/



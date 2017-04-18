CREATE OR REPLACE PACKAGE CPI.gipi_inspection_pkg
AS
   TYPE gipi_insp_data1_type IS RECORD (
      insp_no           gipi_insp_data.insp_no%TYPE,
      status            gipi_insp_data.status%TYPE,
      date_insp         gipi_insp_data.date_insp%TYPE,
      insp_cd           gipi_insp_data.insp_cd%TYPE,
      insp_name         giis_inspector.insp_name%TYPE,
      assd_no           gipi_insp_data.assd_no%TYPE,
      assd_name         gipi_insp_data.assd_name%TYPE,
      intm_no           gipi_insp_data.intm_no%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      approved_by       gipi_insp_data.approved_by%TYPE,
      date_approved     gipi_insp_data.date_approved%TYPE,
      remarks           gipi_insp_data.remarks%TYPE
   );

   TYPE gipi_insp_data1_tab IS TABLE OF gipi_insp_data1_type;

   TYPE gipi_insp_otherdtls_type IS RECORD (
      risk_grade                gipi_insp_data.risk_grade%TYPE,
      peril_option1             gipi_insp_data.peril_option1%TYPE,
      peril_option1_bldg_rate   gipi_insp_data.peril_option1_bldg_rate%TYPE,
      peril_option1_cont_rate   gipi_insp_data.peril_option1_cont_rate%TYPE,
      peril_option2             gipi_insp_data.peril_option2%TYPE,
      peril_option2_bldg_rate   gipi_insp_data.peril_option2_bldg_rate%TYPE,
      peril_option2_cont_rate   gipi_insp_data.peril_option2_cont_rate%TYPE
   );

   TYPE gipi_insp_otherdtls_tab IS TABLE OF gipi_insp_otherdtls_type;

   FUNCTION get_gipi_insp_data1
      RETURN gipi_insp_data1_tab PIPELINED;

   TYPE gipi_insp_data_type IS RECORD (
      item_no                gipi_insp_data.item_no%TYPE,
      item_title             gipi_insp_data.item_title%TYPE,
      item_desc              gipi_insp_data.item_desc%TYPE,
      loc_risk1              gipi_insp_data.loc_risk1%TYPE,
      loc_risk2              gipi_insp_data.loc_risk2%TYPE,
      loc_risk3              gipi_insp_data.loc_risk3%TYPE,
      front                  VARCHAR2(3500),--gipi_insp_data.front%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      LEFT                   VARCHAR2(3500),--gipi_insp_data.LEFT%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      RIGHT                  VARCHAR2(3500),--gipi_insp_data.RIGHT%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      rear                   VARCHAR2(3500),--gipi_insp_data.rear%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      tsi_amt                gipi_insp_data.tsi_amt%TYPE,
      prem_rate              gipi_insp_data.prem_rate%TYPE,
      tarf_cd                gipi_insp_data.tarf_cd%TYPE,
      tariff_zone            gipi_insp_data.tariff_zone%TYPE,
      eq_zone                gipi_insp_data.eq_zone%TYPE,
      flood_zone             gipi_insp_data.flood_zone%TYPE,
      typhoon_zone           gipi_insp_data.typhoon_zone%TYPE,
      occupancy_cd           gipi_insp_data.occupancy_cd%TYPE,
      occupancy_remarks      VARCHAR2(3500),--gipi_insp_data.occupancy_remarks%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      construction_cd        gipi_insp_data.construction_cd%TYPE,
      construction_remarks   VARCHAR2(3500),--gipi_insp_data.construction_remarks%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      block_id               gipi_insp_data.block_id%TYPE,
      approved_by            gipi_insp_data.approved_by%TYPE,
      date_approved          gipi_insp_data.date_approved%TYPE,
      remarks                VARCHAR2(3500),--gipi_insp_data.remarks%TYPE, changed by reymon 03112013 to occupy escape_value_clob
      block_no               giis_block.block_no%TYPE,
      district_no            giis_block.district_no%TYPE,
      city                   giis_block.city%TYPE,
      province               giis_block.province%TYPE,
      province_cd            giis_block.province_cd%TYPE,
      city_cd                giis_block.city_cd%TYPE,
      latitude               gipi_insp_data.latitude%TYPE,  --Added by MarkS 02/10/2017 SR5919
      longitude              gipi_insp_data.longitude%TYPE  --Added by MarkS 02/10/2017 SR5919
   );

   TYPE gipi_insp_data_tab IS TABLE OF gipi_insp_data_type;

   FUNCTION get_gipi_insp_data (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN gipi_insp_data_tab PIPELINED;

   TYPE ins_det_type IS RECORD (
      insp_no            gipi_insp_data.insp_no%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      loc_risk1          gipi_insp_data.loc_risk1%TYPE,
      loc_risk2          gipi_insp_data.loc_risk2%TYPE,
      loc_risk3          gipi_insp_data.loc_risk3%TYPE,
      date_insp          gipi_insp_data.date_insp%TYPE,
      block_no           giis_block.block_no%TYPE,
      insp_name          giis_inspector.insp_name%TYPE,
      intm_name          giis_intermediary.intm_name%TYPE,
      user_name          giis_users.user_name%TYPE,
      district_no        giis_block.block_no%TYPE,
      date_approved      gipi_insp_data.date_approved%TYPE,
      approved_by        gipi_insp_data.approved_by%TYPE,
      tarf_cd            gipi_insp_data.tarf_cd%TYPE,
      remarks            gipi_insp_data.remarks%TYPE,
      tariff_zone_desc   giis_tariff_zone.tariff_zone_desc%TYPE
   );

   TYPE ins_det_tab IS TABLE OF ins_det_type;

   FUNCTION get_inspection_details (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN ins_det_tab PIPELINED;

   TYPE insp_items_type IS RECORD (
      insp_no        gipi_insp_data.insp_no%TYPE,
      item_no        gipi_insp_data.item_no%TYPE,
      item_desc      gipi_insp_data.item_desc%TYPE,
      occu_remarks   gipi_insp_data.occupancy_remarks%TYPE,
      tsi_amt        gipi_insp_data.tsi_amt%TYPE,
      item_title     gipi_insp_data.item_title%TYPE,
      front          VARCHAR2 (2000),
      LEFT           VARCHAR2 (2000),
      rear           VARCHAR2 (2000),
      RIGHT          VARCHAR2 (2000),
      block_id       VARCHAR2(100),
      occupancy_desc giis_fire_occupancy.occupancy_desc%TYPE   
   );

   TYPE insp_items_tab IS TABLE OF insp_items_type;

   FUNCTION get_insp_items (p_insp_no gipi_insp_data.insp_no%TYPE)
      RETURN insp_items_tab PIPELINED;

   TYPE insp_pics_type IS RECORD (
      insp_no     NUMBER,
      item_no     gipi_insp_pictures.item_no%TYPE,
      file_name   gipi_insp_pictures.file_name%TYPE,
      file_ext    gipi_insp_pictures.file_ext%TYPE
   );

   TYPE insp_pics_tab IS TABLE OF insp_pics_type;

   FUNCTION get_insp_pics (
      p_insp_no   NUMBER
   )
      RETURN insp_pics_tab PIPELINED;

   TYPE image_path_type IS RECORD (
      v_path   VARCHAR2 (2000)
   );

   TYPE image_path_tab IS TABLE OF image_path_type;

   FUNCTION get_image_path (
      p_insp_no     NUMBER,
      p_file_name   gipi_insp_pictures.file_name%TYPE,
      p_file_ext    gipi_insp_pictures.file_ext%TYPE
   )
      RETURN image_path_tab PIPELINED;

   PROCEDURE update_gipi_insp_data_table (
      p_insp_no                gipi_insp_data.insp_no%TYPE,
      p_item_no                gipi_insp_data.item_no%TYPE,
      p_item_desc              gipi_insp_data.item_desc%TYPE,
      p_block_id               gipi_insp_data.block_id%TYPE,
      p_assd_no                gipi_insp_data.assd_no%TYPE,
      p_assd_name              gipi_insp_data.assd_name%TYPE,
      p_loc_risk1              gipi_insp_data.loc_risk1%TYPE,
      p_loc_risk2              gipi_insp_data.loc_risk2%TYPE,
      p_loc_risk3              gipi_insp_data.loc_risk3%TYPE,
      p_occupancy_cd           gipi_insp_data.occupancy_cd%TYPE,
      p_occupancy_remarks      gipi_insp_data.occupancy_remarks%TYPE,
      p_construction_cd        gipi_insp_data.construction_cd%TYPE,
      p_construction_remarks   gipi_insp_data.construction_remarks%TYPE,
      p_front                  gipi_insp_data.front%TYPE,
      p_left                   gipi_insp_data.LEFT%TYPE,
      p_right                  gipi_insp_data.RIGHT%TYPE,
      p_rear                   gipi_insp_data.rear%TYPE,
      p_wc_cd                  gipi_insp_data.wc_cd%TYPE,
      p_tarf_cd                gipi_insp_data.tarf_cd%TYPE,
      p_tariff_zone            gipi_insp_data.tariff_zone%TYPE,
      p_eq_zone                gipi_insp_data.eq_zone%TYPE,
      p_flood_zone             gipi_insp_data.flood_zone%TYPE,
      p_typhoon_zone           gipi_insp_data.typhoon_zone%TYPE,
      p_prem_rate              gipi_insp_data.prem_rate%TYPE,
      p_tsi_amt                gipi_insp_data.tsi_amt%TYPE,
      p_intm_no                gipi_insp_data.intm_no%TYPE,
      p_insp_cd                gipi_insp_data.insp_cd%TYPE,
      p_date_insp              gipi_insp_data.date_insp%TYPE,
      p_approved_by            gipi_insp_data.approved_by%TYPE,
      p_date_approved          gipi_insp_data.date_approved%TYPE,
      p_par_id                 gipi_insp_data.par_id%TYPE,
      p_quote_id               gipi_insp_data.quote_id%TYPE,
      p_item_title             gipi_insp_data.item_title%TYPE,
      p_status                 gipi_insp_data.status%TYPE,
      p_item_grp               gipi_insp_data.item_grp%TYPE,
      p_remarks                gipi_insp_data.remarks%TYPE,
      p_arc_ext_data           gipi_insp_data.arc_ext_data%TYPE,
      p_user_id                gipi_insp_data.user_id%TYPE,
      --Added by MarkS 02/09/2017 SR5919
      p_latitude               gipi_insp_data.latitude%TYPE,
      p_longitude              gipi_insp_data.longitude%TYPE
      --end SR5919
   );

   PROCEDURE delete_gipi_insp_data (p_insp_no gipi_insp_data.insp_no%TYPE);

   FUNCTION get_insp_otherdtls (
      p_insp_no   gipi_insp_data.insp_no%TYPE,
      p_item_no   gipi_insp_data.item_no%TYPE
   )
      RETURN gipi_insp_otherdtls_tab PIPELINED;

   PROCEDURE set_insp_otherdtls (
      p_insp_no                   gipi_insp_data.insp_no%TYPE,
      p_item_no                   gipi_insp_data.item_no%TYPE,
      p_risk_grade                gipi_insp_data.risk_grade%TYPE,
      p_peril_option1             gipi_insp_data.peril_option1%TYPE,
      p_peril_option1_bldg_rate   gipi_insp_data.peril_option1_bldg_rate%TYPE,
      p_peril_option1_cont_rate   gipi_insp_data.peril_option1_cont_rate%TYPE,
      p_peril_option2             gipi_insp_data.peril_option2%TYPE,
      p_peril_option2_bldg_rate   gipi_insp_data.peril_option2_bldg_rate%TYPE,
      p_peril_option2_cont_rate   gipi_insp_data.peril_option2_cont_rate%TYPE
   );

   TYPE quote_ins_det_type IS RECORD (
      item_no         gipi_insp_data.item_no%TYPE,
      insp_no         gipi_insp_data.insp_no%TYPE,
      assd_name       giis_assured.assd_name%TYPE,
      insp_name       giis_inspector.insp_name%TYPE,
      item_desc       gipi_insp_data.item_desc%TYPE,
      province        giis_block.province%TYPE,
      city            giis_block.city%TYPE,
      district_desc   giis_block.district_desc%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      loc_risk1       gipi_insp_data.loc_risk1%TYPE,
      loc_risk2       gipi_insp_data.loc_risk2%TYPE,
      loc_risk3       gipi_insp_data.loc_risk3%TYPE,
	  loc_risk	  	  VARCHAR2(200),
      province_cd     giis_block.province_cd%TYPE,
      district_no     giis_block.district_no%TYPE,
      block_no        giis_block.block_no%TYPE
   );

   TYPE quote_ins_det_tab IS TABLE OF quote_ins_det_type;

   FUNCTION get_quote_inspection_list (p_assd_no gipi_insp_data.assd_no%TYPE, p_find_text VARCHAR2)
      RETURN quote_ins_det_tab PIPELINED;

   PROCEDURE save_quote_insp_det (
      p_quote_id      gipi_quote.quote_id%TYPE,
      p_user_id       gipi_quote.user_id%TYPE,
      p_insp_no       gipi_insp_data.insp_no%TYPE,
      p_item_no       gipi_insp_data.item_no%TYPE,
      p_province_cd   giis_block.province_cd%TYPE,
      p_item_desc     gipi_insp_data.item_desc%TYPE,
      p_block_no      giis_block.block_no%TYPE,
      p_district_no   giis_block.district_no%TYPE,
      p_loc_risk1     gipi_insp_data.loc_risk1%TYPE,
      p_loc_risk2     gipi_insp_data.loc_risk2%TYPE,
      p_loc_risk3     gipi_insp_data.loc_risk3%TYPE
   );
   
	/**
	* Rey Jadlocon
	* 05-20-2012
	**/
	PROCEDURE delete_item(p_item_no			number,
						  p_insp_no			number);
						  
	TYPE gipi_inspection_type IS RECORD(
		assd_name       GIPI_INSP_DATA.assd_name%TYPE, 
		item_no         GIPI_INSP_DATA.item_no%TYPE,
		status          GIPI_INSP_DATA.status%TYPE, 
		insp_no         GIPI_INSP_DATA.insp_no%TYPE, 
		block_id        GIPI_INSP_DATA.block_id%TYPE, 
		insp_name       GIIS_INSPECTOR.insp_name%TYPE, 
		item_title      GIPI_INSP_DATA.item_title%TYPE,
		item_desc       GIPI_INSP_DATA.item_desc%TYPE,
		province_cd     GIIS_BLOCK.province_cd%TYPE, 
		province        GIIS_BLOCK.province%TYPE, 
		city_cd         GIIS_BLOCK.city_cd%TYPE, 
		city            GIIS_BLOCK.city%TYPE, 
		district_no     GIIS_BLOCK.district_no%TYPE, 
		district_desc   GIIS_BLOCK.district_desc%TYPE, 
		block_no        GIIS_BLOCK.block_no%TYPE, 
		block_desc      GIIS_BLOCK.block_desc%TYPE, 
		loc_risk1       GIPI_INSP_DATA.loc_risk1%TYPE, 
		loc_risk2       GIPI_INSP_DATA.loc_risk2%TYPE, 
		loc_risk3       GIPI_INSP_DATA.loc_risk3%TYPE
	);
	
	TYPE gipi_inspection_tab IS TABLE OF gipi_inspection_type;
	
	FUNCTION get_approved_inspection_list(p_par_id	  IN  GIPI_PARLIST.par_id%TYPE,
										  p_assd_no   IN  GIPI_INSP_DATA.assd_no%TYPE, 
										  p_find_text IN  VARCHAR2)
	RETURN gipi_inspection_tab PIPELINED;
	
	PROCEDURE save_par_witem_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE,
	 p_item_title	 GIPI_INSP_DATA.item_title%TYPE,
	 p_item_desc	 GIPI_INSP_DATA.item_desc%TYPE,
	 p_block_id	     GIPI_INSP_DATA.block_id%TYPE);
	 
	PROCEDURE save_wfireitm_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE,
	 p_block_id	     GIPI_INSP_DATA.block_id%TYPE,
	 p_insp_cd       GIPI_INSP_DATA.insp_cd%TYPE
	);
	
	PROCEDURE save_wpictures_from_inspection
	(p_par_id        GIPI_PARLIST.par_id%TYPE,
	 p_insp_no       GIPI_INSP_DATA.insp_no%TYPE,
	 p_item_no		 GIPI_INSP_DATA.item_no%TYPE
	);
	
	TYPE gipi_inspection_type_2 IS RECORD(
        insp_no         GIPI_INSP_DATA.insp_no%TYPE,
        insp_cd         GIPI_INSP_DATA.insp_cd%TYPE, 
		insp_name       GIIS_INSPECTOR.insp_name%TYPE,
        assd_no         GIPI_INSP_DATA.assd_no%TYPE,
		assd_name       GIPI_INSP_DATA.assd_name%TYPE,
        intm_no         GIPI_INSP_DATA.intm_no%TYPE,
        intm_name       GIIS_INTERMEDIARY.intm_name%TYPE,    
		loc_risk1       GIPI_INSP_DATA.loc_risk1%TYPE, 
		loc_risk2       GIPI_INSP_DATA.loc_risk2%TYPE, 
		loc_risk3       GIPI_INSP_DATA.loc_risk3%TYPE,
		loc_of_risk		VARCHAR2(200)
	);
	
	TYPE gipi_inspection_tab_2 IS TABLE OF gipi_inspection_type_2;
	
	FUNCTION get_approved_inspection_list_2(p_par_id	IN  GIPI_PARLIST.par_id%TYPE,
										    p_assd_no   IN  GIPI_INSP_DATA.assd_no%TYPE, 
										    p_find_text IN  VARCHAR2)
	RETURN gipi_inspection_tab_2 PIPELINED;
	
	FUNCTION get_quote_inspection_list2(
        p_assd_no           GIPI_INSP_DATA.assd_no%TYPE,
        p_find_text         VARCHAR2
    )
      RETURN quote_ins_det_tab PIPELINED;
      
    PROCEDURE save_quote_inspection(
        p_quote_id          GIPI_QUOTE.quote_id%TYPE,
        p_insp_no           GIPI_INSP_DATA.insp_no%TYPE,
        p_item_no           GIPI_INSP_DATA.item_no%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE
    );
    
   PROCEDURE update_inspection_status(
      p_par_id       GIPI_INSP_DATA.par_id%TYPE
   );
   
   PROCEDURE set_status_to_approved(
      p_par_id       GIPI_INSP_DATA.par_id%TYPE
   );
   
   --john 3.22.2016 SR#5470
   PROCEDURE update_parent_record(
        p_insp_no     VARCHAR2,
        p_assd_no     VARCHAR2,
        p_assd_name   VARCHAR2,
        p_intm_no     VARCHAR2,
        p_insp_cd     VARCHAR2,
        p_remarks     VARCHAR2,
        p_status      VARCHAR2,
        p_user        VARCHAR2
   );
					  
END gipi_inspection_pkg;
/

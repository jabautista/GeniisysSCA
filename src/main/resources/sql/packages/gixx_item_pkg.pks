CREATE OR REPLACE PACKAGE CPI.GIXX_ITEM_PKG AS

  TYPE gixx_item_type IS RECORD
    (extract_id3		GIXX_ITEM.extract_id%TYPE,
	 tsi_fx_name		GIIS_CURRENCY.short_name%TYPE,	
	 tsi_fx_desc		GIIS_CURRENCY.currency_desc%TYPE,
 	 tsi_spelled_tsi	VARCHAR2(400));
	 
  TYPE gixx_item_tab IS TABLE OF gixx_item_type;
  
  FUNCTION get_gixx_item(p_extract_id        GIXX_ITEM.extract_id%TYPE)
    RETURN gixx_item_tab PIPELINED;
    
  TYPE pol_doc_mc_item_type IS RECORD (
      extract_id                    GIXX_ITEM.extract_id%TYPE,
      item_item_no                  GIXX_ITEM.item_no%TYPE,
      item_item_title               VARCHAR2(100),
      item_item_title2                GIXX_ITEM.item_title%TYPE,
      item_desc                     GIXX_ITEM.item_desc%TYPE,
      item_desc2                    GIXX_ITEM.item_desc2%TYPE,
      item_coverage_cd              GIXX_ITEM.coverage_cd%TYPE,
      item_coverage_desc            GIIS_COVERAGE.coverage_desc%TYPE,
      item_currency_desc            GIIS_CURRENCY.currency_desc%TYPE,
      item_other_info               GIXX_ITEM.other_info%TYPE,
      --extract_id                     GIXX_VEHICLE.extract_id%TYPE,
      --vehicle_item_no                 GIXX_VEHICLE.item_no%TYPE,
      vehicle_assignee                GIXX_VEHICLE.assignee%TYPE,
      vehicle_origin                  GIXX_VEHICLE.origin%TYPE,
      vehicle_destination             GIXX_VEHICLE.destination%TYPE,
      vehicle_model_year              GIXX_VEHICLE.model_year%TYPE,
      vehicle_car_coy                 GIIS_MC_CAR_COMPANY.car_company%TYPE,
      vehicle_make                    GIXX_VEHICLE.make%TYPE,
      bodytype_type_of_body           GIIS_TYPE_OF_BODY.type_of_body%TYPE,
      vehicle_color                   GIXX_VEHICLE.color%TYPE,
      vehicle_mv_file_no              GIXX_VEHICLE.mv_file_no%TYPE,
      vehicle_coc_no                  VARCHAR2(20),
      vehicle_coc_issue_date          GIXX_VEHICLE.coc_issue_date%TYPE,    
      vehicle_coc_serial_no           GIXX_VEHICLE.coc_serial_no%TYPE,
      vehicle_serial_no               GIXX_VEHICLE.serial_no%TYPE,
      sublinetype_subline_type_desc   GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
      vehicle_acquired_from           GIXX_VEHICLE.acquired_from%TYPE,
      vehicle_plate_no                GIXX_VEHICLE.plate_no%TYPE,
      vehicle_no_of_pass              GIXX_VEHICLE.no_of_pass%TYPE,
      vehicle_unladen_wt              GIXX_VEHICLE.unladen_wt%TYPE,
      motortyp_motor_type_desc        GIIS_MOTORTYPE.motor_type_desc%TYPE,
      vehicle_motor_no                GIXX_VEHICLE.motor_no%TYPE,
      vehicle_towing                  GIXX_VEHICLE.towing%TYPE,
      vehicle_repair_lim              GIXX_VEHICLE.repair_lim%TYPE,
      repair_lim                      GIXX_VEHICLE.repair_lim%TYPE,
      vehicle_series_cd               GIXX_VEHICLE.series_cd%TYPE,
      vehicle_make_cd                 GIXX_VEHICLE.make_cd%TYPE,
      vehicle_car_company_cd          GIXX_VEHICLE.car_company_cd%TYPE,
      f_towing                        GIXX_VEHICLE.towing%TYPE,
      f_make                          VARCHAR2(200),
      vehicle_deductibles              GIXX_DEDUCTIBLES.deductible_amt%TYPE,
      assignee_label                   VARCHAR2(1) --added by robert 04.17.2013
	  );
    
  TYPE pol_doc_mc_item_tab IS TABLE OF pol_doc_mc_item_type;
    
  FUNCTION get_pol_doc_mc_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
    RETURN pol_doc_mc_item_tab PIPELINED;
    
  /* This function obtains item informations for marine cargo line including cargo and vessel details
         This does not work for non-cargo lines.
      Created by: BRYAN JOSEPH ABULUYAN
      Date: April 14, 2010
   */
  TYPE pol_doc_mn_item_type IS RECORD (
      extract_id                  GIXX_ITEM.extract_id%TYPE,
      item_item_no                GIXX_ITEM.item_no%TYPE,
      item_item_title             VARCHAR2(100),
      item_item_title2              GIXX_ITEM.item_title%TYPE,
      item_desc                   GIXX_ITEM.item_desc%TYPE,
      item_desc2                  GIXX_ITEM.item_desc2%TYPE,
      item_coverage_cd            GIXX_ITEM.coverage_cd%TYPE,
      item_currency_desc          GIIS_CURRENCY.currency_desc%TYPE,
      item_other_info               GIXX_ITEM.other_info%TYPE,
      item_declaration_no          gixx_open_policy.decltn_no%type,
      cargo_item_no               GIXX_CARGO.item_no%TYPE,
      cargo_geog_cd                  GIXX_CARGO.geog_cd%TYPE,
      cargo_class_cd                   GIXX_CARGO.cargo_class_cd%TYPE,
      cargo_vesel_cd              GIXX_CARGO.vessel_cd%TYPE,
      cargo_bl_awb                 GIXX_CARGO.bl_awb%TYPE,
      cargo_origin                     GIXX_CARGO.origin%TYPE,
      cargo_etd                         GIXX_CARGO.etd%TYPE,
      cargo_destn                  GIXX_CARGO.destn%TYPE,
      cargo_eta                         GIXX_CARGO.eta%TYPE,
      cargo_deduct_text              GIXX_CARGO.deduct_text%TYPE,
      cargo_pack_method              GIXX_CARGO.pack_method%TYPE,
      cargo_print_tag              GIXX_CARGO.print_tag%TYPE,
      cargo_lc_no                  GIXX_CARGO.lc_no%TYPE,
      cargo_tranship_origin          GIXX_CARGO.tranship_origin%TYPE,
      cargo_tranship_dest          GIXX_CARGO.tranship_destination%TYPE,
      cargo_voyage_no              GIXX_CARGO.voyage_no%TYPE,
      cargo_geog_desc              GIIS_GEOG_CLASS.geog_desc%TYPE,
      cargo_class                  GIIS_CARGO_CLASS.cargo_class_desc%TYPE,
      vessel_vessel_cd            GIIS_VESSEL.vessel_cd%TYPE,
      vessel_vessel_name          VARCHAR2(200),
      vessel_serial_no               GIIS_VESSEL.serial_no%TYPE,
      vessel_motor_no                   GIIS_VESSEL.motor_no%TYPE,
      vessel_plate_no             GIIS_VESSEL.plate_no%TYPE,
      vessel_vestype_cd           GIIS_VESSEL.vestype_cd%TYPE,
      vessel_desc                  GIIS_VESTYPE.vestype_desc%TYPE,
      ccarrier_exists              VARCHAR2(1),
      f_item_curr_cd              VARCHAR2(20),
      f_inv_value                  VARCHAR2(20),
      f_markup_rate                  VARCHAR2(20),
      f_inv_curr_rt                  VARCHAR2(20),
      f_inv_curr_cd                    VARCHAR2(20),
      f_agreed_value              VARCHAR2(20),
      f_item_tsi_amt              VARCHAR2(50),
      f_item_prem_amt              VARCHAR2(50),
      f_item_short_name              VARCHAR2(20),
      f_peril_exists              VARCHAR2(1),
      ded_exists                  VARCHAR2(1),
      show_ded_text                  VARCHAR2(1),
      show_peril                  VARCHAR2(1)
      );
    
  TYPE pol_doc_mn_item_tab IS TABLE OF pol_doc_mn_item_type;  
  
  FUNCTION get_pol_doc_mn_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
     RETURN pol_doc_mn_item_tab PIPELINED; 
     
  FUNCTION get_itmperil_tsi_amt (p_extract_id  GIXX_ITEM.extract_id%TYPE,
                                 p_item_no     GIXX_ITEM.item_no%TYPE,
                                 p_itmperil_tsi_amt GIXX_ITEM.tsi_amt%TYPE)
     RETURN NUMBER;     

  TYPE pol_doc_ca_item_type IS RECORD (
    extract_id              GIXX_ITEM.extract_id%TYPE,
    item_no                 GIXX_ITEM.item_no%TYPE, 
    item_title              GIXX_ITEM.item_title%TYPE, 
    item_desc               GIXX_ITEM.item_desc%TYPE,
    item_desc2              GIXX_ITEM.item_desc2%TYPE, 
    coverage_cd             GIXX_ITEM.coverage_cd%TYPE,
    currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
    other_info              GIXX_ITEM.other_info%TYPE,
    casualty_location       GIXX_CASUALTY_ITEM.location%TYPE,
    casualty_capacity_cd    GIXX_CASUALTY_ITEM.capacity_cd%TYPE,
    capacity                GIIS_POSITION.position%TYPE,
    casualty_hazard_info    GIXX_CASUALTY_ITEM.section_or_hazard_info%TYPE,
    casualty_line_cd        GIXX_CASUALTY_ITEM.section_line_cd%TYPE,
    casualty_subline_cd     GIXX_CASUALTY_ITEM.section_subline_cd%TYPE,
    casualty_hazard_cd      GIXX_CASUALTY_ITEM.section_or_hazard_cd%TYPE,
    hazard_title            GIIS_SECTION_OR_HAZARD.section_or_hazard_title%TYPE, 
    casualty_liability      GIXX_CASUALTY_ITEM.limit_of_liability%TYPE,
    casualty_interest       GIXX_CASUALTY_ITEM.interest_on_premises%TYPE,
    casualty_conveyance     GIXX_CASUALTY_ITEM.conveyance_info%TYPE,
    casualty_property_type  GIXX_CASUALTY_ITEM.property_no_type%TYPE,
    casualty_property_no    GIXX_CASUALTY_ITEM.property_no%TYPE,
    itemca_from_date        GIXX_ITEM.from_date%TYPE, 
    itemca_to_date          GIXX_ITEM.to_date%TYPE    
    );
    
  TYPE pol_doc_ca_item_tab IS TABLE OF pol_doc_ca_item_type;
  
  FUNCTION get_pol_doc_ca_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
    RETURN pol_doc_ca_item_tab PIPELINED;  
    
  TYPE pol_doc_en_item_type IS RECORD (
    extract_id              GIXX_ITEM.extract_id%TYPE,
    item_item_no            GIXX_ITEM.item_no%TYPE, 
    item_item_title         GIXX_ITEM.item_title%TYPE, 
    item_item_desc          GIXX_ITEM.item_desc%TYPE,
    item_item_desc2         GIXX_ITEM.item_desc2%TYPE, 
    item_coverage_cd        GIXX_ITEM.coverage_cd%TYPE,
    item_currency_desc      GIIS_CURRENCY.currency_desc%TYPE,
    item_other_info         GIXX_ITEM.other_info%TYPE,
    province_cd                GIXX_LOCATION.province_cd%TYPE,
    region_cd                GIXX_LOCATION.region_cd%TYPE,
    province_desc            GIIS_PROVINCE.province_desc%TYPE,
    region_desc                GIIS_REGION.region_desc%TYPE,
    item_title_length        VARCHAR2(4),
    show_ded                VARCHAR2(1)
    );
    
  TYPE pol_doc_en_item_tab IS TABLE OF pol_doc_en_item_type;
  
  FUNCTION get_pol_doc_en_item(p_extract_id GIXX_ITEM.extract_id%TYPE) 
    RETURN pol_doc_en_item_tab PIPELINED;

  TYPE pol_doc_ah_item_type IS RECORD (
    extract_id              GIXX_ITEM.extract_id%TYPE,
    item_no                 GIXX_ITEM.item_no%TYPE,
    item_title              GIXX_ITEM.item_title%TYPE,
    item_desc               GIXX_ITEM.item_desc%TYPE,
    item_desc2              GIXX_ITEM.item_desc2%TYPE,
    coverage_cd             GIXX_ITEM.coverage_cd%TYPE,
    currency_desc           GIIS_CURRENCY.currency_desc%TYPE,
    other_info              GIXX_ITEM.other_info%TYPE,
    item_date_of_travel     VARCHAR2(50),
    from_date               GIXX_ITEM.from_date%TYPE,
    to_date                 GIXX_ITEM.to_date%TYPE,
    acitem_age              GIXX_ACCIDENT_ITEM.age%TYPE,
    acitem_sex              VARCHAR2(10),
    acitem_height           GIXX_ACCIDENT_ITEM.height%TYPE,
    acitem_weight           GIXX_ACCIDENT_ITEM.weight%TYPE,
    acitem_date_of_birth    GIXX_ACCIDENT_ITEM.date_of_birth%TYPE,
    acitem_civil_status     VARCHAR2(50),--GIXX_ACCIDENT_ITEM.civil_status%TYPE,
    monthly_salary          GIXX_ACCIDENT_ITEM.monthly_salary%TYPE,
    acitem_monthly_salary   VARCHAR2(50), --GIXX_ACCIDENT_ITEM.monthly_salary%TYPE,
    acitem_salary_grade     GIXX_ACCIDENT_ITEM.salary_grade%TYPE,
    acitem_no_of_persons    GIXX_ACCIDENT_ITEM.no_of_persons%TYPE,
    acitem_destination      GIXX_ACCIDENT_ITEM.destination%TYPE,
    acitem_position_cd      GIXX_ACCIDENT_ITEM.position_cd%TYPE,
    position                GIIS_POSITION.position%TYPE
    );
    
  TYPE pol_doc_ah_item_tab IS TABLE OF pol_doc_ah_item_type;
  
  FUNCTION get_pol_doc_ah_item (p_extract_id GIXX_ITEM.extract_id%TYPE)
    RETURN pol_doc_ah_item_tab PIPELINED;
    
  TYPE pol_doc_mh_item_type IS RECORD (
    extract_id              GIXX_ITEM.extract_id%TYPE,
    item_item_no            GIXX_ITEM.item_no%TYPE,
    item_item_title         VARCHAR2(100),
    item_item_title2        GIXX_ITEM.item_title%TYPE,
    item_desc                  GIXX_ITEM.item_desc%TYPE,
    item_desc2                 GIXX_ITEM.item_desc2%TYPE,
    item_coverage_cd        GIXX_ITEM.coverage_cd%TYPE,
    item_currency_desc      GIIS_CURRENCY.currency_desc%TYPE,
    item_other_info         GIXX_ITEM.other_info%TYPE,
    ves_item_no                GIXX_ITEM_VES.item_no%TYPE,
    ves_vessel_cd            GIXX_ITEM_VES.vessel_cd%TYPE,
    ves_deduct_text            GIXX_ITEM_VES.deduct_text%TYPE,
    ves_geog_limit            GIXX_ITEM_VES.geog_limit%TYPE,
    VESSEL_VESSEL_CD         GIIS_VESSEL.VESSEL_CD%TYPE,
    VESSEL_VESSEL_NAME         GIIS_VESSEL.VESSEL_NAME%TYPE,
    VESSEL_VESTYPE_CD         GIIS_VESSEL.VESTYPE_CD%TYPE,
    VESSEL_CLASS_CD         GIIS_VESSEL.VESS_CLASS_CD%TYPE,
    VESSEL_HULL_TYPE_CD     GIIS_VESSEL.HULL_TYPE_CD%TYPE,
    VESSEL_GROSS_TON         VARCHAR2(20),
    VESSEL_NET_TON             VARCHAR2(20),
    VESSEL_YEAR_BUILT         GIIS_VESSEL.YEAR_BUILT%TYPE,
    VESSEL_DEADWEIGHT         GIIS_VESSEL.DEADWEIGHT%TYPE,
    VESSEL_DRY_PLACE         GIIS_VESSEL.DRY_PLACE%TYPE,
    VESSEL_NO_CREW             GIIS_VESSEL.NO_CREW%TYPE,
    VESSEL_LENGTH             GIIS_VESSEL.VESSEL_LENGTH%TYPE,       
    VESSEL_BREADTH             GIIS_VESSEL.VESSEL_BREADTH%TYPE,      
    VESSEL_DEPTH             GIIS_VESSEL.VESSEL_DEPTH%TYPE,
    VESSEL_DRY_DATE         GIIS_VESSEL.DRY_DATE%TYPE,
    vestype_desc            giis_vestype.vestype_desc%TYPE,
    vess_class_desc            giis_vess_class.vess_class_desc%TYPE,
    hull_desc                giis_hull_type.hull_desc%TYPE
    );

  TYPE pol_doc_mh_item_tab IS TABLE OF pol_doc_mh_item_type;
  
  FUNCTION get_pol_doc_mh_item (p_extract_id GIXX_ITEM.extract_id%TYPE)
    RETURN pol_doc_mh_item_tab PIPELINED;
    
  TYPE item_type IS RECORD (
    extract_id                GIXX_ITEM.extract_id%TYPE,
    item_no                 GIXX_ITEM.item_no%TYPE,
    show_ded_text           VARCHAR2(1),
    v_cnt                    NUMBER(2)
    );
    
  TYPE item_tab IS TABLE OF item_type;
  
  FUNCTION get_items(p_extract_id GIXX_ITEM.extract_id%TYPE)
     RETURN item_tab PIPELINED;
     
  /** START OF PACKAGE POLICY DOCUMENTS FUNCTIONS **/
  
  FUNCTION get_pack_pol_doc_mc_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_mc_item_tab PIPELINED;
  
  FUNCTION get_pack_pol_doc_en_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_en_item_tab PIPELINED;
  
  FUNCTION get_pack_pol_doc_mn_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_mn_item_tab PIPELINED;
  
  FUNCTION get_pack_pol_doc_ca_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_ca_item_tab PIPELINED;
  
  FUNCTION get_pack_pol_doc_ah_item(p_extract_id GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id  GIXX_ITEM.policy_id%TYPE) 
  RETURN pol_doc_ah_item_tab PIPELINED;
  
  
  -- added by Kris 02.26.2013: for GIPIS101
  TYPE related_item_info_type IS RECORD (
    extract_id          gixx_item.extract_id%TYPE,
    policy_id           gixx_item.policy_id%TYPE,
    item_grp            gixx_item.item_grp%TYPE,
    item_no             gixx_item.item_no%TYPE,
    item_title          gixx_item.item_title%TYPE,
    item_desc           gixx_item.item_desc%TYPE,
    item_desc2          gixx_item.item_desc2%TYPE,
    coverage_cd         gixx_item.coverage_cd%TYPE,
    coverage_desc       giis_coverage.coverage_desc%TYPE,
    currency_cd         gixx_item.currency_cd%TYPE,
    currency_desc       giis_currency.currency_desc%TYPE,
    currency_rt         gixx_item.currency_rt%TYPE,
    tsi_amt             gixx_item.tsi_amt%TYPE,
    prem_amt            gixx_item.prem_amt%TYPE,
    pack_line_cd        gixx_item.pack_line_cd%TYPE,
    pack_subline_cd     gixx_item.pack_subline_cd%TYPE,
    group_cd            gixx_item.group_cd%TYPE,
    peril_view_type        VARCHAR2(15),  
    item_type              VARCHAR2(10),   
    pack_pol_flag       gixx_polbasic.pack_pol_flag%TYPE
  );
  
  TYPE related_item_info_tab IS TABLE OF related_item_info_type;
  
  FUNCTION get_related_item_info(
        p_extract_id        gixx_item.extract_id%TYPE,
        p_policy_id         gixx_polbasic.policy_id%TYPE
  ) RETURN related_item_info_tab PIPELINED;
  -- end 02.26.2013: for GIPIS101
  
END GIXX_ITEM_PKG;
/



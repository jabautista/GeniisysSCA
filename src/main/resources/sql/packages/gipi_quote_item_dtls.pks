CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Item_Dtls AS

  TYPE gipi_quote_mc_type IS RECORD
    (quote_id             GIPI_QUOTE_ITEM_MC.quote_id%TYPE,
	 item_no           	  GIPI_QUOTE_ITEM_MC.item_no%TYPE,
	 plate_no             GIPI_QUOTE_ITEM_MC.plate_no%TYPE,
	 motor_no			  GIPI_QUOTE_ITEM_MC.motor_no%TYPE,
	 serial_no			  GIPI_QUOTE_ITEM_MC.serial_no%TYPE,              
	 subline_type_cd	  GIPI_QUOTE_ITEM_MC.subline_type_cd%TYPE,
	 mot_type			  GIPI_QUOTE_ITEM_MC.mot_type%TYPE,
	 car_company_cd		  GIPI_QUOTE_ITEM_MC.car_company_cd%TYPE,
	 coc_yy				  GIPI_QUOTE_ITEM_MC.coc_yy%TYPE,
	 coc_seq_no			  GIPI_QUOTE_ITEM_MC.coc_seq_no%TYPE,             
	 coc_serial_no		  GIPI_QUOTE_ITEM_MC.coc_serial_no%TYPE,
	 coc_type			  GIPI_QUOTE_ITEM_MC.coc_type%TYPE,
	 repair_lim			  GIPI_QUOTE_ITEM_MC.repair_lim%TYPE,
	 color				  GIPI_QUOTE_ITEM_MC.color%TYPE,
	 model_year			  GIPI_QUOTE_ITEM_MC.model_year%TYPE,             
	 make				  GIPI_QUOTE_ITEM_MC.make%TYPE,
	 est_value			  GIPI_QUOTE_ITEM_MC.est_value%TYPE,
	 towing				  GIPI_QUOTE_ITEM_MC.towing%TYPE,
	 assignee			  GIPI_QUOTE_ITEM_MC.assignee%TYPE,
	 no_of_pass			  GIPI_QUOTE_ITEM_MC.no_of_pass%TYPE,             
	 tariff_zone		  GIPI_QUOTE_ITEM_MC.tariff_zone%TYPE,
	 coc_issue_date		  GIPI_QUOTE_ITEM_MC.coc_issue_date%TYPE,
	 mv_file_no			  GIPI_QUOTE_ITEM_MC.mv_file_no%TYPE,
	 acquired_from		  GIPI_QUOTE_ITEM_MC.acquired_from%TYPE,
	 ctv_tag			  GIPI_QUOTE_ITEM_MC.ctv_tag%TYPE,                
	 type_of_body_cd	  GIPI_QUOTE_ITEM_MC.type_of_body_cd%TYPE,
	 unladen_wt			  GIPI_QUOTE_ITEM_MC.unladen_wt%TYPE,
	 make_cd			  GIPI_QUOTE_ITEM_MC.make_cd%TYPE,
	 series_cd			  GIPI_QUOTE_ITEM_MC.series_cd%TYPE,
	 basic_color_cd		  GIPI_QUOTE_ITEM_MC.basic_color_cd%TYPE,         
	 color_cd			  GIPI_QUOTE_ITEM_MC.color_cd%TYPE,
	 origin				  GIPI_QUOTE_ITEM_MC.origin%TYPE,
	 destination		  GIPI_QUOTE_ITEM_MC.destination%TYPE,
	 coc_atcn			  GIPI_QUOTE_ITEM_MC.coc_atcn%TYPE,
	 user_id			  GIPI_QUOTE_ITEM_MC.user_id%TYPE,                
	 last_update		  GIPI_QUOTE_ITEM_MC.last_update%TYPE,
	 subline_cd			  GIPI_QUOTE_ITEM_MC.subline_cd%TYPE,
	 subline_type_desc	  GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE,
	 car_company		  GIIS_MC_CAR_COMPANY.car_company%TYPE,
	 basic_color		  GIIS_MC_COLOR.basic_color%TYPE,
	 type_of_body		  GIIS_TYPE_OF_BODY.type_of_body%TYPE,
	 engine_series        GIIS_MC_ENG_SERIES.engine_series%TYPE,
	 deductible_amt		  NUMBER(16,2));   

  TYPE gipi_quote_mc_tab IS TABLE OF gipi_quote_mc_type;

  FUNCTION get_gipi_quote_mc (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mc_tab PIPELINED; 
	
  FUNCTION get_all_gipi_quote_mc (p_quote_id      GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_mc_tab PIPELINED;	
	
  PROCEDURE set_gipi_quote_mc (p_quote_item_mc             GIPI_QUOTE_ITEM_MC%ROWTYPE);
							   									 
  PROCEDURE del_gipi_quote_mc (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no                   GIPI_QUOTE_ITEM.item_no%TYPE);	
                               							 
  PROCEDURE del_all_addinfo_mc (p_quote_id                  GIPI_QUOTE.quote_id%TYPE);
  
  TYPE serial_no_mc_type IS RECORD(
    serial_no			  GIPI_QUOTE_ITEM_MC.serial_no%TYPE);
  
  TYPE serial_no_mc_tab IS TABLE OF serial_no_mc_type;
  
  FUNCTION get_all_serial_no_mc
    RETURN serial_no_mc_tab PIPELINED;
    
  TYPE motor_no_mc_type IS RECORD(
    motor_no			  GIPI_QUOTE_ITEM_MC.motor_no%TYPE);
  
  TYPE motor_no_mc_tab IS TABLE OF motor_no_mc_type;  
							   
  FUNCTION get_all_motor_no_mc
    return motor_no_mc_tab PIPELINED;
      
  TYPE plate_no_mc_type IS RECORD(
    plate_no               GIPI_QUOTE_ITEM_MC.plate_no%TYPE);
    
  TYPE plate_no_mc_tab IS TABLE OF plate_no_mc_type; 
     
  FUNCTION get_all_plate_no_mc
    return plate_no_mc_tab PIPELINED;
    
  TYPE coc_no_mc_type IS RECORD(
    coc_serial_no		  GIPI_QUOTE_ITEM_MC.coc_serial_no%TYPE,
    quote_no              VARCHAR2(30));
    
  TYPE coc_no_mc_tab IS TABLE of coc_no_mc_type; 
  
  FUNCTION get_all_coc_no_mc
    return coc_no_mc_tab PIPELINED;     
    

  TYPE gipi_quote_fi_type IS RECORD
    (quote_id                GIPI_QUOTE_FI_ITEM.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_FI_ITEM.item_no%TYPE,
	 assignee             	 GIPI_QUOTE_FI_ITEM.assignee%TYPE,
	 fr_item_type			 GIPI_QUOTE_FI_ITEM.fr_item_type%TYPE,
	 fr_itm_tp_ds		  	 GIIS_FI_ITEM_TYPE.fr_itm_tp_ds%TYPE,	 
	 block_id				 GIPI_QUOTE_FI_ITEM.block_id%TYPE,
	 province_desc		  	 GIIS_PROVINCE.province_desc%TYPE,
     province_cd		  	 GIIS_PROVINCE.province_cd%TYPE,
	 district_no		  	 GIPI_QUOTE_FI_ITEM.district_no%TYPE,
	 block_no		  	 	 GIPI_QUOTE_FI_ITEM.block_no%TYPE,	 
	 block_desc			  	 GIIS_BLOCK.block_desc%TYPE,
	 risk_cd				 GIPI_QUOTE_FI_ITEM.risk_cd%TYPE,
	 risk_desc			 	 GIIS_RISKS.risk_desc%TYPE,              
	 eq_zone				 GIPI_QUOTE_FI_ITEM.eq_zone%TYPE,
	 eq_desc			  	 GIIS_EQZONE.eq_desc%TYPE, 
	 typhoon_zone		  	 GIPI_QUOTE_FI_ITEM.typhoon_zone%TYPE,	         
	 typhoon_zone_desc	  	 GIIS_TYPHOON_ZONE.typhoon_zone_desc%TYPE,
	 flood_zone		  	 	 GIPI_QUOTE_FI_ITEM.flood_zone%TYPE,	 
	 flood_zone_desc	  	 GIIS_FLOOD_ZONE.flood_zone_desc%TYPE,
	 tarf_cd			  	 GIPI_QUOTE_FI_ITEM.tarf_cd%TYPE,
	 tariff_zone		  	 GIPI_QUOTE_FI_ITEM.tariff_zone%TYPE,
	 tariff_zone_desc	  	 GIIS_TARIFF_ZONE.tariff_zone_desc%TYPE,
	 construction_cd	  	 GIPI_QUOTE_FI_ITEM.construction_cd%TYPE,
	 construction_desc    	 GIIS_FIRE_CONSTRUCTION.construction_desc%TYPE,
	 construction_remarks 	 GIPI_QUOTE_FI_ITEM.construction_remarks%TYPE,
	 user_id			  	 GIPI_QUOTE_FI_ITEM.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_FI_ITEM.last_update%TYPE,
	 front				  	 GIPI_QUOTE_FI_ITEM.front%TYPE,
	 RIGHT				  	 GIPI_QUOTE_FI_ITEM.RIGHT%TYPE,
	 LEFT			      	 GIPI_QUOTE_FI_ITEM.LEFT%TYPE,             
	 rear			      	 GIPI_QUOTE_FI_ITEM.rear%TYPE,
	 loc_risk1			  	 GIPI_QUOTE_FI_ITEM.loc_risk1%TYPE,
	 loc_risk2			  	 GIPI_QUOTE_FI_ITEM.loc_risk2%TYPE,
	 loc_risk3			  	 GIPI_QUOTE_FI_ITEM.loc_risk3%TYPE,       
	 occupancy_cd		  	 GIPI_QUOTE_FI_ITEM.occupancy_cd%TYPE,
	 occupancy_desc		  	 GIIS_FIRE_OCCUPANCY.occupancy_desc%TYPE,	       
	 occupancy_remarks	  	 GIPI_QUOTE_FI_ITEM.occupancy_remarks%TYPE,
	 city_cd				 GIIS_BLOCK.city_cd%TYPE,
	 city					 GIIS_BLOCK.city%TYPE,
     date_from			  	 GIPI_QUOTE_FI_ITEM.date_from%TYPE,
     date_to			  	 GIPI_QUOTE_FI_ITEM.date_to%TYPE);   

  TYPE gipi_quote_fi_tab IS TABLE OF gipi_quote_fi_type;

  FUNCTION get_gipi_quote_fi (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_fi_tab PIPELINED;
	

  PROCEDURE set_gipi_quote_fi (
     v_quote_id                IN  GIPI_QUOTE_FI_ITEM.quote_id%TYPE,
	 v_item_no           	   IN  GIPI_QUOTE_FI_ITEM.item_no%TYPE,
	 v_assignee                IN  GIPI_QUOTE_FI_ITEM.assignee%TYPE,
	 v_fr_item_type			   IN  GIPI_QUOTE_FI_ITEM.fr_item_type%TYPE,
	 v_block_id				   IN  GIPI_QUOTE_FI_ITEM.block_id%TYPE,
	 v_district_no		  	   IN  GIPI_QUOTE_FI_ITEM.district_no%TYPE,
	 v_block_no		  	 	   IN  GIPI_QUOTE_FI_ITEM.block_no%TYPE,	 
	 v_risk_cd				   IN  GIPI_QUOTE_FI_ITEM.risk_cd%TYPE,           
	 v_eq_zone				   IN  GIPI_QUOTE_FI_ITEM.eq_zone%TYPE,
	 v_typhoon_zone		  	   IN  GIPI_QUOTE_FI_ITEM.typhoon_zone%TYPE,	         
	 v_flood_zone		  	   IN  GIPI_QUOTE_FI_ITEM.flood_zone%TYPE,	 
	 v_tarf_cd			  	   IN  GIPI_QUOTE_FI_ITEM.tarf_cd%TYPE,
	 v_tariff_zone		  	   IN  GIPI_QUOTE_FI_ITEM.tariff_zone%TYPE,
	 v_construction_cd	  	   IN  GIPI_QUOTE_FI_ITEM.construction_cd%TYPE,
	 v_construction_remarks    IN  GIPI_QUOTE_FI_ITEM.construction_remarks%TYPE,
	 v_user_id			  	   IN  GIPI_QUOTE_FI_ITEM.user_id%TYPE,
	 v_last_update		  	   IN  GIPI_QUOTE_FI_ITEM.last_update%TYPE,
	 v_front				   IN  GIPI_QUOTE_FI_ITEM.front%TYPE,
	 v_right				   IN  GIPI_QUOTE_FI_ITEM.RIGHT%TYPE,
	 v_left			      	   IN  GIPI_QUOTE_FI_ITEM.LEFT%TYPE,             
	 v_rear			      	   IN  GIPI_QUOTE_FI_ITEM.rear%TYPE,
	 v_loc_risk1			   IN  GIPI_QUOTE_FI_ITEM.loc_risk1%TYPE,
	 v_loc_risk2			   IN  GIPI_QUOTE_FI_ITEM.loc_risk2%TYPE,
	 v_loc_risk3			   IN  GIPI_QUOTE_FI_ITEM.loc_risk3%TYPE,       
	 v_occupancy_cd		  	   IN  GIPI_QUOTE_FI_ITEM.occupancy_cd%TYPE,       
	 v_occupancy_remarks	   IN  GIPI_QUOTE_FI_ITEM.occupancy_remarks%TYPE,
     v_date_from               IN  GIPI_QUOTE_FI_ITEM.date_from%TYPE,
     v_date_to                 IN  GIPI_QUOTE_FI_ITEM.date_to%TYPE,
     v_latitude                IN  GIPI_QUOTE_FI_ITEM.latitude%TYPE, --Added by MarkS 02/09/2017 SR5918
     v_longitude               IN  GIPI_QUOTE_FI_ITEM.longitude%TYPE --Added by MarkS 02/09/2017 SR5918
     );	

								 
  PROCEDURE del_gipi_quote_fi (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no                   GIPI_QUOTE_ITEM.item_no%TYPE);
                               
  PROCEDURE del_all_addinfo_fi (p_quote_id                  GIPI_QUOTE.quote_id%TYPE);							   
							   
  TYPE gipi_quote_ac_type IS RECORD
    (quote_id                GIPI_QUOTE_AC_ITEM.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_AC_ITEM.item_no%TYPE,
	 no_of_persons		  	 GIPI_QUOTE_AC_ITEM.no_of_persons%TYPE,
	 position_cd		  	 GIPI_QUOTE_AC_ITEM.position_cd%TYPE,	 
	 position				 GIIS_POSITION.position%TYPE,
	 destination			 GIPI_QUOTE_AC_ITEM.destination%TYPE,
	 monthly_salary		  	 GIPI_QUOTE_AC_ITEM.monthly_salary%TYPE,
	 salary_grade		  	 GIPI_QUOTE_AC_ITEM.salary_grade%TYPE,
	 date_of_birth	  	 	 GIPI_QUOTE_AC_ITEM.date_of_birth%TYPE,	 
	 civil_status			 GIPI_QUOTE_AC_ITEM.civil_status%TYPE,       
	 Age					 GIPI_QUOTE_AC_ITEM.Age%TYPE,
	 weight					 GIPI_QUOTE_AC_ITEM.weight%TYPE,	         
	 height					 GIPI_QUOTE_AC_ITEM.height%TYPE,	 
	 sex					 GIPI_QUOTE_AC_ITEM.sex%TYPE,
	 user_id				 GIPI_QUOTE_AC_ITEM.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_AC_ITEM.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_ac_tab IS TABLE OF gipi_quote_ac_type;

  FUNCTION get_gipi_quote_ac (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_ac_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_ac (
     v_quote_id              IN  GIPI_QUOTE_AC_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_AC_ITEM.item_no%TYPE,
	 v_no_of_persons		 IN  GIPI_QUOTE_AC_ITEM.no_of_persons%TYPE,
	 v_position_cd		  	 IN  GIPI_QUOTE_AC_ITEM.position_cd%TYPE,
	 v_destination			 IN  GIPI_QUOTE_AC_ITEM.destination%TYPE,
	 v_monthly_salary		 IN  GIPI_QUOTE_AC_ITEM.monthly_salary%TYPE,
	 v_salary_grade		  	 IN  GIPI_QUOTE_AC_ITEM.salary_grade%TYPE,
	 v_date_of_birth	  	 IN  GIPI_QUOTE_AC_ITEM.date_of_birth%TYPE,	 
	 v_civil_status			 IN  GIPI_QUOTE_AC_ITEM.civil_status%TYPE,       
	 v_age					 IN  GIPI_QUOTE_AC_ITEM.Age%TYPE,
	 v_weight				 IN  GIPI_QUOTE_AC_ITEM.weight%TYPE,	         
	 v_height				 IN  GIPI_QUOTE_AC_ITEM.height%TYPE,	 
	 v_sex					 IN  GIPI_QUOTE_AC_ITEM.sex%TYPE);	

								 
  PROCEDURE del_gipi_quote_ac (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no                   GIPI_QUOTE_ITEM.item_no%TYPE);	


  TYPE gipi_quote_mn_type IS RECORD
    (quote_id                GIPI_QUOTE_CARGO.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_CARGO.item_no%TYPE,
	 geog_cd				 GIPI_QUOTE_CARGO.geog_cd%TYPE,
	 geog_desc				 GIIS_GEOG_CLASS.geog_desc%TYPE,	 
	 vessel_cd				 GIPI_QUOTE_CARGO.vessel_cd%TYPE,
	 vessel_name			 GIIS_VESSEL.vessel_name%TYPE,	 
	 cargo_class_cd		  	 GIPI_QUOTE_CARGO.cargo_class_cd%TYPE,
	 cargo_class_desc	  	 GIIS_CARGO_CLASS.cargo_class_desc%TYPE,	 
	 cargo_type				 GIPI_QUOTE_CARGO.cargo_type%TYPE,
	 cargo_type_desc		 GIIS_CARGO_TYPE.cargo_type_desc%TYPE,	 
	 pack_method	  	 	 GIPI_QUOTE_CARGO.pack_method%TYPE,	 
	 bl_awb					 GIPI_QUOTE_CARGO.bl_awb%TYPE,       
	 tranship_origin		 GIPI_QUOTE_CARGO.tranship_origin%TYPE,
	 tranship_destination	 GIPI_QUOTE_CARGO.tranship_destination%TYPE,	         
	 voyage_no				 GIPI_QUOTE_CARGO.voyage_no%TYPE,	 
	 lc_no					 GIPI_QUOTE_CARGO.lc_no%TYPE,
	 etd					 GIPI_QUOTE_CARGO.etd%TYPE,
	 eta					 GIPI_QUOTE_CARGO.eta%TYPE,
	 print_tag				 GIPI_QUOTE_CARGO.print_tag%TYPE,	 	 	 
	 print_tag_desc			 CG_REF_CODES.rv_meaning%TYPE,
	 origin					 GIPI_QUOTE_CARGO.origin%TYPE,
	 destn					 GIPI_QUOTE_CARGO.destn%TYPE,	 
	 user_id				 GIPI_QUOTE_CARGO.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_CARGO.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_mn_tab IS TABLE OF gipi_quote_mn_type;

  FUNCTION get_gipi_quote_mn (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mn_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_mn (
  	 v_quote_id              IN  GIPI_QUOTE_CARGO.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_CARGO.item_no%TYPE,
	 v_geog_cd				 IN  GIPI_QUOTE_CARGO.geog_cd%TYPE,	 
	 v_vessel_cd			 IN  GIPI_QUOTE_CARGO.vessel_cd%TYPE,
	 v_cargo_class_cd		 IN  GIPI_QUOTE_CARGO.cargo_class_cd%TYPE,
	 v_cargo_type			 IN  GIPI_QUOTE_CARGO.cargo_type%TYPE,
	 v_pack_method	  	 	 IN  GIPI_QUOTE_CARGO.pack_method%TYPE,	 
	 v_bl_awb				 IN  GIPI_QUOTE_CARGO.bl_awb%TYPE,       
	 v_tranship_origin		 IN  GIPI_QUOTE_CARGO.tranship_origin%TYPE,
	 v_tranship_destination	 IN  GIPI_QUOTE_CARGO.tranship_destination%TYPE,	         
	 v_voyage_no			 IN  GIPI_QUOTE_CARGO.voyage_no%TYPE,	 
	 v_lc_no				 IN  GIPI_QUOTE_CARGO.lc_no%TYPE,
	 v_etd					 IN  GIPI_QUOTE_CARGO.etd%TYPE,
	 v_eta					 IN  GIPI_QUOTE_CARGO.eta%TYPE,
	 v_print_tag			 IN  GIPI_QUOTE_CARGO.print_tag%TYPE,	 	 	 
	 v_origin				 IN  GIPI_QUOTE_CARGO.origin%TYPE,
	 v_destn				 IN  GIPI_QUOTE_CARGO.destn%TYPE);	

								 
  PROCEDURE del_gipi_quote_mn (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no                   GIPI_QUOTE_ITEM.item_no%TYPE);
							   

  TYPE gipi_quote_ca_type IS RECORD
    (quote_id                GIPI_QUOTE_CA_ITEM.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_CA_ITEM.item_no%TYPE,
	 LOCATION				 GIPI_QUOTE_CA_ITEM.LOCATION%TYPE,
	 section_or_hazard_cd	 GIPI_QUOTE_CA_ITEM.section_or_hazard_cd%TYPE,
	 section_or_hazard_title GIIS_SECTION_OR_HAZARD.section_or_hazard_title%TYPE,	 	 
	 capacity_cd			 GIPI_QUOTE_CA_ITEM.capacity_cd%TYPE,
	 position				 GIIS_POSITION.position%TYPE,	 
	 limit_of_liability		 GIPI_QUOTE_CA_ITEM.limit_of_liability%TYPE,	 
	 section_line_cd	  	 GIPI_QUOTE_CA_ITEM.section_line_cd%TYPE,
	 section_subline_cd		 GIPI_QUOTE_CA_ITEM.section_subline_cd%TYPE,
	 property_no_type  	 	 GIPI_QUOTE_CA_ITEM.property_no_type%TYPE,	 
	 property_no			 GIPI_QUOTE_CA_ITEM.property_no%TYPE,       
	 conveyance_info		 GIPI_QUOTE_CA_ITEM.conveyance_info%TYPE,
	 interest_on_premises	 GIPI_QUOTE_CA_ITEM.interest_on_premises%TYPE,	         
	 section_or_hazard_info  GIPI_QUOTE_CA_ITEM.section_or_hazard_info%TYPE,	 
	 user_id				 GIPI_QUOTE_CA_ITEM.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_CA_ITEM.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_ca_tab IS TABLE OF gipi_quote_ca_type;

  FUNCTION get_gipi_quote_ca (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_ca_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_ca (
  	 v_quote_id                IN  GIPI_QUOTE_CA_ITEM.quote_id%TYPE,
	 v_item_no           	   IN  GIPI_QUOTE_CA_ITEM.item_no%TYPE,
	 v_location				   IN  GIPI_QUOTE_CA_ITEM.LOCATION%TYPE,
	 v_section_or_hazard_cd	   IN  GIPI_QUOTE_CA_ITEM.section_or_hazard_cd%TYPE,	 
	 v_capacity_cd			   IN  GIPI_QUOTE_CA_ITEM.capacity_cd%TYPE,
	 v_limit_of_liability	   IN  GIPI_QUOTE_CA_ITEM.limit_of_liability%TYPE,	 
	 v_section_line_cd	  	   IN  GIPI_QUOTE_CA_ITEM.section_line_cd%TYPE,
	 v_section_subline_cd	   IN  GIPI_QUOTE_CA_ITEM.section_subline_cd%TYPE,
	 v_property_no_type  	   IN  GIPI_QUOTE_CA_ITEM.property_no_type%TYPE,	 
	 v_property_no			   IN  GIPI_QUOTE_CA_ITEM.property_no%TYPE,       
	 v_conveyance_info		   IN  GIPI_QUOTE_CA_ITEM.conveyance_info%TYPE,
	 v_interest_on_premises	   IN  GIPI_QUOTE_CA_ITEM.interest_on_premises%TYPE,	         
	 v_section_or_hazard_info  IN  GIPI_QUOTE_CA_ITEM.section_or_hazard_info%TYPE);	

								 
  PROCEDURE del_gipi_quote_ca (p_quote_id                  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no                   GIPI_QUOTE_ITEM.item_no%TYPE);							   						   
							   

  TYPE gipi_quote_en_type IS RECORD
    (quote_id                  GIPI_QUOTE_EN_ITEM.quote_id%TYPE,
	 engg_basic_infonum	  	   GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE,
	 contract_proj_buss_title  GIPI_QUOTE_EN_ITEM.contract_proj_buss_title%TYPE,
	 site_location			   GIPI_QUOTE_EN_ITEM.site_location%TYPE,
	 construct_start_date	   GIPI_QUOTE_EN_ITEM.construct_start_date%TYPE,	 	 
	 construct_end_date	   	   GIPI_QUOTE_EN_ITEM.construct_end_date%TYPE,
	 maintain_start_date	   GIPI_QUOTE_EN_ITEM.maintain_start_date%TYPE,	 
	 maintain_end_date		   GIPI_QUOTE_EN_ITEM.maintain_end_date%TYPE,	 
	 testing_start_date	  	   GIPI_QUOTE_EN_ITEM.testing_start_date%TYPE,
	 testing_end_date		   GIPI_QUOTE_EN_ITEM.testing_end_date%TYPE,
	 weeks_test				   GIPI_QUOTE_EN_ITEM.weeks_test%TYPE,	 
	 time_excess			   GIPI_QUOTE_EN_ITEM.time_excess%TYPE,       
	 mbi_policy_no			   GIPI_QUOTE_EN_ITEM.mbi_policy_no%TYPE,
	 user_id				   GIPI_QUOTE_EN_ITEM.user_id%TYPE,
	 last_update		  	   GIPI_QUOTE_EN_ITEM.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_en_tab IS TABLE OF gipi_quote_en_type;

  FUNCTION get_gipi_quote_en (p_quote_id            GIPI_QUOTE.quote_id%TYPE,
                              p_engg_basic_infonum  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE )
    RETURN gipi_quote_en_tab PIPELINED;
    
  FUNCTION get_gipi_quote_en2 (p_quote_id           GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_en_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_en (
  	 v_quote_id                  IN  GIPI_QUOTE_EN_ITEM.quote_id%TYPE,
	 v_engg_basic_infonum	  	 IN  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE,
	 v_contract_proj_buss_title  IN  GIPI_QUOTE_EN_ITEM.contract_proj_buss_title%TYPE,
	 v_site_location			 IN  GIPI_QUOTE_EN_ITEM.site_location%TYPE,
	 v_construct_start_date	   	 IN  GIPI_QUOTE_EN_ITEM.construct_start_date%TYPE,	 	 
	 v_construct_end_date	   	 IN  GIPI_QUOTE_EN_ITEM.construct_end_date%TYPE,
	 v_maintain_start_date	   	 IN  GIPI_QUOTE_EN_ITEM.maintain_start_date%TYPE,	 
	 v_maintain_end_date		 IN  GIPI_QUOTE_EN_ITEM.maintain_end_date%TYPE,	 
	 v_testing_start_date	  	 IN  GIPI_QUOTE_EN_ITEM.testing_start_date%TYPE,
	 v_testing_end_date		   	 IN  GIPI_QUOTE_EN_ITEM.testing_end_date%TYPE,
	 v_weeks_test				 IN  GIPI_QUOTE_EN_ITEM.weeks_test%TYPE,	 
	 v_time_excess			   	 IN  GIPI_QUOTE_EN_ITEM.time_excess%TYPE,       
	 v_mbi_policy_no			 IN  GIPI_QUOTE_EN_ITEM.mbi_policy_no%TYPE);	

								 
  PROCEDURE del_gipi_quote_en (p_quote_id            GIPI_QUOTE.quote_id%TYPE,
                               p_engg_basic_infonum  GIPI_QUOTE_EN_ITEM.engg_basic_infonum%TYPE);							   

  PROCEDURE del_gipi_quote_en2 (p_quote_id           GIPI_QUOTE.quote_id%TYPE);							   
						   
  TYPE gipi_quote_mh_type IS RECORD
    (quote_id                GIPI_QUOTE_MH_ITEM.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_MH_ITEM.item_no%TYPE,
	 geog_limit				 GIPI_QUOTE_MH_ITEM.geog_limit%TYPE,
	 dry_place				 GIPI_QUOTE_MH_ITEM.dry_place%TYPE,
	 dry_date				 GIPI_QUOTE_MH_ITEM.dry_date%TYPE,	 
	 rec_flag				 GIPI_QUOTE_MH_ITEM.rec_flag%TYPE,
	 deduct_text			 GIPI_QUOTE_MH_ITEM.deduct_text%TYPE,	 	 
	 vessel_cd			 	 GIPI_QUOTE_MH_ITEM.vessel_cd%TYPE,
	 vessel_name		 	 GIIS_VESSEL.vessel_name%TYPE,
	 vessel_old_name		 GIIS_VESSEL.vessel_old_name%TYPE,
	 vestype_desc	 	 	 GIIS_VESTYPE.vestype_desc%TYPE,
	 propel_sw				 GIIS_VESSEL.propel_sw%TYPE,
	 hull_desc				 GIIS_HULL_TYPE.hull_desc%TYPE,
	 gross_ton				 GIIS_VESSEL.gross_ton%TYPE,
	 year_built				 GIIS_VESSEL.year_built%TYPE,
	 ves_class_desc		     GIIS_VESS_CLASS.vess_class_desc%TYPE,
	 reg_owner				 GIIS_VESSEL.reg_owner%TYPE,
	 reg_place				 GIIS_VESSEL.reg_place%TYPE,
	 no_crew				 GIIS_VESSEL.no_crew%TYPE,	 	 	 	 	 	 	 	 	 	 
	 net_ton				 GIIS_VESSEL.net_ton%TYPE,
	 deadweight		 	 	 GIIS_VESSEL.deadweight%TYPE,	 
	 crew_nat			 	 GIIS_VESSEL.crew_nat%TYPE,
	 vessel_length		 	 GIIS_VESSEL.vessel_length%TYPE,	 
	 vessel_breadth		 	 GIIS_VESSEL.vessel_breadth%TYPE,
	 vessel_depth		 	 GIIS_VESSEL.vessel_depth%TYPE,	 	 
	 user_id				 GIPI_QUOTE_MH_ITEM.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_MH_ITEM.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_mh_tab IS TABLE OF gipi_quote_mh_type;

  FUNCTION get_gipi_quote_mh (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_mh_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_mh (
  	 v_quote_id              IN  GIPI_QUOTE_MH_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_MH_ITEM.item_no%TYPE,
	 v_geog_limit			 IN  GIPI_QUOTE_MH_ITEM.geog_limit%TYPE,
	 v_dry_place			 IN  GIPI_QUOTE_MH_ITEM.dry_place%TYPE,
	 v_dry_date				 IN  GIPI_QUOTE_MH_ITEM.dry_date%TYPE,	 
	 v_rec_flag				 IN  GIPI_QUOTE_MH_ITEM.rec_flag%TYPE,
	 v_deduct_text			 IN  GIPI_QUOTE_MH_ITEM.deduct_text%TYPE,	 	 
	 v_vessel_cd			 IN  GIPI_QUOTE_MH_ITEM.vessel_cd%TYPE);	

								 
  PROCEDURE del_gipi_quote_mh (p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no   GIPI_QUOTE_ITEM.item_no%TYPE);
							   

  TYPE gipi_quote_av_type IS RECORD
    (quote_id                GIPI_QUOTE_AV_ITEM.quote_id%TYPE,
	 item_no           	  	 GIPI_QUOTE_AV_ITEM.item_no%TYPE,
	 vessel_cd			 	 GIPI_QUOTE_AV_ITEM.vessel_cd%TYPE,
	 rec_flag				 GIPI_QUOTE_AV_ITEM.rec_flag%TYPE,
	 fixed_wing				 GIPI_QUOTE_AV_ITEM.fixed_wing%TYPE,
	 rotor					 GIPI_QUOTE_AV_ITEM.rotor%TYPE,	 
	 vessel_name		 	 GIIS_VESSEL.vessel_name%TYPE,
	 rpc_no					 GIIS_VESSEL.rpc_no%TYPE,
	 air_desc	 	 	     GIIS_AIR_TYPE.air_desc%TYPE,	 
	 purpose				 GIPI_QUOTE_AV_ITEM.purpose%TYPE,
	 deduct_text			 GIPI_QUOTE_AV_ITEM.deduct_text%TYPE,
	 prev_util_hrs			 GIPI_QUOTE_AV_ITEM.prev_util_hrs%TYPE,
	 est_util_hrs			 GIPI_QUOTE_AV_ITEM.est_util_hrs%TYPE,
	 total_fly_time			 GIPI_QUOTE_AV_ITEM.total_fly_time%TYPE,	 	 	 	 	 
	 qualification			 GIPI_QUOTE_AV_ITEM.qualification%TYPE,
	 geog_limit				 GIPI_QUOTE_AV_ITEM.geog_limit%TYPE,	 
	 user_id				 GIPI_QUOTE_AV_ITEM.user_id%TYPE,
	 last_update		  	 GIPI_QUOTE_AV_ITEM.last_update%TYPE);  							   	
							   
  TYPE gipi_quote_av_tab IS TABLE OF gipi_quote_av_type;

  FUNCTION get_gipi_quote_av (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
    RETURN gipi_quote_av_tab PIPELINED;

	
  PROCEDURE set_gipi_quote_av (
  	 v_quote_id              IN  GIPI_QUOTE_AV_ITEM.quote_id%TYPE,
	 v_item_no           	 IN  GIPI_QUOTE_AV_ITEM.item_no%TYPE,
	 v_vessel_cd			 IN  GIPI_QUOTE_AV_ITEM.vessel_cd%TYPE,
	 v_rec_flag				 IN  GIPI_QUOTE_AV_ITEM.rec_flag%TYPE,
	 v_fixed_wing			 IN  GIPI_QUOTE_AV_ITEM.fixed_wing%TYPE,
	 v_rotor				 IN  GIPI_QUOTE_AV_ITEM.rotor%TYPE,	 
	 v_purpose				 IN  GIPI_QUOTE_AV_ITEM.purpose%TYPE,
	 v_deduct_text			 IN  GIPI_QUOTE_AV_ITEM.deduct_text%TYPE,
	 v_prev_util_hrs		 IN  GIPI_QUOTE_AV_ITEM.prev_util_hrs%TYPE,
	 v_est_util_hrs			 IN  GIPI_QUOTE_AV_ITEM.est_util_hrs%TYPE,
	 v_total_fly_time		 IN  GIPI_QUOTE_AV_ITEM.total_fly_time%TYPE,	 	 	 	 	 
	 v_qualification		 IN  GIPI_QUOTE_AV_ITEM.qualification%TYPE,
	 v_geog_limit			 IN  GIPI_QUOTE_AV_ITEM.geog_limit%TYPE);	

								 
  PROCEDURE del_gipi_quote_av (p_quote_id  GIPI_QUOTE.quote_id%TYPE,
                               p_item_no   GIPI_QUOTE_ITEM.item_no%TYPE);
							   
  FUNCTION get_all_gipi_quote_mh (p_quote_id   GIPI_QUOTE.quote_id%TYPE)
    RETURN gipi_quote_mh_tab PIPELINED;			
    
  TYPE gipi_quote_fi_item_type IS RECORD(
    assignee                    GIPI_QUOTE_FI_ITEM.assignee%TYPE,
    block_id                    GIPI_QUOTE_FI_ITEM.block_id%TYPE,
    risk_cd                     GIPI_QUOTE_FI_ITEM.risk_cd%TYPE,
    tarf_cd                     GIPI_QUOTE_FI_ITEM.tarf_cd%TYPE,
    construction_remarks        GIPI_QUOTE_FI_ITEM.construction_remarks%TYPE,
    front                       GIPI_QUOTE_FI_ITEM.front%TYPE,
    RIGHT                       GIPI_QUOTE_FI_ITEM.RIGHT%TYPE,
    LEFT                        GIPI_QUOTE_FI_ITEM.LEFT%TYPE,
    rear                        GIPI_QUOTE_FI_ITEM.rear%TYPE,
    occupancy_remarks           GIPI_QUOTE_FI_ITEM.occupancy_remarks%TYPE,
    item_no                     GIPI_QUOTE_FI_ITEM.item_no%TYPE,
    user_id                     GIPI_QUOTE_FI_ITEM.user_id%TYPE,
    loc_risk1                   GIPI_QUOTE_FI_ITEM.loc_risk1%TYPE,
    loc_risk2                   GIPI_QUOTE_FI_ITEM.loc_risk2%TYPE,
    loc_risk3                   GIPI_QUOTE_FI_ITEM.loc_risk3%TYPE,
    last_update                 GIPI_QUOTE_FI_ITEM.last_update%TYPE,
    block_no                    GIPI_QUOTE_FI_ITEM.block_no%TYPE,
    district_no                 GIPI_QUOTE_FI_ITEM.district_no%TYPE,
    eq_zone                     GIPI_QUOTE_FI_ITEM.eq_zone%TYPE,
    fr_item_type                GIPI_QUOTE_FI_ITEM.fr_item_type%TYPE,
    typhoon_zone                GIPI_QUOTE_FI_ITEM.typhoon_zone%TYPE,
    flood_zone                  GIPI_QUOTE_FI_ITEM.flood_zone%TYPE,
    construction_cd             GIPI_QUOTE_FI_ITEM.construction_cd%TYPE,
    occupancy_cd                GIPI_QUOTE_FI_ITEM.occupancy_cd%TYPE,
    tariff_zone                 GIPI_QUOTE_FI_ITEM.tariff_zone%TYPE,
    dsp_province                giis_province.province_desc%TYPE,
    dsp_city                    giis_block.city%TYPE,
    dsp_block_no                giis_block.block_desc%TYPE,
    dsp_district_desc           giis_block.district_desc%TYPE,
    dsp_fr_item_type            giis_fi_item_type.fr_itm_tp_ds%TYPE,
    dsp_construction_cd         giis_fire_construction.construction_desc%TYPE,
    dsp_occupancy_cd            giis_fire_occupancy.occupancy_desc%TYPE,
    dsp_risk                    giis_risks.risk_desc%TYPE,
    nbt_from_dt                 gipi_quote_item.date_from%TYPE,
    nbt_to_dt                   gipi_quote_item.date_to%TYPE,
    dsp_tariff_zone             giis_tariff_zone.tariff_zone_desc%TYPE,
    dsp_eq_zone                 giis_eqzone.eq_desc%TYPE,
    dsp_typhoon_zone            giis_typhoon_zone.typhoon_zone_desc%TYPE,
    dsp_flood_zone              giis_flood_zone.flood_zone_desc%TYPE,
    latitude                    GIPI_QUOTE_FI_ITEM.latitude%TYPE,--Added by MarkS 02/08/2017 SR5918
    longitude                   GIPI_QUOTE_FI_ITEM.longitude%TYPE--Added by MarkS 02/08/2017 SR5918
    );            

  TYPE gipi_quote_fi_item_tab IS TABLE OF gipi_quote_fi_item_type;		
  
  FUNCTION get_gipi_quote_fi2 (p_quote_id   gipi_quote_fi_item.quote_id%TYPE,
                               p_item_no    gipi_quote_fi_item.item_no%TYPE)
   RETURN gipi_quote_fi_item_tab PIPELINED;		  
   
   TYPE gipi_quote_mc_item_type IS RECORD(
    quote_id                gipi_quote_item_mc.quote_id%TYPE,
    item_no                 gipi_quote_item_mc.item_no%TYPE,
    assignee                gipi_quote_item_mc.assignee%TYPE,
    acquired_from           gipi_quote_item_mc.acquired_from%TYPE,
    origin                  gipi_quote_item_mc.origin%TYPE,
    destination             gipi_quote_item_mc.destination%TYPE,
    plate_no                gipi_quote_item_mc.plate_no%TYPE,
    model_year              gipi_quote_item_mc.model_year%TYPE,
    mv_file_no              gipi_quote_item_mc.mv_file_no%TYPE,
    no_of_pass              gipi_quote_item_mc.no_of_pass%TYPE,
    basic_color_cd          gipi_quote_item_mc.basic_color_cd%TYPE,
    color                   gipi_quote_item_mc.color%TYPE,
    towing                  gipi_quote_item_mc.towing%TYPE,
    repair_lim              gipi_quote_item_mc.repair_lim%TYPE,
    coc_type                gipi_quote_item_mc.coc_type%TYPE,
    coc_serial_no           gipi_quote_item_mc.coc_serial_no%TYPE,
    coc_yy                  gipi_quote_item_mc.coc_yy%TYPE,
    ctv_tag                 gipi_quote_item_mc.ctv_tag%TYPE,
    type_of_body_cd         gipi_quote_item_mc.type_of_body_cd%TYPE,
    car_company_cd          gipi_quote_item_mc.car_company_cd%TYPE,
    make                    gipi_quote_item_mc.make%TYPE,
    series_cd               gipi_quote_item_mc.series_cd%TYPE,
    mot_type                gipi_quote_item_mc.mot_type%TYPE,
    unladen_wt              gipi_quote_item_mc.unladen_wt%TYPE,
    serial_no               gipi_quote_item_mc.serial_no%TYPE,
    subline_type_cd         gipi_quote_item_mc.subline_type_cd%TYPE,
    motor_no                gipi_quote_item_mc.motor_no%TYPE,
    est_value               gipi_quote_item_mc.est_value%TYPE,
    tariff_zone             gipi_quote_item_mc.tariff_zone%TYPE,
    coc_issue_date          gipi_quote_item_mc.coc_issue_date%TYPE,
    make_cd                 gipi_quote_item_mc.make_cd%TYPE,
    color_cd                gipi_quote_item_mc.color_cd%TYPE,
    coc_atcn                gipi_quote_item_mc.coc_atcn%TYPE,
    coc_seq_no              gipi_quote_item_mc.coc_seq_no%TYPE,
    subline_cd              gipi_quote_item_mc.subline_cd%TYPE,
    dsp_basic_color         giis_mc_color.basic_color%TYPE,
    dsp_deductibles         gipi_quote_deductibles.deductible_amt%TYPE,
    dsp_repair_lim          NUMBER(16,2),
    dsp_type_of_body_cd     giis_type_of_body.type_of_body%TYPE,
    dsp_car_company_cd      giis_mc_car_company.car_company%TYPE,
    dsp_engine_series       giis_mc_eng_series.engine_series%TYPE,
    dsp_mot_type            giis_motortype.motor_type_desc%TYPE,
    dsp_subline_type_cd     giis_mc_subline_type.subline_type_desc%TYPE
    );            

  TYPE gipi_quote_mc_item_tab IS TABLE OF gipi_quote_mc_item_type;		
  
  FUNCTION get_gipi_quote_mc2 (
       p_quote_id   gipi_quote_item_mc.quote_id%TYPE,
       p_item_no    gipi_quote_item_mc.item_no%TYPE
    )
       RETURN gipi_quote_mc_item_tab PIPELINED;	 
       
        FUNCTION get_gipi_quote_mn2 (p_quote_id   GIPI_QUOTE.quote_id%TYPE,
                              p_item_no    GIPI_QUOTE_ITEM.item_no%TYPE )
        RETURN gipi_quote_mn_tab PIPELINED;
							   
END Gipi_Quote_Item_Dtls;
/



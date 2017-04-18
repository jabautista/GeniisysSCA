CREATE OR REPLACE PACKAGE CPI.GIPIS100_EXTRACT_SUMMARY IS

    PROCEDURE populate_summary_tab_a
    (p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
     p_policy_id    OUT  GIPI_POLBASIC.policy_id%TYPE,
     p_extract_id   OUT  NUMBER,
     p_co_sw        OUT  GIPI_POLBASIC.co_insurance_sw%TYPE);
     
     PROCEDURE populate_summary_tab_b
    (p_extract_id   IN  NUMBER,
     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
     p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
     p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE);
     
    PROCEDURE populate_bond 
    (p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE,
	 p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
     p_extract_id   IN   NUMBER);
     
     PROCEDURE populate_invoice (p_extract_id   IN   NUMBER,
                                 p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE);
                            
     PROCEDURE populate_prem_collns (p_extract_id  IN NUMBER,
                                     p_iss_cd      IN GIPI_INVOICE.iss_cd%TYPE,
                                     p_prem_seq_no IN GIPI_INVOICE.prem_seq_no%TYPE);
                                     
     PROCEDURE populate_claims (p_extract_id   IN   NUMBER,
                                p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE);
                                
     PROCEDURE populate_pictures (p_extract_id   IN   NUMBER,
                                  p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE);
     
     PROCEDURE populate_deductibles (p_extract_id   IN   NUMBER,
                                     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                     p_item_no      IN   GIPI_ITEM.item_no%TYPE);
                                     
     PROCEDURE populate_mortgagee (p_extract_id IN NUMBER,
                                   p_policy_id  IN   GIPI_POLBASIC.policy_id%TYPE);
                                   
     PROCEDURE populate_group_items (p_extract_id   IN   NUMBER,
                                     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                     p_item_no      IN   GIPI_ITEM.item_no%TYPE,
                                     p_grouped_items_flag OUT VARCHAR2);
                                     
     PROCEDURE populate_beneficiary (p_extract_id   IN   NUMBER,
                                     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                     p_item_no      IN   GIPI_ITEM.item_no%TYPE);
                                     
     PROCEDURE populate_group_beneficiary (p_extract_id      IN   NUMBER,
                                           p_policy_id       IN   GIPI_POLBASIC.policy_id%TYPE,
                                           p_item_no         IN   GIPI_ITEM.item_no%TYPE,
                                           p_grouped_item_no IN   GIXX_GROUPED_ITEMS.grouped_item_no%TYPE);
                                           
     PROCEDURE populate_accessory (p_extract_id   IN   NUMBER,
                                   p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                                   p_item_no      IN   GIPI_ITEM.item_no%TYPE);
                                   
     PROCEDURE populate_engg (p_extract_id   IN   NUMBER,
                              p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                              p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
                              p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
                              p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
                              p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
                              p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
                              p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
                              
     PROCEDURE populate_wc (p_extract_id   IN   NUMBER,
                            p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
                            p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
                            p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
                            p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
                            p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
                            p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
                            p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
                                           
     PROCEDURE populate_personnel 
        ( p_extract_id   IN   NUMBER,
          p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
          p_item_no      IN   GIPI_ITEM.item_no%TYPE,
          p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
          p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
          p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
          p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
          p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
          p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
     
     PROCEDURE populate_add_item (
      p_extract_id            IN   NUMBER,
      p_policy_id             IN   GIPI_POLBASIC.policy_id%TYPE,
      p_item_no               IN   GIPI_ITEM.item_no%TYPE,
      p_subline               IN   GIPI_POLBASIC.subline_cd%TYPE,
      p_iss_cd                IN   GIPI_POLBASIC.iss_cd%TYPE,
      p_issue_yy              IN   GIPI_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no            IN   GIPI_POLBASIC.pol_seq_no%TYPE,
      p_renew_no              IN   GIPI_POLBASIC.renew_no%TYPE, 
      p_line_cd               IN OUT  GIPI_POLBASIC.line_cd%TYPE,
      p_vessel_cd             IN OUT  GIPI_CARGO.vessel_cd%TYPE,
      p_geog_cd               IN OUT  GIPI_CARGO.geog_cd%TYPE,
      p_cargo_class_cd        IN OUT  GIPI_CARGO.cargo_class_cd%TYPE,
      p_bl_awb                IN OUT  GIPI_CARGO.bl_awb%TYPE,
      p_origin                IN OUT  GIPI_CARGO.origin%TYPE, 
      p_destn                 IN OUT  GIPI_CARGO.destn%TYPE,
      p_etd                   IN OUT  GIPI_CARGO.etd%TYPE,  
      p_eta                   IN OUT  GIPI_CARGO.eta%TYPE,
      p_cargo_type            IN OUT  GIPI_CARGO.cargo_type%TYPE,
      p_deduct_text           IN OUT  GIPI_CARGO.deduct_text%TYPE,
      p_pack_method           IN OUT  GIPI_CARGO.pack_method%TYPE, 
      p_tranship_origin       IN OUT  GIPI_CARGO.tranship_origin%TYPE,
      p_tranship_destination  IN OUT  GIPI_CARGO.tranship_destination%TYPE,
      p_print_tag             IN OUT  GIPI_CARGO.print_tag%TYPE,
      p_voyage_no             IN OUT  GIPI_CARGO.voyage_no%TYPE,
      p_lc_no                 IN OUT  GIPI_CARGO.lc_no%TYPE,
      v_cargo_flag            IN OUT  VARCHAR2,
      v_multi_sw              IN OUT  VARCHAR2,

      p_district_no           IN OUT  GIPI_FIREITEM.district_no%TYPE, 
      p_eq_zone               IN OUT  GIPI_FIREITEM.eq_zone%TYPE,       
      p_tarf_cd               IN OUT  GIPI_FIREITEM.tarf_cd%TYPE,            
      p_block_no              IN OUT  GIPI_FIREITEM.block_no%TYPE,                    
      p_fr_item_type          IN OUT  GIPI_FIREITEM.fr_item_type%TYPE,                     
      p_loc_risk1             IN OUT  GIPI_FIREITEM.loc_risk1%TYPE,               
      p_loc_risk2             IN OUT  GIPI_FIREITEM.loc_risk2%TYPE,                    
      p_loc_risk3             IN OUT  GIPI_FIREITEM.loc_risk3%TYPE,                        
      p_tariff_zone           IN OUT  GIPI_FIREITEM.tariff_zone%TYPE,                         
      p_typhoon_zone          IN OUT  GIPI_FIREITEM.typhoon_zone%TYPE,                         
      p_flood_zone            IN OUT  GIPI_FIREITEM.flood_zone%TYPE,               
      p_front                 IN OUT  GIPI_FIREITEM.front%TYPE,                                                        
      p_right                 IN OUT  GIPI_FIREITEM.right%TYPE,                
      p_left                  IN OUT  GIPI_FIREITEM.left%TYPE,                 
      p_rear                  IN OUT  GIPI_FIREITEM.rear%TYPE,             
      p_construction_cd       IN OUT  GIPI_FIREITEM.construction_cd%TYPE,                
      p_construction_remarks  IN OUT  GIPI_FIREITEM.construction_remarks%TYPE,                  
      p_occupancy_cd          IN OUT  GIPI_FIREITEM.occupancy_cd%TYPE,                  
      p_occupancy_remarks     IN OUT  GIPI_FIREITEM.occupancy_remarks%TYPE,
      p_fi_assignee           IN OUT  GIPI_FIREITEM.assignee%TYPE,         
      p_block_id              IN OUT  GIPI_FIREITEM.block_id%TYPE,
      p_latitude              IN OUT  GIPI_FIREITEM.latitude%TYPE,  --benjo 01.10.2017 SR-5749
      p_longitude             IN OUT  GIPI_FIREITEM.longitude%TYPE, --benjo 01.10.2017 SR-5749
      v_fireitem_flag         IN OUT  VARCHAR2,                         

      p_subline_cd            IN OUT  GIPI_VEHICLE.subline_cd%TYPE,  
      p_coc_yy                IN OUT  GIPI_VEHICLE.coc_yy%TYPE,
      p_coc_seq_no            IN OUT  GIPI_VEHICLE.coc_seq_no%TYPE,
      p_coc_serial_no         IN OUT  GIPI_VEHICLE.coc_serial_no%TYPE,   
      p_coc_type              IN OUT  GIPI_VEHICLE.coc_type%TYPE,
      p_repair_lim            IN OUT  GIPI_VEHICLE.repair_lim%TYPE,
      p_color                 IN OUT  GIPI_VEHICLE.color%TYPE,
      p_motor_no              IN OUT  GIPI_VEHICLE.motor_no%TYPE,
      p_model_year            IN OUT  GIPI_VEHICLE.model_year%TYPE,
      p_make                  IN OUT  GIPI_VEHICLE.make%TYPE,
      p_mot_type              IN OUT  GIPI_VEHICLE.mot_type%TYPE,
      p_est_value             IN OUT  GIPI_VEHICLE.est_value%TYPE,
      p_serial_no             IN OUT  GIPI_VEHICLE.serial_no%TYPE,
      p_towing                IN OUT  GIPI_VEHICLE.towing%TYPE,  
      p_assignee              IN OUT  GIPI_VEHICLE.assignee%TYPE,
      p_plate_no              IN OUT  GIPI_VEHICLE.plate_no%TYPE,
      p_subline_type_cd       IN OUT  GIPI_VEHICLE.subline_type_cd%TYPE,
      p_no_of_pass            IN OUT  GIPI_VEHICLE.no_of_pass%TYPE,
      p_tariff_zone1          IN OUT  GIPI_VEHICLE.tariff_zone%TYPE, 
      p_coc_issue_date        IN OUT  GIPI_VEHICLE.coc_issue_date%TYPE, 
      p_mv_file_no            IN OUT  GIPI_VEHICLE.mv_file_no%TYPE,   
      p_acquired_from         IN OUT  GIPI_VEHICLE.acquired_from%TYPE,   
      p_type_of_body_cd       IN OUT  GIPI_VEHICLE.type_of_body_cd%TYPE, 
      p_car_company_cd        IN OUT  GIPI_VEHICLE.car_company_cd%TYPE, 
      p_color_cd              IN OUT  GIPI_VEHICLE.color_cd%TYPE,
      p_basic_color_cd        IN OUT  GIPI_VEHICLE.basic_color_cd%TYPE,
      p_unladen_wt            IN OUT  GIPI_VEHICLE.unladen_wt%TYPE,
      v_vehicle_flag          IN OUT  VARCHAR2,
       
      p_date_of_birth         IN OUT  GIPI_ACCIDENT_ITEM.date_of_birth%TYPE,
      p_age                   IN OUT  GIPI_ACCIDENT_ITEM.age%TYPE,   
      p_civil_status          IN OUT  GIPI_ACCIDENT_ITEM.civil_status%TYPE,
      p_position_cd           IN OUT  GIPI_ACCIDENT_ITEM.position_cd%TYPE,
      p_monthly_salary        IN OUT  GIPI_ACCIDENT_ITEM.monthly_salary%TYPE,
      p_salary_grade          IN OUT  GIPI_ACCIDENT_ITEM.salary_grade%TYPE,
      p_no_of_persons         IN OUT  GIPI_ACCIDENT_ITEM.no_of_persons%TYPE,
      p_destination           IN OUT  GIPI_ACCIDENT_ITEM.destination%TYPE,
      p_height                IN OUT  GIPI_ACCIDENT_ITEM.height%TYPE,
      p_weight                IN OUT  GIPI_ACCIDENT_ITEM.weight%TYPE,
      p_sex                   IN OUT  GIPI_ACCIDENT_ITEM.sex%TYPE, 
      p_ac_class_cd           IN OUT  GIPI_ACCIDENT_ITEM.ac_class_cd%TYPE,
      p_grouped_items_flag    IN OUT  VARCHAR2,
      v_accident_item_flag    IN OUT  VARCHAR2,   

      p_vessel_cd1            IN OUT  GIPI_AVIATION_ITEM.vessel_cd%TYPE,
      p_total_fly_time        IN OUT  GIPI_AVIATION_ITEM.total_fly_time%TYPE,
      p_qualification         IN OUT  GIPI_AVIATION_ITEM.qualification%TYPE,
      p_purpose               IN OUT  GIPI_AVIATION_ITEM.purpose%TYPE,
      p_geog_limit            IN OUT  GIPI_AVIATION_ITEM.geog_limit%TYPE, 
      p_deduct_text1          IN OUT  GIPI_AVIATION_ITEM.deduct_text%TYPE,
      p_fixed_wing            IN OUT  GIPI_AVIATION_ITEM.fixed_wing%TYPE,
      p_rotor                 IN OUT  GIPI_AVIATION_ITEM.rotor%TYPE, 
      p_prev_util_hrs         IN OUT  GIPI_AVIATION_ITEM.prev_util_hrs%TYPE,
      p_est_util_hrs          IN OUT  GIPI_AVIATION_ITEM.est_util_hrs%TYPE,
      v_aviation_item_flag    IN OUT  VARCHAR2,
                               
      p_section_line_cd       IN OUT  GIPI_CASUALTY_ITEM.section_line_cd%TYPE,
      p_section_subline_cd    IN OUT  GIPI_CASUALTY_ITEM.section_subline_cd%TYPE,
      p_capacity_cd           IN OUT  GIPI_CASUALTY_ITEM.capacity_cd%TYPE,
      p_section_or_hazard_cd  IN OUT  GIPI_CASUALTY_ITEM.section_or_hazard_cd%TYPE,
      p_property_no           IN OUT  GIPI_CASUALTY_ITEM.property_no%TYPE,
      p_property_no_type      IN OUT  GIPI_CASUALTY_ITEM.property_no_type%TYPE,
      p_location              IN OUT  GIPI_CASUALTY_ITEM.location%TYPE,
      p_conveyance_info       IN OUT  GIPI_CASUALTY_ITEM.conveyance_info%TYPE,
      p_limit_of_liability    IN OUT  GIPI_CASUALTY_ITEM.limit_of_liability%TYPE,
      p_interest_on_premises  IN OUT  GIPI_CASUALTY_ITEM.interest_on_premises%TYPE,
      p_section_or_hazard_info  IN OUT  GIPI_CASUALTY_ITEM.section_or_hazard_info%TYPE,
      p_ca_grouped_items_flag   IN OUT  VARCHAR2,
      v_casualty_item_flag      IN OUT  VARCHAR2,
                              
      p_vessel_cd2          IN OUT  GIPI_ITEM_VES.vessel_cd%TYPE,
      p_geog_limit2         IN OUT  GIPI_ITEM_VES.geog_limit%TYPE,   
      p_deduct_text2        IN OUT  GIPI_ITEM_VES.deduct_text%TYPE,
      p_dry_date            IN OUT  GIPI_ITEM_VES.dry_date%TYPE,
      p_dry_place           IN OUT  GIPI_ITEM_VES.dry_place%TYPE,
      v_item_ves_flag       IN OUT  VARCHAR2);
      
     PROCEDURE populate_item 
     (p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
      p_subline_cd    IN   GIPI_POLBASIC.subline_cd%TYPE,
      p_iss_cd        IN   GIPI_POLBASIC.iss_cd%TYPE,
      p_issue_yy      IN   GIPI_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no    IN   GIPI_POLBASIC.pol_seq_no%TYPE,
      p_renew_no      IN   GIPI_POLBASIC.renew_no%TYPE,
      p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
      p_extract_id    IN   NUMBER,
      p_param_line_cd OUT  GIPI_POLBASIC.line_cd%TYPE);
     
     PROCEDURE populate_open_liab 
      (p_extract_id   IN   NUMBER,
       p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
       p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
       p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
       p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
       p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
       p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
       p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
       
     PROCEDURE populate_open_peril     
     (p_extract_id   IN   NUMBER,
      p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
      p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
      p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
      p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
      p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
      p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
         
     PROCEDURE populate_cargo_carrier
     (p_extract_id   IN   NUMBER,
      p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
      p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
      p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
      p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
      p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
      p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
      p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
      
     PROCEDURE populate_bank_schedule 
    (p_extract_id   IN   NUMBER,
     p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
     p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
     
     PROCEDURE populate_co_peril 
    (p_extract_id   IN   NUMBER,
     p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
     
     PROCEDURE populate_co_ins 
    (p_extract_id   IN   NUMBER,
     p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE,
     p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
     
     PROCEDURE populate_main 
    (p_extract_id   IN   NUMBER,
     p_co_sw        IN   GIPI_POLBASIC.co_insurance_sw%TYPE,
     p_line_cd      IN   GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd   IN   GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd       IN   GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy     IN   GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no   IN   GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no     IN   GIPI_POLBASIC.renew_no%TYPE);
     --added by robert SR 20307 10.27.15
	 PROCEDURE populate_principal (
       p_extract_id   IN   NUMBER,
       p_policy_id    IN   gipi_polbasic.policy_id%TYPE,
       p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
       p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
       p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
       p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no     IN   gipi_polbasic.renew_no%TYPE
    );
	 
END;
/



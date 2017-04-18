CREATE OR REPLACE PACKAGE CPI.gipi_vehicle_pkg
AS
   FUNCTION get_mot_type (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   ) 
      RETURN VARCHAR2;

   FUNCTION get_subline_type_cd (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_mc_tariff_zone (
      p_par_id    gipi_parlist.par_id%TYPE,
      p_item_no   gipi_witem.item_no%TYPE
   )
      RETURN VARCHAR2;

   TYPE gipi_vehicle_rep_type IS RECORD (    --Created by: Alfred  03/10/2011
      policy_id         gipi_vehicle.policy_id%TYPE,
      item_no           gipi_vehicle.item_no%TYPE,
      model_year        gipi_vehicle.model_year%TYPE,
      make              VARCHAR2 (200),
      type_of_body      giis_type_of_body.type_of_body%TYPE,
      motor_type_desc   giis_motortype.motor_type_desc%TYPE,
      unladen_wt        giis_motortype.unladen_wt%TYPE,
      color             gipi_vehicle.color%TYPE,
      coc_seq_no1       VARCHAR2 (200),
      plate_no          gipi_vehicle.plate_no%TYPE,
      serial_no         gipi_vehicle.serial_no%TYPE,
      motor_no          gipi_vehicle.motor_no%TYPE,
      assignee          gipi_vehicle.assignee%TYPE,
      no_of_pass        gipi_vehicle.no_of_pass%TYPE,
      coc_serial_no     gipi_vehicle.coc_serial_no%TYPE,
      blt_no            gipi_vehicle.mv_file_no%TYPE,
      coc_atcn          gipi_vehicle.coc_atcn%TYPE,
      assignee2         gipi_vehicle.assignee%TYPE,
      model_year2       gipi_vehicle.model_year%TYPE,
      make2             VARCHAR2 (200),
      type_of_body2     giis_type_of_body.type_of_body%TYPE,
      color2            gipi_vehicle.color%TYPE,
      plate_no2         gipi_vehicle.plate_no%TYPE,
      serial_no2        gipi_vehicle.serial_no%TYPE,
      motor_no2         gipi_vehicle.motor_no%TYPE,
      no_of_pass2       gipi_vehicle.no_of_pass%TYPE,
      unladen_wt2       giis_motortype.unladen_wt%TYPE
   );

   TYPE gipi_vehicle_rep_tab IS TABLE OF gipi_vehicle_rep_type;

   TYPE gipi_vehicle_coc_type IS RECORD (
      policy_id         gipi_vehicle.policy_id%TYPE,
      policy_no         VARCHAR2 (50),
      vehicle_model     VARCHAR2 (60),
      serial_no         gipi_vehicle.serial_no%TYPE,
      motor_no          gipi_vehicle.motor_no%TYPE,
      plate_no          gipi_vehicle.plate_no%TYPE,
      item_title        VARCHAR(500),--gipi_item.item_title%TYPE,   --modified by jeffdojello 05.19.2014 SR-15828
      item_desc         gipi_item.item_desc%TYPE,
      item_no           gipi_item.item_no%TYPE,
      car               VARCHAR2 (105),
      coc_type          gipi_vehicle.coc_type%TYPE,
      coc_yy            gipi_vehicle.coc_yy%TYPE,
      coc_serial_no     gipi_vehicle.coc_serial_no%TYPE,
      coc_atcn          gipi_vehicle.coc_atcn%TYPE,
      compulsory_flag   VARCHAR2 (5)
   );

   TYPE gipi_vehicle_coc_tab IS TABLE OF gipi_vehicle_coc_type;

   FUNCTION get_gipi_vehicle_rep (p_policy_id gipi_vehicle.policy_id%TYPE)
      --Created by Alfred  03/10/2011
   RETURN gipi_vehicle_rep_tab PIPELINED;

   TYPE motor_cars_type IS RECORD (
      coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      model_year      gipi_vehicle.model_year%TYPE,
      serial_no       gipi_vehicle.serial_no%TYPE,
      policy_id       gipi_vehicle.policy_id%TYPE,
      motor_no        gipi_vehicle.motor_no%TYPE,
      plate_no        gipi_vehicle.plate_no%TYPE,
      coc_type        gipi_vehicle.coc_type%TYPE,
      item_no         gipi_vehicle.item_no%TYPE,
      coc_yy          gipi_vehicle.coc_yy%TYPE,
      iss_cd          gipi_polbasic.iss_cd%TYPE,
      line_cd         gipi_polbasic.line_cd%TYPE,
      issue_yy        gipi_polbasic.issue_yy%TYPE,
      renew_no        gipi_polbasic.renew_no%TYPE,
      pol_flag        gipi_polbasic.pol_flag%TYPE,
      pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      subline_cd      gipi_polbasic.subline_cd%TYPE,
      policy_no       VARCHAR2 (50),
      status          VARCHAR2 (50),
      has_attachment  VARCHAR2 (1) --added by apollo cruz 07.11.2014      
   );

   TYPE motor_cars_tab IS TABLE OF motor_cars_type;

   FUNCTION get_motor_cars
      RETURN motor_cars_tab PIPELINED;

   TYPE gipi_vehicle_par_type IS RECORD (
      policy_id         gipi_vehicle.policy_id%TYPE,
      item_no           gipi_vehicle.item_no%TYPE,
      subline_cd        gipi_vehicle.subline_cd%TYPE,
      motor_no          gipi_vehicle.motor_no%TYPE,
      plate_no          gipi_vehicle.plate_no%TYPE,
      est_value         gipi_vehicle.est_value%TYPE,
      make              gipi_vehicle.make%TYPE,
      mot_type          gipi_vehicle.mot_type%TYPE,
      color             gipi_vehicle.color%TYPE,
      repair_lim        gipi_vehicle.repair_lim%TYPE,
      serial_no         gipi_vehicle.serial_no%TYPE,
      coc_seq_no        gipi_vehicle.coc_seq_no%TYPE,
      coc_serial_no     gipi_vehicle.coc_serial_no%TYPE,
      coc_type          gipi_vehicle.coc_type%TYPE,
      assignee          gipi_vehicle.assignee%TYPE,
      model_year        gipi_vehicle.model_year%TYPE,
      coc_issue_date    gipi_vehicle.coc_issue_date%TYPE,
      coc_yy            gipi_vehicle.coc_yy%TYPE,
      towing            gipi_vehicle.towing%TYPE,
      subline_type_cd   gipi_vehicle.subline_type_cd%TYPE,
      no_of_pass        gipi_vehicle.no_of_pass%TYPE,
      tariff_zone       gipi_vehicle.tariff_zone%TYPE,
      mv_file_no        gipi_vehicle.mv_file_no%TYPE,
      acquired_from     gipi_vehicle.acquired_from%TYPE,
      ctv_tag           gipi_vehicle.ctv_tag%TYPE,
      car_company_cd    gipi_vehicle.car_company_cd%TYPE,
      type_of_body_cd   gipi_vehicle.type_of_body_cd%TYPE,
      unladen_wt        gipi_vehicle.unladen_wt%TYPE,
      make_cd           gipi_vehicle.make_cd%TYPE,
      series_cd         gipi_vehicle.series_cd%TYPE,
      basic_color_cd    gipi_vehicle.basic_color_cd%TYPE,
      basic_color       giis_mc_color.basic_color%TYPE,
      color_cd          gipi_vehicle.color_cd%TYPE,
      origin            gipi_vehicle.origin%TYPE,
      destination       gipi_vehicle.destination%TYPE,
      coc_atcn          gipi_vehicle.coc_atcn%TYPE,
      motor_coverage    gipi_vehicle.motor_coverage%TYPE,
      coc_serial_sw     gipi_vehicle.coc_serial_sw%TYPE,
      car_company       giis_mc_car_company.car_company%TYPE,
      engine_series     giis_mc_eng_series.engine_series%TYPE,
	  --additional columns added by Nica 10.19.2012 - needed for COC authentication
	  reg_type			gipi_vehicle.reg_type%TYPE,
	  mv_type			gipi_vehicle.mv_type%TYPE,
	  mv_prem_type		gipi_vehicle.mv_prem_type%TYPE,
	  tax_type			gipi_vehicle.tax_type%TYPE
   );

   TYPE gipi_vehicle_tab_all_cols IS TABLE OF gipi_vehicle_par_type;

   FUNCTION get_gipi_vehicle (
      p_policy_id   IN   gipi_vehicle.policy_id%TYPE,
      p_item_no     IN   gipi_vehicle.item_no%TYPE
   )
      RETURN gipi_vehicle_tab_all_cols PIPELINED;

   TYPE vehicle_info_type IS RECORD (
      policy_id           gipi_vehicle.policy_id%TYPE,
      item_no             gipi_vehicle.item_no%TYPE,
      assignee            gipi_vehicle.assignee%TYPE,
      origin              gipi_vehicle.origin%TYPE,
      coc_yy              gipi_vehicle.coc_yy%TYPE,
      make                gipi_vehicle.make%TYPE,
      color               gipi_vehicle.color%TYPE,
      towing              gipi_vehicle.towing%TYPE,
      plate_no            gipi_vehicle.plate_no%TYPE,
      serial_no           gipi_vehicle.serial_no%TYPE,
      motor_no            gipi_vehicle.motor_no%TYPE,
      make_cd             gipi_vehicle.make_cd%TYPE,
      est_value           gipi_vehicle.est_value%TYPE,
      mv_file_no          gipi_vehicle.mv_file_no%TYPE,
      no_of_pass          gipi_vehicle.no_of_pass%TYPE,
      series_cd           gipi_vehicle.series_cd%TYPE,
      coc_atcn            gipi_vehicle.coc_atcn%TYPE,
      color_cd            gipi_vehicle.color_cd%TYPE,
      coc_type            gipi_vehicle.coc_type%TYPE,
      mot_type            gipi_vehicle.mot_type%TYPE,
      subline_cd          gipi_vehicle.subline_cd%TYPE,
      model_year          gipi_vehicle.model_year%TYPE,
      repair_lim          gipi_vehicle.repair_lim%TYPE,
      unladen_wt          gipi_vehicle.unladen_wt%TYPE,
      coc_serial_no       gipi_vehicle.coc_serial_no%TYPE,
      basic_color_cd      gipi_vehicle.basic_color_cd%TYPE,
      subline_type_cd     gipi_vehicle.subline_type_cd%TYPE,
      car_company_cd      gipi_vehicle.car_company_cd%TYPE,
      acquired_from       gipi_vehicle.acquired_from%TYPE,
      destination         gipi_vehicle.destination%TYPE,
      item_title          gipi_item.item_title%TYPE,
      motor_coverage      cg_ref_codes.rv_meaning%TYPE,
      basic_color         giis_mc_color.basic_color%TYPE,
      type_desc           giis_motortype.motor_type_desc%TYPE,
      type_of_body        giis_type_of_body.type_of_body%TYPE,
      deductible          gipi_deductibles.deductible_amt%TYPE,
      car_company         giis_mc_car_company.car_company%TYPE,
      engine_series       giis_mc_eng_series.engine_series%TYPE,
      subline_type_desc   giis_mc_subline_type.subline_type_desc%TYPE
   );

   TYPE vehicle_info_tab IS TABLE OF vehicle_info_type;

   FUNCTION get_vehicle_info (
      p_policy_id   gipi_vehicle.policy_id%TYPE,
      p_item_no     gipi_vehicle.item_no%TYPE
   )
      RETURN vehicle_info_tab PIPELINED;

   FUNCTION get_motor_coverage (p_policy_id gipi_vehicle.policy_id%TYPE)
      RETURN gipi_vehicle_coc_tab PIPELINED;

   FUNCTION get_motor_coverage2 (p_policy_id gipi_vehicle.policy_id%TYPE, 
                                 p_pack_pol_flag gipi_polbasic.pack_pol_flag%TYPE)
      RETURN gipi_vehicle_coc_tab PIPELINED;

   PROCEDURE set_gipi_vehicle_gipis091 (
      p_policy_id       gipi_vehicle.policy_id%TYPE,
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_coc_yy          gipi_vehicle.coc_yy%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_atcn        gipi_vehicle.coc_atcn%TYPE
   );

   FUNCTION check_existing_coc_serial (
      p_policy_id       gipi_vehicle.policy_id%TYPE,
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_type        gipi_vehicle.coc_type%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_gipi_vehicle_rep2 (
      p_policy_id   gipi_vehicle.policy_id%TYPE
   )
      RETURN gipi_vehicle_rep_tab PIPELINED;

   TYPE gipi_vehicle_gicl010_type IS RECORD (
      plate_no       gipi_vehicle.plate_no%TYPE,
      assured_name   giis_assured.assd_name%TYPE
   );

   TYPE gipi_vehicle_gicl010_tab IS TABLE OF gipi_vehicle_gicl010_type;

   FUNCTION get_plate_lov_gicl010
      RETURN gipi_vehicle_gicl010_tab PIPELINED;
      
   TYPE gipi_vehicle_motor_type IS RECORD (
      motor_no       gipi_vehicle.motor_no%TYPE,
      assured_name   giis_assured.assd_name%TYPE
   );   
   
   TYPE gipi_vehicle_motor_tab IS TABLE OF gipi_vehicle_motor_type;
   
   FUNCTION get_motor_lov_gicl010 
      RETURN gipi_vehicle_motor_tab PIPELINED;
      
   TYPE gipi_vehicle_serial_type IS RECORD (
      serial_no       gipi_vehicle.serial_no%TYPE,
      assured_name   giis_assured.assd_name%TYPE
   );     
   
   TYPE gipi_vehicle_serial_tab IS TABLE OF gipi_vehicle_serial_type;   
   
   FUNCTION get_serial_lov_gicl010 
      RETURN gipi_vehicle_serial_tab PIPELINED;   
      
    FUNCTION get_valid_plate_nos(
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_pol_iss_cd       GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE
        )  
    RETURN motor_cars_tab PIPELINED;
    
   TYPE motcar_item_type IS RECORD (
      item_no               gipi_vehicle.item_no%TYPE,
      item_title            gipi_item.item_title%TYPE,
      model_year            gipi_vehicle.model_year%TYPE,
      car_company_cd        giis_mc_car_company.car_company_cd%TYPE,
      car_company           giis_mc_car_company.car_company%TYPE,
      make_cd               giis_mc_make.make_cd%TYPE,
      make                  giis_mc_make.make%TYPE,
      motor_no              gipi_vehicle.motor_no%TYPE,
      serial_no             gipi_vehicle.serial_no%TYPE,
      plate_no              gipi_vehicle.plate_no%TYPE,
      basic_color_cd        giis_mc_color.basic_color_cd%TYPE,
      basic_color           giis_mc_color.basic_color%TYPE,
      color_cd              giis_mc_color.color_cd%TYPE,
      color                 giis_mc_color.color%TYPE
   );   
   
   TYPE motcar_item_tab IS TABLE OF motcar_item_type;
   
   FUNCTION get_motcar_item_gicls026( 
        p_line_cd          GIPI_POLBASIC.line_cd%TYPE,  
        p_subline_cd       GIPI_POLBASIC.subline_cd%TYPE,
        p_iss_cd           GIPI_POLBASIC.iss_cd%TYPE,
        p_issue_yy         GIPI_POLBASIC.issue_yy%TYPE,
        p_pol_seq_no       GIPI_POLBASIC.pol_seq_no%TYPE,
        p_renew_no         GIPI_POLBASIC.renew_no%TYPE,
        p_item_no          GIPI_ITEM.item_no%TYPE
   )
   RETURN motcar_item_tab PIPELINED;
   
   TYPE ctpl_policy_listing_type IS RECORD(
      policy_id            GIPI_VEHICLE.policy_id%TYPE,
      item_no              GIPI_VEHICLE.item_no%TYPE,
      plate_no             GIPI_VEHICLE.plate_no%TYPE,
      serial_no            GIPI_VEHICLE.serial_no%TYPE,
      policy_no            VARCHAR2(50),
      assd_name            GIIS_ASSURED.assd_name%TYPE,
      incept_date          VARCHAR2(20),
      dsp_plate_no         GIPI_VEHICLE.plate_no%TYPE,
      dsp_serial_no        GIPI_VEHICLE.serial_no%TYPE,
      dsp_co_make          VARCHAR2(125),
      ctpl_premium         GIPI_ITMPERIL.prem_amt%TYPE,
      reinsurer            GIIS_REINSURER.ri_name%TYPE,
      cred_branch          GIPI_POLBASIC.cred_branch%TYPE
   );
   TYPE ctpl_policy_listing_tab IS TABLE OF ctpl_policy_listing_type;
   
   FUNCTION get_ctpl_policy_listing(
      p_cred_branch        GIPI_POLBASIC.cred_branch%TYPE,
      p_as_of_date         VARCHAR2,
      p_from_date          VARCHAR2,
      p_to_date            VARCHAR2,
      p_plate_ending       VARCHAR2,
      p_date_basis         VARCHAR2,
      p_date_range         VARCHAR2,
      p_reinsurance        VARCHAR2,
      p_module_id          GIIS_MODULES.module_id%TYPE,
      p_user_id            GIIS_USERS.user_id%TYPE
   )
     RETURN ctpl_policy_listing_tab PIPELINED;
          
END gipi_vehicle_pkg;
/



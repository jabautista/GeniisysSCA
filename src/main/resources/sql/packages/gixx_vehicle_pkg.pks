CREATE OR REPLACE PACKAGE CPI.GIXX_VEHICLE_PKG AS

    TYPE pol_doc_vehicle_type IS RECORD(
        extract_id                     GIXX_VEHICLE.extract_id%TYPE,
        vehicle_item_no                 GIXX_VEHICLE.item_no%TYPE,
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
        vehicle_car_company_cd          GIXX_VEHICLE.car_company_cd%TYPE
        );    
    
    TYPE pol_doc_vehicle_tab IS TABLE OF pol_doc_vehicle_type;
    
    FUNCTION get_pol_doc_vehicle (p_extract_id GIXX_VEHICLE.extract_id%TYPE)
      RETURN pol_doc_vehicle_tab PIPELINED;
      
      
    -- added by Kris 03.08.2013 for GIPIS101
    TYPE gixx_vehicle_type IS RECORD (
        extract_id              gixx_vehicle.extract_id%TYPE,
        item_no                 gixx_vehicle.item_no%TYPE,
        assignee                gixx_vehicle.assignee%TYPE,
        coc_type                gixx_vehicle.coc_type%TYPE,
        coc_serial_no           gixx_vehicle.coc_serial_no%TYPE,
        coc_yy                  gixx_vehicle.coc_yy%TYPE,
        acquired_from           gixx_vehicle.acquired_from%TYPE,
        type_of_body_cd         gixx_vehicle.type_of_body_cd%TYPE,
        plate_no                gixx_vehicle.plate_no%TYPE,
        model_year              gixx_vehicle.model_year%TYPE,
        car_company_cd          gixx_vehicle.car_company_cd%TYPE,
        mv_file_no              gixx_vehicle.mv_file_no%TYPE,
        no_of_pass              gixx_vehicle.no_of_pass%TYPE,
        make                    gixx_vehicle.make%TYPE,
        basic_color_cd          gixx_vehicle.basic_color_cd%TYPE,
        color_cd                gixx_vehicle.color_cd%TYPE,
        color                   gixx_vehicle.color%TYPE,
        series_cd               gixx_vehicle.series_cd%TYPE,
        make_cd                 gixx_vehicle.make_cd%TYPE,
        towing                  gixx_vehicle.towing%TYPE,
        mot_type                gixx_vehicle.mot_type%TYPE,
        unladen_wt              gixx_vehicle.unladen_wt%TYPE,
        serial_no               gixx_vehicle.serial_no%TYPE,
        subline_cd              gixx_vehicle.subline_cd%TYPE,
        subline_type_cd         gixx_vehicle.subline_type_cd%TYPE,
        repair_lim              gixx_vehicle.repair_lim%TYPE,
        motor_no                gixx_vehicle.motor_no%TYPE,        
        
        engine_series           giis_mc_eng_series.engine_series%TYPE,
        car_company             giis_mc_car_company.car_company%TYPE,
        type_of_body            giis_type_of_body.type_of_body%TYPE,
        motor_type_desc         giis_motortype.motor_type_desc%TYPE,
        deductible              gixx_deductibles.deductible_amt%TYPE,
        subline_type_desc       giis_mc_subline_type.subline_type_desc%TYPE,
        basic_color             giis_mc_color.basic_color%TYPE
    );
    
    TYPE gixx_vehicle_tab IS TABLE OF gixx_vehicle_type;
    
    FUNCTION get_vehicle_info(
        p_extract_id    gixx_vehicle.extract_id%TYPE,
        p_item_no       gixx_vehicle.item_no%TYPE,
        p_policy_id     gipi_polbasic.policy_id%TYPE
    ) RETURN gixx_vehicle_tab PIPELINED;
    -- 03.08.2013 for GIPIS101
    
    
END GIXX_VEHICLE_PKG;
/



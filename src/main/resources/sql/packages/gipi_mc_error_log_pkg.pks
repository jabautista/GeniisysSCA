CREATE OR REPLACE PACKAGE CPI.Gipi_MC_Error_Log_Pkg AS       
  
  TYPE gipi_mc_error_log_tab IS TABLE OF gipi_mc_error_log%ROWTYPE;
  
  FUNCTION get_gipi_mc_error_log_list(p_filename      GIPI_MC_ERROR_LOG.filename%TYPE) 
    RETURN gipi_mc_error_log_tab PIPELINED;
    
  PROCEDURE set_gipi_mc_error_log (
    p_upload_no           GIPI_MC_ERROR_LOG.upload_no%TYPE,
    p_filename            GIPI_MC_ERROR_LOG.filename%TYPE,
    p_item_no             GIPI_MC_ERROR_LOG.item_no%TYPE,
    p_item_title          GIPI_MC_ERROR_LOG.item_title%TYPE,
    p_item_desc           GIPI_MC_ERROR_LOG.item_desc%TYPE,
    p_item_desc2          GIPI_MC_ERROR_LOG.item_desc2%TYPE,
    p_acquired_from       GIPI_MC_ERROR_LOG.acquired_from%TYPE,
    p_assignee            GIPI_MC_ERROR_LOG.assignee%TYPE,
    p_basic_color_cd      GIPI_MC_ERROR_LOG.basic_color_cd%TYPE,
    p_car_company_cd      GIPI_MC_ERROR_LOG.car_company_cd%TYPE,
    p_coc_atcn            GIPI_MC_ERROR_LOG.coc_atcn%TYPE,
    p_coc_issue_date      GIPI_MC_ERROR_LOG.coc_issue_date%TYPE,
    p_coc_seq_no          GIPI_MC_ERROR_LOG.coc_seq_no%TYPE,
    p_coc_serial_no       GIPI_MC_ERROR_LOG.coc_serial_no%TYPE,
    p_coc_type            GIPI_MC_ERROR_LOG.coc_type%TYPE,
    p_coc_yy              GIPI_MC_ERROR_LOG.coc_yy%TYPE,
    p_color               GIPI_MC_ERROR_LOG.color%TYPE,
    p_color_cd            GIPI_MC_ERROR_LOG.color_cd%TYPE,
    p_coverage_cd         GIPI_MC_ERROR_LOG.coverage_cd%TYPE,
    p_ctv_tag             GIPI_MC_ERROR_LOG.ctv_tag%TYPE,
    p_currency_cd         GIPI_MC_ERROR_LOG.currency_cd%TYPE,
    p_destination         GIPI_MC_ERROR_LOG.destination%TYPE,
    p_est_value           GIPI_MC_ERROR_LOG.est_value%TYPE,
    p_model_year          GIPI_MC_ERROR_LOG.model_year%TYPE,
    p_make                GIPI_MC_ERROR_LOG.make%TYPE,
    p_make_cd             GIPI_MC_ERROR_LOG.make_cd%TYPE,
    p_mot_type            GIPI_MC_ERROR_LOG.mot_type%TYPE,
    p_motor_no            GIPI_MC_ERROR_LOG.motor_no%TYPE,  
    p_mv_file_no          GIPI_MC_ERROR_LOG.mv_file_no%TYPE,
    p_no_of_pass          GIPI_MC_ERROR_LOG.no_of_pass%TYPE,
    p_origin              GIPI_MC_ERROR_LOG.origin%TYPE,
    p_plate_no            GIPI_MC_ERROR_LOG.plate_no%TYPE,
    p_region_cd           GIPI_MC_ERROR_LOG.region_cd%TYPE,
    p_repair_lim          GIPI_MC_ERROR_LOG.repair_lim%TYPE,
    p_serial_no           GIPI_MC_ERROR_LOG.serial_no%TYPE,
    p_series_cd           GIPI_MC_ERROR_LOG.series_cd%TYPE,
    p_tariff_zone         GIPI_MC_ERROR_LOG.tariff_zone%TYPE,
    p_towing              GIPI_MC_ERROR_LOG.towing%TYPE,
    p_type_of_body_cd     GIPI_MC_ERROR_LOG.type_of_body_cd%TYPE,
    p_unladen_wt          GIPI_MC_ERROR_LOG.unladen_wt%TYPE,
    p_remarks             GIPI_MC_ERROR_LOG.remarks%TYPE,
    p_subline_type_cd     GIPI_MC_ERROR_LOG.subline_type_cd%TYPE,
    p_currency_rt         GIPI_MC_ERROR_LOG.currency_rt%TYPE,
    p_user_id             GIPI_MC_ERROR_LOG.user_id%TYPE
  );
                              
END Gipi_MC_Error_Log_Pkg;
/



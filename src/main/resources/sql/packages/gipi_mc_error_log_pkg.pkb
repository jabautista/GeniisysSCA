CREATE OR REPLACE PACKAGE BODY CPI.Gipi_MC_Error_Log_Pkg AS
  
  FUNCTION get_gipi_mc_error_log_list(p_filename      GIPI_MC_ERROR_LOG.filename%TYPE) 
    RETURN gipi_mc_error_log_tab PIPELINED IS
  
  	v_mc_error_log		gipi_mc_error_log%ROWTYPE;
  
  BEGIN
  	   
	   FOR a IN (select upload_no,
					   	filename,
					    item_no,
					    item_title,
					    motor_no,
					    plate_no,
					    serial_no,
					    user_id,
                        remarks,
                        last_update
				   from gipi_mc_error_log
				   /*where filename = p_filename*/)
	   LOOP
	   	 v_mc_error_log.upload_no 	 := a.upload_no;
		 v_mc_error_log.filename  	 := a.filename;
		 v_mc_error_log.item_no	  	 := a.item_no;
		 v_mc_error_log.item_title	 := a.item_title;
		 v_mc_error_log.motor_no	 := a.motor_no;
		 v_mc_error_log.plate_no	 := a.plate_no;
		 v_mc_error_log.serial_no	 := a.serial_no;
		 v_mc_error_log.user_id		 := a.user_id;
         v_mc_error_log.remarks      := a.remarks;      -- marco - added 02.01.2013
         v_mc_error_log.last_update  := a.last_update;  --
	   
	     PIPE ROW(v_mc_error_log);
	   END LOOP;
	   
    RETURN;
	   
  END;
  
    /*
    **  Created by   :  D.Alcantara
    **  Date Created :  March 6, 2012
    **  Reference By : (GIPIS198 - Upload Fleet Data)
    **  Description  : This is for inserting valid records in GIPI_MC_ERROR_LOG 
    */    
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
  ) IS
  BEGIN
    MERGE INTO gipi_mc_error_log
    USING DUAL 
       ON (upload_no = p_upload_no AND p_filename = p_filename AND item_no = p_item_no)
     WHEN NOT MATCHED THEN
        INSERT (
            upload_no, filename, item_no, item_title, item_desc, item_desc2,
            acquired_from, assignee, basic_color_cd, car_company_cd, coc_atcn,
            coc_issue_date, coc_seq_no, coc_serial_no, coc_type, coc_yy, color, 
            color_cd, coverage_cd, ctv_tag, currency_cd, destination, est_value,
            model_year, make, make_cd, mot_type, motor_no, mv_file_no, no_of_pass, 
            origin, plate_no, region_cd, repair_lim, serial_no, series_cd,
            tariff_zone, towing, type_of_body_cd, unladen_wt, remarks,
            subline_type_cd, currency_rt, user_id
            )
        VALUES (
            p_upload_no, p_filename, p_item_no, p_item_title, p_item_desc, p_item_desc2,
            p_acquired_from, p_assignee, p_basic_color_cd, p_car_company_cd, p_coc_atcn,
            p_coc_issue_date, p_coc_seq_no, p_coc_serial_no, p_coc_type, p_coc_yy, p_color, 
            p_color_cd, p_coverage_cd, p_ctv_tag, p_currency_cd, p_destination, p_est_value, 
            p_model_year, p_make, p_make_cd, p_mot_type, p_motor_no, p_mv_file_no, p_no_of_pass, 
            p_origin, p_plate_no, p_region_cd, p_repair_lim, p_serial_no, p_series_cd,
            p_tariff_zone, p_towing, p_type_of_body_cd, p_unladen_wt, p_remarks,
            p_subline_type_cd, p_currency_rt, NVL(p_user_id, USER)
        )
     WHEN MATCHED THEN
         UPDATE
            SET item_title      = p_item_title, 
                item_desc       = p_item_desc, 
                item_desc2      = p_item_desc2,
                acquired_from      = p_acquired_from, 
                assignee        = p_assignee, 
                basic_color_cd      = p_basic_color_cd, 
                car_company_cd      = p_car_company_cd, 
                coc_atcn        = p_coc_atcn,
                coc_issue_date      = p_coc_issue_date, 
                coc_seq_no      = p_coc_seq_no, 
                coc_serial_no      = p_coc_serial_no, 
                coc_type        = p_coc_type, 
                coc_yy          = p_coc_yy, 
                color           = p_color, 
                color_cd      = p_color_cd, 
                coverage_cd      = p_coverage_cd, 
                ctv_tag      = p_ctv_tag, 
                currency_cd      = p_currency_cd, 
                destination      = p_destination, 
                est_value      = p_est_value,
                model_year      = p_model_year, 
                make            = p_make, 
                make_cd      = p_make_cd, 
                mot_type      = p_mot_type, 
                motor_no      = p_motor_no, 
                mv_file_no      = p_mv_file_no, 
                no_of_pass      = p_no_of_pass,
                origin      = p_origin, 
                plate_no      = p_plate_no, 
                region_cd      = p_region_cd, 
                repair_lim      = p_repair_lim, 
                serial_no      = p_serial_no, 
                series_cd      = p_series_cd,
                tariff_zone      = p_tariff_zone, 
                towing      = p_towing, 
                type_of_body_cd      = p_type_of_body_cd, 
                unladen_wt      = p_unladen_wt, 
                remarks      = p_remarks,
                subline_type_cd      = p_subline_type_cd, 
                currency_rt      = p_currency_rt, 
                user_id      = NVL(p_user_id, USER);
        
  END set_gipi_mc_error_log;
  
  
                              
END Gipi_MC_Error_Log_Pkg;
/



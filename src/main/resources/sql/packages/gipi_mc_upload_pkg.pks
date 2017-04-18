CREATE OR REPLACE PACKAGE CPI.Gipi_MC_Upload_Pkg AS       
  
  TYPE gipi_mc_upload_tab IS TABLE OF gipi_mc_upload%ROWTYPE;
  
  FUNCTION get_gipi_mc_upload (p_filename      GIPI_MC_UPLOAD.filename%TYPE) 
    RETURN gipi_mc_upload_tab PIPELINED;
  
  PROCEDURE set_gipi_mc_upload (p_filename            GIPI_MC_UPLOAD.filename%TYPE,                     
                                p_item_no             GIPI_MC_UPLOAD.item_no%TYPE,                
                                p_motor_no            GIPI_MC_UPLOAD.motor_no%TYPE,               
                                p_serial_no           GIPI_MC_UPLOAD.serial_no%TYPE,              
                                p_plate_no            GIPI_MC_UPLOAD.plate_no%TYPE,
								p_item_title		  GIPI_MC_ERROR_LOG.item_title%TYPE,
								p_subline_type_cd	  GIPI_MC_ERROR_LOG.subline_type_cd%TYPE,
                                p_session_user        GIPI_MC_UPLOAD.user_id%TYPE);
                                
  PROCEDURE set_gipi_mc_upload1 (p_upload_no          GIPI_MC_UPLOAD.upload_no%TYPE,
                                p_filename            GIPI_MC_UPLOAD.filename%TYPE,                     
                                p_item_no             GIPI_MC_UPLOAD.item_no%TYPE,                
                                p_motor_no            GIPI_MC_UPLOAD.motor_no%TYPE,               
                                p_serial_no           GIPI_MC_UPLOAD.serial_no%TYPE,              
                                p_plate_no            GIPI_MC_UPLOAD.plate_no%TYPE,
								p_item_title		  GIPI_MC_ERROR_LOG.item_title%TYPE,
								p_subline_type_cd	  GIPI_MC_ERROR_LOG.subline_type_cd%TYPE,
                                p_user_id             GIPI_MC_UPLOAD.user_id%TYPE);
  
  PROCEDURE del_gipi_mc_upload (p_filename       GIPI_MC_UPLOAD.filename%TYPE);
                              
END Gipi_MC_Upload_Pkg;
/



CREATE OR REPLACE PACKAGE CPI.GIPI_ERROR_LOG_PKG
AS
  TYPE gipi_error_log_type IS RECORD(
  	   upload_no		      		 GIPI_ERROR_LOG.upload_no%TYPE,		  	   	  
	   filename 				 	 GIPI_ERROR_LOG.filename%TYPE, 
	   grouped_item_title 			 GIPI_ERROR_LOG.grouped_item_title%TYPE,			 
	   sex 							 GIPI_ERROR_LOG.sex%TYPE,		 				  
	   civil_status 				 GIPI_ERROR_LOG.civil_status%TYPE,							  				  
	   date_of_birth 				 GIPI_ERROR_LOG.date_of_birth%TYPE,
	   age 							 GIPI_ERROR_LOG.age%TYPE,			  
	   salary 						 GIPI_ERROR_LOG.salary%TYPE,					  
	   salary_grade 				 GIPI_ERROR_LOG.salary_grade%TYPE,
	   amount_coverage 				 GIPI_ERROR_LOG.amount_coverage%TYPE,		  
	   remarks 						 GIPI_ERROR_LOG.remarks%TYPE,					  
	   user_id 						 GIPI_ERROR_LOG.user_id%TYPE,
	   last_update 					 GIPI_ERROR_LOG.last_update%TYPE,			  
	   control_cd 					 GIPI_ERROR_LOG.control_cd%TYPE,				  
	   control_type_cd 				 GIPI_ERROR_LOG.control_type_cd%TYPE,
	   grouped_item_no 				 GIPI_ERROR_LOG.grouped_item_no%TYPE
  	   );
	   
  TYPE gipi_error_log_tab IS TABLE OF gipi_error_log_type;

  FUNCTION get_gipi_error_log (p_filename		 GIPI_ERROR_LOG.filename%TYPE)
    RETURN gipi_error_log_tab PIPELINED; 

  PROCEDURE del_gipi_error_log;	
	
END;
/



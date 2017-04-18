CREATE OR REPLACE PACKAGE CPI.gipi_upload_temp_pkg
AS
  TYPE gipi_upload_temp_type IS RECORD(
  	   upload_no			GIPI_UPLOAD_TEMP.upload_no%TYPE,
	   filename				GIPI_UPLOAD_TEMP.filename%TYPE,
	   grouped_item_title	GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,							   
	   sex					GIPI_UPLOAD_TEMP.sex%TYPE,		
	   civil_status			VARCHAR2(2000),		
	   date_of_birth		GIPI_UPLOAD_TEMP.date_of_birth%TYPE,		
	   age					GIPI_UPLOAD_TEMP.age%TYPE,		
	   salary				GIPI_UPLOAD_TEMP.salary%TYPE,		
	   salary_grade			GIPI_UPLOAD_TEMP.salary_grade%TYPE,		
	   amount_coverage		GIPI_UPLOAD_TEMP.amount_coverage%TYPE,		
	   remarks				GIPI_UPLOAD_TEMP.remarks%TYPE,		
	   user_id				GIPI_UPLOAD_TEMP.user_id%TYPE,        
       last_update            GIPI_UPLOAD_TEMP.last_update%TYPE,        
       upload_date            GIPI_UPLOAD_TEMP.upload_date%TYPE,        
       control_cd            GIPI_UPLOAD_TEMP.control_cd%TYPE,        
       control_type_cd        GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
       upload_seq_no        GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
       from_date            GIPI_UPLOAD_TEMP.from_date%TYPE,
       to_date                GIPI_UPLOAD_TEMP.to_date%TYPE
         );
       
  TYPE gipi_upload_temp_tab IS TABLE OF gipi_upload_temp_type;

  FUNCTION get_gipi_upload_temp
    RETURN gipi_upload_temp_tab PIPELINED; 
    
  PROCEDURE set_gipi_upload_temp(
              p_upload_no                        GIPI_UPLOAD_TEMP.upload_no%TYPE,
               p_filename                       GIPI_UPLOAD_TEMP.filename%TYPE,
               p_grouped_item_title           GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,                               
               p_sex                           GIPI_UPLOAD_TEMP.sex%TYPE,        
               p_civil_status                   GIPI_UPLOAD_TEMP.civil_status%TYPE,            
               p_date_of_birth                   GIPI_UPLOAD_TEMP.date_of_birth%TYPE,        
               p_age                           GIPI_UPLOAD_TEMP.age%TYPE,        
               p_salary                       GIPI_UPLOAD_TEMP.salary%TYPE,        
               p_salary_grade                   GIPI_UPLOAD_TEMP.salary_grade%TYPE,        
               p_amount_coverage               GIPI_UPLOAD_TEMP.amount_coverage%TYPE,        
               p_remarks                       GIPI_UPLOAD_TEMP.remarks%TYPE,        
               p_user_id                       GIPI_UPLOAD_TEMP.user_id%TYPE,        
            p_last_update                   GIPI_UPLOAD_TEMP.last_update%TYPE,        
               p_upload_date                   GIPI_UPLOAD_TEMP.upload_date%TYPE,        
               p_control_cd                   GIPI_UPLOAD_TEMP.control_cd%TYPE,        
               p_control_type_cd               GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
               p_upload_seq_no                   GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
               p_from_date                       GIPI_UPLOAD_TEMP.from_date%TYPE,
               p_to_date                       GIPI_UPLOAD_TEMP.to_date%TYPE
              );    
            
  PROCEDURE set_gipi_upload_temp_perils(
              p_upload_no                        GIPI_UPLOAD_TEMP.upload_no%TYPE,
               p_filename                       GIPI_UPLOAD_TEMP.filename%TYPE,
               p_grouped_item_title           GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,                               
               p_sex                           GIPI_UPLOAD_TEMP.sex%TYPE,        
               p_civil_status                   GIPI_UPLOAD_TEMP.civil_status%TYPE,            
               p_date_of_birth                   GIPI_UPLOAD_TEMP.date_of_birth%TYPE,        
               p_age                           GIPI_UPLOAD_TEMP.age%TYPE,        
               p_salary                       GIPI_UPLOAD_TEMP.salary%TYPE,        
               p_salary_grade                   GIPI_UPLOAD_TEMP.salary_grade%TYPE,        
               p_amount_coverage               GIPI_UPLOAD_TEMP.amount_coverage%TYPE,        
               p_remarks                       GIPI_UPLOAD_TEMP.remarks%TYPE,        
               p_user_id                       GIPI_UPLOAD_TEMP.user_id%TYPE,        
            p_last_update                   GIPI_UPLOAD_TEMP.last_update%TYPE,        
               p_upload_date                   GIPI_UPLOAD_TEMP.upload_date%TYPE,        
               p_control_cd                   GIPI_UPLOAD_TEMP.control_cd%TYPE,        
               p_control_type_cd               GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
               p_upload_seq_no                   GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
               p_from_date                       GIPI_UPLOAD_TEMP.from_date%TYPE,
               p_to_date                       GIPI_UPLOAD_TEMP.to_date%TYPE
              );        
    
  FUNCTION Validate_Upload_File (p_filename        GIPI_UPLOAD_TEMP.filename%TYPE)
  RETURN VARCHAR2;        
  
  FUNCTION get_upload_no (p_filename        GIPI_UPLOAD_TEMP.filename%TYPE)
  RETURN VARCHAR2;    
  
  PROCEDURE insert_values (p_upload_no          NUMBER);
  
    FUNCTION get_gipi_upload_temp_tg (p_upload_no IN gipi_upload_temp.upload_no%TYPE)
    RETURN gipi_upload_temp_tab PIPELINED;

  TYPE gipi_uploaded_enrollees_type IS RECORD(
  	   grouped_item_no  	GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE,
	   grouped_item_title	GIPI_UPLOAD_TEMP.grouped_item_title%TYPE,							   
	   sex					GIPI_UPLOAD_TEMP.sex%TYPE,		
	   civil_status_desc	VARCHAR2(2000),		
       civil_status			GIPI_UPLOAD_TEMP.CIVIL_STATUS%TYPE,
	   date_of_birth		GIPI_UPLOAD_TEMP.date_of_birth%TYPE,		
	   age					GIPI_UPLOAD_TEMP.age%TYPE,		
	   salary				GIPI_UPLOAD_TEMP.salary%TYPE,		
	   salary_grade			GIPI_UPLOAD_TEMP.salary_grade%TYPE,		
	   amount_coverage		GIPI_UPLOAD_TEMP.amount_coverage%TYPE,		
	   remarks				GIPI_UPLOAD_TEMP.remarks%TYPE,		
	   user_id				GIPI_UPLOAD_TEMP.user_id%TYPE,        
       last_update          GIPI_UPLOAD_TEMP.last_update%TYPE,        
       upload_date          GIPI_UPLOAD_TEMP.upload_date%TYPE,        
       control_cd           GIPI_UPLOAD_TEMP.control_cd%TYPE,        
       control_type_cd      GIPI_UPLOAD_TEMP.control_type_cd%TYPE,        
       control_type_desc    GIIS_CONTROL_TYPE.CONTROL_TYPE_DESC%TYPE,
       --upload_seq_no        GIPI_UPLOAD_TEMP.upload_seq_no%TYPE,
       from_date            GIPI_UPLOAD_TEMP.from_date%TYPE,
       to_date              GIPI_UPLOAD_TEMP.to_date%TYPE
       );
       
  TYPE gipi_uploaded_enrollees_tab IS TABLE OF gipi_uploaded_enrollees_type;
  
  FUNCTION get_gipi_uploaded_enrollees (p_upload_no   gipi_upload_temp.upload_no%TYPE,
                                        p_par_id      gipi_wgrouped_items.PAR_ID%TYPE,
                                        p_item_no     gipi_wgrouped_items.ITEM_NO%TYPE)
  RETURN gipi_uploaded_enrollees_tab PIPELINED;
  
   FUNCTION get_upload_count(
      p_upload_no                   GIPI_UPLOAD_TEMP.upload_no%TYPE
   )
     RETURN NUMBER;
     
END;
/



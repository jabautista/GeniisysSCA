CREATE OR REPLACE PACKAGE CPI.Gipi_Wreqdocs_Pkg AS

  TYPE gipi_wreqdocs_type IS RECORD
    (doc_cd				  GIPI_WREQDOCS.doc_cd%TYPE,
	 par_id				  GIPI_WREQDOCS.par_id%TYPE,
	 doc_sw				  GIPI_WREQDOCS.doc_sw%TYPE,
	 line_cd			  GIPI_WREQDOCS.line_cd%TYPE,
	 date_submitted		  GIPI_WREQDOCS.date_submitted%TYPE,
	 user_id			  GIPI_WREQDOCS.user_id%TYPE,
	 last_update		  GIPI_WREQDOCS.last_update%TYPE,
	 remarks			  GIPI_WREQDOCS.remarks%TYPE,
	 doc_name			  GIIS_REQUIRED_DOCS.doc_name%TYPE);
	 
  TYPE gipi_wreqdocs_tab IS TABLE OF gipi_wreqdocs_type;
  
  FUNCTION get_wreqdocs_list(p_par_id 			GIPI_WREQDOCS.par_id%TYPE) 
    RETURN gipi_wreqdocs_tab PIPELINED;
	
  Procedure delete_gipi_wreqdoc(p_par_id 			GIPI_WREQDOCS.par_id%TYPE
  							   ,p_doc_cd			GIPI_WREQDOCS.doc_cd%TYPE);
							   
  Procedure set_gipi_wreqdoc(p_wreqdoc	IN GIPI_WREQDOCS%ROWTYPE);
  
  Procedure set_gipi_wreqdoc1(p_doc_cd	   	  IN GIPI_WREQDOCS.doc_cd%TYPE
  							,p_par_id	   	  IN GIPI_WREQDOCS.par_id%TYPE
							,p_doc_sw	   	  IN GIPI_WREQDOCS.doc_sw%TYPE
							,p_line_cd	   	  IN GIPI_WREQDOCS.line_cd%TYPE
							,p_date_submitted IN GIPI_WREQDOCS.date_submitted%TYPE
							,p_user_id		  IN GIPI_WREQDOCS.user_id%TYPE
							,p_remarks		  IN GIPI_WREQDOCS.remarks%TYPE);

	Procedure DEL_GIPI_WREQDOCS (p_par_id IN GIPI_WREQDOCS.par_id%TYPE);
END Gipi_Wreqdocs_Pkg;
/



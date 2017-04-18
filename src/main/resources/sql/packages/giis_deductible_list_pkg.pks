CREATE OR REPLACE PACKAGE CPI.GIIS_DEDUCTIBLE_LIST_PKG AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B350_DSP_DEDUCTIBLE_CD 
***********************************************************************************/

  TYPE deductible_list_type IS RECORD
  	   (deductible_title	GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
	    line_cd				GIIS_DEDUCTIBLE_DESC.line_cd%TYPE,
		subline_cd			GIIS_DEDUCTIBLE_DESC.subline_cd%TYPE,
		deductible_cd		VARCHAR2(100),
		deductible_text 	GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
		ded_type            GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,		
	    deductible_amt		GIIS_DEDUCTIBLE_DESC.deductible_amt%TYPE,
		deductible_rt		GIIS_DEDUCTIBLE_DESC.deductible_rt%TYPE, 
        min_amt             GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
        max_amt             GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
        range_sw            GIIS_DEDUCTIBLE_DESC.range_sw%TYPE);
  
  TYPE deductible_list_tab IS TABLE OF deductible_list_type;
  
  FUNCTION get_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   					   p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE) 
	RETURN deductible_list_tab PIPELINED;

/********************************** FUNCTION 2 ************************************	
  MODULE: GIPIS002 
  RECORD GROUP NAME: DEDUCTIBLES 
***********************************************************************************/

  TYPE ded_deductible_list_type IS RECORD
  	   (deductible_cd		VARCHAR2(100),
	    deductible_title	GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
        ded_type            GIIS_DEDUCTIBLE_DESC.ded_type%TYPE,
		ded_type_desc		CG_REF_CODES.rv_meaning%TYPE,
		deductible_rt		GIIS_DEDUCTIBLE_DESC.deductible_rt%TYPE,
		deductible_amt		GIIS_DEDUCTIBLE_DESC.deductible_amt%TYPE,
		deductible_text		GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,
		min_amt		   		GIIS_DEDUCTIBLE_DESC.min_amt%TYPE,
		max_amt		   		GIIS_DEDUCTIBLE_DESC.max_amt%TYPE,
		range_sw	   		GIIS_DEDUCTIBLE_DESC.range_sw%TYPE); 
  
  TYPE ded_deductible_list_tab IS TABLE OF ded_deductible_list_type;
  
  FUNCTION get_ded_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   						p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE) 
	RETURN ded_deductible_list_tab PIPELINED;

	
/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS011 
  RECORD GROUP NAME: CGFK$B350_PACK_DEDUCTIBLE_CD 
***********************************************************************************/	
	
  TYPE pack_deductible_list_type IS RECORD
  	   (deductible_cd		GIIS_DEDUCTIBLE_DESC.deductible_cd%TYPE,
	    deductible_title	GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
		deductible_amt		GIIS_DEDUCTIBLE_DESC.deductible_amt%TYPE); 
  
  TYPE pack_deductible_list_tab IS TABLE OF pack_deductible_list_type;
  
  FUNCTION get_pack_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   			 			    p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE,
									p_par_id		GIPI_WDEDUCTIBLES.par_id%TYPE) 
	RETURN pack_deductible_list_tab PIPELINED;

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B350_DSP_DEDUCTIBLE_TITLE 
***********************************************************************************/
	
  TYPE item_deductible_list_type IS RECORD
  	   (deductible_title	GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
	    line_cd				GIIS_DEDUCTIBLE_DESC.line_cd%TYPE,
		subline_cd			GIIS_DEDUCTIBLE_DESC.subline_cd%TYPE,
		deductible_cd		GIIS_DEDUCTIBLE_DESC.deductible_cd%TYPE,
		deductible_text 	GIIS_DEDUCTIBLE_DESC.deductible_text%TYPE,		
	    deductible_amt		GIIS_DEDUCTIBLE_DESC.deductible_amt%TYPE); 
  
  TYPE item_deductible_list_tab IS TABLE OF item_deductible_list_type;
  
  FUNCTION get_item_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   			 			    p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE,
									p_par_id		GIPI_WDEDUCTIBLES.par_id%TYPE,
									p_item_no		GIPI_WDEDUCTIBLES.item_no%TYPE) 
	RETURN item_deductible_list_tab PIPELINED;

END GIIS_DEDUCTIBLE_LIST_PKG;
/



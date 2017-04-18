CREATE OR REPLACE PACKAGE CPI.Giis_Geog_Class_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS006 
  RECORD GROUP NAME: CGFK$B340_DSP_GEOG_DESC 
***********************************************************************************/

  TYPE geog_list_type IS RECORD
    (geog_desc     VARCHAR2(32000),--GIIS_GEOG_CLASS.geog_desc%TYPE,
     geog_cd       GIIS_GEOG_CLASS.geog_cd%TYPE,
     type          VARCHAR2(20),
	 class_type	   GIIS_GEOG_CLASS.class_type%TYPE);

  TYPE geog_list_tab IS TABLE OF geog_list_type;     
     
  FUNCTION get_geog_list(p_par_id GIPI_WVES_AIR.par_id%TYPE)
    RETURN geog_list_tab PIPELINED;


/********************************** FUNCTION 2 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: GEOG_DESC 
***********************************************************************************/

  FUNCTION get_geog2_list(p_quote_id    GIPI_QUOTE_VES_AIR.quote_id%TYPE)
    RETURN geog_list_tab PIPELINED;    
    
  FUNCTION get_all_geog_list RETURN geog_list_tab PIPELINED;
  
  FUNCTION get_endt_geog_list (p_par_id GIPI_WPOLBAS.par_id%TYPE)
    RETURN geog_list_tab PIPELINED;
    
END Giis_Geog_Class_Pkg;
/



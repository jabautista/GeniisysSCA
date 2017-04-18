CREATE OR REPLACE PACKAGE CPI.Giis_Province_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B510_DSP_PROVINCE_SEL 
***********************************************************************************/

  TYPE province_list_type IS RECORD
    (province_desc		  GIIS_PROVINCE.province_desc%TYPE,
	 province_cd		  GIIS_PROVINCE.province_cd%TYPE);

  TYPE province_list_tab IS TABLE OF province_list_type;

  FUNCTION get_province_list(p_region_cd GIIS_PROVINCE.region_cd%TYPE)
    RETURN province_list_tab PIPELINED;  
  
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: PROVINCE_RG 
***********************************************************************************/ 
  
  TYPE block_province_list_type IS RECORD
    (province_desc		  GIIS_PROVINCE.province_desc%TYPE,
	 province_cd		  GIIS_PROVINCE.province_cd%TYPE);

  TYPE block_province_list_tab IS TABLE OF block_province_list_type;

  FUNCTION get_block_province_list RETURN block_province_list_tab PIPELINED;
  
/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B510_DSP_PROVINCE_DESC 
***********************************************************************************/

  TYPE region_province_list_type IS RECORD
    (province_desc		  GIIS_PROVINCE.province_desc%TYPE,
	 province_cd		  GIIS_PROVINCE.province_cd%TYPE,
 	 region_cd			  GIIS_REGION.region_cd%TYPE,
	 region_desc		  GIIS_REGION.region_desc%TYPE);

  TYPE region_province_list_tab IS TABLE OF region_province_list_type;

  FUNCTION get_region_province_list RETURN region_province_list_tab PIPELINED;
  
  FUNCTION get_province_listing(p_region_cd GIIS_REGION.region_cd%TYPE 
                               ,p_find_text VARCHAR2)
    RETURN region_province_list_tab PIPELINED;   
  
  FUNCTION get_province_list
    RETURN region_province_list_tab PIPELINED; 
      
END Giis_Province_Pkg;
/



CREATE OR REPLACE PACKAGE CPI.Giis_Fire_Item_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_FR_IT 
***********************************************************************************/

  TYPE fire_item_type_list_type IS RECORD
    (fr_itm_tp_ds		GIIS_FI_ITEM_TYPE.fr_itm_tp_ds%TYPE,
	 fr_item_type		GIIS_FI_ITEM_TYPE.fr_item_type%TYPE);
	 
  TYPE fire_item_type_list_tab IS TABLE OF fire_item_type_list_type;

  FUNCTION get_fire_item_type_list 
    RETURN fire_item_type_list_tab PIPELINED;
  
    
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: FIRE_ITEM_TYPE_STOCKS 
***********************************************************************************/  
  
  TYPE fire_item_type_stocks_list_tab IS TABLE OF fire_item_type_list_type;

  FUNCTION get_fire_item_type_stocks_list(p_fire_item_type  GIIS_FI_ITEM_TYPE.fr_item_type%TYPE) 
    RETURN fire_item_type_stocks_list_tab PIPELINED;

END Giis_Fire_Item_Type_Pkg;
/



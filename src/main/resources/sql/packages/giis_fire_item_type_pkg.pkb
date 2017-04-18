CREATE OR REPLACE PACKAGE BODY CPI.Giis_Fire_Item_Type_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_FR_IT 
***********************************************************************************/

  FUNCTION get_fire_item_type_list 
    RETURN fire_item_type_list_tab PIPELINED IS
	
	v_item 		fire_item_type_list_type;
	
  BEGIN
    FOR i IN (
		SELECT UPPER(fr_itm_tp_ds) fr_itm_tp_ds, fr_item_type
		  FROM GIIS_FI_ITEM_TYPE
      ORDER BY fr_itm_tp_ds)
	LOOP
		v_item.fr_itm_tp_ds	   := i.fr_itm_tp_ds;
		v_item.fr_item_type	   := i.fr_item_type;
	  PIPE ROW(v_item);
	END LOOP;
	
    RETURN;
  END get_fire_item_type_list;
  

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: FIRE_ITEM_TYPE_STOCKS 
***********************************************************************************/  
  
  FUNCTION get_fire_item_type_stocks_list(p_fire_item_type GIIS_FI_ITEM_TYPE.fr_item_type%TYPE) 
    RETURN fire_item_type_stocks_list_tab PIPELINED IS
	
	v_item 		fire_item_type_list_type;
	
  BEGIN
    FOR i IN (
		SELECT fr_itm_tp_ds, fr_item_type
		  FROM GIIS_FI_ITEM_TYPE
		 WHERE fr_item_type = p_fire_item_type)
	LOOP
		v_item.fr_itm_tp_ds	   := i.fr_itm_tp_ds;
		v_item.fr_item_type	   := i.fr_item_type;
	  PIPE ROW(v_item);
	END LOOP;
	
    RETURN;
  END get_fire_item_type_stocks_list;
  
END Giis_Fire_Item_Type_Pkg;
/



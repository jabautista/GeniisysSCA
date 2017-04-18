CREATE OR REPLACE PACKAGE CPI.Giis_Accessory_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS010  
  RECORD GROUP NAME: ACC    
***********************************************************************************/ 

  TYPE accessory_list_type IS RECORD
  	   (accessory_cd		    GIIS_ACCESSORY.accessory_cd%TYPE,
   	    accessory_desc			GIIS_ACCESSORY.accessory_desc%TYPE,
		acc_amt					GIIS_ACCESSORY.acc_amt%type);
   
  TYPE accessory_list_tab IS TABLE OF accessory_list_type;
  
  FUNCTION get_accessory_list
  RETURN accessory_list_tab PIPELINED;
  
	FUNCTION get_accessory_list_tg(p_find_text IN VARCHAR2)
	RETURN accessory_list_tab PIPELINED;

END Giis_Accessory_Pkg;
/



CREATE OR REPLACE PACKAGE CPI.GIIS_GROUP_PKG
AS
  TYPE giis_group_list_type IS RECORD (
  	   group_cd				giis_group.group_cd%TYPE,
	   group_desc			giis_group.group_desc%TYPE
  	   );
  TYPE giis_group_list_tab IS TABLE OF giis_group_list_type;

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS011  
  RECORD GROUP NAME: GROUP  
***********************************************************************************/
 	   
  FUNCTION get_giis_group_list (p_assd_no giis_assured_group.assd_no%TYPE)
	RETURN giis_group_list_tab PIPELINED;
	
   FUNCTION get_all_giis_group_list
      RETURN giis_group_list_tab PIPELINED;
		   
END;
/



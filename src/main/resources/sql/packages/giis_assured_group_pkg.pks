CREATE OR REPLACE PACKAGE CPI.Giis_Assured_Group_Pkg AS

  TYPE giis_assured_group_type IS RECORD
    (assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE,
	 group_cd				  GIIS_ASSURED_GROUP.group_cd%TYPE,
	 group_desc				  GIIS_GROUP.group_desc%TYPE,
	 remarks				  GIIS_ASSURED_GROUP.remarks%TYPE,
	 user_id				  GIIS_ASSURED_GROUP.user_id%TYPE,
	 last_update			  GIIS_ASSURED_GROUP.last_update%TYPE);
	 
  TYPE giis_assured_group_tab IS TABLE OF giis_assured_group_type;
  
  FUNCTION get_giis_assured_group (p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE)
    RETURN giis_assured_group_tab PIPELINED;

  
  PROCEDURE set_giis_assured_group (
  	 p_assd_no				  IN  GIIS_ASSURED_GROUP.assd_no%TYPE,
	 p_group_cd				  IN  GIIS_ASSURED_GROUP.group_cd%TYPE,
	 p_remarks				  IN  GIIS_ASSURED_GROUP.remarks%TYPE);
	 
  PROCEDURE del_giis_assured_group (
     p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE,
	 p_group_cd				  GIIS_ASSURED_GROUP.group_cd%TYPE);	

  PROCEDURE del_giis_assured_group_all (
     p_assd_no				  GIIS_ASSURED_GROUP.assd_no%TYPE);		 
	 
END Giis_Assured_Group_Pkg;
/



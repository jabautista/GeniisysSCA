CREATE OR REPLACE PACKAGE CPI.Giis_Assured_Intm_Pkg AS

  TYPE giis_assured_intm_type IS RECORD
    (assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE,
	 line_cd				  GIIS_ASSURED_INTM.line_cd%TYPE,
	 intm_no				  GIIS_ASSURED_INTM.intm_no%TYPE,
	 intm_name				  GIIS_INTERMEDIARY.intm_name%TYPE,
	 user_id				  GIIS_ASSURED_INTM.user_id%TYPE,
	 last_update			  GIIS_ASSURED_INTM.last_update%TYPE);
	 
  TYPE giis_assured_intm_tab IS TABLE OF giis_assured_intm_type;
  
  FUNCTION get_giis_assured_intm (p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE)
    RETURN giis_assured_intm_tab PIPELINED;

  
  PROCEDURE set_giis_assured_intm (
  	 p_assd_no				  IN  GIIS_ASSURED_INTM.assd_no%TYPE,
	 p_line_cd				  IN  GIIS_ASSURED_INTM.line_cd%TYPE,
	 p_intm_no				  IN  GIIS_ASSURED_INTM.intm_no%TYPE);
	 
  PROCEDURE del_giis_assured_intm (
     p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE,
	 p_line_cd				  GIIS_ASSURED_INTM.line_cd%TYPE,
	 p_intm_no				  GIIS_ASSURED_INTM.intm_no%TYPE);	 
	 
  PROCEDURE del_giis_assured_intm_all (
     p_assd_no				  GIIS_ASSURED_INTM.assd_no%TYPE);		 
	 	
	
END Giis_Assured_Intm_Pkg;
/



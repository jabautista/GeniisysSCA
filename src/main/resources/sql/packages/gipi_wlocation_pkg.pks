CREATE OR REPLACE PACKAGE CPI.GIPI_WLOCATION_PKG
AS
    TYPE gipi_wloc_item_type IS RECORD (
		par_id       GIPI_WLOCATION.par_id%TYPE,
		item_no      GIPI_WLOCATION.item_no%TYPE,
		region_cd    GIPI_WLOCATION.region_cd%TYPE,
		province_cd  GIPI_WLOCATION.province_cd%TYPE);

    TYPE gipi_wloc_item_tab IS TABLE OF gipi_wloc_item_type;

	Procedure del_gipi_wlocation (p_par_id IN GIPI_WLOCATION.par_id%TYPE);
    
    FUNCTION get_item_wlocations (p_par_id IN GIPI_WLOCATION.par_id%TYPE) RETURN gipi_wloc_item_tab PIPELINED;
	
	FUNCTION get_gipi_wlocation_pack_pol (
		p_par_id IN gipi_wlocation.par_id%TYPE,
		p_item_no IN gipi_wlocation.item_no%TYPE)
	RETURN gipi_wloc_item_tab PIPELINED;
    
    PROCEDURE set_gipi_wlocation (p_par_id IN GIPI_WLOCATION.par_id%TYPE,
                                  p_item_no IN GIPI_WLOCATION.item_no%TYPE,
                                  p_region_cd IN GIPI_WLOCATION.region_cd%TYPE,
                                  p_province_cd IN GIPI_WLOCATION.province_cd%TYPE);
                                  
    PROCEDURE del_gipi_wlocation2 (p_par_id IN GIPI_WLOCATION.par_id%TYPE, p_item_no IN GIPI_WLOCATION.item_no%TYPE);
                                  

END GIPI_WLOCATION_PKG;
/



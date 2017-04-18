CREATE OR REPLACE PACKAGE CPI.GIIS_TARIFF_RATES_HDR_PKG AS

  TYPE tariff_rates_hdr_type IS RECORD (
	prem_tag     giis_tariff_rates_hdr.default_prem_tag%TYPE,
   	tarf_sw      VARCHAR2(1),
   	tariff_cd    giis_tariff_rates_hdr.tariff_cd%TYPE);

  TYPE tariff_rates_hdr_tab IS TABLE OF tariff_rates_hdr_type;
  
  FUNCTION get_tariff_details_mc(p_coverage_cd           giis_tariff_rates_hdr.COVERAGE_CD%TYPE,
   	  	             			 p_line_cd               giis_tariff_rates_hdr.LINE_CD%TYPE,
   	  	             			 p_subline_cd            giis_tariff_rates_hdr.SUBLINE_CD%TYPE,
   	  	             			 p_peril_cd              giis_tariff_rates_hdr.PERIL_CD%TYPE,
   	  	             			 p_item_no               gipi_wvehicle.ITEM_NO%TYPE,
   	  	             			 p_par_id                gipi_wvehicle.par_id%TYPE)
	RETURN tariff_rates_hdr_tab PIPELINED;
	
  FUNCTION get_tariff_details_fi(p_line_cd               giis_tariff_rates_hdr.LINE_CD%TYPE,
   	  	             			 p_subline_cd            giis_tariff_rates_hdr.SUBLINE_CD%TYPE,
   	  	             			 p_peril_cd              giis_tariff_rates_hdr.PERIL_CD%TYPE,
   	  	             			 p_item_no               gipi_wvehicle.ITEM_NO%TYPE,
   	  	             			 p_par_id                gipi_wvehicle.par_id%TYPE)
	RETURN tariff_rates_hdr_tab PIPELINED; 

END GIIS_TARIFF_RATES_HDR_PKG;
/



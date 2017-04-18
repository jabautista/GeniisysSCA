CREATE OR REPLACE PACKAGE CPI.Giis_Tariff_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_TARIFF 
***********************************************************************************/

  TYPE tariff_zone_list_type IS RECORD
    (tariff_zone_desc		 GIIS_TARIFF_ZONE.tariff_zone_desc%TYPE,
	 tariff_zone			 GIIS_TARIFF_ZONE.tariff_zone%TYPE,
     tarf_cd			 GIIS_TARIFF_ZONE.tarf_cd%TYPE);
	 
  TYPE tariff_zone_list_tab IS TABLE OF tariff_zone_list_type;

  FUNCTION get_tariff_zone_list(p_line_cd 	GIIS_TARIFF_ZONE.line_cd%TYPE,
  		   						p_subline_cd 	GIIS_TARIFF_ZONE.subline_cd%TYPE) 
	RETURN tariff_zone_list_tab PIPELINED;
	

/********************************** FUNCTION 2 ************************************
  MODULE: GIIMM002 
  RECORD GROUP NAME: TARIFF_ZONE 
***********************************************************************************/

  FUNCTION get_all_tariff_zone_list	RETURN tariff_zone_list_tab PIPELINED;	

END Giis_Tariff_Zone_Pkg;
/



CREATE OR REPLACE PACKAGE CPI.Giis_Tariff_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003 
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_TARF_CD 
***********************************************************************************/

  TYPE tariff_list_type IS RECORD (
    tarf_cd            giis_tariff.tarf_cd%TYPE,
    tarf_desc        giis_tariff.tarf_desc%TYPE,
    tarf_rate        giis_tariff.tarf_rate%TYPE,
    tariff_zone        giis_tariff.tariff_zone%TYPE,
    occupancy_cd    giis_tariff.occupancy_cd%TYPE);

  TYPE tariff_list_tab IS TABLE OF tariff_list_type;
     
  FUNCTION get_tariff_list RETURN tariff_list_tab PIPELINED;
  
  
/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS038 
  RECORD GROUP NAME: TARIFF_RG 
***********************************************************************************/  

  TYPE peril_tariff_list_type IS RECORD
    (tarf_cd        GIIS_PERIL_TARIFF.tarf_cd%TYPE,
     tarf_desc        GIIS_TARIFF.tarf_desc%TYPE,
     tarf_rate        GIIS_TARIFF.tarf_rate%TYPE);

  TYPE peril_tariff_list_tab IS TABLE OF peril_tariff_list_type;
     
  FUNCTION get_peril_tariff_list(p_line_cd    GIIS_PERIL_TARIFF.line_cd%TYPE,
                                      p_peril_cd    GIIS_PERIL_TARIFF.peril_cd%TYPE)
    RETURN peril_tariff_list_tab PIPELINED;
    
    FUNCTION get_peril_tariff_list1(
        p_line_cd IN giis_peril_tariff.line_cd%TYPE,
          p_peril_cd IN giis_peril_tariff.peril_cd%TYPE,
        p_find_text IN VARCHAR2)
    RETURN peril_tariff_list_tab PIPELINED;

END Giis_Tariff_Pkg;
/



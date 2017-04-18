CREATE OR REPLACE PACKAGE BODY CPI.Giis_Tariff_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DSP_TARIFF
***********************************************************************************/

  FUNCTION get_tariff_zone_list(p_line_cd 		GIIS_TARIFF_ZONE.line_cd%TYPE,
  		   						p_subline_cd 	GIIS_TARIFF_ZONE.subline_cd%TYPE)
    RETURN tariff_zone_list_tab PIPELINED IS

	v_zone 		tariff_zone_list_type;

  BEGIN
    FOR i IN (
		SELECT tariff_zone_desc, tariff_zone, tarf_cd
		  FROM GIIS_TARIFF_ZONE
		 WHERE line_cd = p_line_cd
		   AND (subline_cd = p_subline_cd OR subline_cd IS NULL))
	LOOP
		v_zone.tariff_zone_desc		:= i.tariff_zone_desc;
		v_zone.tariff_zone			:= i.tariff_zone;
        v_zone.tarf_cd              :=i.tarf_cd;
	  PIPE ROW(v_zone);
	END LOOP;

    RETURN;
  END get_tariff_zone_list;


/********************************** FUNCTION 2 ************************************
  MODULE: GIIMM002
  RECORD GROUP NAME: TARIFF_ZONE
***********************************************************************************/

  FUNCTION get_all_tariff_zone_list
    RETURN tariff_zone_list_tab PIPELINED IS

	v_zone 		tariff_zone_list_type;

  BEGIN
    FOR i IN (
		SELECT tariff_zone_desc, tariff_zone
		  FROM GIIS_TARIFF_ZONE)
	LOOP
		v_zone.tariff_zone_desc		:= i.tariff_zone_desc;
		v_zone.tariff_zone			:= i.tariff_zone;
	  PIPE ROW(v_zone);
	END LOOP;

    RETURN;
  END get_all_tariff_zone_list;

END Giis_Tariff_Zone_Pkg;
/



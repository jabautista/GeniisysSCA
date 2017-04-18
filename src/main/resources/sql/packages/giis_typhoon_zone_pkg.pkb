CREATE OR REPLACE PACKAGE BODY CPI.Giis_Typhoon_Zone_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: GIPI_WFIREITM6_DSP_TYPHOON
***********************************************************************************/

  FUNCTION get_typhoon_zone_list
    RETURN typhoon_zone_list_tab PIPELINED IS

	v_typhoon		typhoon_zone_list_type;

  BEGIN
  	FOR i IN (
		SELECT typhoon_zone, typhoon_zone_desc
		  FROM GIIS_TYPHOON_ZONE
		 ORDER BY typhoon_zone)
	LOOP
		v_typhoon.typhoon_zone 		:= i.typhoon_zone;
		v_typhoon.typhoon_zone_desc	:= i.typhoon_zone_desc;
	  PIPE ROW(v_typhoon);
	END LOOP;

    RETURN;
  END get_typhoon_zone_list;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 05.04.2011
	**  Reference By 	: (GIPIS003 - Item Information - FIRE)
	**  Description     : Returns typhoon zone listing
    */
    FUNCTION get_typhoon_zone_listing(p_find_text IN VARCHAR2) RETURN typhoon_zone_list_tab PIPELINED
    IS
        v_typhoon typhoon_zone_list_type;
    BEGIN
        FOR i IN (
            SELECT typhoon_zone, typhoon_zone_desc
              FROM giis_typhoon_zone
             WHERE UPPER(typhoon_zone_desc) LIKE UPPER(NVL(p_find_text, '%%'))
          ORDER BY typhoon_zone)
        LOOP
            v_typhoon.typhoon_zone         := i.typhoon_zone;
            v_typhoon.typhoon_zone_desc := i.typhoon_zone_desc;

            PIPE ROW(v_typhoon);
        END LOOP;

        RETURN;
    END get_typhoon_zone_listing;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 05.04.2011
    **  Reference By    : (GIPIS003 - Item Information - FIRE)
    **  Description     : Returns typhoon_zone_desc based on the given typhoon_zone
    */
    FUNCTION get_typhoon_zone_desc(p_typhoon_zone IN giis_typhoon_zone.typhoon_zone%TYPE)
    RETURN giis_typhoon_zone.typhoon_zone_desc%TYPE
    IS
        v_typhoon_zone_desc giis_typhoon_zone.typhoon_zone_desc%TYPE;
    BEGIN
        FOR i IN (
            SELECT typhoon_zone_desc
              FROM giis_typhoon_zone
             WHERE typhoon_zone = p_typhoon_zone)
        LOOP
            v_typhoon_zone_desc := i.typhoon_zone_desc;
        END LOOP;

        RETURN v_typhoon_zone_desc;
    END get_typhoon_zone_desc;

END Giis_Typhoon_Zone_Pkg;
/



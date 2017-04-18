CREATE OR REPLACE PACKAGE BODY CPI.Giis_District_Pkg AS

	/********************************** FUNCTION 1 ************************************
	  MODULE: GIPIS003 
	  RECORD GROUP NAME: CGFK$GIPI_WFIREITM6_DISTRICT_N 
	***********************************************************************************/
	/*
	**  Modified by		: Mark JM
	**  Date Created 	: 03.03.2010
	**  Reference By 	: (GIPIS003 - Item Information)
	**  Description 	: Add DECODE for all parameters used in order to return records
	**					: even parameters are null
	*/
	FUNCTION get_district_list (p_province_desc    GIIS_PROVINCE.province_desc%TYPE,
							  p_city			 GIIS_BLOCK.city%TYPE)								  	
	RETURN district_list_tab PIPELINED 
	IS	
		v_district		district_list_type;	
	BEGIN
		FOR i IN (
			SELECT a.district_no, a.district_desc, a.block_id, a.block_no, a.block_desc, a.province_cd, 
				   b.province_desc, a.city, a.eq_zone, a.typhoon_zone, a.flood_zone, 
				   c.eq_desc, d.typhoon_zone_desc, e.flood_zone_desc 
			  FROM GIIS_BLOCK a, GIIS_PROVINCE b, GIIS_EQZONE c, 
				   GIIS_TYPHOON_ZONE d, GIIS_FLOOD_ZONE e   
			 WHERE a.eq_zone       = c.eq_zone(+) 
			   AND a.flood_zone    = e.flood_zone(+) 
			   AND a.typhoon_zone  = d.typhoon_zone(+) 
			   AND a.province_cd   = b.province_cd(+)
			   AND b.province_desc = DECODE(p_province_desc, '*', b.province_desc, p_province_desc)
			   AND a.city          = DECODE(p_city, '*', a.city, p_city)
			 ORDER BY a.district_no, a.block_no)
		LOOP
			v_district.district_no			:= i.district_no;
			v_district.block_id				:= i.block_id;
			v_district.block_no				:= i.block_no;
			v_district.block_desc			:= i.block_desc;
			v_district.province_cd			:= i.province_cd;
			v_district.province_desc		:= i.province_desc;
			v_district.city					:= i.city;
			v_district.eq_zone				:= i.eq_zone;
			v_district.typhoon_zone			:= i.typhoon_zone;
			v_district.flood_zone			:= i.flood_zone;
			v_district.eq_desc				:= i.eq_desc;
			v_district.typhoon_zone_desc	:= i.typhoon_zone_desc;
			v_district.flood_zone_desc 		:= i.flood_zone_desc;
		  PIPE ROW(v_district);
		END LOOP;

		RETURN;
	END get_district_list;

    FUNCTION get_all_district_list
    RETURN all_district_list_tab PIPELINED 
	IS	
		v_district		all_district_list_type;
    
    BEGIN
        
		FOR i IN (
			SELECT DISTINCT a.district_no, a.district_desc, a.city_cd, a.province_cd
			  FROM  GIIS_BLOCK a, GIIS_PROVINCE b, GIIS_EQZONE c, 
				   GIIS_TYPHOON_ZONE d, GIIS_FLOOD_ZONE e   
              WHERE a.eq_zone       = c.eq_zone(+) 
			   AND a.flood_zone    = e.flood_zone(+) 
			   AND a.typhoon_zone  = d.typhoon_zone(+) 
			   AND a.province_cd   = b.province_cd(+)
              ORDER BY DISTRICT_DESC)
        LOOP
            v_district.district_no			:= i.district_no;
            v_district.district_desc        := i.district_desc;
            v_district.city_cd              := i.city_cd;
            v_district.province_cd          := i.province_cd;
            PIPE ROW(v_district);
        END LOOP;             
                   
    END get_all_district_list;    
END Giis_District_Pkg;
/



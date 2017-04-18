CREATE OR REPLACE PACKAGE BODY CPI.Giis_Province_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS004
  RECORD GROUP NAME: CGFK$B510_DSP_PROVINCE_SEL
***********************************************************************************/

  FUNCTION get_province_list(p_region_cd GIIS_PROVINCE.region_cd%TYPE)
    RETURN province_list_tab PIPELINED IS

	v_province		province_list_type;

  BEGIN
  	FOR i IN (
		SELECT province_desc, province_cd
		  FROM GIIS_PROVINCE
		 WHERE region_cd = p_region_cd)
	LOOP
		v_province.province_desc	:= i.province_desc;
		v_province.province_cd		:= i.province_cd;
	  PIPE ROW(v_province);
	END LOOP;

    RETURN;
  END get_province_list;

/********************************** FUNCTION 2 ************************************
  MODULE: GIPIS003
  RECORD GROUP NAME: PROVINCE_RG
***********************************************************************************/

  FUNCTION get_block_province_list
    RETURN block_province_list_tab PIPELINED IS

	v_province		block_province_list_type;

  BEGIN
  	FOR i IN (
		SELECT DISTINCT b.province_desc, b.province_cd
		  FROM GIIS_BLOCK a, GIIS_PROVINCE b
		 WHERE a.province_cd = b.province_cd)
	LOOP
		v_province.province_desc	:= i.province_desc;
		v_province.province_cd		:= i.province_cd;
	  PIPE ROW(v_province);
	END LOOP;

    RETURN;
  END get_block_province_list;

/********************************** FUNCTION 3 ************************************
  MODULE: GIPIS004
  RECORD GROUP NAME: CGFK$B510_DSP_PROVINCE_DESC
***********************************************************************************/

  FUNCTION get_region_province_list
    RETURN region_province_list_tab PIPELINED IS

	v_province		region_province_list_type;

  BEGIN
  	FOR i IN (
		SELECT a.province_desc, a.region_cd, b.region_desc, a.province_cd
		  FROM GIIS_PROVINCE a ,GIIS_REGION b
		 WHERE b.region_cd = a.region_cd
		 ORDER BY UPPER(a.province_cd))
	LOOP
		v_province.province_desc	:= i.province_desc;
		v_province.province_cd		:= i.province_cd;
		v_province.region_cd		:= i.region_cd;
		v_province.region_desc		:= i.region_desc;
	  PIPE ROW(v_province);
	END LOOP;

    RETURN;
  END get_region_province_list;

    /*
    **  Created by        : Andrew Robes
    **  Date Created     : 04.19.2011
    **  Reference By     : (GIPIS039 - Endt Fire Item Information)
    **  Description     : This procedure is used for retrieving province lov
    */
  FUNCTION get_province_listing(p_region_cd GIIS_REGION.region_cd%TYPE
                               ,p_find_text VARCHAR2)
    RETURN region_province_list_tab PIPELINED IS

	v_province		region_province_list_type;

  BEGIN
  	FOR i IN (SELECT DISTINCT b.province_desc, a.province_cd, b.region_cd
                FROM giis_block a
                    ,giis_province b
               WHERE a.province_cd = b.province_cd
                 AND b.region_cd = NVL(p_region_cd, b.region_cd)
                 AND UPPER(b.province_desc) LIKE UPPER(NVL(p_find_text, '%%'))
               ORDER BY b.province_desc)
	LOOP
		v_province.province_desc	:= i.province_desc;
		v_province.province_cd		:= i.province_cd;
        v_province.region_cd		:= i.region_cd;
	  PIPE ROW(v_province);
	END LOOP;

    RETURN;
  END get_province_listing;

  FUNCTION get_province_list
    RETURN region_province_list_tab PIPELINED IS
	v_province		region_province_list_type;
  BEGIN
  	FOR i IN (
		SELECT a.province_desc, a.province_cd
		  FROM GIIS_PROVINCE a ,GIIS_REGION b
		 WHERE b.region_cd = a.region_cd
		 ORDER BY UPPER(a.province_cd))
	LOOP
		v_province.province_desc	:= i.province_desc;
		v_province.province_cd		:= i.province_cd;
	  PIPE ROW(v_province);
	END LOOP;

    RETURN;
  END get_province_list;

END Giis_Province_Pkg;
/



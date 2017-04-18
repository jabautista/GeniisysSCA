DROP PROCEDURE CPI.GET_RECORDS_FOR_SERVICE;

CREATE OR REPLACE PROCEDURE CPI.Get_Records_For_Service (
	p_par_id 		IN GIPI_PARLIST.par_id%TYPE,
	p_iss_cd_ri		IN OUT VARCHAR2,
	p_wpolgenin		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wpolgenin,
	p_wendttext		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wendttext,
	p_wopen_policy	OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_wopen_policy,
	p_witmperl		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_witmperl,
	p_witem			OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_witem,
	p_parlist		OUT Gipis031_Ref_Cursor_Pkg.rc_gipi_parlist)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.13.2010
	**  Reference By 	: GIPIS031 - Endt Basic Information
	**  Description 	: This procedure returns records from different tables	
	*/
BEGIN
	OPEN p_wpolgenin FOR
	SELECT *
	  FROM GIPI_WPOLGENIN
	 WHERE par_id = p_par_id;
	 
	OPEN p_wendttext FOR
	SELECT *
	  FROM GIPI_WENDTTEXT
	 WHERE par_id = p_par_id;
	 
	OPEN p_wopen_policy FOR
	SELECT *
	  FROM GIPI_WOPEN_POLICY
	 WHERE par_id = p_par_id;
	
	OPEN p_witmperl FOR
	SELECT *
	  FROM GIPI_WITMPERL
	 WHERE par_id = p_par_id;
	 
	OPEN p_witem FOR
	SELECT *
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id;
	
	OPEN p_parlist FOR
	SELECT *
	  FROM GIPI_PARLIST
	 WHERE par_id = p_par_id;
	 
	p_iss_cd_ri := Giis_Parameters_Pkg.v(p_iss_cd_ri);
	
END Get_Records_For_Service;
/



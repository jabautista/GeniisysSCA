DROP PROCEDURE CPI.UPD_GIPI_WPACK_LINE_SUBLINE;

CREATE OR REPLACE PROCEDURE CPI.UPD_GIPI_WPACK_LINE_SUBLINE (
	p_par_id			IN gipi_wpack_line_subline.par_id%TYPE,
	p_pack_line_cd		IN gipi_wpack_line_subline.pack_line_cd%TYPE,
	p_pack_subline_cd	IN gipi_wpack_line_subline.pack_subline_cd%TYPE,
	p_pack_pol_flag		IN gipi_wpolbas.pack_pol_flag%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.07.2010
	**  Reference By 	: (GIPI061 - Endt Item Information - Casualty)
	**  Description 	: Call upd_gipi_wpack_line_subline procedure to update item_tag of the given par_id
	*/
BEGIN
	IF p_pack_pol_flag = 'Y' THEN
        Gipi_Wpack_Line_Subline_Pkg.upd_gipi_wpack_line_subline(p_par_id, p_pack_line_cd, p_pack_subline_cd);
    END IF;
END UPD_GIPI_WPACK_LINE_SUBLINE;
/



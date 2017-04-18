DROP PROCEDURE CPI.GIPIS010_ADD_PAR_STATUS_NO2;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_ADD_PAR_STATUS_NO2 (
	p_par_id			IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd			IN GIPI_PARLIST.line_cd%TYPE,
	p_iss_cd			IN GIPI_PARLIST.iss_cd%TYPE,
	p_invoice_sw		IN VARCHAR2,
	p_item_grp			IN GIPI_WITEM.item_grp%TYPE,	
	p_par_status		OUT GIPI_PARLIST.par_status%TYPE,
	p_v_pack_pol_flag	OUT GIPI_WPOLBAS.pack_pol_flag%TYPE,
	p_v_item_tag		OUT VARCHAR2,
	p_msg_alert			OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 08.27.2010
	**  Reference By 	: (GIPI010 - Item Information - MC)
	**  Description 	: Update the par status of the PAR in process depending on the changes
	*/
	v_dist_no	GIUW_POL_DIST.dist_no%TYPE;
	v_exist 	VARCHAR2(1) := 'N';
BEGIN
	FOR i IN (
		SELECT dist_no
		  FROM giuw_pol_dist
		 WHERE par_id = p_par_id)
	LOOP
		Changes_In_Par_Status2(p_par_id, i.dist_no, p_line_cd, p_iss_cd,
			p_invoice_sw, p_item_grp, p_par_status, p_v_pack_pol_flag, p_v_item_tag);
		v_exist := 'Y';
	END LOOP;
	
	IF v_exist = 'N' THEN
		Changes_In_Par_Status2(p_par_id, v_dist_no, p_line_cd, p_iss_cd,
			p_invoice_sw, p_item_grp, p_par_status, p_v_pack_pol_flag, p_v_item_tag);
	END IF;
	
	IF p_par_status = 3 OR p_par_status IS NULL THEN
		NULL;
	ELSIF p_par_status < 3 THEN
		NULL;
	ELSIF p_par_status > 3 THEN
		p_msg_alert := 'You are not granted access to this form. The changes that you have made '||
						'will not be committed to the database.';
	END IF;	
END GIPIS010_ADD_PAR_STATUS_NO2;
/



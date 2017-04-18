DROP PROCEDURE CPI.PRE_CHANGES_IN_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.PRE_CHANGES_IN_PAR_STATUS (
	p_par_id		IN GIPI_PARLIST.par_id%TYPE,
	p_dist_no		IN GIUW_POL_DIST.dist_no%TYPE,
	p_line_cd		IN GIPI_PARLIST.line_cd%TYPE,
	p_invoice_sw	IN VARCHAR2,
	p_msg_type		OUT VARCHAR2,
	p_msg_alert		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 08.26.2010
	**  Reference By 	: (GIPI010 - Item Information - MC)
	**  Description 	: This procedure returns message alert text after performing some validation
	*/
BEGIN
	IF p_invoice_sw = 'Y' THEN
		PRE_CREATE_DISTRIBUTION_ITEM(p_par_id, p_dist_no, p_msg_type, p_msg_alert);
	END IF;
END PRE_CHANGES_IN_PAR_STATUS;
/



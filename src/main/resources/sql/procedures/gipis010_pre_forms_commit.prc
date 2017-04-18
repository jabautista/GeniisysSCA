DROP PROCEDURE CPI.GIPIS010_PRE_FORMS_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_PRE_FORMS_COMMIT (
	p_par_id		IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd		IN GIPI_PARLIST.line_cd%TYPE,
	p_par_status	IN GIPI_PARLIST.par_status%TYPE,
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
	v_exist VARCHAR2(1) := 'N';
	v_dist_no	GIUW_POL_DIST.dist_no%TYPE;
BEGIN
	FOR i IN (
		SELECT dist_no
		  FROM GIUW_POL_DIST
		 WHERE par_id = p_par_id)
	LOOP
		PRE_CHANGES_IN_PAR_STATUS(p_par_id, i.dist_no, p_line_cd, p_invoice_sw, p_msg_type, p_msg_alert);
		v_exist := 'Y';
		
		IF p_msg_alert IS NOT NULL THEN
			EXIT;
		END IF;
	END LOOP;
	
	IF p_msg_alert IS NOT NULL THEN
		RETURN;
	END IF;
		
	IF v_exist = 'N' THEN
		PRE_CHANGES_IN_PAR_STATUS(p_par_id, v_dist_no, p_line_cd, p_invoice_sw, p_msg_type, p_msg_alert);
		
		IF p_msg_alert IS NOT NULL THEN
			RETURN;
		END IF;
	END IF;
	
	IF p_par_status = 3 OR p_par_status IS NULL THEN
		NULL;
	ELSIF p_par_status > 3 THEN
		NULL;
	ELSIF p_par_status < 3 THEN
		p_msg_alert := 'You are not granted access to this form. The changes that you have made '||
						'will not be committed to the database.';
		p_msg_type := 'ALERT';
	END IF;
END GIPIS010_PRE_FORMS_COMMIT;
/



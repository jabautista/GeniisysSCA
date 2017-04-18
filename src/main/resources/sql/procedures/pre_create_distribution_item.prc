DROP PROCEDURE CPI.PRE_CREATE_DISTRIBUTION_ITEM;

CREATE OR REPLACE PROCEDURE CPI.PRE_CREATE_DISTRIBUTION_ITEM (
	p_par_id	IN GIPI_PARLIST.par_id%TYPE,
	p_dist_no	IN GIUW_POLICYDS.dist_no%TYPE,
	p_msg_type	OUT VARCHAR2,
	p_msg_alert	OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 08.26.2010
	**  Reference By 	: (GIPI010 - Item Information - MC)
	**  Description 	: This procedure returns message alert text after performing some validation
	*/
	v_exist NUMBER;
BEGIN
	FOR i IN (
		SELECT DISTINCT frps_yy, frps_seq_no
		  FROM GIRI_DISTFRPS
		 WHERE dist_no = p_dist_no)
	LOOP
		p_msg_alert := 'This PAR has corresponding records in the posted tables for RI. '|| 
						'Could not proceed.';
		p_msg_type := 'ALERT';
		RETURN;
	END LOOP;	
	
	BEGIN
		SELECT DISTINCT 1
		  INTO v_exist
		  FROM GIUW_POLICYDS
		 WHERE dist_no = p_dist_no;
		
		IF SQL%FOUND THEN
			p_msg_alert := 'This PAR has existing records in the posted POLICY tables. ' ||
							'Changes will be made.  Would you like to continue?';
			p_msg_type := 'CONFIRM';
			RETURN;
		ELSE
			RAISE NO_DATA_FOUND;
		END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;
	
	BEGIN
		SELECT DISTINCT 1
		  INTO v_exist
		  FROM GIUW_WPOLICYDS
		 WHERE dist_no = p_dist_no;
		
		IF SQL%FOUND THEN
			p_msg_alert := 'Changes will be done to the distribution tables. Do you like to proceed?';
			p_msg_type := 'CONFIRM';
			RETURN;
		ELSE
			RAISE NO_DATA_FOUND;
		END IF;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;
END PRE_CREATE_DISTRIBUTION_ITEM;
/



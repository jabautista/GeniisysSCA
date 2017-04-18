DROP PROCEDURE CPI.GIPIS031_INIT_PARAMETERS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_INIT_PARAMETERS (
	p_lc_MC				OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_lc_AC				OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_lc_EN				OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_subline_mop		OUT GIIS_PARAMETERS.param_value_v%TYPE,
	p_advance_booking	OUT VARCHAR2)
IS	
BEGIN
	FOR A1 IN (
		SELECT a.param_value_v  a_param_value_v,
			   b.param_value_v  b_param_value_v
		  FROM GIIS_PARAMETERS a,
			   GIIS_PARAMETERS b
		 WHERE a.param_name LIKE 'MOTOR CAR'
		   AND  b.param_name LIKE 'LINE_CODE_AC')
	LOOP
		p_lc_MC := a1.a_param_value_v;
		p_lc_AC := a1.b_param_value_v;
	END LOOP;
	
	FOR B IN (
		SELECT param_value_v
		  FROM GIIS_PARAMETERS
		 WHERE param_name = 'MN_SUBLINE_MOP')
	LOOP
		p_subline_mop := b.param_value_v;
	END LOOP;
	
	p_advance_booking := 'N';
	
	FOR E IN (
		SELECT param_value_v
		  FROM GIIS_PARAMETERS
		 WHERE param_name = 'ALLOW_BOOKING_IN_ADVANCE')
	LOOP
		p_advance_booking := E.param_value_v;
	END LOOP;
	
	FOR F IN (
		SELECT param_value_v
		  FROM GIIS_PARAMETERS
		 WHERE param_name = 'LINE_CODE_EN')
	LOOP
		p_lc_EN  := F.param_value_v;        
	END LOOP;
END GIPIS031_INIT_PARAMETERS;
/



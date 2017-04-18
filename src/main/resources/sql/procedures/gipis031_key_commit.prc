DROP PROCEDURE CPI.GIPIS031_KEY_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.Gipis031_Key_Commit (
	p_par_id			IN GIPI_PARLIST.par_id%TYPE,
	p_line_cd			IN GIPI_PARLIST.line_cd%TYPE,
	p_iss_cd			IN GIPI_PARLIST.iss_cd%TYPE,
	p_pol_flag			IN GIPI_WPOLBAS.pol_flag%TYPE,
	p_nbt_pol_flag 		IN VARCHAR2,
	p_prorate_sw 		IN VARCHAR2,
	p_p_back_endt_sw	IN VARCHAR2,
	p_p_ins_winvoice	IN VARCHAR2,
	p_survey_agent_cd	IN GIPI_WPOLBAS.survey_agent_cd%TYPE,
	p_settling_agent_cd IN GIPI_WPOLBAS.settling_agent_cd%TYPE,	
	p_g_cg$back_endt 	OUT VARCHAR2,
	p_show_popup		OUT VARCHAR2,
	p_back_stat			OUT GIPI_WPOLBAS.back_stat%TYPE,
	p_msg_alert			OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.15.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Checks for backward endorsement
	**					: Insert record to gipi_winvoice
	*/
BEGIN
	IF p_pol_flag = '4' OR NVL(p_nbt_pol_flag, '1') = '4' OR NVL(p_prorate_sw, '2') = '1' THEN
		p_g_cg$back_endt := 'N';
	END IF;
	
	IF p_g_cg$back_endt = 'Y' AND p_p_back_endt_sw = 'Y' THEN
		p_show_popup := 'TRUE';
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	ELSE
		p_show_popup := 'FALSE';
		p_back_stat := NULL;
	END IF;
	
	IF p_p_ins_winvoice = 'Y' THEN
		Create_Winvoice1(p_par_id, p_line_cd, p_iss_cd, p_msg_alert);
	END IF;
	
	IF p_msg_alert IS NOT NULL THEN
		GOTO RAISE_FORM_TRIGGER_FAILURE;
	END IF;
	
	DECLARE
		v_param_value_v   VARCHAR2(200);
		v_menu_line_cd    VARCHAR2(2);
	BEGIN		
		v_param_value_v := Giis_Parameters_Pkg.v('LINE_CODE_MN');
		
		FOR y IN (
			SELECT menu_line_cd
			  FROM GIIS_LINE
			 WHERE line_cd = p_line_cd)
		LOOP
			v_menu_line_cd := y.menu_line_cd;
		END LOOP;
		
		IF (p_line_cd = v_param_value_v) OR ('MN' = v_menu_line_cd) THEN			
			IF Giis_Parameters_Pkg.v('REQ_SURVEY_SETT_AGENT') = 'Y' THEN
				IF p_survey_agent_cd IS NULL OR p_settling_agent_cd IS NULL THEN
					p_msg_alert := 'Survey Agent and Settling Agent are required';
				END IF;	
				
				IF p_msg_alert IS NOT NULL THEN
					GOTO RAISE_FORM_TRIGGER_FAILURE;
				END IF;
			END IF;			
		END IF;
		COMMIT;
	END;
	
	<<RAISE_FORM_TRIGGER_FAILURE>>
	NULL;
END Gipis031_Key_Commit;
/



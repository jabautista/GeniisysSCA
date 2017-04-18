DROP PROCEDURE CPI.VALIDATE_ENDT_EXP_DATE;

CREATE OR REPLACE PROCEDURE CPI.Validate_Endt_Exp_Date (
	p_record_status 	IN VARCHAR2,
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_expiry_date		IN VARCHAR2,
	p_eff_date			IN VARCHAR2,	
	p_endt_exp_date 	IN VARCHAR2,
	p_v_v_old_date_exp	IN VARCHAR2,
	p_comp_sw			IN VARCHAR2,
	p_v_v_add_time		IN OUT NUMBER,	
	p_prorate_flag		OUT GIPI_WPOLBAS.prorate_flag%TYPE,
	p_v_mpl_switch		OUT VARCHAR2,
	p_p_confirm_sw		OUT VARCHAR2,
	p_prorate_days		OUT NUMBER,
	p_msg_alert			OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.10.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Get the value of the default_prorate_tag from
    **					  giis_parameters which would help to determine what would
    **					  be the default rate use
	*/
	v_default_prorate_tag      GIIS_PARAMETERS.param_value_v%TYPE;	
	v_end_of_day	VARCHAR2(1);
	v_endt_exp_date	DATE := TO_DATE(p_endt_exp_date, 'MM-DD-RRRR');
	v_eff_date		DATE := TO_DATE(p_eff_date, 'MM-DD-RRRR');
	v_expiry_date	DATE := TO_DATE(p_expiry_date, 'MM-DD-RRRR');	
BEGIN
	FOR A IN (
		SELECT param_value_v
		  FROM GIIS_PARAMETERS
		 WHERE param_name = 'DEFAULT_PRORATE_TAG')
	LOOP 
		v_default_prorate_tag := A.param_value_v;
		EXIT;
	END LOOP;
	
	IF p_record_status IN ('NEW', 'INSERT') THEN
		IF v_default_prorate_tag = 'Y' THEN
			IF TRUNC(v_endt_exp_date) <> TRUNC(ADD_MONTHS(v_eff_date, 12)) THEN
				p_prorate_flag := '1';
			ELSE
				p_prorate_flag := '2';
			END IF;
		ELSIF v_default_prorate_tag = 'N' THEN
			IF (v_endt_exp_date - v_eff_date) <> 365 THEN
				p_prorate_flag := '2';
			END IF;
		END IF;
	END IF;
	
	IF p_record_status IN ('CHANGED', 'INSERT') THEN
		IF p_v_v_old_date_exp != p_endt_exp_date THEN
			Get_Addtl_Time_Gipis002(p_line_cd, p_subline_cd, p_v_v_add_time);
			v_end_of_day := Giis_Subline_Pkg.get_subline_time_sw(p_line_cd, p_subline_cd);
			IF NVL(v_end_of_day, 'N') = 'Y' THEN
				v_endt_exp_date := v_endt_exp_date + 86399 /86400;
			ELSE
				v_endt_exp_date := v_endt_exp_date + p_v_v_add_time / 86400;
			END IF;
		END IF;
		
		IF TRUNC(v_expiry_date) < TRUNC(v_endt_exp_date) THEN
			p_v_mpl_switch := 'Y';
			p_msg_alert := 'The endorsement expiry date should not be later than the policy expiry date.';
			v_endt_exp_date := TO_DATE(p_v_v_old_date_exp, 'MM-DD-RRRR HH:MI:SS AM');
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
		
		IF TRUNC(v_endt_exp_date) < TRUNC(v_eff_date) THEN
			p_v_mpl_switch := 'Y';
			p_msg_alert := 'Endorsement expiry date should not be earlier than the endorsement effectivity date.';
			v_endt_exp_date := TO_DATE(p_v_v_old_date_exp, 'MM-DD-RRRR HH:MI:SS AM');
			GOTO RAISE_FORM_TRIGGER_FAILURE;
		END IF;
		
		IF TO_DATE(p_v_v_old_date_exp, 'MM-DD-RRRR') != TO_DATE(p_endt_exp_date, 'MM-DD-RRRR') THEN
			p_p_confirm_sw := 'N';
			IF p_prorate_flag = '1' AND v_endt_exp_date IS NOT NULL AND v_eff_date IS NOT NULL THEN
				p_prorate_days := TRUNC(v_endt_exp_date) - TRUNC(v_eff_date);
				IF p_comp_sw = 'Y' THEN
					p_prorate_days := p_prorate_days + 1;
				ELSIF p_comp_sw = 'M' THEN
					p_prorate_days := p_prorate_days - 1;
				ELSE
					p_prorate_days := p_prorate_days;
				END IF;
			END IF;
		END IF;
		
		<<RAISE_FORM_TRIGGER_FAILURE>>
		NULL;
	END IF;
END Validate_Endt_Exp_Date;
/



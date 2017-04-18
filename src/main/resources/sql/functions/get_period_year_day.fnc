DROP FUNCTION CPI.GET_PERIOD_YEAR_DAY;

CREATE OR REPLACE FUNCTION CPI.GET_PERIOD_YEAR_DAY (
	p_start_date IN DATE,
	p_end_date IN DATE) RETURN VARCHAR2	
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.29.2011
	**  Reference By 	: -
	**  Description 	: This function returns the period in words (ex. One (1) year and two (2) days)
	*/
	
	v_total_months NUMBER := 0;
	v_no_of_years NUMBER := 0;
	v_no_of_days NUMBER := 0;
	
	v_spell_day VARCHAR2(100) := '';
	v_spell_year VARCHAR2(100) := '';
	
	c_year CONSTANT VARCHAR2(4) := 'YEAR';
	c_years CONSTANT VARCHAR2(5) := 'YEARS';
	c_day CONSTANT VARCHAR2(5) := 'DAY';
	c_days CONSTANT VARCHAR2(6) := 'DAYS';
BEGIN
	IF p_end_date <= p_start_date THEN
		RETURN NULL;
	END IF;	
	
	SELECT TRUNC(MONTHS_BETWEEN(p_end_date, p_start_date))
	  INTO v_total_months
	  FROM dual;
    
    IF v_total_months < 12 THEN
        v_no_of_years := 0;
        v_no_of_days := TRUNC(p_end_date - p_start_date);
    ELSE
        v_no_of_years := TRUNC(v_total_months / 12);
        v_no_of_days := TRUNC(p_end_date - ADD_MONTHS(p_start_date, (v_no_of_years * 12)));
    END IF;
    
    IF v_no_of_days < 0 THEN
        v_spell_day := '';
    ELSIF v_no_of_days = 1 THEN
        v_spell_day := LOWER(dh_util.spell(v_no_of_days)) || ' (' || v_no_of_days || ') ' || LOWER(c_day);
    ELSE
        v_spell_day := LOWER(dh_util.spell(v_no_of_days)) || ' (' || v_no_of_days || ') ' || LOWER(c_days);
    END IF;
    
    IF v_no_of_years < 1  THEN
        v_spell_year := '';
    ELSIF v_no_of_years = 1 THEN
        v_spell_year := INITCAP(dh_util.spell(v_no_of_years)) || ' (' || v_no_of_years || ') ' || LOWER(c_year);
    ELSE
        v_spell_year := INITCAP(dh_util.spell(v_no_of_years)) || ' (' || v_no_of_years || ') ' || LOWER(c_years);
    END IF;

    IF v_no_of_days = 0 AND v_no_of_years > 0 THEN    
        RETURN v_spell_year;
    ELSIF v_no_of_days = 0 AND v_no_of_years = 0 THEN
        RETURN '';
    -- 9/5/2011 added for PRF 7790         
    ELSIF v_no_of_days > 0 AND v_no_of_years = 0 THEN
        RETURN v_spell_day;
    ELSE
        RETURN v_spell_year || ' and ' || v_spell_day;
    END IF;
END GET_PERIOD_YEAR_DAY;
/



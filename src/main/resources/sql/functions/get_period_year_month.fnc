DROP FUNCTION CPI.GET_PERIOD_YEAR_MONTH;

CREATE OR REPLACE FUNCTION CPI.GET_PERIOD_YEAR_MONTH (
	p_start_date IN DATE,
	p_end_date IN DATE) RETURN VARCHAR2	
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.15.2011
	**  Reference By 	: -
	**  Description 	: This function returns the period in words (ex. One (1) year and two (2) months)
	*/
	
	v_total_months NUMBER := 0;
	v_no_of_years NUMBER := 0;
	v_no_of_months NUMBER := 0;
	
	v_spell_month VARCHAR2(100) := '';
    v_spell_year VARCHAR2(100) := '';
    
    c_year CONSTANT VARCHAR2(4) := 'YEAR';
    c_years CONSTANT VARCHAR2(5) := 'YEARS';
    c_month CONSTANT VARCHAR2(5) := 'MONTH';
    c_months CONSTANT VARCHAR2(6) := 'MONTHS';
BEGIN
    IF p_end_date <= p_start_date THEN
        RETURN NULL;
    END IF;
    
    SELECT TRUNC(MONTHS_BETWEEN(p_end_date, p_start_date))
      INTO v_total_months
      FROM dual;
    
    IF v_total_months < 12 THEN
        v_no_of_years := 0;
        v_no_of_months := v_total_months;
    ELSE
        v_no_of_years := TRUNC(v_total_months / 12);
        v_no_of_months := MOD(v_total_months, 12);
    END IF;
    
    IF v_no_of_months < 0 THEN
        v_spell_month := '';
    ELSIF v_no_of_months = 1 THEN
        v_spell_month := LOWER(dh_util.spell(v_no_of_months)) || ' (' || v_no_of_months || ') ' || LOWER(c_month);
    ELSE
        v_spell_month := LOWER(dh_util.spell(v_no_of_months)) || ' (' || v_no_of_months || ') ' || LOWER(c_months);
    END IF;
    
    IF v_no_of_years < 1  THEN
        v_spell_year := '';
    ELSIF v_no_of_years = 1 THEN
        v_spell_year := INITCAP(dh_util.spell(v_no_of_years)) || ' (' || v_no_of_years || ') ' || LOWER(c_year);
    ELSE
        v_spell_year := INITCAP(dh_util.spell(v_no_of_years)) || ' (' || v_no_of_years || ') ' || LOWER(c_years);
    END IF;

    IF v_no_of_months = 0 AND v_no_of_years > 0 THEN    
        RETURN v_spell_year;
    ELSIF v_no_of_months = 0 AND v_no_of_years = 0 THEN
        RETURN '';
    ELSE
        RETURN v_spell_year || ' and ' || v_spell_month;
    END IF;
END GET_PERIOD_YEAR_MONTH;
/



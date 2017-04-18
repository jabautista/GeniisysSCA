DROP PROCEDURE CPI.GIPIS031_GET_BOOKING_DATE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_GET_BOOKING_DATE (
	p_p_v_vdate IN NUMBER,
	p_issue_date IN gipi_wpolbas.issue_date%TYPE,
	p_eff_date IN gipi_wpolbas.eff_date%TYPE,
	p_p_v_idate OUT DATE,
	p_booking_year OUT gipi_wpolbas.booking_year%TYPE,
	p_booking_mth OUT gipi_wpolbas.booking_mth%TYPE)
AS
	/*	Date        Author			Description
    **	==========	===============	============================    
    **	01.11.2012	mark jm			get the valid booking month and year based on the newly entered eff_date
    **						        valid booking month depends on the value of parameter 'PROD_TAKE_UP' which is set up
    **                                in GIAC_PARAMETERS, this value was assigned to field p_p_v_vdate (:PARAMETER.VAR_VDATE) 
    **                                for the ff. value of p_p_v_vdate (:PARAMETER.VAR_VDATE) booking date would be based as follows
    **                                1 - booking date would be based on issue date
    **                                2 - booking date would be based on effectivity date
    **                                3 - booking date would be based on effectivity date or issue date whichever is higher
    **                                (Original Description)
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    ** 07.17.2012  andrew     added date format in TO_DATE function to handle ORA-01858 on some machines
    **
    */    
    v_d2 DATE;
    v_date_flag2 NUMBER := 2;
BEGIN
    IF p_p_v_vdate = 1 OR (p_p_v_vdate = 3 AND p_issue_date > p_eff_date) THEN
        p_p_v_idate := p_issue_date;
        v_d2 := p_eff_date;
        
        FOR C IN (
            SELECT booking_year, 
                   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-YYYY'), 'MM'), 
                   booking_mth 
              FROM giis_booking_month
             WHERE (NVL(booked_tag, 'N') != 'Y')
               AND (booking_year > TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                OR (booking_year = TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
               AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(p_issue_date, 'MM'))))
          ORDER BY 1, 2 ) 
        LOOP
            p_booking_year := TO_NUMBER(C.booking_year);       
            p_booking_mth  := C.booking_mth;              
            v_date_flag2 := 5;
            EXIT;
        END LOOP;
        
        IF v_date_flag2 <> 5 THEN
            p_booking_year := NULL;
            p_booking_mth := NULL;
        END IF;
    ELSIF p_p_v_vdate = 2 OR (p_p_v_vdate = 3 AND p_issue_date <= p_eff_date) THEN
        p_p_v_idate := p_eff_date;
        
        FOR C IN (
            SELECT booking_year, 
                   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-YYYY'), 'MM'), 
                   booking_mth 
              FROM giis_booking_month
             WHERE ( NVL(booked_tag, 'N') <> 'Y')
               AND (booking_year > TO_NUMBER(TO_CHAR(p_eff_date, 'YYYY'))
                OR (booking_year = TO_NUMBER(TO_CHAR(p_eff_date, 'YYYY'))
               AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(p_eff_date, 'MM'))))
          ORDER BY 1, 2 )
        LOOP
            p_booking_year := TO_NUMBER(C.booking_year);       
            p_booking_mth  := C.booking_mth;              
            v_date_flag2 := 5;
            EXIT;
        END LOOP;
        
        IF v_date_flag2 <> 5 THEN
            p_booking_year := NULL;
            p_booking_mth := NULL;
        END IF;
    END IF;
END GIPIS031_GET_BOOKING_DATE;
/



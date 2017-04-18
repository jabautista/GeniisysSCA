DROP PROCEDURE CPI.GIPIS031_VALIDATE_ISSUE_DATE01;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_VALIDATE_ISSUE_DATE01 (
    p_line_cd IN gipi_wpolbas.line_cd%TYPE,
    p_subline_cd IN gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd IN gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy IN gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no IN gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no IN gipi_wpolbas.renew_no%TYPE,
    p_p_var_vdate IN NUMBER,
    p_issue_date IN gipi_wpolbas.issue_date%TYPE,
    p_eff_date IN gipi_wpolbas.eff_date%TYPE,    
    p_p_var_idate OUT DATE,
    p_booking_year OUT gipi_wpolbas.booking_year%TYPE,
    p_booking_mth OUT gipi_wpolbas.booking_mth%TYPE,
    p_message OUT VARCHAR2,
    p_message_type OUT VARCHAR2)
AS
    /*    Date        Author            Description
    **    ==========    ===============    ============================    
    **    01.18.2012    mark jm            Validates issue date    
    **                                Reference By : (GIPIS031 - Endt. Basic Information)
    */
    v_date_flag2 NUMBER := 2;
    v_policy_issue_date  gipi_polbasic.issue_date%TYPE;--This is to store value of policy issue_date
BEGIN
    IF p_p_var_vdate = 1 OR (p_p_var_vdate = 3 AND p_issue_date > p_eff_date) THEN
        --This is to select issue_date from gipi_polbasic into v_policy_issue_date 
        FOR issue IN (
            SELECT issue_date
              FROM gipi_polbasic
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND iss_cd = p_iss_cd
               AND issue_yy = p_issue_yy
               AND pol_seq_no = p_pol_seq_no
               AND renew_no = p_renew_no
               AND endt_seq_no = 0)
        LOOP                     
            v_policy_issue_date := issue.issue_date;
            EXIT;
        END LOOP;
        
        --this is to validate endorsement issue date. Endt issue date should 
        -- not be earlier than Policy issue date.     
        IF TRUNC(p_issue_date) < TRUNC(v_policy_issue_date) THEN
            p_message := 'Endorsement issue date must not be earlier than Policy issue date ('||v_policy_issue_date||').';
            p_message_type := 'ERROR';
            RETURN;
        END IF;
        
        p_p_var_idate := p_issue_date;
        
        FOR c IN (
            SELECT booking_year, 
                   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'), 
                   booking_mth 
              FROM giis_booking_month
             WHERE (NVL(booked_tag, 'N') != 'Y')
               AND (booking_year > TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                OR (booking_year = TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
               AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'))>= TO_NUMBER(TO_CHAR(p_issue_date, 'MM'))))
          ORDER BY 1, 2)
        LOOP
            p_booking_year := c.booking_year;       
            p_booking_mth  := c.booking_mth;              
            v_date_flag2 := 5;
            EXIT;
        END LOOP;
        
        IF v_date_flag2 <> 5 THEN
            p_booking_year := NULL;
            p_booking_mth := NULL;
        END IF;
    ELSIF p_p_var_vdate = 2 OR (p_p_var_vdate = 3 AND p_issue_date <= p_eff_date) THEN
        p_p_var_idate := p_eff_date;
        
        FOR c IN (
            SELECT booking_year, 
                   TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'), 
                   booking_mth 
              FROM giis_booking_month
             WHERE (NVL(booked_tag, 'N') <> 'Y')
               AND (booking_year > TO_NUMBER(TO_CHAR(p_eff_date, 'YYYY'))
                OR (booking_year = TO_NUMBER(TO_CHAR(p_eff_date, 'YYYY'))
               AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| booking_year), 'MM'))>= TO_NUMBER(TO_CHAR(p_eff_date, 'MM'))))                 
          ORDER BY 1, 2)
        LOOP
            p_booking_year := c.booking_year;       
            p_booking_mth  := c.booking_mth;              
            v_date_flag2 := 5;
            EXIT;
        END LOOP;
        
        IF v_date_flag2 <> 5 THEN
            p_booking_year := NULL;
            p_booking_mth := NULL;
        END IF;
    END IF;
END GIPIS031_VALIDATE_ISSUE_DATE01;
/



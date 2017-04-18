DROP PROCEDURE CPI.GET_BOOK_DATE_FOR_COPIED_PAR;

CREATE OR REPLACE PROCEDURE CPI.get_book_date_for_copied_par
    (p_issue_date    IN     GIPI_WPOLBAS.issue_date%TYPE,
    p_incept_date    IN     GIPI_WPOLBAS.incept_date%TYPE,
    p_booking_mth    OUT    GIPI_WPOLBAS.booking_mth%TYPE,
    p_booking_year   OUT    GIPI_WPOLBAS.booking_year%TYPE)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 14, 2011
**  Reference By : (GIPIS001 - PAR Listing)
**  Description  : This get new booking year and booking month for newly copied PAR. 
**				   		 
*/

    var_vdate                   GIIS_PARAMETERS.param_value_n%TYPE;

BEGIN
    FOR C IN (SELECT param_value_n
              FROM GIAC_PARAMETERS
              WHERE param_name = 'PROD_TAKE_UP')
    LOOP
        var_vdate := c.param_value_n;
    END LOOP;
    
    IF var_vdate > 3 THEN
        RAISE_APPLICATION_ERROR(-20000, 'The parameter value ('||TO_CHAR(var_vdate)||') for parameter name ''PROD_TAKE_UP'' is invalid. Please do the necessary changes.');
    END IF;        
    
    IF var_vdate = 1 OR
             (var_vdate = 3 AND p_issue_date > p_incept_date) THEN
         FOR C IN (SELECT booking_year,
                        TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| 
                        booking_year, 'DD-MON-RRRR'), 'MM'), booking_mth
                   FROM GIIS_BOOKING_MONTH
                   WHERE (NVL(booked_tag, 'N') != 'Y')
                   AND (booking_year > TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                   OR (booking_year = TO_NUMBER(TO_CHAR(p_issue_date, 'YYYY'))
                   AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| 
                        booking_year, 'DD-MON-RRRR'), 'MM'))>= TO_NUMBER(TO_CHAR(p_issue_date, 'MM'))))
                ORDER BY 1, 2 ) 
         LOOP
             p_booking_year := TO_NUMBER(c.booking_year);       
             p_booking_mth  := c.booking_mth;              
             EXIT;
         END LOOP;
                              
    ELSIF var_vdate = 2 OR
         (var_vdate = 3 AND p_issue_date <= p_incept_date) THEN
            FOR C IN (SELECT booking_year, 
                      TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| 
                      booking_year,  'DD-MONYYYY' ), 'MM'), booking_mth        -- jhing 10.06.2015 added date format mask GENQA SR# 5030
             FROM GIIS_BOOKING_MONTH
            WHERE (NVL(booked_tag, 'N') <> 'Y')
              AND (booking_year > TO_NUMBER(TO_CHAR(p_incept_date, 'YYYY'))
               OR (booking_year = TO_NUMBER(TO_CHAR(p_incept_date, 'YYYY'))
              AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(booking_mth,1, 3)|| 
                    booking_year,  'DD-MONYYYY' ), 'MM'))>= TO_NUMBER(TO_CHAR(p_incept_date, 'MM'))))    -- jhing 10.06.2015 added date format mask GENQA SR# 5030
            ORDER BY 1, 2 ) 
         LOOP
             p_booking_year := to_number(c.booking_year);       
             p_booking_mth  := c.booking_mth;              
             EXIT;
         END LOOP;                     
    END IF;
END;
/



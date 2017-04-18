DROP PROCEDURE CPI.GET_BOOK_DT;

CREATE OR REPLACE PROCEDURE CPI.Get_Book_Dt 
/*  Created by:  Aaron
**  Date Created: June 4, 2009
**  Remarks:  This procedure will retrieve the booking date to be saved 
**            in gipi_winvoice.  This procedure is used in GIPIS031 (refer 
**            to from procedure Create_winvoice1) and is called when 
**            when endorsement is endt_tax. 
*/
(v_booking_year OUT GIPI_WINVOICE.MULTI_BOOKING_YY%TYPE,
 v_booking_mth  OUT GIPI_WINVOICE.MULTI_BOOKING_MM%TYPE,
 p_yearly_tag   IN VARCHAR2,
 v_booking_date IN DATE,
 v_due_date     IN DATE,
 p_err          OUT NUMBER) 
IS

BEGIN
      
/*SELECT booking_year, booking_mth
  INTO v_booking_year, v_booking_mth
  FROM ( SELECT BOOKING_YEAR,
                TO_CHAR(TO_DATE('01-' || SUBSTR(booking_mth,1, 3) || '-' || booking_year, 'DD-MON-YYYY'), 'MON')
                BOOKING_MTH
           FROM GIIS_BOOKING_MONTH
          WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
            AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
                  OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
            AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3) || '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'))))
               ORDER BY 1, 2) A
 WHERE ROWNUM = 1;*/ -- replaced by: Nica 09.04.2012 to retrieve correct value of booking month
 
 SELECT booking_year, booking_mth
 	INTO v_booking_year, v_booking_mth
	FROM ( SELECT BOOKING_YEAR,
				  --TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'),
          TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'), -- andrew - 09.18.2012 - added date pattern
				  BOOKING_MTH
			 FROM GIIS_BOOKING_MONTH
			WHERE ( NVL(BOOKED_TAG, 'N') <> 'Y')
			  AND (BOOKING_YEAR > TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
			   OR (BOOKING_YEAR = TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'YYYY'))
			  --AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| BOOKING_YEAR), 'MM'))>= TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM'))))
        AND TO_NUMBER(TO_CHAR(TO_DATE('01-'||SUBSTR(BOOKING_MTH,1, 3)|| '-' || BOOKING_YEAR, 'DD-MON-YYYY'), 'MM'))>= TO_NUMBER(TO_CHAR(DECODE(p_yearly_tag, 'Y', v_booking_date, v_due_date), 'MM')))) -- andrew - 09.18.2012 - added date pattern
		 ORDER BY 1, 2) A
	WHERE ROWNUM = 1 ;  
 EXCEPTION
 WHEN NO_DATA_FOUND THEN
   p_err := 1;  -- p_err = 1 will prompt GIPIS031 to display message to check maintenance table
END;
/



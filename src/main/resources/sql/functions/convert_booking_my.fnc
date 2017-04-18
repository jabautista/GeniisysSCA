DROP FUNCTION CPI.CONVERT_BOOKING_MY;

CREATE OR REPLACE FUNCTION CPI.convert_booking_my (
   v_booking_mth    gipi_polbasic.booking_mth%TYPE,
   v_booking_year   gipi_polbasic.booking_year%TYPE
)
/*
||  Author: Terrence To
||
||  Overview: Converts Booking Month / Year to Date format mm-dd-yyyy
||
||  Major Modifications(when, who, what):
||  04/12/2002 - TRN - Create function
||
*/
   RETURN VARCHAR2
IS
   v_booking_date   DATE := NULL;
BEGIN
   v_booking_date := TO_DATE (
                           v_booking_mth
                        || '01'
                        || TO_CHAR (v_booking_year),
                        'MM-DD-YYYY'
                     );
   RETURN (v_booking_date);
END convert_booking_my;
/



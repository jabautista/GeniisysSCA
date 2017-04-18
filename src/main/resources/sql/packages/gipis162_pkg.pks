CREATE OR REPLACE PACKAGE CPI.GIPIS162_PKG
AS

    TYPE gipis162_type IS RECORD(
        booking_mth     GIIS_BOOKING_MONTH.BOOKING_MTH%TYPE,
        booking_year    GIIS_BOOKING_MONTH.BOOKING_YEAR%TYPE,
        booked_tag      GIIS_BOOKING_MONTH.BOOKED_TAG%TYPE,
        remarks         GIIS_BOOKING_MONTH.REMARKS%TYPE,
        last_update     GIIS_BOOKING_MONTH.LAST_UPDATE%TYPE,
        user_id         GIIS_BOOKING_MONTH.USER_ID%TYPE
    );
    
    TYPE gipis162_tab IS TABLE OF gipis162_type;
    
    FUNCTION get_booking_list
    RETURN gipis162_tab PIPELINED; 
    
    PROCEDURE generate_booking_months(
        p_booking_year  GIIS_BOOKING_MONTH.BOOKING_YEAR%TYPE,
        p_user_id       GIIS_BOOKING_MONTH.USER_ID%TYPE
    );   
    
    
END GIPIS162_PKG;
/



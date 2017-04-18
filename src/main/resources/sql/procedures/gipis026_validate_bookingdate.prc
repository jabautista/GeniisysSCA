DROP PROCEDURE CPI.GIPIS026_VALIDATE_BOOKINGDATE;

CREATE OR REPLACE PROCEDURE CPI.gipis026_validate_bookingdate(
    p_eff_date        VARCHAR2, 
    p_expiry_date     VARCHAR2,   
    p_sel_bdate       VARCHAR2, 
    p_old_bdate       VARCHAR2, 
    p_nxt_bdate       VARCHAR2, 
    p_prev_bdate      VARCHAR2
   )
IS
BEGIN
    IF (TO_DATE(p_sel_bdate, 'MM-DD-YYYY') < TRUNC(TO_DATE(p_eff_date, 'MM-DD-YYYY'), 'MONTH')) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking month schedule must not be earlier than the inception date of the policy.');
    ELSIF(TO_DATE(p_sel_bdate, 'MM-DD-YYYY') > TO_DATE(p_expiry_date, 'MM-DD-YYYY')) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking date schedule must not be later than the expiry date of the policy.');
    ELSIF(TO_DATE(p_sel_bdate, 'MM-DD-YYYY') < TRUNC(TO_DATE(p_old_bdate, 'MM-DD-YYYY'), 'MON')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking date schedule must be in proper sequence.');
    ELSIF(TO_DATE(p_sel_bdate, 'MM-DD-YYYY') > TO_DATE(p_nxt_bdate, 'MM-DD-YYYY')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking date schedule must be in proper sequence.');
    ELSIF(TO_DATE(p_sel_bdate, 'MM-DD-YYYY') >= TO_DATE(p_nxt_bdate, 'MM-DD-YYYY')) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking date schedule must be in proper sequence.');
    ELSIF(TO_DATE(p_sel_bdate, 'MM-DD-YYYY') <= TO_DATE(p_prev_bdate, 'MM-DD-YYYY')) THEN --belle 09022012
        RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Booking date schedule must be in proper sequence.');
    END IF; 
END;
/



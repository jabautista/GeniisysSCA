CREATE OR REPLACE TRIGGER CPI.WINVOICE_TBIXX
--  Created by    : Cherrie Love L. Perello
--  Date Created    : July 29, 2011
--  Description    : This trigger will fire after inserting record on gipi_winvoice,
--                   it will copy the value of booking_mth and booking_year columns of gipi_wpolbas table to
--                   multi_booking_mm and multi_booking_yy columns of gipi_winvoice when new inserted record 
--                   pack_par_id is not null.
    BEFORE INSERT OR UPDATE
ON CPI.GIPI_WINVOICE FOR EACH ROW
DECLARE
    v_pack_par_id     gipi_winvoice.par_id%TYPE;
    v_booking_mm      gipi_winvoice.multi_booking_mm%TYPE;
    v_booking_yy      gipi_winvoice.multi_booking_yy%TYPE;   
BEGIN
    v_pack_par_id := NULL;

    SELECT pack_par_id, 
           booking_mth, 
           booking_year
      INTO v_pack_par_id,
           v_booking_mm, 
           v_booking_yy
      FROM gipi_wpolbas
     WHERE par_id = :NEW.par_id;
     

   IF v_pack_par_id IS NOT NULL  THEN
          
      :NEW.multi_booking_mm := v_booking_mm;
      :NEW.multi_booking_yy := v_booking_yy;
           
   END IF;
   
   -- bonok :: 6.14.2016 :: UCPB SR 22472     
	IF :NEW.item_grp IS NULL THEN
      :NEW.item_grp := 1;
   END IF;

END;
/



DROP PROCEDURE CPI.B540_BOOKYR_WVI_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Bookyr_Wvi_B_Gipis002
  (b540_booking_year IN NUMBER,
   b540_booking_mth IN VARCHAR2,
   v_tag OUT VARCHAR2) IS
BEGIN
  FOR booked IN (
         SELECT NVL(booked_tag, 'N') booked_tag
           FROM GIIS_BOOKING_MONTH
          WHERE booking_year =  b540_booking_year
            AND booking_mth  =  b540_booking_mth)
     LOOP
       v_tag := booked.booked_tag;
     END LOOP;
END;
/



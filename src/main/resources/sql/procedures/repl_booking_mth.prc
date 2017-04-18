DROP PROCEDURE CPI.REPL_BOOKING_MTH;

CREATE OR REPLACE PROCEDURE CPI.repl_booking_mth
         (p_booking_mth   IN gipi_polbasic.booking_mth%TYPE,
           v_prod_mm    OUT  NUMBER )IS
BEGIN
  IF UPPER(p_booking_mth) = 'JANUARY' THEN
    v_prod_mm := 1;
  ELSIF UPPER(p_booking_mth) = 'FEBRUARY' THEN
    v_prod_mm := 2;
  ELSIF UPPER(p_booking_mth) = 'MARCH' THEN
    v_prod_mm := 3;
  ELSIF UPPER(p_booking_mth) = 'APRIL' THEN
    v_prod_mm := 4;
  ELSIF UPPER(p_booking_mth) = 'MAY' THEN
    v_prod_mm := 5;
  ELSIF UPPER(p_booking_mth) = 'JUNE' THEN
    v_prod_mm := 6;
  ELSIF UPPER(p_booking_mth) = 'JULY' THEN
    v_prod_mm := 7;
  ELSIF UPPER(p_booking_mth) = 'AUGUST' THEN
    v_prod_mm := 8;
  ELSIF UPPER(p_booking_mth) = 'SEPTEMBER' THEN
    v_prod_mm := 9;
  ELSIF UPPER(p_booking_mth) = 'OCTOBER' THEN
    v_prod_mm := 10;
  ELSIF UPPER(p_booking_mth) = 'NOVEMBER' THEN
    v_prod_mm := 11;
  ELSIF UPPER(p_booking_mth) = 'DECEMBER' THEN
    v_prod_mm := 12;
  ELSE
    RAISE_APPLICATION_ERROR(-20001,'The booking month is incorrect');
  END IF;
END;
/



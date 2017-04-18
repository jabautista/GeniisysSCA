DROP PROCEDURE CPI.GIPIS002A_PRE_COMMIT_INVOICE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_PRE_COMMIT_INVOICE
   (p_booking_year IN NUMBER,
    p_booking_mth IN VARCHAR2,
    p_pack_par_id IN NUMBER) IS    
BEGIN

  FOR i IN (SELECT par_id
              FROM gipi_parlist
             WHERE pack_par_id = p_pack_par_id)
  LOOP
      UPDATE GIPI_WINVOICE
         SET multi_booking_yy = p_booking_year, 
             multi_booking_mm = p_booking_mth
       WHERE par_id = i.par_id
         AND takeup_seq_no = 1;  
  END LOOP;

END;
/



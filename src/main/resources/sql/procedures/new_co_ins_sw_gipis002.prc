DROP PROCEDURE CPI.NEW_CO_INS_SW_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.New_Co_Ins_Sw_Gipis002
  (b240_par_id IN NUMBER,
   rec_cnt IN OUT NUMBER) IS
BEGIN
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_ORIG_INVPERL
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_ORIG_INV_TAX
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_ORIG_INVOICE
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_ORIG_ITMPERIL
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_CO_INSURER
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
     FOR A1 IN(SELECT 'A' 
                 FROM GIPI_MAIN_CO_INS
         WHERE  par_id  = b240_par_id) LOOP
         rec_cnt := rec_cnt + 1;
     END LOOP;
END;
/



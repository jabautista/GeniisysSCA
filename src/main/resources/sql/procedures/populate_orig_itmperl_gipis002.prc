DROP PROCEDURE CPI.POPULATE_ORIG_ITMPERL_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Populate_Orig_Itmperl_Gipis002
  (b240_par_id IN NUMBER,
   b540_co_insurance_sw IN VARCHAR2) IS
BEGIN
     DELETE FROM GIPI_ORIG_COMM_INV_PERIL
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_ORIG_COMM_INVOICE
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_ORIG_INVPERL
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_ORIG_INV_TAX
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_ORIG_INVOICE
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_ORIG_ITMPERIL
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_CO_INSURER
       WHERE  par_id  = b240_par_id;
     DELETE FROM GIPI_MAIN_CO_INS
       WHERE  par_id  = b240_par_id;
  IF b540_co_insurance_sw = '2' THEN     
     FOR A IN(SELECT item_no, line_cd, peril_cd, rec_flag,
                     prem_rt, DECODE(NVL(prem_rt,0),0,0,((prem_amt/prem_rt) * 100)) prem_amt,
                     DECODE(NVL(prem_rt,0),0,0,((tsi_amt/prem_rt) * 100)) tsi_amt
                FROM GIPI_WITMPERL
               WHERE par_id = b240_par_id)
     LOOP
       INSERT INTO GIPI_ORIG_ITMPERIL(par_id,       item_no,      line_cd,    peril_cd, 
                                      rec_flag,     prem_rt,      prem_amt,   tsi_amt)
                               VALUES(b240_par_id, A.item_no,    A.line_cd,  A.peril_cd,
                                      A.rec_flag,   A.prem_rt,    A.prem_amt, A.tsi_amt);
     END LOOP;
  END IF;     
END;
/



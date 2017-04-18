DROP PROCEDURE CPI.UPD_GIPI_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.upd_gipi_wpolbas(p_par_id  IN  NUMBER) IS
BEGIN
  /* Fetch records from GIPI_WITEM.
  */
  FOR A1 IN (
    SELECT SUM(NVL(tsi_amt,0)     *NVL(currency_rt,1))      TSI,
           SUM(NVL(prem_amt,0)    *NVL(currency_rt,1))     PREM,
           SUM(NVL(ann_tsi_amt,0) *NVL(currency_rt,1))  ANN_TSI,
           SUM(NVL(ann_prem_amt,0)*NVL(currency_rt,1)) ANN_PREM
      FROM gipi_witem
     WHERE par_id = p_par_id) LOOP
    /* Update basic information with respect to the
    ** fetch records from GIPI_WITEM.
    */
    FOR A2 IN (
     SELECT   par_id
       FROM   gipi_wpolbas
      WHERE   par_id  =  p_par_id
              FOR UPDATE) LOOP
        UPDATE gipi_wpolbas
           SET gipi_wpolbas.tsi_amt =      A1.TSI,
               gipi_wpolbas.prem_amt =     A1.PREM,
               gipi_wpolbas.ann_tsi_amt =  A1.ann_tsi,
               gipi_wpolbas.ann_prem_amt = A1.ann_prem
         WHERE gipi_wpolbas.par_id = A2.par_id;
        EXIT;
     END LOOP;
     EXIT;
  END LOOP;
END;
/



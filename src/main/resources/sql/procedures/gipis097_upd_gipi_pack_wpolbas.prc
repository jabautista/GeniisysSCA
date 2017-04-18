DROP PROCEDURE CPI.GIPIS097_UPD_GIPI_PACK_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.gipis097_upd_gipi_pack_wpolbas(p_pack_par_id  IN  NUMBER) IS
BEGIN
  /* Fetch records from GIPI_WPOLBAS.
  */
  FOR A1 IN (
    SELECT SUM(NVL(tsi_amt,0)) tsi, 
           SUM(NVL(prem_amt,0)) prem, 
           SUM(NVL(ann_tsi_amt,0)) ann_tsi, 
           SUM(NVL(ann_prem_amt,0)) ann_prem
      FROM gipi_wpolbas
     WHERE EXISTS (SELECT 1
                     FROM gipi_parlist z
                    WHERE z.par_id = gipi_wpolbas.par_id
                      AND z.par_status NOT IN (98,99)
                      AND z.pack_par_id = p_pack_par_id)) LOOP
    /* Update package basic information with respect to the
    ** fetch records from GIPI_WPOLBAS.
    */
    UPDATE gipi_pack_wpolbas
       SET tsi_amt =      A1.TSI,
           prem_amt =     A1.PREM,
           ann_tsi_amt =  A1.ann_tsi,
           ann_prem_amt = A1.ann_prem
     WHERE pack_par_id = p_pack_par_id;
     EXIT;
  END LOOP;
END;
/



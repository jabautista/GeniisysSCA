DROP PROCEDURE CPI.GIPIS172_UPD_GIPI_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.gipis172_upd_gipi_wpolbas (p_par_id IN NUMBER)
IS
BEGIN
   FOR a2 IN (SELECT     par_id
                    FROM gipi_wpolbas
                   WHERE par_id = p_par_id
              FOR UPDATE)
   LOOP
      UPDATE gipi_wpolbas
         SET gipi_wpolbas.tsi_amt = '',
             gipi_wpolbas.prem_amt = '',
             gipi_wpolbas.ann_tsi_amt = '',
             gipi_wpolbas.ann_prem_amt = ''
       WHERE gipi_wpolbas.par_id = p_par_id;

      EXIT;
   END LOOP;
END;
/



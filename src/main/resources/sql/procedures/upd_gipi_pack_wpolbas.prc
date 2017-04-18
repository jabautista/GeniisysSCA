DROP PROCEDURE CPI.UPD_GIPI_PACK_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.UPD_GIPI_PACK_WPOLBAS (p_pack_par_id IN NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Updates the tsi_amt, prem_amt, ann_tsi_amt, and ann_prem_amt of tables gipi_wpolbas and gipi_pack_wpolbas	
	*/
BEGIN
	FOR A1 IN (
		SELECT par_id, 
			   SUM(NVL(tsi_amt,0) * NVL(currency_rt,1)) tsi,
			   SUM(NVL(prem_amt,0) * NVL(currency_rt,1)) prem,
			   SUM(NVL(ann_tsi_amt,0) * NVL(currency_rt,1)) ann_tsi,
			   SUM(NVL(ann_prem_amt,0) * NVL(currency_rt,1)) ann_prem
		  FROM gipi_witem
		 WHERE EXISTS (SELECT 1
						 FROM gipi_parlist z
						WHERE z.par_id = gipi_witem.par_id
						  AND z.par_status NOT IN (98,99)
						  AND z.pack_par_id = p_pack_par_id)
	  GROUP BY par_id)
	LOOP
		gipi_wpolbas_pkg.update_gipi_wpolbas_amounts(A1.par_id, A1.tsi, A1.ann_tsi, A1.prem, A1.ann_prem);		
	END LOOP;
	
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
						  AND z.pack_par_id = p_pack_par_id))
	LOOP
		gipi_pack_wpolbas_pkg.update_pack_polbas(p_pack_par_id, A1.tsi, A1.prem, A1.ann_tsi, A1.ann_prem);        
        EXIT;
    END LOOP;
END UPD_GIPI_PACK_WPOLBAS;
/



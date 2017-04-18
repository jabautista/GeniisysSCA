DROP PROCEDURE CPI.GIPIS010_UPD_GIPI_WPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Upd_Gipi_Wpolbas (p_par_id  IN  NUMBER)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.08.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Update GIPI_WPOLBAS.
	*/
	v_tsi        GIPI_WITEM.tsi_amt%TYPE;
	v_prem       GIPI_WITEM.prem_amt%TYPE;
	v_ann_tsi    GIPI_WITEM.ann_tsi_amt%TYPE;
	v_ann_prem   GIPI_WITEM.ann_prem_amt%TYPE;
BEGIN
	SELECT SUM(NVL(tsi_amt,0)*NVL(currency_rt,1)), 
		   SUM(NVL(prem_amt,0)*NVL(currency_rt,1)),
		   SUM(NVL(ann_tsi_amt,0)*NVL(currency_rt,1)), 
		   SUM(NVL(ann_prem_amt,0)*NVL(currency_rt,1))
	  INTO v_tsi, 
		   v_prem, 
		   v_ann_tsi, 
		   v_ann_prem
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id;
  
	UPDATE GIPI_WPOLBAS
	   SET GIPI_WPOLBAS.tsi_amt =  v_tsi,
		   GIPI_WPOLBAS.prem_amt = v_prem,
		   GIPI_WPOLBAS.ann_tsi_amt = v_ann_tsi,
		   GIPI_WPOLBAS.ann_prem_amt = v_ann_prem
	 WHERE GIPI_WPOLBAS.par_id = p_par_id;
END;
/



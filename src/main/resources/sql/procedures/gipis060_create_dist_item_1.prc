DROP PROCEDURE CPI.GIPIS060_CREATE_DIST_ITEM_1;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_CREATE_DIST_ITEM_1 (
	p_par_id 	GIPI_WITEM.par_id%TYPE,
	p_dist_no	NUMBER)
IS
	v_tsi_amt      GIPI_WITEM.tsi_amt%TYPE := 0;
	v_ann_tsi_amt  GIPI_WITEM.ann_tsi_amt%TYPE := 0;
	v_prem_amt     GIPI_WITEM.prem_amt%TYPE := 0;
BEGIN
	SELECT SUM(tsi_amt     * currency_rt),
		   SUM(ann_tsi_amt * currency_rt),
		   SUM(prem_amt    * currency_rt)
	  INTO v_tsi_amt,
		   v_ann_tsi_amt,
		   v_prem_amt
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id;
       
    IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
		Gipis010_Delete_Ri_Tables(p_dist_no);
		Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);
		Gipis010_Del_Main_Dist_Tables(p_dist_no);
		GIUW_DISTREL_PKG.del_giuw_distrel(p_dist_no);
		GIUW_POL_DIST_PKG.del_giuw_pol_dist(p_dist_no);		
    END IF;
END;
/



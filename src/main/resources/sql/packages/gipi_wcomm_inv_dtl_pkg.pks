CREATE OR REPLACE PACKAGE CPI.GIPI_WCOMM_INV_DTL_PKG AS

	   PROCEDURE del_gipi_wcomm_inv_dtl (
			p_par_id				GIPI_WCOMM_INV_DTL.par_id%TYPE,
			p_item_grp				GIPI_WCOMM_INV_DTL.item_grp%TYPE,
			p_intrmdry_intm_no		GIPI_WCOMM_INV_DTL.intrmdry_intm_no%TYPE);
			
	   PROCEDURE del_gipi_wcomm_inv_dtl2 (
			p_par_id				GIPI_WCOMM_INV_DTL.par_id%TYPE,
			p_item_grp				GIPI_WCOMM_INV_DTL.item_grp%TYPE,
			p_intrmdry_intm_no		GIPI_WCOMM_INV_DTL.intrmdry_intm_no%TYPE,
			p_takeup_seq_no			GIPI_WCOMM_INV_DTL.takeup_seq_no%TYPE);

END GIPI_WCOMM_INV_DTL_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIPI_WCOMM_INV_DTL_PKG AS

	    PROCEDURE del_gipi_wcomm_inv_dtl (
			p_par_id				GIPI_WCOMM_INV_DTL.par_id%TYPE,
			p_item_grp				GIPI_WCOMM_INV_DTL.item_grp%TYPE,
			p_intrmdry_intm_no		GIPI_WCOMM_INV_DTL.intrmdry_intm_no%TYPE)IS
		BEGIN
			DELETE GIPI_WCOMM_INV_DTL
		     WHERE par_id = p_par_id
		       AND item_grp = p_item_grp
		       AND intrmdry_intm_no = p_intrmdry_intm_no;
		END del_gipi_wcomm_inv_dtl;

		PROCEDURE del_gipi_wcomm_inv_dtl2 (
			p_par_id				GIPI_WCOMM_INV_DTL.par_id%TYPE,
			p_item_grp				GIPI_WCOMM_INV_DTL.item_grp%TYPE,
			p_intrmdry_intm_no		GIPI_WCOMM_INV_DTL.intrmdry_intm_no%TYPE,
			p_takeup_seq_no			GIPI_WCOMM_INV_DTL.takeup_seq_no%TYPE)IS
		BEGIN
			DELETE FROM GIPI_WCOMM_INV_DTL
		     WHERE par_id = p_par_id
		       AND item_grp = p_item_grp
		       AND intrmdry_intm_no = p_intrmdry_intm_no
			   AND takeup_seq_no	= p_takeup_seq_no;
		END del_gipi_wcomm_inv_dtl2;

END GIPI_WCOMM_INV_DTL_PKG;
/



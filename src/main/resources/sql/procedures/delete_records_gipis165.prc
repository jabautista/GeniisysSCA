DROP PROCEDURE CPI.DELETE_RECORDS_GIPIS165;

CREATE OR REPLACE PROCEDURE CPI.DELETE_RECORDS_GIPIS165(
	p_par_id	IN	gipi_wpolbas.par_id%TYPE
)
AS
BEGIN
	DELETE FROM gipi_winstallment
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_wcomm_inv_perils
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_wcomm_invoices
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_winvperl
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_winv_tax
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_wpackage_inv_tax
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_winvoice
	 WHERE  par_id  =  p_par_id;
	DELETE FROM gipi_orig_invperl
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_orig_inv_tax
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_orig_invoice
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_orig_itmperil
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_co_insurer
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_main_co_ins
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_wpolbas_discount
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_witem_discount
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_wperil_discount
	 WHERE  par_id  = p_par_id;
	DELETE FROM gipi_witmperl
	 WHERE  par_id  = p_par_id;
	--DELETE_CO_INS(p_par_id);
	DELETE FROM gipi_witem
	 WHERE  par_id  = p_par_id;
	 
	/*UPDATE gipi_parlist
	   SET par_status = 5
	 WHERE par_id = p_par_id;*/
	 
	UPDATE gipi_wpolbas
	   SET cancelled_endt_id = NULL
	 WHERE par_id = p_par_id;
	 
END DELETE_RECORDS_GIPIS165;
/



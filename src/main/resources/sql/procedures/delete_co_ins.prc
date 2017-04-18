DROP PROCEDURE CPI.DELETE_CO_INS;

CREATE OR REPLACE PROCEDURE CPI.DELETE_CO_INS (
	p_par_id			IN GIPI_WPOLBAS.par_id%TYPE,
	p_co_insurance_sw	IN	GIPI_WPOLBAS.co_insurance_sw%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.01.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: This procedure deletes record based on the given par_id	
	*/
BEGIN
	IF p_co_insurance_sw = '3' THEN
		Gipi_Co_Insurer_Pkg.del_gipi_co_insurer(p_par_id);
		Gipi_Main_Co_Ins_Pkg.del_gipi_main_co_ins(p_par_id);
	ELSIF p_co_insurance_sw = '2' THEN
		Gipi_Orig_Comm_Inv_Peril_Pkg.del_gipi_orig_comm_inv_peril(p_par_id);
		Gipi_Orig_Comm_Invoice_Pkg.del_gipi_orig_comm_invoice(p_par_id);
		Gipi_Orig_Inv_Tax_Pkg.del_gipi_orig_inv_tax(p_par_id);
		Gipi_Orig_Invperl_Pkg.del_gipi_orig_invperl(p_par_id);
		Gipi_Orig_Invoice_Pkg.del_gipi_orig_invoice(p_par_id);
		Gipi_Orig_Itmperil_Pkg.del_gipi_orig_itmperil(p_par_id);
		Gipi_Co_Insurer_Pkg.del_gipi_co_insurer(p_par_id);
		Gipi_Main_Co_Ins_Pkg.del_gipi_main_co_ins(p_par_id);
	END IF;
END DELETE_CO_INS;
/



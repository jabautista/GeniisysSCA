DROP PROCEDURE CPI.GIPIS010_PPLATE_ORIG_ITMPERIL;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Pplate_Orig_Itmperil (p_par_id 	GIPI_PARLIST.par_id%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete record/s on the following table
	**					  GIPI_ORIG_COMM_INV_PERIL, GIPI_ORIG_COMM_INVOICE, GIPI_ORIG_INVPERL,
	**					  GIPI_ORIG_INV_TAX, GIPI_ORIG_INVOICE, GIPI_ORIG_ITMPERIL,
	**					  GIPI_CO_INSURER, GIPI_MAIN_CO_INS
	*/
BEGIN
	Gipi_Orig_Comm_Inv_Peril_Pkg.del_gipi_orig_comm_inv_peril(p_par_id);
	Gipi_Orig_Comm_Invoice_Pkg.del_gipi_orig_comm_invoice(p_par_id);
	Gipi_Orig_Invperl_Pkg.del_gipi_orig_invperl(p_par_id);
	Gipi_Orig_Inv_Tax_Pkg.del_gipi_orig_inv_tax(p_par_id);
	Gipi_Orig_Invoice_Pkg.del_gipi_orig_invoice(p_par_id);
	Gipi_Orig_Itmperil_Pkg.del_gipi_orig_itmperil(p_par_id);
	Gipi_Co_Insurer_Pkg.del_gipi_co_insurer(p_par_id);
	Gipi_Main_Co_Ins_Pkg.del_gipi_main_co_ins(p_par_id);
END;
/



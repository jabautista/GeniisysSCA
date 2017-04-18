DROP PROCEDURE CPI.GIPIS031_DEL_RECS_FOR_ENDT_TAX;

CREATE OR REPLACE PROCEDURE CPI.GIPIS031_DEL_RECS_FOR_ENDT_TAX (p_par_id IN GIPI_PARLIST.par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.19.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Delete records on the following table using the given par_id	
	*/
BEGIN
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
	Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
	Gipi_Winv_Tax_Pkg.del_gipi_winv_tax_1(p_par_id);
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
	Gipi_Winvoice_Pkg.del_gipi_winvoice1(p_par_id);
END GIPIS031_DEL_RECS_FOR_ENDT_TAX;
/



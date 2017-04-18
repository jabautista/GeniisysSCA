DROP PROCEDURE CPI.GIPIS010_DELETE_BILL;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Delete_Bill (p_par_id IN GIPI_WITEM.par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete records on the following tables
	*/
BEGIN	
	Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);	
	Gipi_Wcomm_Inv_Perils_Pkg.del_gipi_wcomm_inv_perils1(p_par_id);     
	Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);     
	Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);     
	Gipi_Winv_Tax_Pkg.del_all_gipi_winv_tax(p_par_id);     
	Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);     
	Gipi_Winvoice_Pkg.del_gipi_winvoice(p_par_id);
END Gipis010_Delete_Bill;
/



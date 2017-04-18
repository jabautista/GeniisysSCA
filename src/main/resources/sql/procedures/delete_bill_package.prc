DROP PROCEDURE CPI.DELETE_BILL_PACKAGE;

CREATE OR REPLACE PROCEDURE CPI.DELETE_BILL_PACKAGE (p_pack_par_id IN NUMBER)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Delete records on the following table based on the given paack_par_id
	*/
BEGIN
	FOR A IN (
		SELECT par_id
		  FROM gipi_parlist
		 WHERE pack_par_id = p_pack_par_id)
	LOOP
		gipi_winstallment_pkg.del_gipi_winstallment_1(a.par_id);
		gipi_wcomm_inv_perils_pkg.del_gipi_wcomm_inv_perils1(a.par_id);
        gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(a.par_id);
        gipi_winvperl_pkg.del_gipi_winvperl_1(a.par_id);
        gipi_winv_tax_pkg.del_gipi_winv_tax_1(a.par_id);
        gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(a.par_id);
        gipi_winvoice_pkg.del_gipi_winvoice1(a.par_id);
        gipi_pack_winstallment_pkg.del_gipi_pack_winstallment(p_pack_par_id);
        gipi_pack_winvperl_pkg.del_gipi_pack_winvperl(p_pack_par_id);
        gipi_pack_winv_tax_pkg.del_gipi_pack_winv_tax(p_pack_par_id);
        gipi_pack_winvoice_pkg.del_gipi_pack_winvoice(p_pack_par_id);
    END LOOP;
END DELETE_BILL_PACKAGE;
/



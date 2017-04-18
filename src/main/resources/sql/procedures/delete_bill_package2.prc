DROP PROCEDURE CPI.DELETE_BILL_PACKAGE2;

CREATE OR REPLACE PROCEDURE CPI.DELETE_BILL_PACKAGE2(p_par_id IN GIPI_PARLIST.PAR_ID%TYPE,
                                                 p_pack_par_id IN NUMBER)
AS
    /*
    **  Created by      : Steven Ramirez
    **  Date Created    : 06.06.2013
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Delete records on the following table based on the given par_id in the package PAR
    */
BEGIN
    gipi_winstallment_pkg.del_gipi_winstallment_1(p_par_id);
    gipi_wcomm_inv_perils_pkg.del_gipi_wcomm_inv_perils1(p_par_id);
    gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(p_par_id);
    gipi_winvperl_pkg.del_gipi_winvperl_1(p_par_id);
    gipi_winv_tax_pkg.del_gipi_winv_tax_1(p_par_id);
    gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(p_par_id);
    gipi_winvoice_pkg.del_gipi_winvoice1(p_par_id);
            
    gipi_pack_winstallment_pkg.del_gipi_pack_winstallment(p_pack_par_id);
    gipi_pack_winvperl_pkg.del_gipi_pack_winvperl(p_pack_par_id);
    gipi_pack_winv_tax_pkg.del_gipi_pack_winv_tax(p_pack_par_id);
    gipi_pack_winvoice_pkg.del_gipi_pack_winvoice(p_pack_par_id);
END DELETE_BILL_PACKAGE2;
/



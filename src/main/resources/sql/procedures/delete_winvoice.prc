DROP PROCEDURE CPI.DELETE_WINVOICE;

CREATE OR REPLACE PROCEDURE CPI.DELETE_WINVOICE (p_par_id   GIPI_WINVOICE.par_id%TYPE) 
IS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  July 26, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to delete records from tables related to par invoice. 
*/  
BEGIN
  GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils1(p_par_id);
  GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_par_id); 
  GIPI_WINVPERL_PKG.del_gipi_winvperl_1(p_par_id);
  GIPI_WINV_TAX_PKG.del_gipi_winv_tax_1(p_par_id);
  GIPI_WINSTALLMENT_PKG.del_gipi_winstallment_1(p_par_id);
  GIPI_WINVOICE_PKG.del_gipi_winvoice(p_par_id);
END DELETE_WINVOICE;
/



DROP PROCEDURE CPI.POPULATE_ORIG_ITMPERIL3;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ORIG_ITMPERIL3 (p_par_id GIPI_WITMPERL.par_id%TYPE)
IS
/*
**  Created by   : Menandro G.C. Robes
**  Date Created : June 29, 2010
**  Reference By : (GIPIS097 - Endt Item Peril Information)
**  Description  : Procedure to call the delete procedures of the related tables.
*/  
BEGIN
  GIPI_ORIG_COMM_INV_PERIL_PKG.DEL_GIPI_ORIG_COMM_INV_PERIL(p_par_id);
  GIPI_ORIG_COMM_INVOICE_PKG.DEL_GIPI_ORIG_COMM_INVOICE(p_par_id);
  GIPI_ORIG_INVPERL_PKG.DEL_GIPI_ORIG_INVPERL(p_par_id);
  GIPI_ORIG_INV_TAX_PKG.DEL_GIPI_ORIG_INV_TAX(p_par_id);
  GIPI_ORIG_INVOICE_PKG.DEL_GIPI_ORIG_INVOICE(p_par_id);
  GIPI_ORIG_ITMPERIL_PKG.DEL_GIPI_ORIG_ITMPERIL(p_par_id);
  GIPI_CO_INSURER_PKG.DEL_GIPI_CO_INSURER(p_par_id);
  GIPI_MAIN_CO_INS_PKG.DEL_GIPI_MAIN_CO_INS(p_par_id);
END POPULATE_ORIG_ITMPERIL3;
/



DROP PROCEDURE CPI.GIPIS010_CREATE_INVOICE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Create_Invoice_Item (
	p_par_id 	IN GIPI_WITMPERL.par_id%TYPE,
	p_line_cd	IN GIIS_TAX_CHARGES.line_cd%TYPE,
	p_iss_cd	IN GIIS_TAX_CHARGES.iss_cd%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information - Motorcar)
	**					: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Call the stored procedure that will create/update
    **                       the invoice tables based on the changes made in the
    **                       GIPI_WITEM table (original description)
    */
    v_exist    NUMBER;
BEGIN    
    SELECT DISTINCT 1
      INTO v_exist
      FROM GIPI_WITMPERL a, GIPI_WITEM b
     WHERE a.par_id   =  b.par_id
       AND a.par_id   =  p_par_id
       AND a.item_no  =  b.item_no
  GROUP BY b.par_id,b.item_grp,a.peril_cd;
  
    Gipis010_Pplate_Orig_Itmperil(p_par_id);
    Create_Winvoice(0, 0, 0, p_par_id, p_line_cd, p_iss_cd);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        Gipi_Winvperl_Pkg.del_gipi_winvperl_1(p_par_id);
        Gipi_Winv_Tax_Pkg.del_all_gipi_winv_tax(p_par_id);
        Gipi_Wpackage_Inv_Tax_Pkg.del_gipi_wpackage_inv_tax(p_par_id);
        Gipi_Winstallment_Pkg.del_gipi_winstallment_1(p_par_id);
        Gipi_Wcomm_Invoices_Pkg.del_gipi_wcomm_invoices_1(p_par_id);
        Gipi_Winvoice_Pkg.del_gipi_winvoice(p_par_id);
END Gipis010_Create_Invoice_Item;
/



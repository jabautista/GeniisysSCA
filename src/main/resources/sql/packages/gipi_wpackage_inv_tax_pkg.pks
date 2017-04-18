CREATE OR REPLACE PACKAGE CPI.Gipi_Wpackage_Inv_Tax_Pkg
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.11.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record by supplying the par_id only
    */
    PROCEDURE del_gipi_wpackage_inv_tax(p_par_id    gipi_wpackage_inv_tax.par_id%TYPE);
    
    PROCEDURE del_gipi_wpackage_inv_tax1 (
        p_par_id IN gipi_wpackage_inv_tax.par_id%TYPE,
        p_item_grp IN gipi_wpackage_inv_tax.item_grp%TYPE);
    
    PROCEDURE del_gipi_wpackage_inv_tax2 (
        p_par_id IN gipi_wpackage_inv_tax.par_id%TYPE,
        p_item_grp IN gipi_wpackage_inv_tax.item_grp%TYPE,
        p_line_cd IN gipi_wpackage_inv_tax.line_cd%TYPE);
END Gipi_Wpackage_Inv_Tax_Pkg;
/



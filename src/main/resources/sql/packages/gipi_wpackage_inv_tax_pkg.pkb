CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wpackage_Inv_Tax_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.11.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete record by supplying the par_id only
	*/
	PROCEDURE del_gipi_wpackage_inv_tax(p_par_id	gipi_wpackage_inv_tax.par_id%TYPE)
	IS
	BEGIN
		DELETE FROM gipi_wpackage_inv_tax
		 WHERE par_id = p_par_id;

	END del_gipi_wpackage_inv_tax;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.23.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Delete record from gipi_wpackage_inv_tax using the given parameters
    */
    PROCEDURE del_gipi_wpackage_inv_tax1 (
        p_par_id IN gipi_wpackage_inv_tax.par_id%TYPE,
        p_item_grp IN gipi_wpackage_inv_tax.item_grp%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_wpackage_inv_tax
         WHERE par_id = p_par_id
           AND item_grp = p_item_grp;
    END del_gipi_wpackage_inv_tax1;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.23.2011
    **  Reference By     : (GIPIS095 - Package Policy Items)
    **  Description     : Delete record from gipi_wpackage_inv_tax using the given parameters
    */
    PROCEDURE del_gipi_wpackage_inv_tax2 (
        p_par_id IN gipi_wpackage_inv_tax.par_id%TYPE,
        p_item_grp IN gipi_wpackage_inv_tax.item_grp%TYPE,
        p_line_cd IN gipi_wpackage_inv_tax.line_cd%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_wpackage_inv_tax
         WHERE par_id = p_par_id
           AND item_grp = p_item_grp
           AND line_cd = p_line_cd;
    END del_gipi_wpackage_inv_tax2;
END Gipi_Wpackage_Inv_Tax_Pkg;
/



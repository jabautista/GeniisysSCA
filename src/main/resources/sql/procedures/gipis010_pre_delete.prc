DROP PROCEDURE CPI.GIPIS010_PRE_DELETE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_PRE_DELETE (
	p_par_id	IN GIPI_WITEM.par_id%TYPE,
	p_item_no	IN GIPI_WITEM.item_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 08.24.2010
	**  Reference By 	: (GIPIS010 - Item Information - MC)
	**  Description 	: This procedure delete records on the following tables based on par_id and item_no
	*/
BEGIN
	Gipi_Witmperl_Pkg.del_gipi_witmperl_1(p_par_id, p_item_no);
	Gipi_Wperil_Discount_Pkg.del_gipi_wperil_discount_1(p_par_id, p_item_no);
	Gipi_Wdeductibles_Pkg.del_gipi_wdeductibles_item_2(p_par_id, p_item_no);
	Gipi_Wmortgagee_Pkg.del_gipi_wmortgagee_item(p_par_id, p_item_no);
	Gipi_Wmcacc_Pkg.del_gipi_wmcacc(p_par_id, p_item_no);
	Gipi_Wvehicle_Pkg.del_gipi_wvehicle(p_par_id, p_item_no);
END GIPIS010_PRE_DELETE;
/



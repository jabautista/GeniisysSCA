DROP PROCEDURE CPI.GIPIS060_DELETE_WINV_RECORDS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_DELETE_WINV_RECORDS(
	   p_par_id	   IN GIPI_WPOLBAS.par_id%TYPE)
IS
  /*
	**  Created by		: Emman
	**  Date Created 	: 06.24.2010
	**  Reference By 	: (GIPIS060 - Item Information)
	**  Description 	: Deletes records from GIPI_WINVPERL, GIPI_WINV_TAX, and GIPI_WINVOICE
	*/

BEGIN
  	  gipi_winvperl_pkg.del_gipi_winvperl_1(p_par_id);

	  gipi_winv_tax_pkg.del_all_gipi_winv_tax(p_par_id);

	  gipi_winvoice_pkg.del_gipi_winvoice(p_par_id);
END;
/



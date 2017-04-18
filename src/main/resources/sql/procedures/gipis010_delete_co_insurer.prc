DROP PROCEDURE CPI.GIPIS010_DELETE_CO_INSURER;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Delete_Co_Insurer (p_par_id IN GIPI_WITEM.par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete records on the following tables
	*/
BEGIN	
	Gipi_Co_Insurer_Pkg.del_gipi_co_insurer(p_par_id);  
	Gipi_Main_Co_Ins_Pkg.del_gipi_main_co_ins(p_par_id);  
END Gipis010_Delete_Co_Insurer;
/



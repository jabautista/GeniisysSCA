DROP PROCEDURE CPI.GIPIS010_DEL_WRKNG_DIST_TABLES;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Del_Wrkng_Dist_Tables (p_dist_no 	VARCHAR2)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete records on the following tables	
	*/
BEGIN
	Giuw_Witemperilds_Dtl_Pkg.del_giuw_witemperilds_dtl(p_dist_no);
	Giuw_Witemperilds_Pkg.del_giuw_witemperilds(p_dist_no);
	Giuw_Wperilds_Dtl_Pkg.del_giuw_wperilds_dtl(p_dist_no);
	Giuw_Witemds_Dtl_Pkg.del_giuw_witemds_dtl(p_dist_no);
	Giuw_Wpolicyds_Dtl_Pkg.del_giuw_wpolicyds_dtl(p_dist_no);
	Giuw_Wperilds_Pkg.del_giuw_wperilds(p_dist_no);
	Giuw_Witemds_Pkg.del_giuw_witemds(p_dist_no);
	Giuw_Wpolicyds_Pkg.del_giuw_wpolicyds(p_dist_no);
END;
/



DROP PROCEDURE CPI.GIPIS010_DEL_MAIN_DIST_TABLES;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Del_Main_Dist_Tables (p_dist_no 	NUMBER)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.26.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete record/s on the following tables	
	*/
BEGIN
	Giuw_Itemperilds_Dtl_Pkg.del_giuw_itemperilds_dtl(p_dist_no);
	Giuw_Itemperilds_Pkg.del_giuw_itemperilds(p_dist_no);
	Giuw_Perilds_Dtl_Pkg.del_giuw_perilds_dtl(p_dist_no);
	Giuw_Itemds_Dtl_Pkg.del_giuw_itemds_dtl(p_dist_no);
	Giuw_Policyds_Dtl_Pkg.del_giuw_policyds_dtl(p_dist_no);
	Giuw_Perilds_Pkg.del_giuw_perilds(p_dist_no);
	Giuw_Itemds_Pkg.del_giuw_itemds(p_dist_no);
	Giuw_Policyds_Pkg.del_giuw_policyds(p_dist_no);
END;
/



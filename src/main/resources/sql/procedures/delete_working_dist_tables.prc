DROP PROCEDURE CPI.DELETE_WORKING_DIST_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_WORKING_DIST_TABLES (pi_dist_no IN VARCHAR2) IS
	    /*
	    **  Created by   :  Emman
		**  Date Created :  06.24.10
		**  Reference By : (GIPIS060 - Endt Item Info)
		**  Description  : Executes procedure DELETE_WORKING_DIST_TABLES
		*/ 
BEGIN
        giuw_witemperilds_dtl_pkg.del_giuw_witemperilds_dtl(pi_dist_no);  
        giuw_witemperilds_pkg.del_giuw_witemperilds(pi_dist_no) ; 
	    giuw_wperilds_dtl_pkg.del_giuw_wperilds_dtl(pi_dist_no);
	    giuw_witemds_dtl_pkg.del_giuw_witemds_dtl(pi_dist_no);
	    giuw_wpolicyds_dtl_pkg.del_giuw_wpolicyds_dtl(pi_dist_no);
	    giuw_wperilds_pkg.del_giuw_wperilds(pi_dist_no);
	    giuw_witemds_pkg.del_giuw_witemds(pi_dist_no);
	    giuw_wpolicyds_pkg.del_giuw_wpolicyds(pi_dist_no);
END;
/



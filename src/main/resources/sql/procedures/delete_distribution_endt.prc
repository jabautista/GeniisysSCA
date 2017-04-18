DROP PROCEDURE CPI.DELETE_DISTRIBUTION_ENDT;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DISTRIBUTION_ENDT (p_dist_no	IN giuw_pol_dist.dist_no%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Delete records on certain tables
	*/
	CURSOR C1 IS
		SELECT DISTINCT frps_yy,
			   frps_seq_no
		  FROM giri_wdistfrps
		 WHERE dist_no = p_dist_no;
	CURSOR C2 IS
		SELECT DISTINCT  frps_yy,
			   frps_seq_no
		  FROM giri_distfrps
		 WHERE dist_no = p_dist_no;
BEGIN
	FOR C1_rec IN C1
	LOOP
		Giri_Wfrperil_Pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
		Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
	END LOOP;
	
	Giri_Wdistfrps_Pkg.del_giri_wdistfrps(p_dist_no);
	
	FOR C1_rec IN C2
	LOOP
        RAISE_APPLICATION_ERROR(20000, 'This PAR has corresponding records in the posted tables for RI.'||
                  ' Could not proceed.');
    END LOOP;
    
    DELETE_MAIN_DIST_TABLES(p_dist_no);
    
    Giuw_Witemperilds_Dtl_Pkg.del_giuw_witemperilds_dtl(p_dist_no);
    Giuw_Witemperilds_Pkg.del_giuw_witemperilds(p_dist_no);
    Giuw_Wperilds_Dtl_Pkg.del_giuw_wperilds_dtl(p_dist_no);
    Giuw_Witemds_Dtl_Pkg.del_giuw_witemds_dtl(p_dist_no);
    Giuw_Wpolicyds_Dtl_Pkg.del_giuw_wpolicyds_dtl(p_dist_no);
    Giuw_Wperilds_Pkg.del_giuw_wperilds(p_dist_no);
    Giuw_Witemds_Pkg.del_giuw_witemds(p_dist_no);
    Giuw_Wpolicyds_Pkg.del_giuw_wpolicyds(p_dist_no);
    Giuw_Distrel_Pkg.del_giuw_distrel(p_dist_no);
    Giuw_Pol_Dist_Pkg.del_giuw_pol_dist(p_dist_no);
END DELETE_DISTRIBUTION_ENDT;
/



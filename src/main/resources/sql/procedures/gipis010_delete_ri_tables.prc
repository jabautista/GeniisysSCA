DROP PROCEDURE CPI.GIPIS010_DELETE_RI_TABLES;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Delete_Ri_Tables(p_dist_no	GIUW_POL_DIST.dist_no%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete records on the following tables
	*/
BEGIN
	FOR A IN (
		SELECT a.pre_binder_id, b.line_cd, a.frps_yy, a.frps_seq_no
		  FROM GIRI_WFRPS_RI a, GIRI_WDISTFRPS b
		 WHERE a.line_cd = b.line_cd
		   AND a.frps_yy = b.frps_yy
		   AND a.frps_seq_no = b.frps_seq_no
		   AND b.dist_no = p_dist_no)
	LOOP    
		Giri_Wbinder_Peril_Pkg.del_giri_wbinder_peril(a.pre_binder_id);		
		Giri_Wbinder_Pkg.del_giri_wbinder(a.pre_binder_id);
		Giri_Wfrps_Peril_Grp_Pkg.del_giri_wfrps_peril_grp(a.line_cd, a.frps_yy, a.frps_seq_no);
		Giri_Wfrperil_Pkg.del_giri_wfrperil(a.line_cd, a.frps_yy, a.frps_seq_no);
		Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri(a.line_cd, a.frps_yy, a.frps_seq_no);
	END LOOP;

    Giri_Wdistfrps_Pkg.del_giri_wdistfrps(p_dist_no);
END;
/



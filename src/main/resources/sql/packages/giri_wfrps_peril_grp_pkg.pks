CREATE OR REPLACE PACKAGE CPI.GIRI_WFRPS_PERIL_GRP_PKG
AS	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/

	PROCEDURE del_giri_wfrps_peril_grp(
		p_line_cd		GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
		p_frps_yy		GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
		p_frps_seq_no	GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE);
        
    PROCEDURE POPULATE_WFRGROUP(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        );
        
    PROCEDURE copy_frps_peril_grp(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE
    ); 
                
END GIRI_WFRPS_PERIL_GRP_PKG;
/



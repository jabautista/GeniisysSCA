CREATE OR REPLACE PACKAGE CPI.GIRI_WBINDER_PERIL_PKG
AS	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/

	PROCEDURE del_giri_wbinder_peril(p_pre_binder_id	GIRI_WBINDER_PERIL.pre_binder_id%TYPE);
    
    PROCEDURE create_binder_peril_giris002 (
        p_line_cd       giri_wfrps_ri.line_cd%TYPE,
        p_frps_yy       giri_wfrps_ri.frps_yy%TYPE,
        p_frps_seq_no   giri_wfrps_ri.frps_seq_no%TYPE
    );
    
    PROCEDURE copy_binder_peril(
        p_line_cd       IN giri_frps_ri.line_cd%TYPE,
        p_frps_yy       IN giri_frps_ri.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frps_ri.frps_seq_no%TYPE,
        p_fnl_binder_id IN giri_frps_ri.fnl_binder_id%TYPE
    );
    
END GIRI_WBINDER_PERIL_PKG;
/



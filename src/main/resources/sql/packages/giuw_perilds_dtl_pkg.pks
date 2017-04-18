CREATE OR REPLACE PACKAGE CPI.GIUW_PERILDS_DTL_PKG
AS
    TYPE giuw_perilds_dtl_type IS RECORD (
        dist_no             GIUW_PERILDS_DTL.dist_no%TYPE,
        dist_seq_no         GIUW_PERILDS_DTL.dist_seq_no%TYPE,
        line_cd             GIUW_PERILDS_DTL.line_cd%TYPE,
        peril_cd            GIUW_PERILDS_DTL.peril_cd%TYPE,
        share_cd            GIUW_PERILDS_DTL.share_cd%TYPE,
        trty_name           GIIS_DIST_SHARE.trty_name%TYPE,
        dist_tsi            GIUW_PERILDS_DTL.dist_tsi%TYPE,
        dist_prem           GIUW_PERILDS_DTL.dist_prem%TYPE,
        dist_comm_amt       GIUW_PERILDS_DTL.dist_comm_amt%TYPE,
        dist_spct           GIUW_PERILDS_DTL.dist_spct%TYPE,
        dist_spct1          GIUW_PERILDS_DTL.dist_spct1%TYPE,
        ann_dist_spct       GIUW_PERILDS_DTL.ann_dist_spct%TYPE,
        ann_dist_tsi        GIUW_PERILDS_DTL.ann_dist_tsi%TYPE,
        dist_grp            GIUW_PERILDS_DTL.dist_grp%TYPE,
        cpi_rec_no          GIUW_PERILDS_DTL.cpi_rec_no%TYPE,
        cpi_branch_cd       GIUW_PERILDS_DTL.cpi_branch_cd%TYPE,
        arc_ext_data        GIUW_PERILDS_DTL.arc_ext_data%TYPE
    );
    
    TYPE giuw_perilds_dtl_tab IS TABLE OF giuw_perilds_dtl_type;

	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_perilds_dtl (p_dist_no 	GIUW_PERILDS_DTL.dist_no%TYPE);
    
    /*
    **  Created by       : emman
    **  Date Created     : 08.12.2011
    **  Reference By     : (GIUTS021 - Redistribution)
    **  Description      : Retrieve records on giuw_perilds_dtl based on the given parameter
    */
    FUNCTION get_giuw_perilds_dtl (
        p_dist_no       IN giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no   IN giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd       IN giuw_perilds_dtl.line_cd%TYPE,
        p_peril_cd      IN giuw_perilds_dtl.peril_cd%TYPE)
    RETURN giuw_perilds_dtl_tab PIPELINED;
    
END GIUW_PERILDS_DTL_PKG;
/



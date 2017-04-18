CREATE OR REPLACE PACKAGE CPI.GIUW_WITEMPERILDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.17.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemperilds_dtl (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE);
	
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.02.2011
	**  Reference By 	: (GIUWS003 - Preliminary Peril Distribution)
	**  Description 	: Recreate records in table GIUW_WITEMPERILDS_DTL based on
	** 					  the values taken in by table GIUW_WPERILDS_DTL.
	*/
	PROCEDURE POPULATE_WITEMPERILDS_DTL(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE POPULATE_WITEMPERILDS_DTL2 (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE);

    PROCEDURE POPULATE_WITEMPERILDS_DTL3 (p_dist_no 	GIUW_WITEMPERILDS_DTL.dist_no%TYPE);
        
    PROCEDURE neg_itemperilds_dtl (
        p_dist_no     IN  giuw_itemperilds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_itemperilds_dtl.dist_no%TYPE
    );
    
    PROCEDURE NEG_ITEMPERILDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                           p_v_ratio          IN OUT NUMBER);
                                           
    PROCEDURE POST_WITEMPERILDS_DTL_GIUWS015(p_batch_id  GIUW_POL_DIST.batch_id%TYPE,
                                             p_dist_no   GIUW_POL_DIST.dist_no%TYPE);
        
END GIUW_WITEMPERILDS_DTL_PKG;
/



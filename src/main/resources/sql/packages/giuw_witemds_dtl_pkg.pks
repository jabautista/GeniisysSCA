CREATE OR REPLACE PACKAGE CPI.GIUW_WITEMDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemds_dtl (p_dist_no 	GIUW_WITEMDS_DTL.dist_no%TYPE);
	
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.02.2011
	**  Reference By 	: (GIUWS003 - Preliminary Peril Distribution)
	**  Description 	: Recreate records in table GIUW_WITEMDS_DTL based on
	** 					  the values taken in by table GIUW_WITEMPERILDS_DTL.
	*/
	PROCEDURE POPULATE_WITEMDS_DTL(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE POPULATE_WITEMDS_DTL2(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE);
	
	PROCEDURE POPULATE_WITEMDS_DTL_GIUWS012(p_dist_no	   	 GIUW_POL_DIST.dist_no%TYPE);
    
    PROCEDURE neg_itemds_dtl (
        p_dist_no     IN  giuw_itemds_dtl.dist_no%TYPE,
        p_temp_distno IN  giuw_itemds_dtl.dist_no%TYPE
    );
    
    PROCEDURE NEG_ITEMDS_DTL_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                      p_v_ratio          IN OUT NUMBER);
        
END GIUW_WITEMDS_DTL_PKG;
/



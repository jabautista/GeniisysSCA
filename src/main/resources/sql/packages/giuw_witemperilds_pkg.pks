CREATE OR REPLACE PACKAGE CPI.GIUW_WITEMPERILDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_witemperilds (p_dist_no 	GIUW_WITEMPERILDS.dist_no%TYPE);
    
    PROCEDURE neg_itemperilds (
        p_dist_no     IN  giuw_itemperilds.dist_no%TYPE,
        p_temp_distno IN  giuw_itemperilds.dist_no%TYPE
    );
    
    PROCEDURE NEG_ITEMPERILDS_GIUTS021(p_dist_no          IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_temp_distno      IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_var_v_neg_distno IN OUT GIUW_POL_DIST.dist_no%TYPE,
                                       p_v_ratio          IN OUT NUMBER);
                                       
     PROCEDURE TRANSFER_WITEMPERILDS (p_dist_no     IN GIUW_POL_DIST.dist_no%TYPE);
    
END GIUW_WITEMPERILDS_PKG;
/



CREATE OR REPLACE PACKAGE CPI.GIUW_ITEMPERILDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_itemperilds_dtl (p_dist_no 	GIUW_ITEMPERILDS_DTL.dist_no%TYPE);
	
	PROCEDURE POST_WITEMPERILDS_DTL(
	   p_dist_no             giuw_pol_dist.dist_no%TYPE
	);
    
    PROCEDURE POST_WITEMPERILDS_DTL_GIUWS016 (p_dist_no      IN       GIUW_POL_DIST.dist_no%TYPE);
   
END GIUW_ITEMPERILDS_DTL_PKG;
/



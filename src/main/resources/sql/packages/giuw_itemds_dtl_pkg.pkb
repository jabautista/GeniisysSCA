CREATE OR REPLACE PACKAGE BODY CPI.GIUW_ITEMDS_DTL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_itemds_dtl (p_dist_no 	GIUW_ITEMDS_DTL.dist_no%TYPE)
	IS
	BEGIN
		DELETE   GIUW_ITEMDS_DTL
		 WHERE   dist_no  =  p_dist_no;
	END del_giuw_itemds_dtl;

END GIUW_ITEMDS_DTL_PKG;
/



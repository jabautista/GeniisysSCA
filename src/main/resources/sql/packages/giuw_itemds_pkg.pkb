CREATE OR REPLACE PACKAGE BODY CPI.GIUW_ITEMDS_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_itemds (p_dist_no 	GIUW_ITEMDS.dist_no%TYPE)
	IS
	BEGIN
		DELETE GIUW_ITEMDS
		 WHERE dist_no = p_dist_no;
	END del_giuw_itemds;
    
END GIUW_ITEMDS_PKG;
/



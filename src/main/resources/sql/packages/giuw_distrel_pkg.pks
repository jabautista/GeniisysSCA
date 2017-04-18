CREATE OR REPLACE PACKAGE CPI.GIUW_DISTREL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.18.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Contains the Insert / Update / Delete procedure of the table
	*/
	PROCEDURE del_giuw_distrel (p_dist_no 	GIUW_DISTREL.dist_no_old%TYPE);
END GIUW_DISTREL_PKG;
/



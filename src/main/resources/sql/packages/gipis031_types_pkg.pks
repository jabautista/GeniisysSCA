CREATE OR REPLACE PACKAGE CPI.Gipis031_Types_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 07.05.2010
	**  Reference By 	: GIPIS031 - Endt Basic Information
	**  Description 	: Contains different types used in GIPIS031	
	*/
	
	TYPE t_policy_no IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2(15);
END Gipis031_Types_PKG;
/



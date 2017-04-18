CREATE OR REPLACE PACKAGE CPI.GIPIS010_REF_CURSOR_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 08.18.2010
	**  Reference By 	: GIPIS010 - Item Information - MC
	**  Description 	: Contains different row types of every table used in GIPIS010	
	*/	
	
	TYPE RC_GIPI_WDEDUCTIBLES_TYPE IS REF CURSOR RETURN GIPI_WDEDUCTIBLES%ROWTYPE;
END GIPIS010_REF_CURSOR_PKG;
/



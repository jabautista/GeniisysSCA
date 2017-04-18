DROP PROCEDURE CPI.POPULATE_ORIG_ITMPERIL_ENDT;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ORIG_ITMPERIL_ENDT (
	p_par_id 	IN gipi_witmperl.par_id%TYPE,
	p_exist		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Delete records on table and create winvoice entry
	*/
BEGIN
	p_exist := 'N';
	FOR i IN (
		SELECT DISTINCT 1
          FROM gipi_witmperl
         WHERE par_id = p_par_id)    
    LOOP
        Populate_Orig_Itmperil3(p_par_id);        
        Gipi_winvoice_pkg.create_gipi_winvoice(p_par_id);
        p_exist := 'Y';
    END LOOP;
END POPULATE_ORIG_ITMPERIL_ENDT;
/



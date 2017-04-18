DROP PROCEDURE CPI.CREATE_DISTRIBUTION_ENDT;

CREATE OR REPLACE PROCEDURE CPI.CREATE_DISTRIBUTION_ENDT (
	p_par_id	IN gipi_parlist.par_id%TYPE,
	p_exist		OUT VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - CA)
    **  Description     : Call procedure to create the distribution
    */
    v_dist_no giuw_pol_dist.dist_no%TYPE;
BEGIN
    FOR A1 IN (
        SELECT dist_no
          FROM giuw_pol_dist
         WHERE par_id = p_par_id)
    LOOP
        v_dist_no := a1.dist_no;
        EXIT;
    END LOOP;
    
    FOR A2 IN (
        SELECT DISTINCT 1
          FROM gipi_witem
         WHERE par_id = p_par_id)
    LOOP
        GIPIS061_CREATE_DISTRIBUTION(p_par_id, v_dist_no);
        p_exist := 'Y';           
        EXIT;
    END LOOP;
END CREATE_DISTRIBUTION_ENDT;
/



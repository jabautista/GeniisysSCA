DROP PROCEDURE CPI.GIPIS061_DELETE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.GIPIS061_DELETE_DISTRIBUTION (p_par_id IN giuw_pol_dist.par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 10.06.2010
	**  Reference By 	: (GIPIS061 - Endt Item Information - Casualty)
	**  Description 	: Check if par_id has a distribution then delete related records
    */
BEGIN
    FOR i IN (
        SELECT dist_no
          FROM giuw_pol_dist
         WHERE par_id = p_par_id)
    LOOP
        DELETE_DISTRIBUTION_ENDT(i.dist_no);
    END LOOP;
END GIPIS061_DELETE_DISTRIBUTION;
/



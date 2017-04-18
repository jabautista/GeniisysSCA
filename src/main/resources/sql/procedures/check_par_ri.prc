DROP PROCEDURE CPI.CHECK_PAR_RI;

CREATE OR REPLACE PROCEDURE CPI.CHECK_PAR_RI(p_par_id        IN     GIPI_WPOLBAS.par_id%TYPE,
                                             exist           OUT    NUMBER) 
AS

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 02.07.2011
**  Reference By     : (GIPIS001 - PAR Listing and GIPIS058 - Endt PAR Listing)
**  Description 	: This procedure checks RI tables before allowing 
**                    deletion of PAR to prevent error	
*/

BEGIN
    
    FOR s IN (SELECT dist_no 
                FROM GIUW_POL_DIST
                   WHERE par_id = p_par_id
                     AND dist_no IN (SELECT b.dist_no 
                                      FROM GIRI_FRPS_RI A, GIRI_DISTFRPS b
                                      WHERE A.line_cd = b.line_cd
                                      AND A.frps_yy = b.frps_yy
                                      AND A.frps_seq_no = b.frps_seq_no))
    LOOP
        exist := s.dist_no;
    END LOOP;
	
   
END CHECK_PAR_RI;
/



DROP PROCEDURE CPI.CHECK_RI;

CREATE OR REPLACE PROCEDURE CPI.CHECK_RI(p_pack_par_id   IN     GIPI_PACK_WPOLBAS.PACK_PAR_ID%TYPE,
                                         exist           OUT    NUMBER) 
AS

/*
**  Created by        : Veronica V. Raymundo 
**  Date Created     : 11.10.2010
**  Reference By     : (GIPIS001A - Package Par Listing)
**  Description 	: This procedure checks RI tables before allowing 
**                    deletion of PAR to prevent error	
*/

BEGIN
    FOR i IN (SELECT par_id
                          FROM GIPI_PARLIST
                          WHERE pack_par_id = p_pack_par_id)
     LOOP
        FOR s IN (SELECT dist_no 
                    FROM GIUW_POL_DIST
                       WHERE par_id = i.par_id
                         AND dist_no IN (SELECT b.dist_no 
                                          FROM GIRI_FRPS_RI A, GIRI_DISTFRPS b
                                          WHERE A.line_cd = b.line_cd
                                          AND A.frps_yy = b.frps_yy
                                          AND A.frps_seq_no = b.frps_seq_no))
		LOOP
			exist := s.dist_no;
		END LOOP;
	END LOOP;
   
END CHECK_RI;
/



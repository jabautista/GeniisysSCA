DROP PROCEDURE CPI.GIPIS002A_UPDATE_POL_DIST;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_UPDATE_POL_DIST
(p_pack_par_id    IN     GIPI_WPOLBAS.pack_par_id%TYPE,
 p_eff_date       IN     GIUW_POL_DIST.eff_date%TYPE,
 p_expiry_date    IN     GIUW_POL_DIST.expiry_date%TYPE) 
IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 07, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This updates the eff_date and expiry_date in GIUW_POL_DIST
**                    of the policies under the Package PAR.     
*/

BEGIN
  UPDATE GIUW_POL_DIST
     SET eff_date = p_eff_date,
         expiry_date = p_expiry_date
  WHERE par_id IN (SELECT a.par_id
                     FROM GIPI_WPOLBAS a
                     WHERE a.pack_par_id = p_pack_par_id);
END;
/



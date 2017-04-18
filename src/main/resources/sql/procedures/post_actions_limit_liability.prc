DROP PROCEDURE CPI.POST_ACTIONS_LIMIT_LIABILITY;

CREATE OR REPLACE PROCEDURE CPI.POST_ACTIONS_LIMIT_LIABILITY(p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE,
                                                             p_iss_cd     IN GIPI_WPOLBAS.iss_cd%TYPE,
                                                             p_line_cd    IN GIPI_WPOLBAS.line_cd%TYPE) 
IS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 23, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure that will execute post actions from post-forms-commit trigger of GIPIS005 and GIPIS172. 
*/  
BEGIN
  FOR exist IN (
    SELECT 'a'
      FROM GIPI_WOPEN_PERIL
     WHERE par_id = p_wopen_liab.par_id)
  LOOP
    SET_LIMIT_INTO_GIPI_WITEM(p_wopen_liab);
    SET_LIMIT_INTO_GIPI_WITMPERL(p_wopen_liab.par_id, p_wopen_liab.limit_liability, p_line_cd, p_iss_cd); 
    UPD_GIPI_WPOLBAS(p_wopen_liab.par_id); --added 1/18/2011, to update gipi_wpolbas tsi, prem_amts
    EXIT;
  END LOOP; 
END POST_ACTIONS_LIMIT_LIABILITY;
/



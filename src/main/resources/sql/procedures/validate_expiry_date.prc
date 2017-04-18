DROP PROCEDURE CPI.VALIDATE_EXPIRY_DATE;

CREATE OR REPLACE PROCEDURE CPI.Validate_Expiry_Date (
	   p_par_id	  			VARCHAR2,
	   p_expiry_date		VARCHAR2
	   )
  IS
  v_exp	  DATE;	   
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to ensure the same date between gipi_wpolbas and giuw_pol_dist
  */
   v_exp := TO_DATE(p_expiry_date,'MM-DD-YYYY');
   FOR DATE IN(SELECT expiry_date
                 FROM GIUW_POL_DIST
                WHERE par_id = p_par_id)LOOP
     UPDATE GIUW_POL_DIST
        SET expiry_date = v_exp
      WHERE par_id = p_par_id;
   END LOOP;
END;
/



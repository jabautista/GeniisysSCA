DROP PROCEDURE CPI.COPY_POL_WPACK_LINE_SUBLINE;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpack_line_subline(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id			IN  GIPI_POLBASIC.policy_id%TYPE
				  )
 		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wpack_line_subline program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.FILE := 'Copying Covered Line Packages...';
  ELSE
     :gauge.FILE := 'passing copy copy_pol_wpack_line_subline';
  END IF;*/
  INSERT INTO GIPI_PACK_LINE_SUBLINE
    (policy_id,pack_line_cd,pack_subline_cd,line_cd,remarks)
       SELECT p_policy_id,pack_line_cd,pack_subline_cd,
              line_cd,remarks
         FROM GIPI_WPACK_LINE_SUBLINE
        WHERE par_id  =  p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
	  null;         
END;
/



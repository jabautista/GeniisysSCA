DROP PROCEDURE CPI.UPDATE_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.Update_Par_Status (
	   	  p_par_id			IN GIPI_WPOLBAS.par_id%TYPE
	   	  )
   IS
   cg$ctrl_par_status	NUMBER;
   v_count				NUMBER;
   v_exist				NUMBER;
   v_par_status			GIPI_PARLIST.par_status%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to update par status
  */
    Update_Par_Status_A_Gipis002(p_par_id, v_count);
	IF v_count = 0 THEN
       cg$ctrl_par_status := 3;
	END IF;
	FOR par_status IN (SELECT par_status 
				   	     FROM GIPI_PARLIST 
						WHERE par_id = p_par_id)
	LOOP
	   v_par_status := par_status.par_status; 
	END LOOP;
	IF v_par_status = 2 THEN
       cg$ctrl_par_status := 3;
  	END IF;
	
	/*TO CHECK IF PAR ID IS  ALREADY EXISTING IN  gipi_wpolbas TABLE */
	Update_Par_Status_B_Gipis002(p_par_id, v_exist);
	
	IF v_exist IS NULL THEN
       cg$ctrl_par_status := 3;
  	END IF;
	Update_Par_Status_C_Gipis002(p_par_id, cg$ctrl_par_status);	

END;
/



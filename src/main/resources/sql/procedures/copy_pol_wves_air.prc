DROP PROCEDURE CPI.COPY_POL_WVES_AIR;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wves_air(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
				   ) 
		 IS
  v_vessel_cd		GIPI_WVES_AIR.vessel_cd%TYPE;
  v_voy_limit		GIPI_WVES_AIR.voy_limit%TYPE;
  v_rec_flag		GIPI_WVES_AIR.rec_flag%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wves_air program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Air Cargo info..';
  ELSE
    :gauge.FILE := 'passing copy policy WVES_AIR';
  END IF;
  vbx_counter;  */
  BEGIN
  INSERT INTO GIPI_VES_AIR
              (policy_id,vessel_cd,vescon,voy_limit,rec_flag)
  SELECT p_policy_id,vessel_cd,vescon,voy_limit,rec_flag	
    FROM GIPI_WVES_AIR
   WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;      
END;
/



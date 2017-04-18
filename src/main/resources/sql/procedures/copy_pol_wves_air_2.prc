DROP PROCEDURE CPI.COPY_POL_WVES_AIR_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wves_air_2(
    p_new_policy_id     gipi_ves_air.policy_id%TYPE,
    p_old_pol_id        gipi_ves_air.policy_id%TYPE
) 
IS
  v_vessel_cd        gipi_wves_air.vessel_cd%TYPE;
  v_voy_limit        gipi_wves_air.voy_limit%TYPE;
  v_rec_flag        gipi_wves_air.rec_flag%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wves_air program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Air cargo info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  INSERT INTO gipi_ves_air
              (policy_id,vessel_cd,vescon,voy_limit,rec_flag)
  SELECT p_new_policy_id,vessel_cd,vescon,voy_limit,rec_flag    
    FROM gipi_ves_air
   WHERE policy_id = p_old_pol_id;
END;
/



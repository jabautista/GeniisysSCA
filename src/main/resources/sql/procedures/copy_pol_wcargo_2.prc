DROP PROCEDURE CPI.COPY_POL_WCARGO_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcargo_2(
    p_new_policy_id     gipi_cargo.policy_id%TYPE,
    p_old_pol_id        gipi_cargo.policy_id%TYPE
)   
IS
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
  **  Description  : copy_pol_wcargo program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying cargo info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  INSERT INTO gipi_cargo
              (policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
               rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
               tranship_origin,tranship_destination,print_tag,voyage_no,lc_no)
      SELECT p_new_policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
              rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
              tranship_origin,tranship_destination,print_tag,voyage_no,lc_no
         FROM gipi_cargo
        WHERE policy_id = p_old_pol_id;
  INSERT INTO gipi_cargo_carrier
              (policy_id,item_no,vessel_cd,last_update,user_id,voy_limit,
               vessel_limit_of_liab,eta,etd,origin,destn)
      SELECT p_new_policy_id,item_no,vessel_cd, SYSDATE, USER,voy_limit,
             vessel_limit_of_liab,eta,etd,origin,destn
         FROM gipi_cargo_carrier
        WHERE policy_id = p_old_pol_id;

END;
/



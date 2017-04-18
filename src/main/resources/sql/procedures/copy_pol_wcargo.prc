DROP PROCEDURE CPI.COPY_POL_WCARGO;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcargo(
	   	  		   p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				   p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wcargo program unit
  */
  
  --:gauge.FILE := 'passing copy policy CARGO';
  --vbx_counter;
  BEGIN
  INSERT INTO GIPI_CARGO
              (policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
               rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
               tranship_origin,tranship_destination,print_tag, lc_no, voyage_no,
               invoice_value, markup_rate, inv_curr_cd, inv_curr_rt) --added by ailene  120808, **inv_curr_cd, inv_curr_rt added by roset 101209.
      SELECT p_policy_id,item_no,vessel_cd,geog_cd,cargo_class_cd,bl_awb,
              rec_flag,origin,destn,etd,eta,cargo_type,deduct_text,pack_method,
              tranship_origin,tranship_destination,print_tag, lc_no, voyage_no,
              invoice_value, markup_rate, inv_curr_cd, inv_curr_rt --added by ailene  120808, **inv_curr_cd, inv_curr_rt added by roset 101209.
         FROM GIPI_WCARGO
        WHERE par_id = p_par_id;
  INSERT INTO GIPI_CARGO_CARRIER
              (policy_id,item_no,vessel_cd,last_update,user_id,
               voy_limit, vessel_limit_of_liab,eta,etd,origin,destn,delete_sw)
      SELECT p_policy_id,item_no,vessel_cd,last_update,user_id,
             voy_limit, vessel_limit_of_liab,eta,etd,origin,destn,delete_sw
         FROM GIPI_WCARGO_CARRIER
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;          
END;
/



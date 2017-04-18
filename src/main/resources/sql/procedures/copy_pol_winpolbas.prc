DROP PROCEDURE CPI.COPY_POL_WINPOLBAS;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winpolbas(
	   	  		  p_par_id				IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id			IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Description  : copy_pol_winpolbas program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Re-insurance info..';
  ELSE
    :gauge.FILE := 'passing copy policy WINPOLBAS';
  END IF;
  vbx_counter;  */
  BEGIN
  INSERT INTO GIRI_INPOLBAS
             (accept_no,policy_id,ri_policy_no,ri_endt_no,
              ri_binder_no,ri_cd,writer_cd,
              accept_date,offer_date,accept_by,orig_tsi_amt,orig_prem_amt,remarks,ref_accept_no, offered_by, amount_offered)
      SELECT  accept_no,p_policy_id,ri_policy_no,ri_endt_no,ri_binder_no,
              ri_cd,writer_cd,accept_date,offer_date,accept_by,orig_tsi_amt,
              orig_prem_amt,remarks, ref_accept_no, offered_by, amount_offered
         FROM GIRI_WINPOLBAS
        WHERE par_id  = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;        
END;
/



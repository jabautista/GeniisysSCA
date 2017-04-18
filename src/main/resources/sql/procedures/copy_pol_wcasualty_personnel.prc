DROP PROCEDURE CPI.COPY_POL_WCASUALTY_PERSONNEL;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcasualty_personnel(
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
  **  Description  : copy_pol_wcasualty_personnel program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Casualty Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy CASUALTY_ITEM';
  END IF;
  vbx_counter;*/
  BEGIN
   INSERT INTO GIPI_CASUALTY_PERSONNEL
             (policy_id,item_no,personnel_no,NAME,include_tag,capacity_cd,
              amount_covered,remarks, delete_sw)
      SELECT p_policy_id,item_no,personnel_no,NAME,include_tag,capacity_cd,
             amount_covered,remarks, delete_sw
        FROM GIPI_WCASUALTY_PERSONNEL
       WHERE par_id  =  p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;        
END;
/



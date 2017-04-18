DROP PROCEDURE CPI.COPY_POL_WCASUALTY_ITEM;

CREATE OR REPLACE PROCEDURE CPI.copy_POL_WCASUALTY_ITEM(
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
  **  Description  : copy_POL_WCASUALTY_ITEM program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Casualty Item info..';
  ELSE
    :gauge.FILE := 'passing copy policy CASUALTY_ITEM';
  END IF;
  vbx_counter;*/
  BEGIN
   INSERT INTO GIPI_CASUALTY_ITEM
         (policy_id,item_no,section_line_cd,section_subline_cd,section_or_hazard_cd,
          capacity_cd,property_no_type,property_no,LOCATION,conveyance_info,
          interest_on_premises,limit_of_liability,section_or_hazard_info,location_cd) 	--added 'location_cd' by steven 09.21.2012
   SELECT p_policy_id,item_no,section_line_cd,section_subline_cd,
          section_or_hazard_cd,capacity_cd,property_no_type,
          property_no,LOCATION,conveyance_info,interest_on_premises,
          limit_of_liability,section_or_hazard_info,location_cd 	--added 'location_cd' by steven 09.21.2012
     FROM GIPI_WCASUALTY_ITEM
    WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;       
END;
/



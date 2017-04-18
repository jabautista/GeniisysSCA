DROP PROCEDURE CPI.COPY_POL_WCASUALTY_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcasualty_item_2(
    p_new_policy_id     gipi_casualty_item.policy_id%TYPE,
    p_old_pol_id        gipi_casualty_item.policy_id%TYPE
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
  **  Description  : copy_pol_wcasualty_item program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Casualty Item info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
   INSERT INTO gipi_casualty_item
         (policy_id,item_no,section_line_cd,section_subline_cd,section_or_hazard_cd,
          capacity_cd,property_no_type,property_no,location,conveyance_info,
          interest_on_premises,limit_of_liability,section_or_hazard_info)
   SELECT p_new_policy_id,item_no,section_line_cd,section_subline_cd,
          section_or_hazard_cd,capacity_cd,property_no_type,
          property_no,location,conveyance_info,interest_on_premises,
          limit_of_liability,section_or_hazard_info
     FROM gipi_casualty_item
    WHERE policy_id = p_old_pol_id;
END;
/



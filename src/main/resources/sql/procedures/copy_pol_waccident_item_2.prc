DROP PROCEDURE CPI.COPY_POL_WACCIDENT_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_waccident_item_2(
   p_new_policy_id  gipi_accident_item.policy_id%TYPE,
   p_old_pol_id     gipi_accident_item.policy_id%TYPE
) 
IS
/* This procedure was added by ramil 09/03/96
** This procedure had been modified by bismark on 06/07/98 due to the table
** alterations made on the database.
** Updated by   :   Daphne
** Last Update  :   060798
*/
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_waccident_item program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying accident info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  INSERT INTO gipi_accident_item
              (policy_id,item_no,date_of_birth,age,civil_status,position_cd,
               monthly_salary,salary_grade,no_of_persons,destination,height,weight,
               sex,ac_class_cd,group_print_sw)
       SELECT p_new_policy_id,item_no,date_of_birth,age,civil_status,position_cd,
              monthly_salary,salary_grade,no_of_persons,destination,height,weight,
              sex,ac_class_cd,group_print_sw
         FROM gipi_accident_item
        WHERE policy_id = p_old_pol_id;
END;
/



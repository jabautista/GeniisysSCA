DROP PROCEDURE CPI.COPY_POL_WACCIDENT_ITEM;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_waccident_item(
	   	  		  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id	IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_waccident_item program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.FILE := 'Finalising Accident item info....';
  ELSE
     :gauge.FILE := 'passing copy policy ACCIDENT ITEM';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_ACCIDENT_ITEM
              (policy_id,item_no,date_of_birth,age,civil_status,position_cd,
               monthly_salary,salary_grade,no_of_persons,destination,height,weight,
               sex,ac_class_cd,group_print_sw)
       SELECT p_policy_id,item_no,date_of_birth,age,civil_status,position_cd,
              monthly_salary,salary_grade,no_of_persons,destination,height,
              weight,sex,ac_class_cd,group_print_sw
         FROM GIPI_WACCIDENT_ITEM
        WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;        
END;
/



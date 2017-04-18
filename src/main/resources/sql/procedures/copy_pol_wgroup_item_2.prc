DROP PROCEDURE CPI.COPY_POL_WGROUP_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wgroup_item_2(
    p_new_policy_id  gipi_grouped_items.policy_id%TYPE,
    p_old_pol_id     gipi_grouped_items.policy_id%TYPE
) 
IS
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  ** Modified by   : Loth
  ** Date modified : 020499
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wgroup_item program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item grouping info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_grouped_items
                  (policy_id,item_no,grouped_item_no,grouped_item_title,
                   amount_coverage,include_tag,line_cd, subline_cd, remarks,
                   sex, position_cd, civil_status, date_of_birth, age, salary, 
                   salary_grade, group_cd, delete_sw,
                   /* added by gmi */
                   --FROM_DATE,            TO_DATE,           
                   PAYT_TERMS, 
                   PACK_BEN_CD,          ANN_TSI_AMT,       ANN_PREM_AMT, 
                   CONTROL_CD,           CONTROL_TYPE_CD,   TSI_AMT, 
                   PREM_AMT,             PRINCIPAL_CD)
           SELECT p_new_policy_id,item_no,grouped_item_no,grouped_item_title,
                  amount_coverage,include_tag,line_cd, subline_cd,remarks, 
                  sex, position_cd, civil_status, date_of_birth,  trunc(to_number(months_between(sysdate,date_of_birth))/12), salary, 
                  salary_grade, group_cd, delete_sw,
                  /* added by gmi */
                  --FROM_DATE,            TO_DATE,           
                  PAYT_TERMS, 
                  PACK_BEN_CD,          ANN_TSI_AMT,       ANN_PREM_AMT, 
                  CONTROL_CD,           CONTROL_TYPE_CD,   TSI_AMT, 
                  PREM_AMT,             PRINCIPAL_CD
             FROM gipi_grouped_items
            WHERE policy_id = p_old_pol_id;
END;
/



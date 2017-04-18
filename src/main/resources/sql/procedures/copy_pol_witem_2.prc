DROP PROCEDURE CPI.COPY_POL_WITEM_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem_2(
    p_new_policy_id     gipi_item.policy_id%TYPE,
    p_old_pol_id        gipi_item.policy_id%TYPE
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
  **  Description  : copy_pol_witem program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE; 
    INSERT INTO gipi_item
               (policy_id,item_no,item_grp,item_title,item_desc,item_desc2,tsi_amt,
                    prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
                    currency_rt,group_cd,from_date,to_date,pack_line_cd,
                pack_subline_cd,discount_sw,other_info,coverage_cd,
                risk_no, risk_item_no)
         SELECT p_new_policy_id,item_no,item_grp,item_title,item_desc,item_desc2,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,
                    group_cd,from_date,to_date,pack_line_cd,pack_subline_cd,discount_sw,other_info,coverage_cd,
                    risk_no, risk_item_no
           FROM gipi_item
          WHERE policy_id = p_old_pol_id;
END;
/



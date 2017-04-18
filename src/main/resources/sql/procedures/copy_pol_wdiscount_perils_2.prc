DROP PROCEDURE CPI.COPY_POL_WDISCOUNT_PERILS_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdiscount_perils_2(
    p_old_pol_id        gipi_peril_discount.policy_id%TYPE,
    p_new_policy_id     gipi_peril_discount.policy_id%TYPE
) 
IS
   cursor discount_peril is   SELECT  item_no,line_cd,peril_cd,disc_rt,disc_amt,
                                      net_gross_tag,discount_tag,sequence,
                                      level_tag,subline_cd,orig_peril_prem_amt,
                                      net_prem_amt,last_update,remarks
                                FROM  gipi_peril_discount
                               WHERE policy_id = p_old_pol_id;
 
 /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by    : Daphne
  ** Last Update   : 060798
  ** Modified by   : Loth
  ** Date modified : 090998
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wdiscount_perils program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying peril discounts info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  copy_pol_wdiscount_polbas_2(p_old_pol_id, p_new_policy_id);
  copy_pol_wdiscount_item_2(p_old_pol_id, p_new_policy_id);
 FOR D1 in DISCOUNT_PERIL 
    LOOP 
    INSERT INTO gipi_peril_discount
               (policy_id,item_no,line_cd,peril_cd,sequence,
                disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
                subline_cd,orig_peril_prem_amt,
                net_prem_amt,last_update,remarks)
         VALUES(p_new_policy_id,D1.item_no,D1.line_cd,D1.peril_cd,D1.sequence,
                 D1.disc_rt,D1.disc_amt,D1.net_gross_tag,D1.discount_tag,
                 D1.level_tag,D1.subline_cd,D1.orig_peril_prem_amt,
                 D1.net_prem_amt,sysdate,D1.remarks);
    END LOOP;
END;
/



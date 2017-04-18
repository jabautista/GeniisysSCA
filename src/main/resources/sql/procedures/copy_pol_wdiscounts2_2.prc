DROP PROCEDURE CPI.COPY_POL_WDISCOUNTS2_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wdiscounts2_2(
    p_item_no       gipi_wperil_discount.item_no%TYPE,
    p_old_pol_id    gipi_peril_discount.policy_id%TYPE,
    p_new_policy_id gipi_peril_discount.policy_id%TYPE
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wdiscounts2 program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying policy discounts...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_peril_discount
           (policy_id,item_no,line_cd,peril_cd,sequence,
            disc_rt,disc_amt,net_gross_tag,discount_tag,level_tag,
            subline_cd,orig_peril_prem_amt, remarks, net_prem_amt)
       SELECT   p_new_policy_id,item_no,line_cd,peril_cd,sequence,
                disc_rt,disc_amt,net_gross_tag,discount_tag,
                level_tag,subline_cd,orig_peril_prem_amt, remarks, net_prem_amt
         FROM   gipi_peril_discount
        WHERE   policy_id = p_old_pol_id
          AND   item_no =  p_item_no;
END;
/



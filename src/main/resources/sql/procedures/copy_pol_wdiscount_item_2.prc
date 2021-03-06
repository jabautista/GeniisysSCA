DROP PROCEDURE CPI.COPY_POL_WDISCOUNT_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.COPY_POL_WDISCOUNT_ITEM_2(
    p_old_pol_id    gipi_ITEM_discount.policy_id%TYPE,
    p_new_policy_id gipi_item_discount.policy_id%TYPE
) 
IS
   cursor discount is  SELECT  line_cd,       subline_cd,   disc_rt,         disc_amt,
                               net_gross_tag, sequence,     orig_prem_amt,   item_no,
                               net_prem_amt,  last_update,  remarks
                         FROM  gipi_ITEM_discount
                        WHERE policy_id = p_old_pol_id;
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : COPY_POL_WDISCOUNT_ITEM program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item discounts info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
FOR D1 in DISCOUNT 
    LOOP 
        INSERT INTO gipi_item_discount
               (policy_id,    line_cd,       subline_cd,    disc_rt,
                disc_amt,     net_gross_tag, sequence,      orig_prem_amt,
                net_prem_amt, last_update,   remarks,       item_no)
         VALUES(p_new_policy_id, D1.line_cd,       D1.subline_cd,  D1.disc_rt,
                D1.disc_amt,        D1.net_gross_tag, D1.sequence,    D1.orig_prem_amt,
                D1.net_prem_amt,    sysdate,   D1.remarks,     D1.item_no);
    END LOOP;

END;
/



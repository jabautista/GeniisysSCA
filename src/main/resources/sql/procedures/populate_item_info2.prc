DROP PROCEDURE CPI.POPULATE_ITEM_INFO2;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_ITEM_INFO2(
    p_new_par_id    gipi_witem.par_id%TYPE,
    p_old_pol_id    gipi_item.policy_id%TYPE
) 
IS
BEGIN    
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-17-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : POPULATE_ITEM_INFO2 program unit 
  */
  --MESSAGE('Copying item info ...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE; 
  INSERT INTO gipi_witem ( par_id,              item_no,        item_title,
                           item_desc,           item_desc2,     currency_cd,
                           currency_rt,         group_cd,       
                           --from_date,           to_date,             
                           pack_line_cd,        pack_subline_cd,     
                           other_info,          prem_amt,       ann_prem_amt,
                           tsi_amt,             ann_tsi_amt,    discount_sw,
                           coverage_cd,         item_grp,       
                           region_cd,           changed_tag,
                           risk_no,             risk_item_no)
                   SELECT  p_new_par_id,        item_no,        item_title,
                           item_desc,           item_desc2,     currency_cd,
                           currency_rt,         group_cd,       
                           --from_date,           to_date,             
                           pack_line_cd,        pack_subline_cd,
                           other_info,          prem_amt,       ann_prem_amt,
                           tsi_amt,             ann_tsi_amt,    discount_sw,
                           coverage_cd,         item_grp,/*added by aivhie 112201*/       
                           region_cd,           changed_tag,
                           risk_no,             risk_item_no
                     FROM  gipi_item
                    WHERE  policy_id = p_old_pol_id;
  
END;
/



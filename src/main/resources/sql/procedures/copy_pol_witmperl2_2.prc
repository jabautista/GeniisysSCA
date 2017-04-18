DROP PROCEDURE CPI.COPY_POL_WITMPERL2_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperl2_2(
    p_item_no       IN gipi_witmperl.item_no%TYPE,
    p_old_pol_id    IN gipi_itmperil.policy_id%TYPE,
    p_new_policy_id IN gipi_itmperil.policy_id%TYPE 
) 
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_witmperl2 program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item peril info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE; 
  INSERT INTO gipi_itmperil
             (policy_id,line_cd,item_no,peril_cd,tsi_amt,prem_amt,
              ann_tsi_amt,ann_prem_amt,rec_flag,comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw)
      SELECT p_new_policy_id,line_cd,item_no,peril_cd,tsi_amt,ann_prem_amt prem_amt,
          ann_tsi_amt,ann_prem_amt,NVL(rec_flag,'A'),comp_rem,discount_sw,tarf_cd,
              prem_rt,ri_comm_rate,ri_comm_amt,prt_flag,as_charge_sw
         FROM gipi_itmperil
        WHERE policy_id = p_old_pol_id
          AND item_no = p_item_no;
   copy_pol_wdiscounts2_2(p_item_no,p_old_pol_id, p_new_policy_id);
END;
/



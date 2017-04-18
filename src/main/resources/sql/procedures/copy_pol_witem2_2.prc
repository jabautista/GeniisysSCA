DROP PROCEDURE CPI.COPY_POL_WITEM2_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witem2_2(
    p_line_cd       IN VARCHAR2,
    p_subline_cd    IN VARCHAR2,
    p_old_pol_id    IN gipi_item.policy_id%TYPE,
    p_new_policy_id IN gipi_item.policy_id%TYPE
)
IS
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-12-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_witem2 program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Item info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;  
  FOR A IN (
         SELECT item_no,item_grp,item_title,item_desc,item_desc2,tsi_amt,
                prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,
                    group_cd,from_date,to_date,pack_line_cd,pack_subline_cd,discount_sw,
                    coverage_cd, other_info, risk_no, risk_item_no
           FROM gipi_item
          WHERE policy_id = p_old_pol_id
            AND pack_line_cd   = p_line_cd
            AND pack_subline_cd= p_subline_cd) 
  LOOP
    INSERT INTO gipi_item
               (policy_id,item_no,item_grp,item_title,item_desc,item_desc2,tsi_amt,
                    prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
                    currency_rt,group_cd,from_date,to_date,pack_line_cd,
                pack_subline_cd,discount_sw,coverage_cd, other_info,
                risk_no, risk_item_no)
        VALUES (p_new_policy_id,A.item_no,A.item_grp,A.item_title,A.item_desc,a.item_desc2,A.tsi_amt,
                A.prem_amt,A.ann_tsi_amt,A.ann_prem_amt,A.rec_flag,A.currency_cd,
                A.currency_rt,A.group_cd,NULL,NULL,/*A.from_date,A.to_date,*/A.pack_line_cd,
                A.pack_subline_cd, A.discount_sw, A.coverage_cd, a.other_info,
                A.risk_no, A.risk_item_no);
          copy_pol_witmperl2_2(A.item_no, p_old_pol_id, p_new_policy_id);
  END LOOP;
END;
/



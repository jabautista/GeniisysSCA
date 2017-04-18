DROP PROCEDURE CPI.COPY_POL_WGRP_ITMPERIL_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wgrp_itmperil_2(
    p_new_policy_id     gipi_itmperil_grouped.policy_id%TYPE,
    p_old_pol_id        gipi_itmperil_grouped.policy_id%TYPE,
    p_proc_line_cd      gipi_itmperil_grouped.line_cd%TYPE
)
IS
/* Created By  : GMI
   Date Created: 05/31/2007 */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wgrp_itmperil program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Group items peril...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
   INSERT INTO gipi_itmperil_grouped        
        (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, REC_FLAG,
         PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW,
         BASE_AMT, RI_COMM_RATE, RI_COMM_AMT, NO_OF_DAYS)
  SELECT p_new_policy_id, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, NVL(REC_FLAG,'A'),
         PREM_RT, TSI_AMT, ANN_PREM_AMT PREM_AMT, ANN_TSI_AMT, ANN_PREM_AMT, AGGREGATE_SW,
         BASE_AMT, RI_COMM_RATE, RI_COMM_AMT, NO_OF_DAYS
    FROM gipi_itmperil_grouped
   WHERE line_cd = p_proc_line_cd 
     AND policy_id = p_old_pol_id;
END;
/



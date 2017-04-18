DROP PROCEDURE CPI.COPY_POL_WITMPERIL_BEN_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_witmperil_ben_2(
    p_new_policy_id gipi_itmperil_beneficiary.POLICY_ID%TYPE,
    p_old_pol_id    gipi_itmperil_beneficiary.POLICY_ID%TYPE
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
  --MESSAGE('Copying Item peril beneficiary...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
   INSERT INTO gipi_itmperil_beneficiary
        (POLICY_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO,
         LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT, PREM_AMT,
         ANN_TSI_AMT, ANN_PREM_AMT)
  SELECT p_new_policy_id, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO,
         LINE_CD, PERIL_CD, REC_FLAG, PREM_RT, TSI_AMT,ANN_PREM_AMT AS PREM_AMT,
         ANN_TSI_AMT, ANN_PREM_AMT
    FROM gipi_itmperil_beneficiary
   WHERE policy_id = p_old_pol_id;
END;
/



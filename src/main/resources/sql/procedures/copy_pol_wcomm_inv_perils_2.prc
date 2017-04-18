DROP PROCEDURE CPI.COPY_POL_WCOMM_INV_PERILS_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcomm_inv_perils_2(
    p_iss_cd            VARCHAR2,
    p_prem_seq_no       NUMBER,
    p_old_prem_seq_no   NUMBER,
    p_new_policy_id     gipi_comm_inv_peril.policy_id%TYPE,
    p_old_pol_id        gipi_comm_inv_peril.policy_id%TYPE
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
  **  Description  : copy_pol_wcomm_inv_perils program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Commissions Peril info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  INSERT INTO gipi_comm_inv_peril
              (INTRMDRY_INTM_NO,ISS_CD,PREM_SEQ_NO,POLICY_ID,
               PERIL_CD,PREMIUM_AMT,COMMISSION_AMT,COMMISSION_RT,WHOLDING_TAX)
       SELECT intrmdry_intm_no,p_iss_cd,p_prem_seq_no,p_new_policy_id,
              peril_cd,premium_amt,commission_amt,commission_rt,wholding_tax
         FROM gipi_comm_inv_peril
        WHERE policy_id = p_old_pol_id
          AND prem_seq_no =  p_old_prem_seq_no;
END;
/



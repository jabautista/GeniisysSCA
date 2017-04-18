DROP PROCEDURE CPI.COPY_POL_WBOND_BASIC_2;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wbond_basic_2(
    p_new_policy_id     gipi_bond_basic.policy_id%TYPE,
    p_old_pol_id        gipi_bond_basic.policy_id%TYPE
) 
IS
  /* This procedure was created for the purpose of extracting information from gipi_wbond_basic
  ** and inserting this information to gipi_bond_basic.
  ** Revised to have conformity with the objects in the database;
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
  **  Description  : copy_pol_wbond_basic program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying bond basic...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;    
  INSERT INTO gipi_bond_basic
                  (policy_id,      obligee_no,      val_period,   val_period_unit,   np_NO,
                   contract_dtl,   contract_date,   prin_id,      coll_flag,         co_prin_sw,
                   waiver_limit,   indemnity_text,  bond_dtl,     endt_eff_date,     clause_type,
                   remarks,        witness_ri,      witness_bond, witness_ind)
  SELECT p_new_policy_id,obligee_no,val_period,val_period_unit,np_no,
         contract_dtl,contract_date,prin_id,coll_flag,co_prin_sw,
         waiver_limit,indemnity_text,bond_dtl,endt_eff_date,clause_type,
         remarks,witness_ri,      witness_bond, witness_ind
    FROM gipi_bond_basic
   WHERE policy_id = p_old_pol_id;
END;
/



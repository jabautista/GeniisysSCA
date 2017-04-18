DROP PROCEDURE CPI.COPY_POL_WBOND_BASIC;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wbond_basic(
                        p_par_id        IN  GIPI_PARLIST.par_id%TYPE,
                   p_policy_id    IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wbond_basicc program unit
  */
  /*
  **  Modified by   : Udel Dela Cruz Jr.
  **  Date Created : June 7, 2012
  **  Description  : added columns plaintiff_dtl, defendant_dtl, civil_case_no
  */
  
  --:gauge.FILE := 'passing copy policy BOND BASIC';
  --vbx_counter;
  BEGIN
  INSERT INTO GIPI_BOND_BASIC
                  (policy_id,obligee_no,val_period,val_period_unit,np_NO,
                   contract_dtl,contract_date,prin_id,coll_flag,co_prin_sw,
                   waiver_limit,indemnity_text,bond_dtl,endt_eff_date,clause_type,
                   remarks, plaintiff_dtl, defendant_dtl, civil_case_no)
  SELECT p_policy_id,obligee_no,val_period,val_period_unit,np_no,
         contract_dtl,contract_date,prin_id,coll_flag,co_prin_sw,
         waiver_limit,indemnity_text,bond_dtl,endt_eff_date,clause_type,
         remarks, plaintiff_dtl, defendant_dtl, civil_case_no
    FROM GIPI_WBOND_BASIC
   WHERE par_id = p_par_id;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      null;                
  END; 
END;
/



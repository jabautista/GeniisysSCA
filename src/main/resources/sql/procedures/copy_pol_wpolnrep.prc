DROP PROCEDURE CPI.COPY_POL_WPOLNREP;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpolnrep(
                       p_par_id                IN  GIPI_PARLIST.par_id%TYPE,
                  p_policy_id            IN  GIPI_POLBASIC.policy_id%TYPE
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
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wpolnrep program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Policy History info..';
  ELSE
    :gauge.FILE := 'passing copy policy WPOLNREP';
  END IF;
  vbx_counter;  */
      INSERT INTO GIPI_POLNREP
        (PAR_ID,   OLD_POLICY_ID,   NEW_POLICY_ID,
         REC_FLAG, REN_REP_SW, USER_ID, LAST_UPDATE)
      SELECT par_id,old_policy_id,p_policy_id,
             rec_flag,ren_rep_sw, user_id, SYSDATE
        FROM GIPI_WPOLNREP
       WHERE par_id  =  p_par_id;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
      null;       
END;
/



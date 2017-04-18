DROP PROCEDURE CPI.COPY_POL_WCOMM_INV_PERILS;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcomm_inv_perils(
	   	  		  p_iss_cd           IN  VARCHAR2,
                  p_prem_seq_no  	 IN  NUMBER,
                  p_item_grp     	 IN  NUMBER,
                  p_takeup_seq_no    IN  NUMBER,
				  p_par_id		     IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id		 IN  GIPI_POLBASIC.policy_id%TYPE 
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
  **  Description  : copy_pol_wcomm_inv_perils program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Commission risks info..';
  ELSE
    :gauge.FILE := 'passing copy policy WCOMM_INV_PERILS';
  END IF;
  vbx_counter;*/
  BEGIN
  INSERT INTO GIPI_COMM_INV_PERIL
              (INTRMDRY_INTM_NO,ISS_CD,PREM_SEQ_NO,POLICY_ID,
               PERIL_CD,PREMIUM_AMT,COMMISSION_AMT,COMMISSION_RT,WHOLDING_TAX)
       SELECT intrmdry_intm_no,p_iss_cd,p_prem_seq_no,p_policy_id,
              peril_cd,premium_amt,commission_amt,commission_rt,wholding_tax
         FROM GIPI_WCOMM_INV_PERILS
        WHERE par_id   =  p_par_id
          AND item_grp =  p_item_grp
          AND takeup_seq_no = p_takeup_seq_no;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;            
END;
/



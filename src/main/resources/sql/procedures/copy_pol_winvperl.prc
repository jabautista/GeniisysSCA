DROP PROCEDURE CPI.COPY_POL_WINVPERL;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winvperl(
	   	  		  p_item_grp 		 IN  GIPI_WINVPERL.item_grp%TYPE,
                  p_takeup_seq_no 	 IN  GIPI_WINVPERL.takeup_seq_no%TYPE,
				  p_par_id		     IN  GIPI_PARLIST.par_id%TYPE,
				  p_iss_cd			 IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_prem_seq_no		 IN  NUMBER
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
  **  Description  : copy_pol_winvperl program unit
  */
 
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Bill Risk info..';
  ELSE
    :gauge.FILE := 'passing copy policy WINVPERL';
  END IF;
  vbx_counter;  */
  BEGIN
      INSERT INTO GIPI_INVPERIL
                 (iss_cd,prem_seq_no,peril_cd,tsi_amt,prem_amt,item_grp,ri_comm_amt,
                  ri_comm_rt)
           SELECT p_iss_cd,p_prem_seq_no,peril_cd,tsi_amt,prem_amt,
                  item_grp,ri_comm_amt,ri_comm_rt
             FROM GIPI_WINVPERL
            WHERE par_id   = p_par_id
              AND item_grp = p_item_grp
              AND takeup_seq_no = p_takeup_seq_no;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;               
END;
/



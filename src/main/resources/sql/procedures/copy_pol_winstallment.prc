DROP PROCEDURE CPI.COPY_POL_WINSTALLMENT;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winstallment(
	   	  		  p_item_grp         IN GIPI_WINVOICE.item_grp%TYPE,
                  p_takeup_seq_no    IN GIPI_WINVOICE.takeup_seq_no%TYPE,
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
  **  Description  : copy_pol_winstallment program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Bill Installment info..';
  ELSE
    :gauge.FILE := 'passing copy policy WINSTALLMENT';
  END IF;

  vbx_counter; */
  BEGIN
      INSERT INTO GIPI_INSTALLMENT
                 (iss_cd,prem_seq_no,item_grp,inst_no,share_pct,
		              tax_amt,prem_amt,due_date) 
           SELECT p_iss_cd,p_prem_seq_no,item_grp,inst_no,
                  share_pct,tax_amt,prem_amt,due_date
             FROM GIPI_WINSTALLMENT
            WHERE par_id   =  p_par_id
              AND item_grp =  p_item_grp
              AND takeup_seq_no = p_takeup_seq_no;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
	  null;                
  END;              
END;
/



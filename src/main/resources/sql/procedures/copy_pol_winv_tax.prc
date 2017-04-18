DROP PROCEDURE CPI.COPY_POL_WINV_TAX;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_winv_tax(
	   	  		   p_item_grp         IN  GIPI_WINV_TAX.item_grp%TYPE,
                   p_takeup_seq_no    IN  GIPI_WINV_TAX.takeup_seq_no%TYPE,
				   p_par_id		      IN  GIPI_PARLIST.par_id%TYPE,
				   p_prem_seq_no	  IN  NUMBER
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
  **  Description  : copy_pol_winv_tax program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Tax info..';
  ELSE
    :gauge.FILE := 'passing copy policy WINV_TAX';
  END IF;
  vbx_counter;  */
  BEGIN
  INSERT INTO GIPI_INV_TAX
             (prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
              tax_allocation,fixed_tax_allocation,rate)
       SELECT p_prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
              tax_allocation,fixed_tax_allocation,rate
         FROM GIPI_WINV_TAX
        WHERE 1 = 1
          AND takeup_seq_no = p_takeup_seq_no
          AND item_grp = p_item_grp 
          AND par_id  = p_par_id;
--   removed by apollo cruz 02.13.2015 - to promt an error to the user when dup_val_on_index occurs
--  EXCEPTION
--    WHEN DUP_VAL_ON_INDEX THEN
--	  null;                
  END;          
END;
/



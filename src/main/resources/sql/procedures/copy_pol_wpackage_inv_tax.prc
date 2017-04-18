DROP PROCEDURE CPI.COPY_POL_WPACKAGE_INV_TAX;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wpackage_inv_tax(
	   	  		  p_item_grp  IN GIPI_INVOICE.item_grp%TYPE,
				  p_par_id		     IN  GIPI_PARLIST.par_id%TYPE,
				  p_iss_cd			 IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_prem_seq_no		 IN  NUMBER,
				  p_policy_id		IN  GIPI_POLBASIC.policy_id%TYPE 
				  ) 
	   IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : copy_pol_wpackage_inv_tax program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
     :gauge.FILE := 'Copying Package Bill Tax...';
  ELSE
     :gauge.FILE := 'passing copy copy_pol_wpackage_inv_tax';
  END IF;*/
  INSERT INTO GIPI_PACKAGE_INV_TAX
   (policy_id,item_grp,line_cd,iss_cd,prem_seq_no,prem_amt,tax_amt,
    other_charges)
  SELECT p_policy_id,item_grp,line_cd,p_iss_cd,
         p_prem_seq_no,prem_amt,tax_amt,other_charges
    FROM GIPI_WPACKAGE_INV_TAX
   WHERE par_id   =  p_par_id
     AND item_grp =  p_item_grp;
EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
	  null;      
END;
/



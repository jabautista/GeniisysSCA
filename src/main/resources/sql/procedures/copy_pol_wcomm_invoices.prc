DROP PROCEDURE CPI.COPY_POL_WCOMM_INVOICES;

CREATE OR REPLACE PROCEDURE CPI.copy_pol_wcomm_invoices(
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
  **  Description  : copy_pol_wcomm_invoices program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Bill Commission..';
  ELSE
    :gauge.FILE := 'passing copy policy WCOMM_INVOICES';
  END IF;
  vbx_counter;*/

  FOR A IN (SELECT iss_cd,prem_seq_no,item_grp, NVL(takeup_seq_no,1) takeup_seq_no
              FROM GIPI_INVOICE
             WHERE policy_id = p_policy_id) 
  LOOP
    INSERT INTO GIPI_COMM_INVOICE
     (policy_id,intrmdry_intm_no,iss_cd,prem_seq_no,share_percentage,
      premium_amt,commission_amt,wholding_tax,bond_rate,parent_intm_no, whtax_id) -- Added whtax_id SR 4682 -- Kenneth 06.22.2015
    SELECT p_policy_id,intrmdry_intm_no,A.iss_cd,A.prem_seq_no,
           share_percentage,premium_amt,commission_amt,wholding_tax,
           bond_rate,parent_intm_no, whtax_id -- Added whtax_id SR 4682 -- Kenneth 06.22.2015
      FROM GIPI_WCOMM_INVOICES
     WHERE par_id    =  p_par_id
       AND item_grp  =  A.item_grp
       AND takeup_seq_no = A.takeup_seq_no;
     
         --added by A.R.C. 02.15.2005     
    INSERT INTO GIPI_COMM_INV_DTL
     (policy_id,intrmdry_intm_no,iss_cd,prem_seq_no,share_percentage,
      premium_amt,commission_amt,wholding_tax,parent_intm_no)
    SELECT p_policy_id,intrmdry_intm_no,A.iss_cd,A.prem_seq_no,
           share_percentage,premium_amt,commission_amt,wholding_tax,
           parent_intm_no
      FROM GIPI_WCOMM_INV_DTL
     WHERE par_id    =  p_par_id
       AND item_grp  =  A.item_grp
       AND takeup_seq_no = A.takeup_seq_no; --glyza 09.04.08 add to avoid ora-00001
  
    copy_pol_wcomm_inv_perils(A.iss_cd,A.prem_seq_no,A.item_grp, A.takeup_seq_no,
							  p_par_id,p_policy_id);
  END LOOP;
  
END;
/



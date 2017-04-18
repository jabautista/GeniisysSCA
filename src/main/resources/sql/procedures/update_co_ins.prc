DROP PROCEDURE CPI.UPDATE_CO_INS;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_CO_INS(
	   	  		  p_par_id		     IN  GIPI_PARLIST.par_id%TYPE,
				  p_policy_id		 IN  GIPI_POLBASIC.policy_id%TYPE 
	   	  		  )
	    IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : UPDATE_CO_INS program unit
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.FILE := 'Finalising Co-Insurance info..';
  ELSE
    :gauge.FILE := 'passing update policy Co-Insurance';
  END IF;
  vbx_counter;  */

  UPDATE  GIPI_MAIN_CO_INS
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;
 
  UPDATE  GIPI_CO_INSURER
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;

  UPDATE  GIPI_ORIG_ITMPERIL
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;

  UPDATE  GIPI_ORIG_INVOICE
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;
 
  UPDATE  GIPI_ORIG_INV_TAX
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;

  UPDATE  GIPI_ORIG_INVPERL
     SET  policy_id = p_policy_id
   WHERE  par_id = p_par_id;

  UPDATE  GIPI_ORIG_COMM_INVOICE
     SET  policy_id   = p_policy_id 
   WHERE  par_id      = p_par_id;

  UPDATE  GIPI_ORIG_COMM_INV_PERIL
     SET  policy_id   = p_policy_id
   WHERE  par_id      = p_par_id;

  FOR inv_seq IN (
    SELECT prem_seq_no, iss_cd, item_grp
      FROM GIPI_INVOICE
     WHERE policy_id = p_policy_id)
  LOOP
    UPDATE  GIPI_ORIG_COMM_INVOICE
       SET  prem_seq_no = inv_seq.prem_seq_no,
            iss_cd      = inv_seq.iss_cd  
     WHERE  policy_id   = p_policy_id
       AND  item_grp    = inv_seq.item_grp;
          
    UPDATE  GIPI_ORIG_COMM_INV_PERIL
       SET  prem_seq_no = inv_seq.prem_seq_no,
            iss_cd      = inv_seq.iss_cd 
     WHERE  policy_id   = p_policy_id
       AND  item_grp    = inv_seq.item_grp;          
  END LOOP;

END;
/



DROP PROCEDURE CPI.PRECOMMIT_DEL_TAB_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.precommit_del_tab_gipis002
   (p_par_id IN NUMBER) IS    
BEGIN
  DELETE gipi_wcomm_inv_perils
   WHERE par_id = p_par_id; 
  	 	   
  DELETE gipi_wcomm_invoices
   WHERE par_id = p_par_id; 

  DELETE gipi_winstallment
   WHERE par_id = p_par_id; 

  DELETE gipi_winv_tax
   WHERE par_id = p_par_id; 

  DELETE gipi_winvoice
   WHERE par_id = p_par_id; 

  DELETE gipi_witmperl
   WHERE par_id = p_par_id; 
          
  UPDATE gipi_witem
     SET tsi_amt = NULL,
         prem_amt = NULL,
         ann_tsi_amt = NULL,
         ann_prem_amt = NULL
   WHERE par_id = p_par_id; 
            
  UPDATE gipi_wpolbas
     SET tsi_amt = NULL,
         prem_amt = NULL,
	     ann_tsi_amt = NULL,
	     ann_prem_amt = NULL
   WHERE par_id = p_par_id; 

--added by Gzelle 09262014 - delete attached warranties and clauses of peril
  DELETE gipi_wpolwc
   WHERE par_id = p_par_id;    
END;
/



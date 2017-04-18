DROP PROCEDURE CPI.DELETE_BILL_RELATED_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_BILL_RELATED_TABLES(p_par_id 	GIPI_PARLIST.par_id%TYPE) 
 IS
BEGIN

  DELETE gipi_winv_tax
   WHERE par_id = p_par_id;

  DELETE gipi_witmperl
   WHERE par_id = p_par_id;

  DELETE gipi_winstallment
   WHERE par_id = p_par_id;

  DELETE gipi_wcomm_inv_perils
   WHERE par_id = p_par_id;
  
  DELETE gipi_winvperl
   WHERE par_id = p_par_id;
  
  DELETE gipi_wcomm_invoices   
   WHERE par_id = p_par_id;
  
  DELETE gipi_winvoice
   WHERE par_id = p_par_id; 

  DELETE gipi_witem
   WHERE par_id = p_par_id;
    
END DELETE_BILL_RELATED_TABLES;
/



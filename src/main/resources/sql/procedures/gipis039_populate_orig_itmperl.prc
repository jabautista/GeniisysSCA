DROP PROCEDURE CPI.GIPIS039_POPULATE_ORIG_ITMPERL;

CREATE OR REPLACE PROCEDURE CPI.gipis039_POPULATE_ORIG_ITMPERL(p_par_id GIPI_PARLIST.par_id%TYPE) IS
BEGIN
     DELETE FROM gipi_orig_comm_inv_peril
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_orig_comm_invoice
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_orig_invperl
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_orig_inv_tax
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_orig_invoice
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_orig_itmperil
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_co_insurer
       WHERE  par_id  = p_par_id;
     DELETE FROM gipi_main_co_ins
       WHERE  par_id  = p_par_id;
END;
/



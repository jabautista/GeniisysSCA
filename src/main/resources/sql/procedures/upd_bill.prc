DROP PROCEDURE CPI.UPD_BILL;

CREATE OR REPLACE PROCEDURE CPI.UPD_BILL(p_par_id   NUMBER, p_line_cd  VARCHAR2,
                   p_iss_cd   VARCHAR2) IS
BEGIN
  upd_gipi_wpolbas(p_par_id);
  DELETE FROM gipi_winstallment
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_wcomm_inv_perils
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_wcomm_invoices
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_winvperl
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_wpackage_inv_tax
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_winv_tax
       WHERE  par_id  =  p_par_id;
  DELETE FROM gipi_winvoice
       WHERE  par_id  =  p_par_id;
  FOR A IN (SELECT   '1'
              FROM   gipi_witmperl
             WHERE   par_id  = p_par_id) LOOP
    create_winvoice(0,0,0,p_par_id,p_line_cd,p_iss_cd);
    EXIT;
  END LOOP;
END;
/



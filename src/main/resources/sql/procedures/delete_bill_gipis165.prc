DROP PROCEDURE CPI.DELETE_BILL_GIPIS165;

CREATE OR REPLACE PROCEDURE CPI.delete_bill_gipis165(p_par_id   IN  gipi_wpolbas.par_id%TYPE) 
IS

BEGIN
    DELETE
      FROM gipi_winstallment
     WHERE par_id = p_par_id;
     
    GIPI_WINV_TAX_PKG.del_gipi_winv_tax_1(p_par_id);
    GIPI_WINVOICE_PKG.del_gipi_winvoice(p_par_id);
    
    DELETE
      FROM gipi_wcomm_inv_dtl
     WHERE par_id = p_par_id;
    
    GIPI_WCOMM_INV_PERILS_PKG.del_gipi_wcomm_inv_perils1(p_par_id);
    GIPI_WCOMM_INVOICES_PKG.del_gipi_wcomm_invoices_1(p_par_id);
    
   --dist
   FOR x IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE par_id = p_par_id)
   LOOP
       DELETE
         FROM giuw_wpolicyds_dtl
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_wpolicyds
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_witemperilds_dtl
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_witemperilds
        WHERE dist_no = x.dist_no;
       
       DELETE
         FROM giuw_witemds_dtl
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_witemds
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_wperilds_dtl
        WHERE dist_no = x.dist_no;
        
       DELETE
         FROM giuw_wperilds
        WHERE dist_no = x.dist_no;
        
   END LOOP;
   
   DELETE
     FROM giuw_pol_dist
    WHERE par_id = p_par_id;
   
END delete_bill_gipis165;
/



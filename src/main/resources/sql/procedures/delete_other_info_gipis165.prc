DROP PROCEDURE CPI.DELETE_OTHER_INFO_GIPIS165;

CREATE OR REPLACE PROCEDURE CPI.DELETE_OTHER_INFO_GIPIS165(
	p_par_id	IN	gipi_wpolbas.par_id%TYPE
)
AS
	p_dist_no      giuw_pol_dist.dist_no%TYPE;
    p_frps_yy      giri_wdistfrps.frps_yy%TYPE;
    p_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;
BEGIN
	/*gipi_wprincipal_pkg.del_gipi_wprincipal(p_par_id);
	gipi_wlocation_pkg.del_gipi_wlocation(p_par_id);
	gipi_wbond_basic_pkg.del_gipi_wbond_basic(p_par_id);
	gipi_wcosigntry_pkg.del_gipi_wcosigntry(p_par_id);

	DELETE gipi_wdeductibles
 	 WHERE par_id   =  p_par_id;

	gipi_wcomm_inv_perils_pkg.del_gipi_wcomm_inv_perils1(p_par_id);
	gipi_wcomm_invoices_pkg.del_gipi_wcomm_invoices_1(p_par_id);
	gipi_wpackage_inv_tax_pkg.del_gipi_wpackage_inv_tax(p_par_id);
	gipi_winstallment_pkg.del_gipi_winstallment_1(p_par_id);
	gipi_winvoice_pkg.del_gipi_winvoice(p_par_id);
	gipi_winvperl_pkg.del_gipi_winvperl_1(p_par_id);
	gipi_winv_tax_pkg.del_gipi_winv_tax_1(p_par_id);
	gipi_witmperl_pkg.del_gipi_witmperl2(p_par_id);
	gipi_wperil_discount_pkg.del_gipi_wperil_discount(p_par_id);
	gipi_wpolnrep_pkg.del_gipi_wpolnreps(p_par_id);
	gipi_wpolwc_pkg.del_gipi_wpolwc(p_par_id);
	
	DELETE gipi_wpolwc
 	 WHERE par_id = p_par_id;
 
	gipi_wreqdocs_pkg.del_gipi_wreqdocs(p_par_id);
	gipi_wves_accumulation_pkg.del_gipi_wves_accumulation(p_par_id);*/
	
   
   DELETE    GIPI_WPRINCIPAL
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WLOCATION
    WHERE    par_id   =  p_par_id;


   
   DELETE    GIPI_WBOND_BASIC
    WHERE    par_id   =  p_par_id;


   DELETE    GIPI_WCOSIGNTRY
    WHERE    par_id   =  p_par_id;

   DELETE    GIPI_WDEDUCTIBLES
    WHERE    par_id   =  p_par_id;

   
   DELETE    GIPI_WCOMM_INV_PERILS
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WCOMM_INVOICES
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WPACKAGE_INV_TAX
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WINSTALLMENT
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WINVOICE
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WINVPERL
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WINV_TAX
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WITMPERL
    WHERE    par_id   =  p_par_id;
  -- DELETE    GIPI_WITEM
  --  WHERE    par_id   =  p_par_id;


   DELETE    GIPI_WPERIL_DISCOUNT
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WPOLNREP
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WPOLWC
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WREQDOCS
    WHERE    par_id   =  p_par_id;
   DELETE    GIPI_WVES_ACCUMULATION
    WHERE    par_id   =  p_par_id;

	BEGIN
    	FOR x IN (SELECT dist_no
        		    --INTO p_dist_no
        			FROM giuw_pol_dist
       			   WHERE par_id = p_par_id)
    	LOOP
        	p_dist_no := x.dist_no;
      		DELETE     giuw_witemperilds_dtl
       		 WHERE     dist_no   =   p_dist_no;
      		DELETE     giuw_witemperilds
       		 WHERE     dist_no   =   p_dist_no;
      		DELETE     giuw_wperilds_dtl
       		 WHERE     dist_no   =   p_dist_no;
      		DELETE     giuw_wperilds
       		 WHERE     dist_no   =   p_dist_no;
      		DELETE     giuw_witemds_dtl
       		 WHERE     dist_no   =   p_dist_no;
      		DELETE     giuw_witemds
       		 WHERE     dist_no   =   p_dist_no;
   			BEGIN
      			SELECT     frps_yy,   frps_seq_no
        		  INTO     p_frps_yy, p_frps_seq_no
        		  FROM     giri_wdistfrps
       			 WHERE     dist_no  =  p_dist_no
    			 GROUP BY     frps_yy,   frps_seq_no;
      			DELETE     giri_wfrperil
       			 WHERE     frps_yy     =   p_frps_yy
         		   AND     frps_seq_no =   p_frps_seq_no;
      			DELETE     giri_wfrps_ri
       			 WHERE     frps_yy     =   p_frps_yy
         		   AND     frps_seq_no =   p_frps_seq_no;
      			DELETE     giri_wdistfrps
       			 WHERE     frps_yy     =   p_frps_yy
         		   AND     frps_seq_no =   p_frps_seq_no;
   				EXCEPTION
       				WHEN TOO_MANY_ROWS THEN
          			NULL;
       			WHEN NO_DATA_FOUND THEN 
          			NULL;
   			END;
			DELETE     giuw_wpolicyds_dtl
			 WHERE     dist_no   =   p_dist_no;
			DELETE     giuw_wpolicyds
			 WHERE     dist_no   =   p_dist_no;      
			DELETE     giuw_perilds_dtl
			 WHERE     dist_no   =   p_dist_no; 
			DELETE     giuw_itemds_dtl
			 WHERE     dist_no   =   p_dist_no; 
			DELETE     giuw_itemperilds_dtl
			 WHERE     dist_no   =   p_dist_no; 
			DELETE     giuw_policyds_dtl
			 WHERE     dist_no   =   p_dist_no;
			DELETE     giuw_itemperilds
			 WHERE     dist_no   =   p_dist_no;  
			DELETE     giuw_perilds
			 WHERE     dist_no   =   p_dist_no;  
			DELETE     giuw_itemds
			 WHERE     dist_no   =   p_dist_no;  
			DELETE     giuw_policyds
			 WHERE     dist_no   =   p_dist_no;
   		END LOOP;        
	END;
END DELETE_OTHER_INFO_GIPIS165;
/



DROP PROCEDURE CPI.DELETE_OTH_WORKFILE;

CREATE OR REPLACE PROCEDURE CPI.delete_oth_workfile(
	   	  		   p_par_id      gipi_parlist.par_id%TYPE
				   )
		 IS
BEGIN
  /*
  **  Created by   : Jerome Orio  
  **  Date Created : April 05, 2010  
  **  Reference By : (GIPIS055 - POST PAR) 
  **  Description  : delete_oth_workfile program unit 
  */
  
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Bill risks...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WINVPERL';
  END IF;
  vbx_counter;*/
  DELETE GIPI_WCOMM_INV_PERILS
        WHERE par_id = p_par_id;
  DELETE FROM gipi_winvperl
        WHERE par_id = p_par_id;
  /*IF :gauge.process = 'Y' THEN
    :gauge.file := 'Deleting Bill records...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WINVOICE';
  END IF;
  vbx_counter;*/
  DELETE GIPI_WPACKAGE_INV_TAX
        WHERE par_id = p_par_id;
  DELETE GIPI_WCOMM_INVOICES
        WHERE par_id = p_par_id;
  DELETE GIPI_WINV_TAX
        WHERE par_id = p_par_id;
  DELETE FROM gipi_winstallment
        WHERE par_id = p_par_id;
  DELETE FROM gipi_winvoice
        WHERE par_id = p_par_id;
  /*IF :gauge.file = 'Y' THEN
    :gauge.file := 'Deleting Risk Records...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WITMPERL';
  END IF;
  vbx_counter;*/
  DELETE FROM  gipi_wpolbas_discount
        WHERE par_id = p_par_id;
  DELETE FROM  gipi_witem_discount
        WHERE par_id = p_par_id;
  DELETE FROM  gipi_wperil_discount
        WHERE par_id = p_par_id;
  
  DELETE FROM  gipi_witmperl_beneficiary
        WHERE par_id = p_par_id;
  DELETE FROM  gipi_witmperl_grouped
        WHERE par_id = p_par_id;
  DELETE FROM  gipi_witmperl
        WHERE par_id = p_par_id;
  /*IF :gauge.file = 'Y' THEN
    :gauge.file := 'Deleting Item Records...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WITEM';
  END IF;
  vbx_counter;*/
  DELETE FROM gipi_wdeductibles
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wpolwc
       WHERE  par_id = p_par_id;      
  DELETE FROM gipi_wcasualty_item
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wcasualty_personnel
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wlocation
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wgrp_items_beneficiary
       WHERE  par_id = p_par_id;    
  DELETE FROM gipi_wgrouped_items
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wfireitm
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wcasualty_item
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wcargo
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wbeneficiary
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_waviation_item
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_waccident_item
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_witem_ves
       WHERE  par_id = p_par_id;
  DELETE FROM gipi_wvehicle
       WHERE  par_id = p_par_id;
  --DELETE FROM rmd_fire_basic_info
  --     WHERE  par_id = :postpar.par_id;
  /*IF :gauge.file = 'Y' THEN
    :gauge.file := 'Deleting Item Records...';
  ELSE
    :gauge.file := 'passing delete policy DEL-WITEM';
  END IF;
  :gauge.file := 'passing delete policy DEL-WITEM';
  vbx_counter;*/
  DELETE FROM gipi_witem
        WHERE par_id = p_par_id;
END;
/



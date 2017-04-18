DROP PROCEDURE CPI.PROCESS_COMMISSION;

CREATE OR REPLACE PROCEDURE CPI.Process_Commission
  ( p_b240_par_id 							IN GIPI_PARLIST.par_id%TYPE,
   	p_WCOMINV_PAR_ID						IN GIPI_WCOMM_INVOICES.par_id%TYPE, 
	p_WCOMINV_ITEM_GRP						IN GIPI_WCOMM_INVOICES.item_grp%TYPE, 
	p_WCOMINV_intrmdry_intm_no				IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
	p_WCOMINV_intrmdry_intm_no_nbt			IN GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE, 
	p_WCOMINV_share_percentage				IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
	p_WCOMINV_share_percentage_nbt			IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
	p_b450_takeup_seq_no					IN GIPI_WINVOICE.takeup_seq_no%TYPE,
    p_SYSTEM_record_status					IN VARCHAR2,
	variables_v_comm_update_tag			   OUT GIIS_USERS.comm_update_tag%TYPE,
	variables_switch_no 				   OUT VARCHAR2,	
    variables_switch_name				   OUT VARCHAR2,
	variables_v_param_show_comm			   OUT GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,    
	p_GLOBAL_cancel_tag						IN VARCHAR2,		
	p_wcominvper_wholding_tax			   OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,		
	p_wcominvper_commission_amt			    IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
	variables_var_tax_amt					IN GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
	v_go_clear_block					   OUT VARCHAR2,
	v_remove_clrd_rw_frm_grp 			   OUT VARCHAR2,
	v_check_comm_peril					   OUT VARCHAR2,
	v_msg_alert1						   OUT VARCHAR2,
	v_upd_wcomm_inv_prls				   OUT VARCHAR2,
	v_pop_wcomm_inv_prls				   OUT VARCHAR2,
	v_del_wcomm_inv_prls				   OUT VARCHAR2,
	v_msg_alert2						   OUT VARCHAR2,
	v_show_view							   OUT VARCHAR2,
	v_hide_view							   OUT VARCHAR2,
	v_set_itm_prop1						   OUT NUMBER,
	v_set_itm_prop2						   OUT NUMBER,
	v_go_item							   OUT VARCHAR2,
	v_compute_tot_com					   OUT VARCHAR2
		 
  )IS
   v_pol_flag GIPI_WPOLBAS.pol_flag%TYPE;
BEGIN
  
  BEGIN
  	SELECT pol_flag
	    INTO v_pol_flag
	    FROM GIPI_WPOLBAS
	   WHERE par_id = p_b240_par_id;
	END;
       v_go_clear_block := 'Y';
  --   go_block('WCOMINVPER');
  --   clear_block(NO_COMMIT);
     DELETE GIPI_WCOMM_INV_PERILS
      WHERE par_id = p_WCOMINV_PAR_ID
        AND item_grp = p_WCOMINV_ITEM_GRP
        AND intrmdry_intm_no = p_WCOMINV_intrmdry_intm_no
        AND takeup_seq_no = p_b450_takeup_seq_no ;  -- aaron 050509
		
     v_remove_clrd_rw_frm_grp := 'Y';
--	 REMOVE_CLEARED_ROW_FROM_GROUP; 
   

   IF Giacp.v ('CHECK_COMM_PERIL') = 'Y' THEN
    
	 v_check_comm_peril := 'Y';
/*	 
	 check_peril_comm_rate;

      IF variables.missing_perils IS NOT NULL THEN
         msg_alert (
               'Please check intermediary commission rates for the following perils: '
            || variables.missing_perils
            || '.',
            'E',
            TRUE);
      END IF;
 */  
  END IF;
   --END
       IF  p_WCOMINV_intrmdry_intm_no IS NULL
       AND p_WCOMINV_share_percentage IS NOT NULL THEN
      v_msg_alert1 := 'Y';

/*
	  msg_alert ('Intermediary No. is required.', 'I', FALSE);
      go_item ('wcominv.intrmdry_intm_no');
      set_item_property ('wcominv.apply_button', enabled, property_false);
*/   
   END IF;

   IF  p_SYSTEM_record_status = 'CHANGED' THEN
      IF NVL (p_WCOMINV_share_percentage, 0) <>
                                       NVL (p_WCOMINV_share_percentage_nbt, 0) THEN
        v_upd_wcomm_inv_prls := 'Y';
/*		
		 go_block ('wcominvper');
         update_wcomm_inv_perils;
         go_item ('wcominv.dsp_intm_name');
*/      
	  END IF;
   END IF;
   
   IF p_SYSTEM_record_status IN ('NEW', 'INSERT') THEN 
      IF p_WCOMINV_intrmdry_intm_no IS NOT NULL THEN
         v_pop_wcomm_inv_prls := 'Y';

/*		 
	     go_block ('wcominvper');
         clear_block (no_commit);
         populate_wcomm_inv_perils;
         go_item ('wcominv.share_percentage');
*/    
	     variables_switch_no := 'N';
         variables_switch_name := 'N';
      END IF;
   ELSIF p_SYSTEM_record_status = 'CHANGED' THEN
      IF NVL (p_WCOMINV_intrmdry_intm_no, 0) <> NVL (p_WCOMINV_intrmdry_intm_no_nbt, 0) THEN
      	 v_del_wcomm_inv_prls := 'Y';
/*	
	     go_block ('wcominvper');
         clear_block (no_commit);
         populate_wcomm_inv_perils;
         delete_wcomm_inv_perils;
         go_item ('wcominv.share_percentage');
*/    
	     variables_switch_no := 'N';
         variables_switch_name := 'N';
      END IF;
  END IF;

  BEGIN
      SELECT param_value_v
        INTO variables_v_param_show_comm
        FROM GIAC_PARAMETERS
       WHERE param_name = 'SHOW_COMM_AMT';
  EXCEPTION
  	WHEN NO_DATA_FOUND THEN
    v_msg_alert2 := 'Y';
--  	     msg_alert('No data found on giac_parameters for parameter ''SHOW_COMM_AMT''','I',TRUE);
  END;

  BEGIN
      SELECT comm_update_tag
        INTO variables_v_comm_update_tag
        FROM GIIS_USERS
       WHERE user_id = USER;--:cg$ctrl.cg$us;
  END;

  IF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag = 'N' THEN
  	  v_show_view := 'Y';  
--	  show_view ('CANVAS328');
   ELSIF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag ='Y' THEN
   	  v_hide_view := 'Y';	  
--      hide_view ('CANVAS328');
   END IF;


 	-- go_item ('WCOMINV.SHARE_PERCENTAGE');--added by dannel 07/11/2006
   IF  variables_v_param_show_comm = 'Y' AND variables_v_comm_update_tag = 'N' THEN  			
       v_set_itm_prop1 := 1;
/*	
	   set_item_property ('WCOMINVPER.COMMISSION_RT', enabled, property_false);
       set_item_property ('WCOMINVPER.COMMISSION_AMT', enabled, property_false);
*/
   ELSIF  variables_v_param_show_comm = 'N' AND variables_v_comm_update_tag = 'N' THEN
       v_set_itm_prop1 := 2;
/*	   
	   show_view ('CANVAS328');
       set_item_property (
         'WCOMINVPER.COMMISSION_RT',
         navigable,
         property_false);
*/  
   ELSE  	
       v_set_itm_prop1 := 3;      		
/*  
      hide_view ('CANVAS328');
      go_item ('WCOMINV.SHARE_PERCENTAGE');--added by dannel 07/11/2006 
*/      --set_item_property ('WCOMINVPER.COMMISSION_RT', enabled, property_true);
      -- mark jm 12.05.08 starts here
      IF v_pol_flag = 4 OR  p_GLOBAL_cancel_tag = 'Y' THEN
  	   v_set_itm_prop2 := 1;
/*
      		SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_AMT', ENABLED, PROPERTY_FALSE);	
      		SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_RT', ENABLED, PROPERTY_FALSE);
      -- mark jm 12.05.08 ends here
*/  
      ELSE      	
  	   v_set_itm_prop2 := 2;
/*
      	set_item_property ('WCOMINVPER.COMMISSION_AMT', ENABLED, PROPERTY_TRUE);	
      	SET_ITEM_PROPERTY ('WCOMINVPER.COMMISSION_RT', ENABLED, PROPERTY_TRUE);
*/  
      END IF;
  	  v_go_item := 'Y';    
--      go_item ('WCOMINVPER.COMMISSION_RT');
  						
   END IF;
   	   

    p_wcominvper_wholding_tax :=   ROUND (NVL(p_wcominvper_commission_amt, 0),2)
                                 * NVL (variables_var_tax_amt, 0) / 100;
    v_compute_tot_com := 'Y';
--	compute_tot_com;
  

END;
/



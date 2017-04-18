DROP PROCEDURE CPI.GIACS020_VALIDATE_INTM_NO;

CREATE OR REPLACE PROCEDURE CPI.giacs020_validate_intm_no(
	--rename to validate_comm_payts_intm_no
    p_bill_gacc_tran_id         IN     GIAC_COMM_PAYTS.GACC_TRAN_ID%TYPE,   -- shan 10.02.2014
	p_intm_no					IN     GIIS_INTERMEDIARY.intm_no%TYPE,
	p_gacc_tran_id				IN	   GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
	p_tran_type					IN	   GIAC_COMM_PAYTS.tran_type%TYPE,
	p_iss_cd					IN 	   GIAC_COMM_PAYTS.iss_cd%TYPE,
	p_prem_seq_no				IN 	   GIAC_COMM_PAYTS.prem_seq_no%TYPE,
	p_comm_tag					IN	   GIAC_COMM_PAYTS.comm_tag%TYPE,
	p_def_comm_tag_displayed	IN     VARCHAR2,
	p_comm_amt					IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_wtax_amt					IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
	p_input_vat_amt				IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
	p_def_comm_tag				IN OUT GIAC_COMM_PAYTS.def_comm_tag%TYPE,
	p_convert_rate		   		IN OUT GIAC_COMM_PAYTS.convert_rate%TYPE,
	p_currency_cd		   		IN OUT GIAC_COMM_PAYTS.currency_cd%TYPE,
	p_curr_desc			   	  	IN OUT GIIS_CURRENCY.currency_desc%TYPE,
	p_foreign_curr_amt	   		IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
	p_def_wtax_amt		   		IN OUT NUMBER,
	p_drv_comm_amt				IN OUT NUMBER,
	p_def_comm_amt				IN OUT NUMBER,
	p_def_input_vat				IN OUT NUMBER,
	p_dsp_policy_id				IN OUT GIPI_COMM_INVOICE.policy_id%TYPE,
	p_dsp_intm_name				IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
	p_dsp_assd_no				IN OUT GIPI_POLBASIC.assd_no%TYPE,
	p_dsp_assd_name				IN OUT GIIS_ASSURED.assd_name%TYPE,
	p_dsp_line_cd				IN OUT VARCHAR2,
	p_var_vat_rt				IN OUT GIIS_INTERMEDIARY.input_vat_rate%TYPE,
	p_var_clr_rec				IN OUT VARCHAR2,
	p_var_v_pol_flag			IN OUT GIPI_POLBASIC.pol_flag%TYPE,
	p_var_has_premium			IN OUT VARCHAR2,
	p_var_c_premium_amt			IN OUT GIAC_DIRECT_PREM_COLLNS.premium_amt%type,
	p_var_inv_prem_amt			IN OUT GIPI_INVOICE.prem_amt%TYPE,
	p_var_other_charges  		IN OUT GIPI_INVOICE.other_charges%TYPE,
    p_var_notarial_fee			IN OUT GIPI_INVOICE.notarial_fee%TYPE,
	p_var_pd_prem_amt			IN OUT GIAC_DIRECT_PREM_COLLNS.COLLECTION_AMT%TYPE,
	p_var_pct_prem				IN OUT NUMBER,
	p_var_cg_dummy				IN OUT VARCHAR2,
	p_var_comm_payable_param	IN OUT NUMBER,
	p_var_max_input_vat			IN OUT NUMBER,
	p_var_last_wtax				IN OUT NUMBER,
	p_var_invoice_butt			IN OUT VARCHAR2,
	p_var_prev_comm_amt     	IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_var_prev_wtax_amt	   		IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
	p_var_prev_input_vat	    IN OUT GIAC_COMM_PAYTS.input_vat_amt%TYPE,
	p_var_p_tran_type	   		IN OUT GIAC_COMM_PAYTS.tran_type%TYPE,
	p_var_p_tran_id		   		IN OUT GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
	p_var_r_comm_amt		    IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_var_i_comm_amt		    IN OUT GIPI_COMM_INVOICE.commission_amt%TYPE,
	p_var_p_comm_amt   	   		IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_var_r_wtax			    IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
	p_var_fdrv_comm_amt	   		IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_var_def_fgn_curr	   		IN OUT GIAC_COMM_PAYTS.foreign_curr_amt%TYPE,
	p_var_i_wtax			    IN OUT GIPI_COMM_INVOICE.wholding_tax%TYPE,
	p_var_p_wtax			    IN OUT GIAC_COMM_PAYTS.wtax_amt%TYPE,
	p_var_var_tran_type	   		IN OUT NUMBER,
	p_var_input_vat_param   	IN OUT NUMBER,
	p_var_c_fire_now   			IN OUT VARCHAR2,
	p_control_v_comm_amt	    IN OUT GIAC_COMM_PAYTS.comm_amt%TYPE,
	p_control_sum_inp_vat   	IN OUT NUMBER,
	p_control_v_input_vat   	IN OUT NUMBER,
	p_control_sum_comm_amt  	IN OUT NUMBER,
	p_control_sum_wtax_amt  	IN OUT NUMBER,
	p_control_v_wtax_amt	    IN OUT NUMBER,
	p_control_sum_net_comm_amt  IN OUT NUMBER,
	p_policy_status				   OUT VARCHAR2,
	p_gipi_invoice_exist		   OUT VARCHAR2,
	p_inv_comm_fully_paid		   OUT VARCHAR2,
	p_valid_comm_amt			   OUT VARCHAR2,
	p_policy_fully_paid			   OUT VARCHAR2,
	p_invalid_tran_type1_2     	   OUT VARCHAR2,
	p_invalid_tran_type3_4     	   OUT VARCHAR2,
	p_no_tran_type			  	   OUT VARCHAR2, -- 0 if OK, otherwise, enter the transaction type number
	p_pd_prem					   OUT VARCHAR2,
	p_policy_override			   OUT VARCHAR2,
	p_ps_pd_prem_amt			   OUT GIPI_INVOICE.prem_amt%TYPE,
	p_ps_tot_prem_amt			   OUT GIPI_INVOICE.prem_amt%TYPE,
	p_message					   OUT VARCHAR2
)
IS
  /*
  **  Created by   :  Emman
  **  Date Created :  09.21.2010
  **  Reference By : (GIACS020 - Comm Payts)
  **  Description  : Validate intm no
  */ 
BEGIN
    p_message := 'SUCCESS';
	p_ps_pd_prem_amt  := null;
	p_ps_tot_prem_amt := null;
	BEGIN
		p_policy_status	:= 'OK';
		p_gipi_invoice_exist := 'Y';
		p_inv_comm_fully_paid := 'N';
		p_valid_comm_amt := 'Y';
		p_policy_fully_paid := 'Y';
		p_pd_prem := 'Y';
		p_policy_override := 'N';
		p_no_tran_type := '0';
		
		--GET_VAT_RATE
		FOR cur IN (SELECT nvl(input_vat_rate,0)vat_rt
	                  FROM giis_intermediary
	                 WHERE intm_no = p_intm_no) 
	    LOOP
	      p_var_vat_rt := cur.vat_rt;
	    END LOOP;
	 
	
		IF (   p_intm_no IS NOT NULL  -- OR
		   AND p_iss_cd IS NOT NULL   -- OR
		   AND p_prem_seq_no IS NOT NULL) 
		   THEN
		 	BEGIN
			  GIAC_COMM_PAYTS_PKG.chk_gcop_comm_inv_giac_pa(p_intm_no, p_iss_cd, p_prem_seq_no, p_dsp_policy_id, p_dsp_intm_name, p_dsp_assd_no, p_dsp_assd_name, TRUE);
		  EXCEPTION
		    WHEN NO_DATA_FOUND THEN
		      p_message := 'Warning: This Intm. No.,Iss Cd,Bill No. does not exist';
		      p_var_clr_rec := 'Y';
			  RETURN;
		  END;
		  
		  
		  DECLARE
		    CURSOR C IS
		      SELECT '1'
		      FROM    GIAC_COMM_PAYTS
		      WHERE   GACC_TRAN_ID = P_GACC_TRAN_ID
		      AND     INTM_NO = P_INTM_NO
		      AND     ISS_CD = P_ISS_CD
		      AND     PREM_SEQ_NO = P_PREM_SEQ_NO
		      AND     p_comm_tag = 'N';
		  BEGIN
			  OPEN C;
			  FETCH C
			  INTO 
			    p_var_cg_dummy;
			  IF C%NOTFOUND THEN
			    p_var_cg_dummy := '2';
			    RAISE NO_DATA_FOUND;
			  END IF;
			  CLOSE C;
			   
			  p_message := 'Warning: Row with same TRAN ID,INTM. NO.,BILL NO. already exists.';
		      p_var_clr_rec := 'Y';
			  RETURN;
		    EXCEPTION
		    WHEN NO_DATA_FOUND THEN NULL;
		  END;
		END IF;
	END;
	
	BEGIN
		FOR c IN(SELECT a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
		           			to_char(a.issue_yy)||'-'||to_char(a.pol_seq_no)||'-'||
		           			to_char(a.renew_no)||'\'||a.endt_iss_cd||'-'||to_char(a.endt_yy)||'-'||
		           			to_char(a.endt_seq_no) dsp_line_cd, 
		           		  pol_flag  
		      		 FROM gipi_polbasic  a
		          		 ,gipi_comm_invoice b
		     			WHERE a.policy_id   = b.policy_id
		       			AND b.iss_cd      = p_iss_cd
		       			AND b.prem_seq_no = p_prem_seq_no)
		LOOP
			p_dsp_line_cd := c.dsp_line_cd;
			p_var_v_pol_flag := c.pol_flag;
			EXIT;
		END LOOP;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN NULL;
	END;
	
	IF p_var_v_pol_flag = '4' THEN
	   --msg_alert('This is a cancelled policy.','I',FALSE);
	   p_policy_status := 'cancelled';
	ELSIF p_var_v_pol_flag = '5' THEN
	   --msg_alert('This is a spoiled policy.','I',FALSE);
	   p_policy_status := 'spoiled';
	   p_var_clr_rec := 'Y';
	END IF;
	
	BEGIN
	 	IF ((p_var_comm_payable_param = 2) AND (p_tran_type = 1 ))THEN
			DECLARE
				var_premium_amt	  giac_direct_prem_collns.premium_amt%TYPE := 0;
				v_inv_prem_amt    gipi_invoice.prem_amt%type;
			BEGIN			
			    BEGIN
				  SELECT nvl(round(prem_amt*currency_rt,2),0)
				    INTO v_inv_prem_amt
				    FROM gipi_invoice
				   WHERE iss_cd      = p_iss_cd
				     AND prem_seq_no = p_prem_seq_no;
			    EXCEPTION
				  WHEN no_data_found THEN
					  --p_message := 'No existing record in GIPI_INVOICE table.';
					  p_gipi_invoice_exist := 'N';	
			    END;
				
				FOR rec IN (SELECT premium_amt
											FROM giac_direct_prem_collns a , giac_acctrans b
										 WHERE a.gacc_tran_id = b.tran_id
											 AND b.tran_flag <> 'D'
											 AND a.b140_iss_cd     = p_iss_cd
											 AND a.b140_prem_seq_no = p_prem_seq_no
											 AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
																		  FROM giac_reversals c, giac_acctrans d
																		 WHERE c.reversing_tran_id=d.tran_id
											 AND d.tran_flag<>'D'))
				LOOP
					var_premium_amt := NVL(var_premium_amt,0) + NVL(rec.premium_amt,0);
				END LOOP;
			
			  IF (NVL(var_premium_amt,0) = 0 AND v_inv_prem_amt <> 0) THEN   -- judyann 09112006; to handle 0 net premium but with adjustments in commission		
					--msg_alert('No premium payment has been made for this policy.','I',FALSE);
					p_pd_prem := 'N';
					p_var_CLR_REC := 'Y';
					p_var_HAS_PREMIUM  := 'N';
				ELSE
					p_var_c_premium_amt := var_premium_amt ;
				END IF;
			END;
			
			IF p_var_HAS_PREMIUM = 'Y' and NVL(GIACP.v('NO_PREM_PAYT'),'N') = 'N' THEN --added condition by robert SR 19679 07.13.15
				--PARAM2_CHECK_PREM_PAYT;
				DECLARE
					var_prem_amt       		gipi_invoice.prem_amt%TYPE := 0 ;
					var_tax_amt 	   		gipi_invoice.tax_amt%TYPE := 0;
					var_currency_rt	   		gipi_invoice.currency_rt%TYPE  := 0;
					var_tot_prem_amt   		gipi_invoice.prem_amt%TYPE := 0 ;
					var_pd_prem_amt    		gipi_invoice.prem_amt%TYPE := 0 ;
					var_rem_unpd_amt   		gipi_invoice.prem_amt%TYPE := 0 ;
					var_ps_tot_prem_amt		gipi_invoice.prem_amt%TYPE := 0 ; 
					var_ps_pd_prem_amt   	gipi_invoice.prem_amt%TYPE := 0 ;
				BEGIN
					FOR REC IN (SELECT prem_amt, tax_amt, currency_rt 
								  FROM gipi_invoice
								 WHERE iss_cd = p_iss_cd
								   AND prem_seq_no = p_prem_seq_no) 
					LOOP
					  	var_ps_tot_prem_amt := ROUND(NVL(REC.prem_amt,0) * nvl(REC.currency_rt,0),2);
						IF REC.currency_rt <> 1 THEN			
							 var_tot_prem_amt    := (ROUND(NVL(REC.prem_amt,0) * NVL(REC.currency_rt,0),2))+ get_loc_inv_tax_sum(p_iss_cd,p_prem_seq_no);
						ELSE
							 var_tot_prem_amt    := (ROUND(NVL(REC.prem_amt,0) * NVL(REC.currency_rt,0),2))+ (ROUND(NVL(REC.tax_amt,0)*NVL(REC.currency_rt,0),2));
						END IF;	
						--v--
						EXIT;
					END LOOP;
				
					FOR REC2 IN (SELECT premium_amt, tax_amt
								   FROM giac_direct_prem_collns a,  giac_acctrans b
								  WHERE a.gacc_tran_id = b.tran_id
									AND b.tran_flag <> 'D'
									AND a.b140_iss_cd = p_iss_cd
									AND a.b140_prem_seq_no = p_prem_seq_no
									AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
																 FROM giac_reversals c, giac_acctrans d
																WHERE c.reversing_tran_id = d.tran_id
																  AND d.tran_flag <> 'D')) 
					LOOP
						var_ps_pd_prem_amt := nvl(var_ps_pd_prem_amt,0) + nvl(REC2.premium_amt,0) ;
						var_pd_prem_amt := nvl(var_pd_prem_amt,0) + nvl(REC2.premium_amt,0) + nvl(REC2.tax_amt,0);
					END LOOP;
				
					var_rem_unpd_amt :=  nvl(var_tot_prem_amt,0) - nvl(var_pd_prem_amt,0); 
				
					IF nvl(var_rem_unpd_amt,0) = 0  THEN
				  	    p_def_comm_tag := 'Y';
						GIAC_COMM_PAYTS_PKG.get_def_prem_pct(p_iss_cd, p_prem_seq_no, p_var_inv_prem_amt, p_var_other_charges, p_var_notarial_fee, p_var_pd_prem_amt, p_var_c_premium_amt, p_var_has_premium, p_var_clr_rec, p_var_pct_prem, p_pd_prem, p_message);
						IF p_message <> 'SUCCESS' THEN
						   RETURN;
						END IF;
					    DECLARE
						  var_comm_amt       		gipi_comm_invoice.commission_amt%TYPE := 0;
						  var_prnt_comm_amt  		gipi_comm_invoice.commission_amt%TYPE := 0;
						  var_whold_tax      		gipi_comm_invoice.wholding_tax%TYPE  := 0;
						  var_prnt_whold_tax  		gipi_comm_invoice.wholding_tax%TYPE  := 0;
						  var_curr_rt        		gipi_invoice.currency_rt%TYPE := 0;
						  var_rec_comm_amt   		giac_comm_payts.comm_amt%TYPE := 0;
						  var_rec_wtax_amt   		giac_comm_payts.wtax_amt%TYPE := 0;
						  var_comp_comm_amt  		giac_comm_payts.comm_amt%TYPE := 0;
						  var_comp_wtax_amt  		giac_comm_payts.wtax_amt%TYPE := 0;
						  var_rec_input_vat_amt     giac_comm_payts.comm_amt%TYPE := 0;
						  var_intm                  gipi_comm_invoice.intrmdry_intm_no%TYPE;
						  var_prnt_intm             gipi_comm_invoice.parent_intm_no%TYPE;
						BEGIN
						  FOR rec IN (SELECT comm_amt, wtax_amt, input_vat_amt
								  		FROM giac_comm_payts a, giac_acctrans b
								  	   WHERE a.gacc_tran_id = b.tran_id
								    	 AND b.tran_flag <> 'D'
							             AND a.iss_cd = p_iss_cd
								    	 AND a.prem_seq_no = p_prem_seq_no
								    	 AND a.intm_no = p_intm_no
								    	 AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
											       					  FROM giac_reversals c, giac_acctrans d
											       					 WHERE c.reversing_tran_id = d.tran_id
											       					   AND d.tran_flag<>'D')) 
							LOOP 
								var_rec_comm_amt   := NVL(var_rec_comm_amt,0) + nvl(rec.comm_amt,0);
								var_rec_wtax_amt   := NVL(var_rec_wtax_amt,0) + nvl(rec.wtax_amt,0);
								var_rec_input_vat_amt   := NVL(var_rec_input_vat_amt,0) + nvl(rec.input_vat_amt,0);--Vincent 050505: hold value of input_vat_amount                
						  END LOOP;
						       
						  -- added exception (emman 06.07.2011)
						  BEGIN
							  SELECT j.commission_amt, j.wholding_tax,
								       j.currency_rt, j.intrmdry_intm_no 
								  INTO var_comm_amt, var_whold_tax, 
								       var_curr_rt, var_intm
							  	FROM (SELECT a.commission_amt, a.wholding_tax,
									             b.currency_rt, a.intrmdry_intm_no,
									             a.iss_cd, a.prem_seq_no
								    	FROM GIPI_COMM_INVOICE a, GIPI_INVOICE b, GIIS_INTERMEDIARY c
									   WHERE a.iss_cd = b.iss_cd
										 AND a.prem_seq_no = b.prem_seq_no
										 AND a.intrmdry_intm_no = c.intm_no 
										 AND c.lic_tag = 'Y' 
									   UNION
									  SELECT c.commission_amt, c.wholding_tax, 
											 b.currency_rt, c.intrmdry_intm_no,
											 c.iss_cd, c.prem_seq_no
										FROM GIPI_INVOICE b, GIPI_COMM_INV_DTL c, GIIS_INTERMEDIARY d
									   WHERE b.iss_cd = c.iss_cd
										 AND b.prem_seq_no = c.prem_seq_no
										 AND c.intrmdry_intm_no = d.intm_no
										 AND d.lic_tag = 'N') j
								 WHERE j.iss_cd = p_iss_cd
							 	   AND j.prem_seq_no = p_prem_seq_no
								   AND j.intrmdry_intm_no = p_intm_no;
						  EXCEPTION
						  	WHEN NO_DATA_FOUND THEN
								 var_comm_amt  	   := NULL;
								 var_whold_tax 	   := NULL;
								 var_curr_rt	   := NULL;
								 var_intm		   := NULL;
						  END;
						
							   var_comp_comm_amt := (nvl(var_comm_amt,0) * nvl(var_curr_rt,0))- var_rec_comm_amt;
							   var_comp_wtax_amt := (nvl(var_whold_tax,0) * nvl(var_curr_rt,0))- var_rec_wtax_amt; 
							
						  IF var_comp_comm_amt = 0 THEN
								DECLARE
									var_rec_comm_amt   GIAC_COMM_PAYTS.comm_amt%type := 0;
									var_tot_comm_amt   GIPI_COMM_INVOICE.commission_amt%type := 0;
									var_c_tot_comm 	   GIPI_COMM_INVOICE.commission_amt%type;
									var_c_rec_comm	   GIAC_COMM_PAYTS.comm_amt%type;
									var_c_rem_comm	   GIPI_COMM_INVOICE.commission_amt%type;
								BEGIN
								  FOR REC IN (SELECT comm_amt
												FROM giac_comm_payts a, giac_acctrans b
											   WHERE a.gacc_tran_id = b.tran_id
												 AND b.tran_flag <> 'D'
												 AND a.iss_cd = p_iss_cd
												 AND a.prem_seq_no = p_prem_seq_no
												 AND a.intm_no = p_intm_no
												 AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id 
																			  FROM giac_reversals c, giac_acctrans d
																			 WHERE c.reversing_tran_id=d.tran_id
																			   AND d.tran_flag<>'D')) 
									LOOP
										var_rec_comm_amt   := NVL(var_rec_comm_amt,0) +  nvl(REC.comm_amt,0);
								  END LOOP;
								
								  FOR REC2 IN (SELECT nvl(c.commission_amt,a.commission_amt) commission_amt, 
								                      b.currency_rt, a.intrmdry_intm_no, a.parent_intm_no
												 FROM gipi_comm_invoice a, gipi_invoice b, gipi_comm_inv_dtl c
												WHERE a.iss_cd = b.iss_cd
												  AND a.prem_seq_no = b.prem_seq_no
												  AND a.iss_cd = c.iss_cd(+)
												  AND a.prem_seq_no = c.prem_seq_no(+)
												  AND a.intrmdry_intm_no = c.intrmdry_intm_no(+)
												  AND a.iss_cd = p_iss_cd
												  AND a.prem_seq_no = p_prem_seq_no
												  AND a.intrmdry_intm_no = p_intm_no)
									LOOP
								 	  var_tot_comm_amt := NVL(var_tot_comm_amt,0) + (NVL(REC2.commission_amt,0) * NVL(REC2.currency_rt,0));
								  END LOOP;
								
									var_c_tot_comm := NVL(var_tot_comm_amt,0); 
									var_c_rec_comm := NVL(var_rec_comm_amt,0);   
									var_c_rem_comm := NVL(var_c_tot_comm,0) - NVL(var_c_rec_comm,0); 
									
									IF NVL(var_c_rem_comm,0) = 0 THEN
										--msg_alert('Invoice Commission Fully Paid.','I',FALSE);
										p_inv_comm_fully_paid := 'Y';
										p_var_clr_rec := 'Y';
										RETURN;
									END IF;
								END;
							ELSIF var_comp_comm_amt > 0 THEN      
								p_comm_amt := var_comp_comm_amt;
							    p_wtax_amt := (nvl(var_whold_tax,0) * nvl(var_curr_rt,0))- var_rec_wtax_amt;
								p_input_vat_amt := nvl(nvl(p_comm_amt,0) *  nvl(p_var_vat_rt,0)/100,0);
						
								p_var_max_input_vat := (var_comp_comm_amt *	(nvl(p_var_vat_rt,0)/100));			  			  
						
							    p_drv_comm_amt := p_comm_amt - (p_wtax_amt - nvl(p_input_vat_amt,0) );
							ELSE 
								--msg_alert('No valid amount of commission for this transaction type.','I',false);
								p_valid_comm_amt  := 'N';
								p_var_clr_rec := 'Y';
							END IF;
						
							p_def_comm_amt := p_comm_amt;
							p_def_input_vat := p_input_vat_amt;
						
							p_var_last_wtax := p_wtax_amt;
						END;
					ELSE
						 IF p_def_comm_tag_displayed = 'Y' THEN
							  IF p_var_invoice_butt = 'Y' THEN
								   p_def_comm_tag := 'N';
								   GIAC_COMM_PAYTS_PKG.param2_mgmt_comp(p_iss_cd, p_prem_seq_no, p_intm_no, p_comm_amt, p_wtax_amt, p_drv_comm_amt, p_def_comm_amt, p_var_max_input_vat, p_var_vat_rt, p_var_clr_rec, p_valid_comm_amt, var_ps_pd_prem_amt, var_ps_tot_prem_amt);
							  ELSE
							  	  p_policy_override := 'Y';
								  p_ps_pd_prem_amt  := var_ps_pd_prem_amt;
								  p_ps_tot_prem_amt := var_ps_tot_prem_amt;
							  	  --sa labas din to.
							   	  /*IF Id_Null(al_id) THEN 
								    	Message('User_Warning alert does not exist'); 
									    RAISE Form_Trigger_Failure; 
								   ELSE 
		  						    	IF al_button = ALERT_BUTTON1 THEN 
		  								     p_def_comm_tag := 'N';
		  								     param2_mgmt_comp(p_iss_cd, p_prem_seq_no, p_intm_no, p_comm_amt, p_wtax_amt, p_drv_comm_amt, p_def_comm_amt, p_var_max_input_vat, p_var_vat_rt, p_var_clr_rec, p_valid_comm_amt, var_ps_pd_prem_amt, var_ps_tot_prem_amt);
		  							    ELSE
		  								     p_var_CLR_REC := 'Y';				
		  							    END IF;
								   END IF;*/
							  END IF;
						 ELSE
							  --msg_alert(' Policy is not yet fully paid.', 'I', false);
							  p_policy_fully_paid := 'N';
							  p_var_CLR_REC := 'Y';
						 END IF;
					END IF;
				END;
			END IF;
		ELSE
			IF p_DEF_COMM_TAG = 'Y' AND p_tran_type IN (1,3) THEN
				GIAC_COMM_PAYTS_PKG.get_def_prem_pct(p_iss_cd, p_prem_seq_no, p_var_inv_prem_amt, p_var_other_charges, p_var_notarial_fee, p_var_pd_prem_amt, p_var_c_premium_amt, p_var_has_premium, p_var_clr_rec, p_var_pct_prem, p_pd_prem, p_message);
				IF p_message <> 'SUCCESS' THEN
				   RETURN;
				END IF;
			END IF;
			GIAC_COMM_PAYTS_PKG.giacs020_comp_summary(p_def_comm_tag,
                       p_bill_gacc_tran_id,     -- shan 10.02.2014
		  			   p_prem_seq_no,
					   p_intm_no,
					   p_iss_cd,
					   p_tran_type,
					   p_convert_rate,
					   p_currency_cd,
					   p_curr_desc,
					   p_input_vat_amt,
					   p_comm_amt,
					   p_wtax_amt,
					   p_foreign_curr_amt,
					   p_def_input_vat,
					   p_drv_comm_amt,
					   p_def_comm_amt,
					   p_def_wtax_amt,
		  			   p_var_cg_dummy,
		  			   p_var_prev_comm_amt,
					   p_var_prev_wtax_amt,
					   p_var_prev_input_vat,
					   p_var_p_tran_type,
					   p_var_p_tran_id,
					   p_var_r_comm_amt,
					   p_var_i_comm_amt,
					   p_var_p_comm_amt,
					   p_var_r_wtax,
					   p_var_fdrv_comm_amt,
					   p_var_def_fgn_curr,
					   p_var_pct_prem,
					   p_var_i_wtax,
					   p_var_p_wtax,
					   p_var_var_tran_type,
					   p_var_vat_rt,
					   p_var_input_vat_param,
					   p_var_has_premium,
					   p_var_clr_rec,
					   p_control_v_comm_amt,
					   p_control_sum_inp_vat,
					   p_control_v_input_vat,
					   p_control_sum_comm_amt,
					   p_control_sum_wtax_amt,
					   p_control_v_wtax_amt,
					   p_control_sum_net_comm_amt,
					   p_invalid_tran_type1_2,
					   p_invalid_tran_type3_4,
					   p_no_tran_type,
					   p_inv_comm_fully_paid,
					   p_message);
			IF p_message <> 'SUCCESS' THEN
			   RETURN;
			END IF;
		END IF;
		p_var_c_fire_now := 'Y';
	END;
	
	--POST-TEXT-ITEM
	--GIAC_COMM_PAYTS_PKG.giacs020_intm_no_post_text(p_comm_amt, p_prem_seq_no, p_intm_no, p_iss_cd, p_wtax_amt, p_def_comm_tag, p_var_last_wtax);
END giacs020_validate_intm_no;
/



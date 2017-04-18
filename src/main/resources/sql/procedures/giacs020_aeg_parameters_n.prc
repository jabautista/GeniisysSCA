DROP PROCEDURE CPI.GIACS020_AEG_PARAMETERS_N;

CREATE OR REPLACE PROCEDURE CPI.giacs020_aeg_parameters_n(
	   	  		  		   p_gacc_branch_cd			  IN	 GIAC_ACCTRANS.gibr_branch_cd%TYPE,
						   p_gacc_fund_cd			  IN	 GIAC_ACCTRANS.gfun_fund_cd%TYPE,
						   p_gacc_tran_id			  IN	 GIAC_ACCTRANS.tran_id%TYPE,
						   p_iss_cd					  IN	 GIAC_COMM_PAYTS.iss_cd%TYPE,
						   p_prem_seq_no			  IN	 GIAC_COMM_PAYTS.prem_seq_no%TYPE,
						   p_intm_no				  IN	 GIAC_COMM_PAYTS.intm_no%TYPE,
						   p_record_no				  IN	 GIAC_COMM_PAYTS.record_no%TYPE,
						   p_disb_comm				  IN	 GIAC_COMM_PAYTS.disb_comm%TYPE,
						   p_drv_comm_amt		  	  IN	 NUMBER,
						   p_currency_cd			  IN	 GIAC_COMM_PAYTS.currency_cd%TYPE,
						   p_convert_rate			  IN	 GIAC_COMM_PAYTS.convert_rate%TYPE,
	   	  		  		   p_var_comm_take_up		  IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
						   p_var_v_item_num			  IN OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
						   p_var_v_bill_no			  IN OUT GIPI_INVOICE.prem_seq_no%TYPE,
						   p_var_v_issue_cd			  IN OUT GIPI_INVOICE.iss_cd%TYPE,
	   	  		  		   aeg_tran_id      		  IN     GIAC_ACCTRANS.tran_id%TYPE,
                           aeg_module_nm    		  IN	 GIAC_MODULES.module_name%TYPE,
			               aeg_sl_type_cd1  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd2  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd3  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
						   p_message 				     OUT VARCHAR2) IS
  

/***  For COMMISSIONS PAYABLE...*/
  CURSOR PREMIUM_CUR IS
    SELECT c.iss_cd iss_cd, c.comm_amt, c.prem_seq_no bill_no,
           a.line_cd, c.intm_no, a.assd_no, x.acct_line_cd,
           a.type_cd, c.wtax_amt, c.input_vat_amt,
           DECODE(aeg_sl_type_cd1,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', c.intm_no,
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd1,
           DECODE(aeg_sl_type_cd2,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', c.intm_no,
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd2,
           DECODE(aeg_sl_type_cd3,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', c.intm_no,
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd3
      FROM gipi_polbasic a, gipi_invoice  b, giac_comm_payts c, giis_line x
   --        gipi_parlist d
     WHERE a.policy_id    = b.policy_id
       AND b.iss_cd       = c.iss_cd
       AND b.prem_seq_no  = c.prem_seq_no
       AND c.tran_type   != 5
       AND c.gacc_tran_id = aeg_tran_id
       AND a.line_cd      = x.line_cd;
       ---AND a.acct_ent_date IS NOT NULL;

--- Negative factor used for collection amt
  negative_one  NUMBER := 1;
  w_sl_cd       GIAC_ACCT_ENTRIES.sl_cd%TYPE;
  v_intm_no     GIAC_COMM_PAYTS.intm_no%TYPE;
  v_pd_exist		VARCHAR2(1);      

BEGIN
   p_message := 'SUCCESS';
  /*** Call the deletion of accounting entry procedure.***/
  
  --GET_COMM_PAYABLE_TAKE_UP;
  SELECT param_value_n
    INTO   p_var_comm_take_up
    FROM   GIAC_PARAMETERS
    WHERE  param_name = 'COMM_PAYABLE_TAKE_UP';
      
  IF p_var_comm_take_up IN (1,2) THEN   	--1.1
     BEGIN
       FOR PREMIUM_rec IN PREMIUM_CUR LOOP
       	 p_var_v_item_num := p_var_comm_take_up; --jason 9/17/2008
       	 p_var_v_bill_no := premium_rec.bill_no; --jason 9/17/2008
       	 p_var_v_issue_cd := premium_rec.iss_cd; --jason 9/17/2008
         PREMIUM_rec.comm_amt := NVL(PREMIUM_rec.comm_amt, 0) * negative_one;
         IF PREMIUM_rec.assd_no IS NULL THEN
            FOR i IN
              (SELECT d.assd_no assd_no
                 FROM gipi_polbasic a, gipi_invoice  b, giac_comm_payts c,
                  gipi_parlist d
                WHERE a.policy_id    = b.policy_id
                  AND b.iss_cd       = premium_rec.iss_cd
                  AND b.prem_seq_no  = premium_rec.bill_no
                  AND c.tran_type   != 5
                  AND c.gacc_tran_id = aeg_tran_id
                  AND a.par_id       = d.par_id)
            LOOP
              premium_rec.assd_no := i.assd_no;
            END LOOP;
         END IF;

         giacs020_comm_payable_proc_n(
		 					 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
							 aeg_sl_type_cd1, aeg_sl_type_cd2, aeg_sl_type_cd3,
							 p_var_comm_take_up, p_var_v_item_num, p_var_v_bill_no, p_var_v_issue_cd,
		 					 premium_rec.intm_no,       premium_rec.assd_no,
                             premium_rec.acct_line_cd,  premium_rec.comm_amt, 
                             premium_rec.wtax_amt,      premium_rec.line_cd, 
                             premium_rec.input_vat_amt, premium_rec.sl_cd1,
                             premium_rec.sl_cd2,        premium_rec.sl_cd3, p_message) ;
       END LOOP;
       giacs020_overdraft_comm_entry(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
														p_iss_cd, p_prem_seq_no, p_intm_no,
														p_record_no, p_disb_comm, p_drv_comm_amt,
														p_currency_cd, p_convert_rate, p_message);                            
     END;
  ELSE  
 	   BEGIN	--b1
       SELECT NVL(a.parent_intm_no, intm_no)
       	 INTO w_sl_cd
      	 FROM giis_intermediary a, giis_co_intrmdry_types b
        WHERE a.intm_type = b.co_intm_type
      		AND a.intm_no   = v_intm_no;
     EXCEPTION
      	WHEN NO_DATA_FOUND THEN
	       	p_message := 'COMM_PAYABLE_PROC - No data found in GIIS_CO_INTRMDRY_TYPES.';
			RETURN;
     END;
  END IF;

END;
/



DROP PROCEDURE CPI.GIACS020_AEG_PARAMETERS_Y;

CREATE OR REPLACE PROCEDURE CPI.giacs020_aeg_parameters_y(
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
	   	  		  		   p_var_module_name		  IN     VARCHAR2,
						   p_var_module_id			  IN     GIAC_MODULES.module_id%TYPE,
						   p_var_gen_type			  IN     GIAC_MODULES.generation_type%TYPE,
						   p_var_comm_take_up		  IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
	   	  		  		   aeg_tran_id      		  IN     GIAC_ACCTRANS.tran_id%TYPE,
                           aeg_module_nm    		  IN	 GIAC_MODULES.module_name%TYPE,
		                   aeg_sl_type_cd1  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd2  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
                           aeg_sl_type_cd3  		  IN	 GIAC_PARAMETERS.param_name%TYPE,
						   p_message				     OUT VARCHAR2) IS  

/***  For COMMISSION EXPENSE...*/

  CURSOR PREMIUM_CUR IS
    SELECT c.iss_cd iss_cd ,
           ROUND((y.commission_amt/w.commission_amt)*c.comm_amt,2) comm_amt,
           ROUND((y.wholding_tax/w.wholding_tax)*c.wtax_amt,2) wtax_amt,
           ROUND((y.wholding_tax/w.wholding_tax)*C.input_vat_amt,2) input_vat_amt,
           c.prem_seq_no bill_no, a.line_cd ,x.acct_line_cd,
	         c.intm_no, a.assd_no,
	         LTRIM(TO_CHAR(x.acct_line_cd,'00'))||LTRIM(TO_CHAR(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00000')) lsp,
	         a.type_cd, 
           DECODE(aeg_sl_type_cd1,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00000')),
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL) sl_cd1,
           DECODE(aeg_sl_type_cd2,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00000')),
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL)sl_cd2,
           DECODE(aeg_sl_type_cd3,'ASSD_SL_TYPE', a.assd_no,
                                  'INTM_SL_TYPE', LTRIM(TO_CHAR(x.acct_line_cd,'00'))||ltrim(to_char(z.acct_subline_cd,'00'))||LTRIM(TO_CHAR(peril_cd,'00000')),
                                  'LINE_SL_TYPE', x.acct_line_cd, NULL, NULL)sl_cd3
      FROM gipi_polbasic a, gipi_invoice  b, giac_comm_payts c,
           giis_line x, gipi_comm_inv_peril y, gipi_comm_invoice w,
           giis_subline z
     WHERE a.policy_id    = b.policy_id
       AND b.iss_cd       = c.iss_cd
       AND b.prem_seq_no  = c.prem_seq_no
       AND c.tran_type   != 5
       AND a.line_cd      = x.line_cd
       AND b.iss_cd       = y.iss_cd
       AND c.gacc_tran_id = aeg_tran_id
       AND b.prem_seq_no  = y.prem_seq_no
       AND w.iss_cd       = y.iss_cd
       AND w.prem_seq_no  = y.prem_seq_no
       AND w.policy_id    = b.policy_id
       AND a.line_cd      = z.line_cd
       AND X.LINE_CD      = Z.LINE_CD
       AND A.SUBLINE_CD   = Z.SUBLINE_CD
       AND c.intm_no      = y.intrmdry_intm_no --added by robert 04.24.15
       AND c.intm_no      = w.intrmdry_intm_no; --added by robert 04.24.15
       ---AND a.acct_ent_date >= '30-SEP-03';
           

--- Negative factor used for collection amt
 negative_one NUMBER := 1;
 w_sl_cd      GIAC_ACCT_ENTRIES.sl_cd%TYPE;
 v_intm_no    GIAC_COMM_PAYTS.intm_no%TYPE;

BEGIN

  p_message := 'SUCCESS';

  /*** Call the deletion of accounting entry procedure.***/
  p_var_comm_take_up:= 6;

  BEGIN
    FOR PREMIUM_rec IN PREMIUM_CUR LOOP
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

      giacs020_comm_payable_proc_y(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id, p_var_comm_take_up,
	  							  aeg_sl_type_cd1, aeg_sl_type_cd2, aeg_sl_type_cd3,
			  					  premium_rec.intm_no,      premium_rec.assd_no,
		                          premium_rec.acct_line_cd, premium_rec.comm_amt, 
		                          premium_rec.wtax_amt,     premium_rec.line_cd,
		                          premium_rec.lsp,          premium_rec.input_vat_amt,
		                          premium_rec.sl_cd1,       premium_rec.sl_cd2,
		                          premium_rec.sl_cd3, p_message) ;
    END LOOP;
    giacs020_overdraft_comm_entry(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
														p_iss_cd, p_prem_seq_no, p_intm_no,
														p_record_no, p_disb_comm, p_drv_comm_amt,
														p_currency_cd, p_convert_rate, p_message);
  END;
END giacs020_aeg_parameters_y;
/



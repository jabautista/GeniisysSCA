DROP PROCEDURE CPI.AEG_PARAMETERS_Y_PREM_REC;

CREATE OR REPLACE PROCEDURE CPI.aeg_parameters_Y_prem_rec(aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
                                  aeg_module_nm   GIAC_MODULES.module_name%TYPE,
								  p_item_no OUT number,
								  p_msg_alert       OUT    VARCHAR2,
								  p_giop_gacc_branch_cd GIAC_ACCT_ENTRIES.gacc_gibr_branch_cd%TYPE,
								  p_giop_gacc_fund_cd   GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%TYPE
								  ) IS
   
  cursor PR_cur is                 
    SELECT c.b140_iss_cd iss_cd      , sum(c.collection_amt) collection_amt,
           c.b140_prem_seq_no bill_no, a.line_cd       ,
	   d.assd_no                 , a.type_cd
      FROM gipi_polbasic a,
           gipi_invoice  b, 
           giac_direct_prem_collns c,
           gipi_parlist d 
     WHERE a.policy_id    = b.policy_id
       AND b.iss_cd       = c.b140_iss_cd
       AND b.prem_seq_no  = c.b140_prem_seq_no
       AND a.par_id       = d.par_id
       AND c.gacc_tran_id = aeg_tran_id
       and not exists (SELECT '1'
                         FROM giac_advanced_payt
                        WHERE iss_cd = c.b140_iss_cd
					                AND prem_seq_no = c.b140_prem_seq_no
					                AND inst_no = c.inst_no
					                AND gacc_tran_id = aeg_tran_id) 
       group by c.b140_iss_cd,
           c.b140_prem_seq_no, a.line_cd       ,
	   d.assd_no                 , a.type_cd;

  CURSOR EVAT_cur (p_iss_cd      gipi_invoice.iss_cd%type, 
                   p_bill_no     gipi_invoice.prem_seq_no%type) IS
      
		SELECT sum(tax_amt) tax_amt, b160_iss_cd, b160_prem_seq_no
      FROM giac_tax_collns
     WHERE b160_iss_cd = p_iss_cd
       AND b160_prem_seq_no = p_bill_no
       AND gacc_tran_id = aeg_tran_id
       AND b160_tax_cd = (select giacp.n('EVAT') from dual)
     GROUP BY b160_iss_cd, b160_prem_seq_no
    HAVING nvl(sum(tax_amt),0) <> 0; --Vincent 03062006: added so as not to generate 0 amt acct entries

	v_module_id giac_modules.module_id%TYPE;
    v_gen_type giac_modules.generation_type%TYPE;
BEGIN
dbms_output.put_line('HERE2.1');
  BEGIN
    SELECT module_id,
           generation_type
      INTO v_module_id,
           v_gen_type
      FROM giac_modules
     WHERE module_name  = aeg_module_nm;
    EXCEPTION
      WHEN no_data_found THEN
        p_msg_alert := ('No data found in GIAC MODULES.');
  END;

  FOR PR_rec in PR_cur LOOP
    /*
    ** Call the accounting entry generation procedure.
    */
    --
    --
    p_item_no := 1; --added by rochelle,05282008
                            --resolved problem that prems receivable should not be added to prem deposits in giac_acct_entries 
  
    AEG_Create_Acct_Entries_Y(PR_rec.assd_no   , v_module_id  ,
                            p_item_no, PR_rec.iss_cd        ,
                            PR_rec.bill_no   , PR_rec.line_cd       ,
                            PR_rec.type_cd   , PR_rec.collection_amt,
                            v_gen_type, 
							p_msg_alert, p_giop_gacc_branch_cd,
							p_giop_gacc_fund_cd, aeg_tran_id);



   FOR EVAT_rec IN EVAT_cur (pr_rec.iss_cd, pr_rec.bill_no) LOOP
     IF NVL(GIACP.V('OUTPUT_VAT_COLLN_ENTRY'),'N') = 'Y' THEN
      /* from giac_taxes
      AEG_Create_Acct_Entries_tax_N(VARIABLES.evat, EVAT_rec.tax_amt,
                                   VARIABLES.gen_type);
      */
      
      /* item_no 7 - deferred output vat*/
      AEG_Create_Acct_Entries_Y(null, v_module_id  ,
                            7, PR_rec.iss_cd        ,
                            PR_rec.bill_no   , PR_rec.line_cd       ,
                            PR_rec.type_cd   , EVAT_rec.tax_amt,
                            v_gen_type,
							p_msg_alert, p_giop_gacc_branch_cd,
							p_giop_gacc_fund_cd, aeg_tran_id);
      
      /* item_no 6 - output vat payable*/                            
      AEG_Create_Acct_Entries_Y(null, v_module_id  ,
                            6, PR_rec.iss_cd        ,
                            PR_rec.bill_no   , PR_rec.line_cd       ,
                            PR_rec.type_cd   , EVAT_rec.tax_amt,
                            v_gen_type, 
							p_msg_alert, p_giop_gacc_branch_cd,
							p_giop_gacc_fund_cd, aeg_tran_id);                            
     END IF;
   END LOOP;

  END LOOP; 
END;
/



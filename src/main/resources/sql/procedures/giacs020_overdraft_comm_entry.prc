DROP PROCEDURE CPI.GIACS020_OVERDRAFT_COMM_ENTRY;

CREATE OR REPLACE PROCEDURE CPI.giacs020_overdraft_comm_entry(
	   	  		  						p_gacc_branch_cd		IN	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
							  			p_gacc_fund_cd			IN	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
	   	  		  						p_gacc_tran_id			IN     GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
										p_iss_cd				IN     GIAC_COMM_PAYTS.iss_cd%TYPE,
										p_prem_seq_no			IN     GIAC_COMM_PAYTS.prem_seq_no%TYPE,
										p_intm_no				IN     GIAC_COMM_PAYTS.intm_no%TYPE,
										p_record_no				IN     GIAC_COMM_PAYTS.record_no%TYPE,
										p_disb_comm				IN	   GIAC_COMM_PAYTS.disb_comm%TYPE,
										p_drv_comm_amt			IN	   NUMBER,
										p_currency_cd			IN	   GIAC_COMM_PAYTS.currency_cd%TYPE,
										p_convert_rate			IN	   GIAC_COMM_PAYTS.convert_rate%TYPE,
										p_message				   OUT VARCHAR2)
IS
  /*
	**  Created by   :  Emman
	**  Date Created :  09.30.2010
	**  Reference By : (GIACS020 - Comm Payts)
	**  Description  : Executes procedure OVERDRAFT_COMM_ENTRY_PROC on GIACS020
	*/ 
  v_gl_acct_category       giac_acct_entries.gl_acct_category%TYPE; 
  v_gl_control_acct        giac_acct_entries.gl_control_acct%TYPE;
  v_gl_sub_acct_1  	       giac_acct_entries.gl_sub_acct_1%TYPE;
  v_gl_sub_acct_2  	       giac_acct_entries.gl_sub_acct_2%TYPE;
  v_gl_sub_acct_3  	       giac_acct_entries.gl_sub_acct_3%TYPE;
  v_gl_sub_acct_4  	       giac_acct_entries.gl_sub_acct_4%TYPE;
  v_gl_sub_acct_5  	       giac_acct_entries.gl_sub_acct_5%TYPE;
  v_gl_sub_acct_6  	       giac_acct_entries.gl_sub_acct_6%TYPE;
  v_gl_sub_acct_7  	       giac_acct_entries.gl_sub_acct_7%TYPE;
  v_dr_cr_tag              giac_module_entries.dr_cr_tag%TYPE;
  v_debit_amt   	       giac_acct_entries.debit_amt%TYPE := 0; 
  v_credit_amt  	       giac_acct_entries.credit_amt%TYPE := 0;
  v_acct_entry_id 	       giac_acct_entries.acct_entry_id%TYPE;
  v_gen_type      	       giac_modules.generation_type%TYPE;
  v_gl_acct_id    	       giac_chart_of_accts.gl_acct_id%TYPE;
  v_sl_type_cd    	       giac_module_entries.sl_type_cd%TYPE;
  v_intm_type_level  	   giac_module_entries.intm_type_level%TYPE;
  v_line_dependency_level  giac_module_entries.line_dependency_level%TYPE;  
  
  v_diff_comm			   giac_comm_payts.comm_amt%TYPE; 	-- judyann 06142006; 
  																													-- difference between computed net comm and actual disbursed comm			
  v_assd			 	   giac_prem_deposit.assd_no%type;
  v_assured				   giis_assured.assd_name%TYPE;--giac_prem_deposit.assured_name%type; to prevent ora-06502 issa06.12.2007
  v_line				   giac_prem_deposit.line_cd%type;
  v_subline				   giac_prem_deposit.subline_cd%type;
  v_iss					   giac_prem_deposit.iss_cd%type; 
  v_issue_yy			   giac_prem_deposit.issue_yy%type;  
  v_pol_seq				   giac_prem_deposit.pol_seq_no%type;  
  v_renew_no			   giac_prem_deposit.renew_no%type;     		
  v_item_no				   giac_prem_deposit.item_no%type;    
  o_sl_cd				   giac_acct_entries.sl_cd%type;
  v_parent_intm_no		   giis_intermediary.parent_intm_no%type;
  v_acct_line_cd		   giis_line.acct_line_cd%type;
  v_gen_type2			   giac_modules.generation_type%type;
  v_pd_exist			   varchar2(1);	
  v_comm_diff			   giac_comm_payts.comm_amt%type;
  v_item_diff			   GIAC_MODULE_ENTRIES.item_no%TYPE;

BEGIN
  p_message := 'SUCCESS';
  FOR j IN (SELECT '1' exist
              FROM giac_prem_deposit
             WHERE gacc_tran_id = p_gacc_tran_id
               AND b140_iss_cd = p_iss_cd
               AND b140_prem_seq_no = p_prem_seq_no
               AND intm_no = p_intm_no
               AND comm_rec_no = p_record_no)
  LOOP
    v_pd_exist := j.exist;
  END LOOP;

  IF p_disb_comm IS NOT NULL THEN
     v_diff_comm := NVL(p_drv_comm_amt,0) - p_disb_comm; 
  ELSE
  	 v_diff_comm := 0;
  END IF;   
  -- GET_PREMDEP_ITEM_NO
  BEGIN
    SELECT NVL(MAX(item_no),0) + 1
      INTO v_item_no
      FROM giac_prem_deposit
     WHERE gacc_tran_id = p_gacc_tran_id;
  EXCEPTION
  	WHEN NO_DATA_FOUND THEN
  	  v_item_no := 1;
  END;

  FOR p IN (SELECT a.assd_no, c.assd_name, 
                   a.line_cd, a.subline_cd, a.iss_cd, 
                   a.issue_yy, a.pol_seq_no, a.renew_no, 
                   d.acct_line_cd
              FROM gipi_polbasic a, gipi_invoice b, giis_assured c, giis_line d
             WHERE a.policy_id = b.policy_id
               AND a.assd_no = c.assd_no    
               AND a.line_cd = d.line_cd       
               AND b.iss_cd = p_iss_cd
               AND b.prem_seq_no = p_prem_seq_no)
  LOOP
    v_assd     := p.assd_no;		 		
    v_assured  := p.assd_name;			
    v_line	   := p.line_cd;			
    v_subline  := p.subline_cd;		 
    v_iss      := p.iss_cd;				
    v_issue_yy := p.issue_yy;			
    v_pol_seq  := p.pol_seq_no;		
    v_renew_no := p.renew_no;
    v_acct_line_cd := p.acct_line_cd;
  END LOOP;  

  IF v_diff_comm > 0 THEN
     IF v_pd_exist IS NULL THEN
        INSERT INTO giac_prem_deposit
                    (gacc_tran_id, item_no,	transaction_type,	collection_amt,
 	                   dep_flag, assd_no, assured_name, b140_iss_cd, b140_prem_seq_no, 
 			               line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, 
 			               currency_cd,	convert_rate,	foreign_curr_amt,
			               colln_dt, or_print_tag, or_tag, comm_rec_no, intm_no,
			               remarks, user_id, last_update)        
             VALUES (p_gacc_tran_id, v_item_no, 1, v_diff_comm,
			               3,	v_assd, v_assured, p_iss_cd, p_prem_seq_no,
			               v_line, v_subline, v_iss, v_issue_yy, v_pol_seq, v_renew_no,
			               p_currency_cd, p_convert_rate, v_diff_comm/NVL(p_convert_rate,1),
			               TRUNC(SYSDATE), 'N', 'N', p_record_no, p_intm_no,
			               'For overdraft of commission', NVL(GIIS_USERS_PKG.app_user, USER), SYSDATE);   
     END IF;
  ELSIF v_diff_comm < 0 THEN
     IF v_pd_exist IS NULL THEN
        INSERT INTO giac_prem_deposit
                    (gacc_tran_id, item_no,	transaction_type,	collection_amt,
 			               dep_flag, assd_no, assured_name, b140_iss_cd, b140_prem_seq_no, 
 			               line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no, 
 			               currency_cd,	convert_rate,	foreign_curr_amt, 
			               colln_dt, or_print_tag, or_tag, comm_rec_no, intm_no,
			               remarks, user_id, last_update)             
             VALUES (p_gacc_tran_id, v_item_no, 3, v_diff_comm,
			               3,	v_assd, v_assured, p_iss_cd, p_prem_seq_no,
			               v_line, v_subline, v_iss, v_issue_yy, v_pol_seq, v_renew_no,
			               p_currency_cd, p_convert_rate, v_diff_comm/NVL(p_convert_rate,1),
			               TRUNC(SYSDATE), 'N', 'N', p_record_no, p_intm_no,
			               'For overdraft of commission', NVL(GIIS_USERS_PKG.app_user, USER), SYSDATE);   
     END IF;			                 
  END IF;	 
       
  FOR c IN (SELECT iss_cd, prem_seq_no, intm_no, 
                   NVL(comm_amt,0) comm_amt, NVL(wtax_amt,0) wtax_amt, 
                   NVL(input_vat_amt,0) input_vat_amt, NVL(disb_comm,0) disb_comm
              FROM giac_comm_payts
             WHERE gacc_tran_id = p_gacc_tran_id)
  LOOP 
  	IF c.disb_comm <> 0 THEN                  
       v_comm_diff := c.disb_comm - (c.comm_amt - c.wtax_amt + c.input_vat_amt);
       IF v_comm_diff > 0 THEN
       	  v_item_diff := 3; 
       ELSIF v_comm_diff < 0 THEN
    	    v_item_diff := 4;
    	 END IF;   
       BEGIN	
         SELECT a.gl_acct_category, a.gl_control_acct, 
               	NVL(a.gl_sub_acct_1,0), NVL(a.gl_sub_acct_2,0), NVL(a.gl_sub_acct_3,0), NVL(a.gl_sub_acct_4,0), 
               	NVL(a.gl_sub_acct_5,0), NVL(a.gl_sub_acct_6,0), NVL(a.gl_sub_acct_7,0),a.sl_type_cd,
               	NVL(a.intm_type_level,0), a.dr_cr_tag,
               	b.generation_type, a.gl_acct_category, a.gl_control_acct
      	   INTO v_gl_acct_category, v_gl_control_acct, 
              	v_gl_sub_acct_1, v_gl_sub_acct_2, v_gl_sub_acct_3, v_gl_sub_acct_4, 
               	v_gl_sub_acct_5, v_gl_sub_acct_6, v_gl_sub_acct_7,v_sl_type_cd, 
             	  v_intm_type_level, v_dr_cr_tag,
             	  v_gen_type, v_gl_acct_category, v_gl_control_acct
      	   FROM giac_module_entries a, giac_modules b
      	  WHERE b.module_name = 'GIACS026' 
      		  AND a.item_no     = v_item_diff
      	  	AND b.module_id   = a.module_id; 
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           p_message := 'Overdraft Comm - No data found in GIAC_MODULE_ENTRIES.  GIACS026, Item No. 3 and 4';
		   RETURN;
       END;	

       GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(
	   							v_gl_acct_category, v_gl_control_acct,
                                v_gl_sub_acct_1,    v_gl_sub_acct_2,
                                v_gl_sub_acct_3,    v_gl_sub_acct_4,
                                v_gl_sub_acct_5,    v_gl_sub_acct_6,
                                v_gl_sub_acct_7,    v_gl_acct_id, p_message);   
     
       IF v_comm_diff > 0 THEN   	              
          IF v_dr_cr_tag = 'D' THEN
           	 v_debit_amt  := v_comm_diff;
        	   v_credit_amt := 0;
          ELSE
        	   v_debit_amt  := 0;
        	   v_credit_amt := v_comm_diff;
          END IF;  
       ELSIF v_comm_diff < 0 THEN
          IF v_dr_cr_tag = 'D' THEN
          	 v_debit_amt  := v_comm_diff * -1;
        	   v_credit_amt := 0;
          ELSE
             v_debit_amt  := 0;
        	   v_credit_amt := v_comm_diff * -1;
          END IF;    			
   	   END IF;
       
       FOR g IN (SELECT generation_type
                   FROM giac_modules
                  WHERE module_name = 'GIACS020')  
       LOOP
     	   v_gen_type2 := g.generation_type;
       END LOOP;	                 

       /* get SL for overdraft comm entry */
       IF v_sl_type_cd = giacp.v('LINE_SL_TYPE') THEN    
          o_sl_cd := v_acct_line_cd;     
       ELSIF v_sl_type_cd = giacp.v('ASSD_SL_TYPE') THEN
          o_sl_cd:= v_assd;   
       ELSIF v_sl_type_cd = giacp.v('INTM_SL_TYPE') THEN  
          BEGIN
     	      SELECT a.parent_intm_no
              INTO v_parent_intm_no
         	    FROM giis_intermediary a
             WHERE a.intm_no = c.intm_no;
          EXCEPTION
          	WHEN NO_DATA_FOUND THEN
          	  v_parent_intm_no := NULL;
          END;	   
          IF v_parent_intm_no IS NOT NULL THEN
             o_sl_cd := v_parent_intm_no;
          ELSE
      	     o_sl_cd := c.intm_no;
          END IF;
       ELSE
          o_sl_cd := NULL;   
       END IF;     	

   	   GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
  								 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
								 v_gl_acct_category, v_gl_control_acct,
                                 v_gl_sub_acct_1,    v_gl_sub_acct_2, v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,    v_gl_sub_acct_5, v_gl_sub_acct_6,
                                 v_gl_sub_acct_7,    v_sl_type_cd,    '1', o_sl_cd, 
				    	         v_gen_type2,        v_gl_acct_id,    v_debit_amt, v_credit_amt);
    END IF;
  END LOOP;
END giacs020_overdraft_comm_entry;
/



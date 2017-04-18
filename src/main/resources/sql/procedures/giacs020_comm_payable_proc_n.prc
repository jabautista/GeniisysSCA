CREATE OR REPLACE PROCEDURE CPI.giacs020_comm_payable_proc_n(
	   	  		  			  p_gacc_branch_cd			  IN GIAC_ACCTRANS.gibr_branch_cd%TYPE,
							  p_gacc_fund_cd			  IN GIAC_ACCTRANS.gfun_fund_cd%TYPE,
							  p_gacc_tran_id			  IN GIAC_ACCTRANS.tran_id%TYPE,
	   	  		  			  v_var_sl_cd1	  			  IN GIAC_PARAMETERS.param_name%TYPE,
							  v_var_sl_cd2	  			  IN GIAC_PARAMETERS.param_name%TYPE,
							  v_var_sl_cd3	  			  IN GIAC_PARAMETERS.param_name%TYPE,
	   	  		  			  p_var_comm_take_up		  IN OUT GIAC_PARAMETERS.param_value_n%TYPE,
	   	  		  			  p_var_v_item_num			  IN OUT GIAC_MODULE_ENTRIES.item_no%TYPE,
	   	  		  			  p_var_v_bill_no			  IN OUT GIPI_INVOICE.prem_seq_no%TYPE,
						   	  p_var_v_issue_cd			  IN OUT GIPI_INVOICE.iss_cd%TYPE,
	   	  		  			  v_intm_no    				  IN GIAC_COMM_PAYTS.intm_no%TYPE,
                              v_assd_no       			  IN GIPI_POLBASIC.assd_no%TYPE,
                              v_acct_line_cd  			  IN GIIS_LINE.acct_line_cd%TYPE, 
                              v_comm_amt      			  IN GIAC_COMM_PAYTS.comm_amt%TYPE,
                              v_wtax_amt      			  IN GIAC_COMM_PAYTS.wtax_amt%TYPE,
			                  v_line_cd       			  IN GIIS_LINE.line_cd%TYPE,
                              v_input_vat_amt 			  IN GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                              v_sl_cd1        			  IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                              v_sl_cd2        			  IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                              v_sl_cd3        			  IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
							  p_message					     OUT VARCHAR2) IS

	/*** 10/13/1998 Commissions Payable Procedure  ***
	*12/14/1998 FETCH SL CD codes update***/  
    
    x_intm_no       	     GIIS_INTERMEDIARY.intm_no%TYPE;
    w_sl_cd         	     GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    y_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    z_sl_cd                  GIAC_ACCT_ENTRIES.sl_cd%TYPE;

    V_GL_ACCT_CATEGORY       GIAC_ACCT_ENTRIES.GL_ACCT_CATEGORY%TYPE; 
    V_GL_CONTROL_ACCT        GIAC_ACCT_ENTRIES.GL_CONTROL_ACCT%TYPE;
    v_gl_sub_acct_1  	     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    v_gl_sub_acct_2  	     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    v_gl_sub_acct_3  	     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    v_gl_sub_acct_4  	     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    v_gl_sub_acct_5  	     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    v_gl_sub_acct_6  	     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_sub_acct_7  	     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    v_intm_type_level  	     GIAC_MODULE_ENTRIES.INTM_TYPE_LEVEL%TYPE;
    v_LINE_DEPENDENCY_LEVEL  GIAC_MODULE_ENTRIES.LINE_DEPENDENCY_LEVEL%TYPE;
    v_dr_cr_tag              GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    v_debit_amt   	         GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0;
    v_credit_amt  	         GIAC_ACCT_ENTRIES.credit_amt%TYPE := 0;
    v_acct_entry_id 	     GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    v_gen_type      	     GIAC_MODULES.generation_type%TYPE;
    v_gl_acct_id    	     GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    v_sl_type_cd    	     GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type_cd2    	     GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type_cd3    	     GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    ws_line_cd	    	     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_intm_no             GIAC_COMM_PAYTS.intm_no%TYPE;
    v_gl_assd_no             GIPI_POLBASIC.assd_no%TYPE;
    v_gl_acct_line_cd        GIIS_LINE.acct_line_cd%TYPE; 
    ws_acct_intm_cd          GIIS_INTM_TYPE.acct_intm_cd%TYPE;
/*aa*/

    v_epc_param   giac_parameters.param_value_v%TYPE := giacp.v('ENTER_PREPAID_COMM');     --jason 9/17/2008       
    v_tax_ent_p		giac_parameters.param_value_v%TYPE := giacp.v('TAX_ENTRY_ON_COMM_PAYT');     --jason 8/10/2009    
    v_wtax_item		giac_module_entries.item_no%TYPE;  --jason 08/10/2009: will hold the giac_module_entries item number for wtax entry generation
    v_invat_item	giac_module_entries.item_no%TYPE;  --jason 08/10/2009: will hold the giac_module_entries item number for input vat entry generation
    v_adv_payt		VARCHAR2(1) := 'N';  --jason 08102009: Y - payment is advance
    v_tran_date DATE;      --added by alfie 05192010
    v_booking_date DATE;   --added by alfie 05192010
    v_ok            VARCHAR2(1) := 'N'; -- shan 10.23.2014
    v_net_comm_amt GIAC_COMM_PAYTS.comm_amt%TYPE; --mikel 06.15.2015

BEGIN 
  p_message := 'SUCCESS';
  --alfie 05192010 start: check if commission payment is advance
  SELECT tran_date
    INTO v_tran_date
      FROM giac_acctrans
        WHERE tran_id = p_gacc_tran_id;
    DECLARE
        ORA_1843 EXCEPTION;
        ORA_1858 EXCEPTION;
        PRAGMA EXCEPTION_INIT(ORA_1858, -1858); --not a valid month, cause: multi_booking_mm is null
        PRAGMA EXCEPTION_INIT(ORA_1843, -1843); --a non-numeric character found where a non-numeric is expected
    BEGIN
       SELECT TO_DATE (multi_booking_mm || '-' || multi_booking_yy, 'MM-YYYY')
         INTO v_booking_date
         FROM gipi_invoice
        WHERE prem_seq_no = p_var_v_bill_no AND iss_cd = p_var_v_issue_cd;
    EXCEPTION
       WHEN ORA_1843
       THEN
          p_message := 'Invalid booking month was entered or generated in the bill.';
          RETURN;
       WHEN ORA_1858
       THEN
          p_message := 'Invalid booking year was entered or generated in the bill.';
          RETURN;
    END;
    
  --jason 08102009 start: check if payment is advance
  /*FOR m IN (SELECT 1 exist
                FROM giac_advanced_payt
               WHERE prem_seq_no = p_var_v_bill_no
                 AND iss_cd = p_var_v_issue_cd)  
  LOOP
  	v_adv_payt := 'Y';
  END LOOP;*/ --remove by steven 09.11.2014
  
  IF NVL(v_epc_param,'N') = 'Y' AND (TRUNC(v_tran_date) < v_booking_date) THEN
  	v_adv_payt := 'Y';
  END IF;
  
  --assign values for item no variables for wtax and input vat acct entry generation
  IF NVL(v_tax_ent_p,'A') = 'A' AND v_adv_payt = 'Y' THEN
    BEGIN
        SELECT '1' 
          INTO v_ok
          FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
         WHERE B.module_name = 'GIACS020' 
           AND A.item_no     = 8
           AND B.module_id   = A.module_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in GIAC_MODULE_ENTRIES.');
    END;
    
    BEGIN
        SELECT '1' 
          INTO v_ok
          FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
         WHERE B.module_name = 'GIACS020' 
           AND A.item_no     = 9
           AND B.module_id   = A.module_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in GIAC_MODULE_ENTRIES.');
    END;    
    v_wtax_item	:= 9;
    v_invat_item := 8;
  ELSE 
    v_wtax_item	:= 4;
    v_invat_item := 5;
  END IF;
  --assign values for item no variable for acctg entry generation of commission
  IF NVL(v_epc_param,'N') = 'Y' AND v_adv_payt = 'Y' THEN
  	--jason 08072009: insert record in giac_prepaid_comm table
      FOR j in (SELECT a.gacc_tran_id, b.policy_id, a.tran_type,
      								 a.intm_no, a.iss_cd, a.prem_seq_no, a.comm_amt,
	   									 a.wtax_amt, a.input_vat_amt, c.multi_booking_mm,
	   									 c.multi_booking_yy
  								FROM GIAC_COMM_PAYTS a, GIPI_POLBASIC b, GIPI_INVOICE c
 								 WHERE a.iss_cd = c.iss_cd
   								 AND a.prem_seq_no = c.prem_seq_no
  								 AND b.policy_id = c.policy_id
 									 AND a.iss_cd = p_var_v_issue_cd
  								 AND a.prem_seq_no = p_var_v_bill_no)
      LOOP
      	--jason 08242009: added the update statement to avoid duplicate records since the table has no primary key constraint
      	UPDATE giac_prepaid_comm
      	   SET gacc_tran_id = j.gacc_tran_id,
      	       comm_amt = j.comm_amt,
      	       wtax_amt = j.wtax_amt,
      	       input_vat_amt = j.input_vat_amt,
      	       user_id = NVL(GIIS_USERS_PKG.app_user, USER),
      	       last_update = SYSDATE,
      	       booking_mth = j.multi_booking_mm,
      	       booking_year = j.multi_booking_yy
      	 WHERE policy_id = j.policy_id
      	   AND transaction_type = j.tran_type
      	   AND iss_cd = j.iss_cd
      	   AND prem_seq_no = j.prem_seq_no
      	   AND intm_no = j.intm_no;

        IF SQL%NOTFOUND THEN  --jason 08242009: insert the record if there were no records updated
          INSERT INTO giac_prepaid_comm
                      (gacc_tran_id,			policy_id,			transaction_type,
        	  					 intm_no,						iss_cd,					prem_seq_no,
        		  				 comm_amt,					wtax_amt,				input_vat_amt,
        			  			 user_id,						last_update,		booking_mth,
        				  		 booking_year)
        	  	 VALUES (j.gacc_tran_id, 		j.policy_id,    j.tran_type,
      			   				 j.intm_no,         j.iss_cd,       j.prem_seq_no, 
      				  			 j.comm_amt, 			  j.wtax_amt,     j.input_vat_amt, 
      					  		 NVL(GIIS_USERS_PKG.app_user, USER),	            SYSDATE,        j.multi_booking_mm,
	   							  	 j.multi_booking_yy);
	   	  END IF;
      END LOOP;
    p_var_v_item_num := 7;
  ELSE 
    p_var_v_item_num := p_var_comm_take_up;
  END IF;

  giacs020_get_sl_code_n(v_var_sl_cd1, v_var_sl_cd2, v_var_sl_cd3, v_intm_no,v_assd_no,v_acct_line_cd,
                w_sl_cd,y_sl_cd,z_sl_cd,v_gl_intm_no,v_gl_assd_no, v_gl_acct_line_cd);
  BEGIN
    SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
           NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
           NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0),
		       A.dr_cr_tag,B.generation_type,A.sl_type_cd,A.LINE_DEPENDENCY_LEVEL  
      INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
           V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
           V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7, V_INTM_TYPE_LEVEL,
		       v_dr_cr_tag,v_gen_type, v_sl_type_cd, v_LINE_DEPENDENCY_LEVEL  
      FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
     WHERE B.module_name = 'GIACS020' 
       AND A.item_no     = p_var_v_item_num  --replaced by jason 9/17/2008: to handle prepaid comm --p_var_comm_take_up
       AND B.module_id   = A.module_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_message := 'COMM PAYABLE - No data found in GIAC_MODULE_ENTRIES.  Item No '||TO_CHAR(p_var_comm_take_up)||'.';
	  RETURN;
  END;	--c2
  
  IF v_intm_type_level != 0 THEN
     ws_acct_intm_cd := v_gl_intm_no;

     GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, 	ws_acct_intm_cd,
			                 v_gl_sub_acct_1, 	v_gl_sub_acct_2,
			                 v_gl_sub_acct_3, 	v_gl_sub_acct_4,
			                 v_gl_sub_acct_5, 	v_gl_sub_acct_6,
	                     	 v_gl_sub_acct_7);
  END IF;

  IF v_LINE_DEPENDENCY_LEVEL != 0 THEN  	--2.1  
     BEGIN
       SELECT acct_line_cd
         INTO ws_line_cd
         FROM giis_line
        WHERE line_cd = v_line_cd;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_message := 'No data found in giis_line.';
		 RETURN;      
     END;

    GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_line_dependency_level, ws_line_cd, --v_intm_type_level, 	ws_acct_intm_cd,  replaced by: Nica 09.25.2012 to produce correct accounting entries
			                 v_gl_sub_acct_1, 	v_gl_sub_acct_2,
			                 v_gl_sub_acct_3, 	v_gl_sub_acct_4,
			                 v_gl_sub_acct_5, 	v_gl_sub_acct_6,
	                     	 v_gl_sub_acct_7);
  END IF;

  GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
						                           v_gl_sub_acct_1, v_gl_sub_acct_2,
						                           v_gl_sub_acct_3, v_gl_sub_acct_4,
						                           v_gl_sub_acct_5, v_gl_sub_acct_6,
						                           v_gl_sub_acct_7, v_gl_acct_id, p_message);
                                                   
  --added by mikel 06.15.2015; Wtax enhancements, BIR demo findings.
  v_net_comm_amt := v_comm_amt;
  IF NVL(giacp.v('BATCH_GEN_WTAX'), 'N') = 'Y' THEN
    v_net_comm_amt := v_comm_amt - v_wtax_amt;
  END IF; 
      
  IF v_comm_amt > 0 THEN
     IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := v_net_comm_amt; --v_comm_amt; --mikel 06.15.2015
        v_credit_amt := 0;
     ELSE
        v_debit_amt  := 0;
        v_credit_amt := v_net_comm_amt; --v_comm_amt; --mikel 06.15.2015
     END IF;  
  ELSIF v_comm_amt < 0 THEN
     IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := 0;
        v_credit_amt := v_net_comm_amt * -1; --v_comm_amt * -1; --mikel 06.15.2015
     ELSE
        v_debit_amt  := v_net_comm_amt * -1; --v_comm_amt * -1; --mikel 06.15.2015
        v_credit_amt := 0;
     END IF;    
  END IF;

  GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
  								 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
  								 v_gl_acct_category, v_gl_control_acct,
                                 v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
                                 v_gl_sub_acct_7, v_sl_type_cd,'1',w_sl_cd, v_gen_type, 
                                 v_gl_acct_id, v_debit_amt, v_credit_amt);

  IF NVL(giacp.v('BATCH_GEN_WTAX'), 'N') = 'N' THEN --added by mikel 06.15.2015; Wtax enhancements, BIR demo findings.     	
      -- For Withholding Tax Payable
      BEGIN	--e1
        IF NVL(v_wtax_amt,0) = 0 THEN
           NULL;
        ELSE 
       
       /* Modified by Mikel
        ** 10.05.2012
        ** Accounting entries for WITHHOLDING TAX will be based on Intermediaries Wtax Code in Withholding Tax Maintenance
        */     
        
    --       BEGIN
    --         SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
    --             	  NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
    --             	  NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.INTM_TYPE_LEVEL,0), A.dr_cr_tag,
    --             	  B.generation_type 
    --      	   INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
    --             	  V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
    --             	  V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_INTM_TYPE_LEVEL, v_dr_cr_tag,
    --             	  v_gen_type
    --      	   FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
    --      	  WHERE B.module_name = 'GIACS020' 
    --      	    AND A.item_no     = v_wtax_item
    --      	    AND B.module_id   = A.module_id;
    --       EXCEPTION
    --         WHEN NO_DATA_FOUND THEN
    --           p_message := 'WITHHOLDING TAX - No data found in GIAC_MODULE_ENTRIES. Item No = 4.';
    --		   RETURN;
    --       END;

    --       GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, 	ws_acct_intm_cd,
    --			                 v_gl_sub_acct_1, 	v_gl_sub_acct_2,
    --			                 v_gl_sub_acct_3, 	v_gl_sub_acct_4,
    --			                 v_gl_sub_acct_5, 	v_gl_sub_acct_6,
    --	                     	 v_gl_sub_acct_7);

    --       GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
    --						                           v_gl_sub_acct_1, v_gl_sub_acct_2,
    --						                           v_gl_sub_acct_3, v_gl_sub_acct_4,
    --						                           v_gl_sub_acct_5, v_gl_sub_acct_6,
    --						                           v_gl_sub_acct_7, v_gl_acct_id, p_message); 

    --       IF v_wtax_amt > 0 THEN
    --          IF v_dr_cr_tag = 'D' THEN
    --        	   v_debit_amt  := v_wtax_amt;
    --        	   v_credit_amt := 0;
    --      	  ELSE
    --        	   v_debit_amt  := 0;
    --        	   v_credit_amt := v_wtax_amt;
    --      	  END IF;  
    --       ELSIF v_wtax_amt < 0 THEN
    --          IF v_dr_cr_tag = 'D' THEN
    --        	   v_debit_amt  := 0;
    --        	   v_credit_amt := v_wtax_amt * -1;
    --      	  ELSE
    --        	   v_debit_amt  := v_wtax_amt * -1;
    --        	   v_credit_amt := 0;
    --      	  END IF;
    --       END IF;		

    --       GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
    --  								 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
    --  								 v_gl_acct_category, v_gl_control_acct,
    --                                 v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
    --                                 v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
    --                                 v_gl_sub_acct_7, v_sl_type_cd,'1',w_sl_cd, v_gen_type, 
    --                                 v_gl_acct_id, v_debit_amt, v_credit_amt);

    --comment out by mikel 10.05.2012 and replaced by codes below 
            BEGIN
                BEGIN
                   SELECT DISTINCT a.gl_acct_id
                     INTO v_gl_acct_id
                     FROM giac_wholding_taxes a, giis_intermediary b
                    WHERE 1 = 1 
                      AND a.whtax_id = b.whtax_id 
                      AND b.intm_no = v_intm_no;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    p_message := 'No Withholding Tax Code maintained in intermediary maintenance.';
                    RETURN;
                END;
                 
               SELECT a.gl_acct_category, a.gl_control_acct, NVL (a.gl_sub_acct_1, 0),
                      NVL (a.gl_sub_acct_2, 0), NVL (a.gl_sub_acct_3, 0),
                      NVL (a.gl_sub_acct_4, 0), NVL (a.gl_sub_acct_5, 0),
                      NVL (a.gl_sub_acct_6, 0), NVL (a.gl_sub_acct_7, 0)
                 INTO v_gl_acct_category, v_gl_control_acct, v_gl_sub_acct_1,
                      v_gl_sub_acct_2, v_gl_sub_acct_3,
                      v_gl_sub_acct_4, v_gl_sub_acct_5,
                      v_gl_sub_acct_6, v_gl_sub_acct_7
                 FROM giac_chart_of_accts a
                WHERE a.gl_acct_id = v_gl_acct_id;
    				
               IF v_wtax_amt > 0
               THEN                                                    --positive - credit
                  v_debit_amt := 0;
                  v_credit_amt := v_wtax_amt;
               ELSIF v_wtax_amt < 0
               THEN                                                     --negative - debit
                  v_debit_amt := v_wtax_amt * -1;
                  v_credit_amt := 0;
               END IF;
    				
                GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
                                                      p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
                                                      v_gl_acct_category, v_gl_control_acct,
                                                      v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
                                                      v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
                                                      v_gl_sub_acct_7,v_sl_type_cd,'1', y_sl_cd, 
                                                      v_gen_type, v_gl_acct_id, v_debit_amt,
                                                      v_credit_amt);
            END;
            -- end mikel 10.05.2012 
        END IF;
      END;
  END IF;    

  
  IF NVL(v_input_vat_amt,0) != 0 THEN		--5.1
     BEGIN	--f1
       SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
             	NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
             	NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD,
             	NVL(A.INTM_TYPE_LEVEL,0), A.dr_cr_tag,
             	B.generation_type, A.gl_acct_category, A.gl_control_acct
      	 INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
            	V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
             	V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, 
             	V_INTM_TYPE_LEVEL, v_dr_cr_tag,
             	v_gen_type, v_gl_acct_category, v_gl_control_acct
      	 FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
      	WHERE B.module_name = 'GIACS020'
      	    AND A.item_no     = v_invat_item
      		AND B.module_id   = A.module_id; 
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_message := 'INPUT V.A.T. - No data found in GIAC_MODULE_ENTRIES.  Item No = 5.';
		 RETURN;
     END;

     GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
						                           v_gl_sub_acct_1, v_gl_sub_acct_2,
						                           v_gl_sub_acct_3, v_gl_sub_acct_4,
						                           v_gl_sub_acct_5, v_gl_sub_acct_6,
						                           v_gl_sub_acct_7, v_gl_acct_id, p_message);   

     IF v_input_vat_amt > 0 THEN   	-- 6.1              
        IF v_dr_cr_tag = 'D' THEN
         	 v_debit_amt  := v_input_vat_amt;
        	 v_credit_amt := 0;
        ELSE
        	 v_debit_amt  := 0;
        	 v_credit_amt := v_input_vat_amt;
        END IF;  
     ELSIF v_input_vat_amt < 0 THEN 
        IF v_dr_cr_tag = 'D' THEN
        	 v_debit_amt  := 0;
        	 v_credit_amt := v_input_vat_amt * -1;
        ELSE
           v_debit_amt  := v_input_vat_amt * -1;
        	 v_credit_amt := 0;
        END IF;    			
   	 END IF;
    
   	 GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
  								 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
  								 v_gl_acct_category, v_gl_control_acct,
                                 v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
                                 v_gl_sub_acct_7, v_sl_type_cd,'1',w_sl_cd, v_gen_type, 
                                 v_gl_acct_id, v_debit_amt, v_credit_amt);
  END IF;


END giacs020_comm_payable_proc_n; 
/


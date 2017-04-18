DROP PROCEDURE CPI.GIACS020_COMM_PAYABLE_PROC_Y;

CREATE OR REPLACE PROCEDURE CPI.giacs020_comm_payable_proc_y
	   	  		  			 (p_gacc_branch_cd		GIAC_ACCTRANS.gibr_branch_cd%TYPE,
							  p_gacc_fund_cd			GIAC_ACCTRANS.gfun_fund_cd%TYPE,
							  p_gacc_tran_id			GIAC_ACCTRANS.tran_id%TYPE,
		 					  v_comm_take_up  IN GIAC_PARAMETERS.param_value_n%TYPE,
							  v_var_sl_cd1	  IN GIAC_PARAMETERS.param_name%TYPE,
							  v_var_sl_cd2	  IN GIAC_PARAMETERS.param_name%TYPE,
							  v_var_sl_cd3	  IN GIAC_PARAMETERS.param_name%TYPE,
							  v_intm_no       IN GIAC_COMM_PAYTS.intm_no%TYPE,
                              v_assd_no       IN GIPI_POLBASIC.assd_no%TYPE,
                              v_acct_line_cd  IN GIIS_LINE.acct_line_cd%TYPE, 
                              v_comm_amt      IN GIAC_COMM_PAYTS.comm_amt%TYPE,
                              v_wtax_amt      IN GIAC_COMM_PAYTS.wtax_amt%TYPE,
			                  v_line_cd       IN GIIS_LINE.line_cd%TYPE,
                              v_lsp           VARCHAR2,
                              v_input_vat_amt IN GIAC_COMM_PAYTS.input_vat_amt%TYPE,
                              v_sl_cd1        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                              v_sl_cd2        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                              v_sl_cd3        IN GIAC_ACCT_ENTRIES.sl_cd%TYPE,
							  p_message		 OUT VARCHAR2) IS
	x_intm_no       	      GIIS_INTERMEDIARY.intm_no%TYPE;
    w_sl_cd         	      GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    y_sl_cd                   GIAC_ACCT_ENTRIES.sl_cd%TYPE;
    z_sl_cd                   GIAC_ACCT_ENTRIES.sl_cd%TYPE;

    V_GL_ACCT_CATEGORY        GIAC_ACCT_ENTRIES.GL_ACCT_CATEGORY%TYPE; 
    V_GL_CONTROL_ACCT         GIAC_ACCT_ENTRIES.GL_CONTROL_ACCT%TYPE;
    v_gl_sub_acct_1  	      GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
    v_gl_sub_acct_2  	      GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
    v_gl_sub_acct_3  	      GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
    v_gl_sub_acct_4  	      GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
    v_gl_sub_acct_5  	      GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
    v_gl_sub_acct_6  	      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_sub_acct_7  	      GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;

    v_intm_type_level  	      GIAC_MODULE_ENTRIES.INTM_TYPE_LEVEL%TYPE;
    v_LINE_DEPENDENCY_LEVEL   GIAC_MODULE_ENTRIES.LINE_DEPENDENCY_LEVEL%TYPE;
    v_dr_cr_tag               GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
    v_debit_amt   	          GIAC_ACCT_ENTRIES.debit_amt%TYPE := 0; --set default value to suppress null value in Acctg entries. Pia, 09.09.04
    v_credit_amt  	          GIAC_ACCT_ENTRIES.credit_amt%TYPE := 0; --set default value to suppress null value in Acctg entries. Pia, 09.09.04
    v_acct_entry_id 	      GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
    v_gen_type      	      GIAC_MODULES.generation_type%TYPE;
    v_gl_acct_id    	      GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
    v_sl_type_cd    	      GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;--07/31/99 JEANNETTE
    v_sl_type_cd2    	      GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    v_sl_type_cd3    	      GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;
    ws_line_cd	    	      GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
    v_gl_intm_no              GIAC_COMM_PAYTS.intm_no%TYPE;
    v_gl_assd_no              GIPI_POLBASIC.assd_no%TYPE;
    v_gl_acct_line_cd         GIIS_LINE.acct_line_cd%TYPE; 
    ws_acct_intm_cd           GIIS_INTM_TYPE.acct_intm_cd%TYPE;
    v_gl_lsp                  VARCHAR2(8);
/*aa*/

BEGIN 
  p_message := 'SUCCESS';
  giacs020_get_sl_code_y(v_var_sl_cd1, v_var_sl_cd2, v_var_sl_cd3, v_intm_no,v_lsp,v_assd_no,v_acct_line_cd,
                w_sl_cd,y_sl_cd,z_sl_cd,v_gl_intm_no,v_gl_lsp,v_gl_assd_no, v_gl_acct_line_cd);

  BEGIN 	--c1
    SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
           NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0),
           NVL(A.GL_SUB_ACCT_4,0), NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0),
           NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0), 
           A.dr_cr_tag, B.generation_type, A.sl_type_cd,
           A.LINE_DEPENDENCY_LEVEL  
     INTO  V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT,
           V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3,
           V_GL_SUB_ACCT_4, V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6,
           V_GL_SUB_ACCT_7, V_INTM_TYPE_LEVEL,
           v_dr_cr_tag,v_gen_type, v_sl_type_cd, v_LINE_DEPENDENCY_LEVEL  
      FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
     WHERE B.module_name = 'GIACS020' 
       AND A.item_no     = v_comm_take_up
       AND B.module_id   = A.module_id; 
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_message := 'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES. Item No '||TO_CHAR(v_comm_take_up)||'.';
	  RETURN;
  END;	--c2

  IF v_intm_type_level != 0 THEN
     --msg_alert('v_gl_intm_no' || to_char(v_gl_intm_no), 'i', false);
     ws_acct_intm_cd := v_gl_intm_no;
     GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, 	ws_acct_intm_cd,
			                 v_gl_sub_acct_1, 	v_gl_sub_acct_2,
			                 v_gl_sub_acct_3, 	v_gl_sub_acct_4,
			                 v_gl_sub_acct_5, 	v_gl_sub_acct_6,
	                     	 v_gl_sub_acct_7);
  END IF;

	/*******  Added by : Abu Bakar
	****  Date     : Feb . 10, 1999***/
  IF v_LINE_DEPENDENCY_LEVEL != 0 THEN  	--2.1  
     BEGIN	--d1
       SELECT acct_line_cd
         INTO ws_line_cd
         FROM giis_line
        WHERE line_cd = v_line_cd;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_message := 'No data found in giis_line.';
		 RETURN;      
     END;

     GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_LINE_DEPENDENCY_LEVEL , ws_line_cd,
			    	           v_gl_sub_acct_1, v_gl_sub_acct_2,
			    	           v_gl_sub_acct_3, v_gl_sub_acct_4,
			    	           v_gl_sub_acct_5, v_gl_sub_acct_6,
	                     	   v_gl_sub_acct_7);
  END IF;

  GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(v_gl_acct_category, v_gl_control_acct,
						                           v_gl_sub_acct_1, v_gl_sub_acct_2,
						                           v_gl_sub_acct_3, v_gl_sub_acct_4,
						                           v_gl_sub_acct_5, v_gl_sub_acct_6,
						                           v_gl_sub_acct_7, v_gl_acct_id, p_message);   

  IF v_comm_amt > 0 THEN  		--3.1               
     IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := v_comm_amt;
        v_credit_amt := 0;
     ELSE
        v_debit_amt  := 0;
        v_credit_amt := v_comm_amt;
     END IF;  
  ELSIF v_comm_amt < 0 THEN
     IF v_dr_cr_tag = 'D' THEN
        v_debit_amt  := 0;
        v_credit_amt := v_comm_amt * -1;
     ELSE
        v_debit_amt  := v_comm_amt * -1;
        v_credit_amt := 0;
     END IF;    
  END IF;				--3.2
 
  GIAC_ACCT_ENTRIES_PKG.giacs020_aeg_ins_upd_acct_ents(
  								 p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
  								 v_gl_acct_category, v_gl_control_acct,
                                 v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
                                 v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
                                 v_gl_sub_acct_7, v_sl_type_cd,'1',w_sl_cd, v_gen_type, 
                                 v_gl_acct_id, v_debit_amt, v_credit_amt);

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
--             	  NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0),
--             	  NVL(A.GL_SUB_ACCT_4,0), NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0),
--             	  NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.INTM_TYPE_LEVEL,0),
--             	  A.dr_cr_tag, B.generation_type 
--      	   INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
--             	  V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3,
--             	  V_GL_SUB_ACCT_4, V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6,
--             	  V_GL_SUB_ACCT_7, V_SL_TYPE_CD, V_INTM_TYPE_LEVEL,
--             	  v_dr_cr_tag, v_gen_type
--      	   FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
--      	  WHERE B.module_name = 'GIACS020' 
--      	    AND A.item_no     = 4
--      	    AND B.module_id   = A.module_id; 
--         EXCEPTION
--      	   WHEN NO_DATA_FOUND THEN
--        	   p_message := 'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 4.';
--			   RETURN;
--       END;

--       GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, v_sl_cd2,
--					    		            v_gl_sub_acct_1, v_gl_sub_acct_2,
--					    		            v_gl_sub_acct_3, v_gl_sub_acct_4,
--					    		            v_gl_sub_acct_5, v_gl_sub_acct_6,
--			                    			v_gl_sub_acct_7);

--       GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts (v_gl_acct_category,v_gl_control_acct,
--					                             	   v_gl_sub_acct_1, v_gl_sub_acct_2,
--					                             	   v_gl_sub_acct_3, v_gl_sub_acct_4,
--					                             	   v_gl_sub_acct_5, v_gl_sub_acct_6,
--					                             	   v_gl_sub_acct_7,v_gl_acct_id, p_message);   

--       IF v_wtax_amt > 0 THEN  
--          IF v_dr_cr_tag = 'D' THEN
--        	   v_debit_amt  := v_wtax_amt;
--        	   v_credit_amt := 0;
--          ELSE
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
--  								 	  p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
--	   								  v_gl_acct_category, v_gl_control_acct,
--                                      v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
--                                      v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
--                                      v_gl_sub_acct_7,v_sl_type_cd,'1', y_sl_cd, 
--				                      v_gen_type, v_gl_acct_id, v_debit_amt,
--				                      v_credit_amt);

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


  IF nvl(v_input_vat_amt,0) != 0 THEN		--5.1
     BEGIN	--f1
       SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
              NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0),
              NVL(A.GL_SUB_ACCT_4,0), NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0),
              NVL(A.GL_SUB_ACCT_7,0), A.SL_TYPE_CD, NVL(A.INTM_TYPE_LEVEL,0),
              A.dr_cr_tag, B.generation_type, A.gl_acct_category, A.gl_control_acct
         INTO V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
              V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3,
              V_GL_SUB_ACCT_4, V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6,
              V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_INTM_TYPE_LEVEL,
              v_dr_cr_tag, v_gen_type, v_gl_acct_category, v_gl_control_acct
      	 FROM GIAC_MODULE_ENTRIES A, GIAC_MODULES B
        WHERE B.module_name = 'GIACS020' 
       	  AND A.item_no     = 5
      	  AND B.module_id   = A.module_id; 
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         p_message := 'INPUT V.A.T.C - No data found in GIAC_MODULE_ENTRIES.  Item No = 5.';
		 RETURN;
     END;

     GIAC_ACCT_ENTRIES_PKG.aeg_check_chart_of_accts(v_gl_acct_category,v_gl_control_acct,
                              v_gl_sub_acct_1, v_gl_sub_acct_2,
                              v_gl_sub_acct_3, v_gl_sub_acct_4,
                              v_gl_sub_acct_5, v_gl_sub_acct_6,
                              v_gl_sub_acct_7,v_gl_acct_id, p_message);   
   	
     IF v_input_vat_amt > 0 THEN   	-- 6.1              
        IF v_dr_cr_tag = 'D' THEN
         	 v_debit_amt  := v_input_vat_amt;
         	 v_credit_amt := 0;
        ELSE
           v_debit_amt  := 0;
         	 v_credit_amt := v_input_vat_amt;
        END IF;  
     ELSIF v_wtax_amt < 0 THEN
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
                                 v_gl_sub_acct_7,v_sl_type_cd,'1', z_sl_cd, 
				  	             v_gen_type,v_gl_acct_id, v_debit_amt, v_credit_amt);
  END IF;
END giacs020_comm_payable_proc_y;
/



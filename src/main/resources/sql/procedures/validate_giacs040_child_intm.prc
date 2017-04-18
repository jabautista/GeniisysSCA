DROP PROCEDURE CPI.VALIDATE_GIACS040_CHILD_INTM;

CREATE OR REPLACE PROCEDURE CPI.validate_giacs040_child_intm(p_transaction_type				IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
	   	  		  										 p_iss_cd						IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
														 p_prem_seq_no					IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
														 p_intm_no						IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
														 p_chld_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
														 p_intermediary_name 			IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
													     p_child_intm_name   			IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
														 p_policy_no  		   			IN OUT VARCHAR2,
														 p_assd_name     	   			IN OUT GIIS_ASSURED.assd_name%TYPE,
														 p_comm_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
														 p_input_vat					IN OUT GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
														 p_wtax_amt		   				IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
														 p_foreign_curr_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
														 p_prev_comm_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
														 p_prev_for_curr_amt			IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
														 p_convert_rt			  		IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
													     p_currency_cd		  			IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
													     p_currency_desc		  		IN OUT GIIS_CURRENCY.currency_desc%TYPE,
														 p_var_with_prem				IN OUT NUMBER,
														 p_var_comm_amt				 	IN OUT NUMBER,
														 p_var_comm_amt_def			 	IN OUT NUMBER,
														 p_var_for_cur_amt_def			IN OUT NUMBER,
														 p_var_prem_amt				    IN OUT NUMBER,
								  						 p_var_percentage	 	 	 	IN OUT NUMBER,
														 p_var_premium_payts			IN OUT NUMBER,
														 p_var_wtax_amt	   				IN	   GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE,
														 p_var_foreign_curr_amt	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
														 p_var_switch					IN OUT NUMBER,
														 p_var_currency_rt	  			IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
													   	 p_var_currency_cd	  	 		IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
													     p_var_currency_desc	  		IN OUT GIIS_CURRENCY.currency_desc%TYPE,
														 p_message						   OUT VARCHAR2
	   	  		  										)
IS
BEGIN
	p_message := 'SUCCESS';
	DECLARE
	V_EXIST              NUMBER(1);
	BEGIN
		IF P_TRANSACTION_TYPE=1 THEN
		    /*  This is to check whether a bill_no of the same intm_no,iss_cd,chld_intm_no already exist,
		    **  provided that transaction_type is in (1,2).
		    */
		    V_EXIST :=0;
		    FOR CL IN(SELECT A.TRANSACTION_TYPE
		                FROM GIAC_OVRIDE_COMM_PAYTS A,
		                     GIAC_ACCTRANS B
		               WHERE A.TRANSACTION_TYPE IN(1,2)
		                 AND A.INTM_NO=P_INTM_NO
		                 AND A.ISS_CD=P_ISS_CD
		                 AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
		                 AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
		                 AND A.GACC_TRAN_ID=B.TRAN_ID
		                 AND B.TRAN_FLAG!='D'
		                 AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
		                                        FROM GIAC_REVERSALS X,
		                                             GIAC_ACCTRANS Y
		                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
		                                         AND Y.TRAN_FLAG !='D'))LOOP
		
		
			IF CL.TRANSACTION_TYPE IN(1,2) THEN
		             IF P_VAR_WITH_PREM = 0 THEN             	
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT1_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no,
											   p_comm_amt, p_foreign_curr_amt, p_prev_comm_amt,
											   p_prev_for_curr_amt, p_var_comm_amt, p_var_comm_amt_def,
											   p_var_for_cur_amt_def, p_var_prem_amt, p_var_percentage,
											   p_var_premium_payts);
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		             END IF;     
		          IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
		             IF P_COMM_AMT = 0 THEN
		                 p_message := 'Commission is Fully Paid.';
		                 P_VAR_SWITCH := 1;
		             end if;
		          ELSE 
		             IF P_COMM_AMT = 0 THEN
		                p_message := 'Cannot Release Commission. Make additional Premium Payments.';
		                P_VAR_switch := 1;       
		             end if;
		          end if;
		        END IF;
		      V_EXIST:=1;
		    END LOOP;
		        IF V_EXIST = 0 THEN
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_DEFAULT_VAL_PROCEDURE(p_transaction_type, p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_prev_comm_amt, p_var_percentage, p_var_prem_amt, p_var_premium_payts, p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def);           
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        END IF;
		
		ELSIF P_TRANSACTION_TYPE=2 THEN
		       /*   This is to check whether there is an account to refund from.*/ 
		      FOR TU IN(SELECT A.TRANSACTION_TYPE
		                FROM GIAC_OVRIDE_COMM_PAYTS A,
		                     GIAC_ACCTRANS B
		               WHERE A.TRANSACTION_TYPE =1
		                 AND A.INTM_NO=P_INTM_NO
		                 AND A.ISS_CD=P_ISS_CD
		                 AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
		                 AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
		                 AND A.GACC_TRAN_ID=B.TRAN_ID
		                 AND B.TRAN_FLAG!='D'
		                 AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
		                                        FROM GIAC_REVERSALS X,
		                                             GIAC_ACCTRANS Y
		                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
		                                         AND Y.TRAN_FLAG !='D'))LOOP
		        IF TU.TRANSACTION_TYPE IS NOT NULL THEN
		
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT3_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt,
										     p_foreign_curr_amt, p_prev_comm_amt, p_prev_for_curr_amt, p_var_comm_amt,
										   	 p_var_comm_amt_def, p_var_for_cur_amt_def, p_message);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        ELSE
		            p_message := 'No transaction type 1 for this bill and intermediary.';
		        END IF;
		       
		    END LOOP;
		
		ELSIF P_TRANSACTION_TYPE=3 THEN
		      /*  This is to check whether a bill_no of the same intm_no,iss_cd,chld_intm_no already exist,
		      **  provided that transaction_type is in (3,4).
		      */
		      v_exist:=0;
		    FOR TR IN(SELECT A.TRANSACTION_TYPE
		                FROM GIAC_OVRIDE_COMM_PAYTS A,
		                     GIAC_ACCTRANS B
		               WHERE A.TRANSACTION_TYPE IN(3,4)
		                 AND A.INTM_NO=P_INTM_NO
		                 AND A.ISS_CD=P_ISS_CD
		                 AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
		                 AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
		                 AND A.GACC_TRAN_ID=B.TRAN_ID
		                 AND B.TRAN_FLAG!='D'
		                 AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
		                                        FROM GIAC_REVERSALS X,
		                                             GIAC_ACCTRANS Y
		                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
		                                         AND Y.TRAN_FLAG !='D'))LOOP
		
			IF TR.TRANSACTION_TYPE IN(3,4) THEN
		             IF P_VAR_WITH_PREM = 0 THEN
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT4_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no,
											   p_comm_amt, p_foreign_curr_amt, p_prev_comm_amt,
											   p_prev_for_curr_amt, p_var_comm_amt, p_var_comm_amt_def,
											   p_var_for_cur_amt_def, p_var_prem_amt, p_var_percentage,
											   p_var_premium_payts);
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		             END IF;
		          IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
		             IF P_COMM_AMT = 0 THEN
		                 p_message := 'Commission is Fully Paid.';
		                 P_VAR_SWITCH := 1;
		             end if;
		          ELSE 
		             IF P_COMM_AMT = 0 THEN
		                p_message := 'Cannot Release Commission. Make additional Premium Payments.';
		                P_VAR_switch := 1;       
		             end if;
		          END IF;
		        END IF;
		       v_exist:=1;
		    END LOOP;
		        IF v_exist = 0 THEN
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_DEFAULT_VAL_PROCEDURE(p_transaction_type, p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_prev_comm_amt, p_var_percentage, p_var_prem_amt, p_var_premium_payts, p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		           GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        END IF;
		                   
		ELSIF P_TRANSACTION_TYPE=4 THEN
		      FOR FO IN(SELECT A.TRANSACTION_TYPE
		                FROM GIAC_OVRIDE_COMM_PAYTS A,
		                     GIAC_ACCTRANS B
		               WHERE A.TRANSACTION_TYPE =3
		                 AND A.INTM_NO=P_INTM_NO
		                 AND A.ISS_CD=P_ISS_CD
		                 AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
		                 AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
		                 AND A.GACC_TRAN_ID=B.TRAN_ID
		                 AND B.TRAN_FLAG!='D'
		                 AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
		                                        FROM GIAC_REVERSALS X,
		                                             GIAC_ACCTRANS Y
		                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
		                                         AND Y.TRAN_FLAG !='D'))LOOP
		        IF FO.TRANSACTION_TYPE IS NOT NULL THEN
		
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT6_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt,
										     p_foreign_curr_amt, p_prev_comm_amt, p_prev_for_curr_amt, p_var_comm_amt,
										   	 p_var_comm_amt_def, p_var_for_cur_amt_def);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        ELSE
		            p_message := 'No transaction type 3 for this bill and intermediary.';
		        END IF;
		  END LOOP;
		END IF;
	END;
	
	BEGIN
	   GIAC_OVRIDE_COMM_PAYTS_PKG.GET_VAL_CURRENCY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no,
															  p_convert_rt, p_currency_cd, p_currency_desc, p_var_currency_rt,
															  p_var_currency_cd, p_var_currency_desc);
	   
	-- sa labas
	/*if P_comm_amt is null then
	   GET_TOTALS;
	else
	   GET_RUNNING_TOTAL;
	END IF; */
	END;
END validate_giacs040_child_intm;
/



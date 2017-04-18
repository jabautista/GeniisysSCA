CREATE OR REPLACE PACKAGE BODY CPI.Wf IS
FUNCTION get_workflow_disp_column(p_disp_column IN VARCHAR2,
                                  p_table IN VARCHAR2) RETURN VARCHAR2 IS
  v_disp  VARCHAR2(32000);
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 11/08/2004
--  Remarks   : This function was created to handle the display columns for the Create_Group_From_Query
--              of 'WORKFLOW' record group in the forms 'WOFLO001' and 'WOFLO002'.
*/
  IF p_disp_column = 'POLICY_NO' THEN
  	 v_disp := 'LINE_CD||''-''|| SUBLINE_CD|| ''-''|| ISS_CD|| ''-''|| LTRIM (TO_CHAR (ISSUE_YY, ''09''))|| ''-''|| LTRIM (TO_CHAR (POL_SEQ_NO, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (RENEW_NO, ''09''))';
  ELSIF p_disp_column = 'PAR_NO' THEN
  	 v_disp := 'LINE_CD||''-''|| ISS_CD|| ''-''|| LTRIM (TO_CHAR (PAR_YY, ''09''))|| ''-''|| LTRIM (TO_CHAR (PAR_SEQ_NO, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (QUOTE_SEQ_NO, ''09''))';
  ELSIF p_disp_column = 'CLAIM_NO' THEN
     IF p_table IN ('GIAC_ACCTRANS') THEN
  	    v_disp := '(SELECT GET_CLM_NO(Z.CLAIM_ID) FROM GIAC_DIRECT_CLAIM_PAYTS Z WHERE Z.GACC_TRAN_ID = A.TRAN_ID)';
	 ELSE	  
    	v_disp := 'LINE_CD||''-''|| SUBLINE_CD|| ''-''|| ISS_CD|| ''-''|| LTRIM (TO_CHAR (CLM_YY, ''09''))|| ''-''|| LTRIM (TO_CHAR (CLM_SEQ_NO, ''0999999''))';
	 END IF;
  ELSIF p_disp_column = 'QUOTE_NO' THEN
  	 v_disp := 'LINE_CD||''-''|| SUBLINE_CD|| ''-''|| ISS_CD|| ''-''|| QUOTATION_YY|| ''-''|| LTRIM (TO_CHAR (QUOTATION_NO, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (PROPOSAL_NO, ''099''))';
  ELSIF p_disp_column = 'INVOICE_NO' THEN
  	 v_disp := 'ISS_CD|| ''-''|| LTRIM (TO_CHAR (PREM_SEQ_NO, ''099999999999''))';
  ELSIF p_disp_column = 'ASSURED_NAME' THEN
     IF p_table IN ('GIPI_PARLIST','GIPI_POLBASIC','GIEX_EXPIRY') THEN
  	    v_disp := '(SELECT Z.ASSD_NAME FROM GIIS_ASSURED Z WHERE Z.ASSD_NO = A.ASSD_NO)';
     ELSIF p_table = 'GIRI_DISTFRPS' THEN
  	    v_disp := '( SELECT X.ASSD_NAME FROM GIIS_ASSURED X, GIPI_POLBASIC Y, GIUW_POL_DIST Z WHERE X.ASSD_NO = Y.ASSD_NO AND Y.POLICY_ID = Z.POLICY_ID AND Z.DIST_NO = A.DIST_NO)';
     ELSE
  	    v_disp := 'ASSD_NAME';
     END IF;
  ELSIF p_disp_column = 'FRPS_NO' THEN
  	 v_disp := 'LINE_CD||''-''|| LTRIM (TO_CHAR (FRPS_YY, ''09''))|| ''-''|| LTRIM (TO_CHAR (FRPS_SEQ_NO, ''09999999''))';
  ELSIF p_disp_column = 'OR_NO' THEN  	 
  
     IF p_table IN ('GIAC_ORDER_OF_PAYTS') THEN
  	    v_disp := 'A.GIBR_BRANCH_CD||'' ''||A.OR_DATE||'' ''||DECODE(A.OR_NO,NULL,NULL,A.OR_PREF_SUF||''-''||A.OR_NO)||'' ''||A.PAYOR';
     ELSIF p_table IN ('GIAC_SPOILED_OR') THEN
  	    v_disp := 'A.FUND_CD||'' ''||A.BRANCH_CD||'' ''||DECODE(A.OR_NO,NULL,NULL,A.OR_PREF||''-''||A.OR_NO)||'' ''||A.SPOIL_DATE';
     ELSE
  	    v_disp := '(SELECT Z.GIBR_BRANCH_CD||'' ''||Z.OR_DATE||'' ''||DECODE(Z.OR_NO,NULL,NULL,Z.OR_PREF_SUF||''-''||Z.OR_NO)||'' ''||Z.PAYOR FROM GIAC_ORDER_OF_PAYTS Z WHERE Z.GACC_TRAN_ID = A.TRAN_ID)';
     END IF;	 
  ELSIF p_disp_column = 'JV_NO' THEN
  	 v_disp := 'DECODE(JV_NO,NULL,NULL,JV_PREF_SUFF||''-''||LTRIM(TO_CHAR(JV_NO, ''099999'')) )';
  ELSIF p_disp_column = 'MEMO_NO' THEN
  	 v_disp := '(SELECT Z.BRANCH_CD||'' ''||Z.MEMO_DATE||'' ''||DECODE(Z.MEMO_SEQ_NO,NULL,NULL,Z.MEMO_TYPE||''-''||Z.MEMO_YEAR||''-''||LTRIM(TO_CHAR(Z.MEMO_SEQ_NO, ''099999'')) ) FROM GIAC_CM_DM Z WHERE Z.GACC_TRAN_ID = A.TRAN_ID)';
  ELSIF p_disp_column = 'TRAN_NO' THEN
  	 v_disp := 'A.GIBR_BRANCH_CD||'' ''||A.TRAN_DATE||'' ''||DECODE(A.TRAN_SEQ_NO,NULL,NULL,A.TRAN_YEAR||''-''||A.TRAN_MONTH||''-''||LTRIM(TO_CHAR(A.TRAN_SEQ_NO, ''09999'')))';
  ELSIF p_disp_column = 'REQUEST_NO' THEN
     IF p_table IN ('GIAC_DISB_VOUCHERS') THEN
  	    v_disp := '(SELECT Z.DOCUMENT_CD||''-''||Z.BRANCH_CD||''-''||Z.LINE_CD||''-''||Z.DOC_YEAR||''-''||Z.DOC_MM||''-''||LTRIM(TO_CHAR(Z.DOC_SEQ_NO, ''099999'')) FROM GIAC_PAYT_REQUESTS Z, GIAC_PAYT_REQUESTS_DTL Y WHERE Z.REF_ID = A.GPRQ_REF_ID AND Z.FUND_CD = A.GIBR_GFUN_FUND_CD AND Z.BRANCH_CD = A.GIBR_BRANCH_CD AND Y.REQ_DTL_NO = A.REQ_DTL_NO AND Z.REF_ID = Y.GPRQ_REF_ID AND Y.TRAN_ID = A.GACC_TRAN_ID)';
     ELSE
  	    v_disp := 'A.DOCUMENT_CD||''-''||A.BRANCH_CD||''-''||A.LINE_CD||''-''||A.DOC_YEAR||''-''||A.DOC_MM||''-''||LTRIM(TO_CHAR(A.DOC_SEQ_NO, ''099999''))';
     END IF;  

  ELSIF p_disp_column = 'DV_NO' THEN
  	 v_disp := 'DECODE(DV_NO,NULL,NULL,DV_PREF||''-''||LTRIM(TO_CHAR(DV_NO, ''0999999999'')) )';
  ELSIF p_disp_column = 'DCB_NO' THEN
  	 v_disp := 'TRAN_DATE||'' ''||TRAN_YEAR||''-''||LTRIM(TO_CHAR(TRAN_CLASS_NO, ''099999''))';
  ELSIF p_disp_column = 'ADVICE_NO' THEN
  	 v_disp := 'LINE_CD||''-''|| ISS_CD|| ''-''|| ADVICE_YEAR|| ''-''||ADVICE_SEQ_NO';	 
  ELSE
  	 v_disp := p_disp_column;
  END IF;
  RETURN(v_disp);
END;
/*******************/
FUNCTION get_workflow_tran_list(p_event_cd IN NUMBER) RETURN VARCHAR2 IS
  v_query  VARCHAR2(32000):=NULL;
  v_event_desc  GIIS_EVENTS.event_desc%TYPE;
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 11/08/2004
--  Remarks   : This function was created to handle the query used for the Create_Group_From_Query
--              of 'TRAN_LIST' record group in the form 'WOFLO001'.
*/
  FOR c1 IN (SELECT UPPER(event_desc) event_desc
               FROM GIIS_EVENTS
			  WHERE event_cd = p_event_cd)
  LOOP
    v_event_desc := c1.event_desc;
  END LOOP;
--  IF p_event_cd = 200 THEN
  IF v_event_desc = 'QUOTATION TO PAR' THEN
  	 v_query := ' SELECT TO_CHAR(quote_id) col_value, '||
	                   ' line_cd||''-''||subline_cd||''-''||iss_cd||''-''||quotation_yy||''-''||LTRIM(TO_CHAR(quotation_no,''0999999''))||''-''||LTRIM(TO_CHAR (proposal_no,''099''))||'' ''||assd_name Tran_Dtl '|| 
	              ' FROM gipi_quote '||
				 ' WHERE Status = ''N'' '||
				   ' AND user_id = USER';
--  ELSIF p_event_cd = 201 THEN
  ELSIF v_event_desc = 'PAR-POLICY (READY FOR POSTING)' THEN
  	 v_query := ' SELECT TO_CHAR(par_id) col_value, '|| 
	                   ' line_cd||''-''|| iss_cd|| ''-''|| LTRIM (TO_CHAR (par_yy, ''09''))|| ''-''|| LTRIM (TO_CHAR (par_seq_no, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (quote_seq_no, ''09'')) Tran_Dtl '||
	              ' FROM gipi_parlist '|| 
				 ' WHERE underwriter = USER '||
				   ' AND par_status < 10 '|| 
				   ' AND par_type = ''P'' '||
				   ' AND assign_sw = ''Y'' ';
--  ELSIF p_event_cd = 232 THEN
  ELSIF v_event_desc = 'PAR-ENDORSEMENT (READY FOR POSTING)' THEN
  	 v_query := ' SELECT TO_CHAR(par_id) col_value, '|| 
	                   ' line_cd||''-''|| iss_cd|| ''-''|| LTRIM (TO_CHAR (par_yy, ''09''))|| ''-''|| LTRIM (TO_CHAR (par_seq_no, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (quote_seq_no, ''09'')) Tran_Dtl '|| 
				  ' FROM gipi_parlist '||
				 ' WHERE underwriter = USER '|| 
				   ' AND par_status < 10 '||
				   ' AND par_type = ''E'' '||
				   ' AND assign_sw = ''Y'' ';
--  ELSIF p_event_cd = 212 THEN
  ELSIF v_event_desc = 'ADVICE APPROVAL - OVERRIDE' THEN
  	 v_query := ' SELECT TO_CHAR(claim_id) col_value, '||
	                   ' line_cd||''-''||subline_cd||''-''||iss_cd||''-''||LTRIM(TO_CHAR(clm_yy, ''09''))||''-''||LTRIM(TO_CHAR(clm_seq_no, ''0000009'')) Tran_Dtl '|| 
				  ' FROM gicl_claims '||
				 ' WHERE claim_id IN (SELECT A.claim_id '||
				                      ' FROM gicl_claims A, giis_clm_stat b, gicl_clm_loss_exp c '|| 
									 ' WHERE A.clm_stat_cd = b.clm_stat_cd '|| 
									   ' AND A.claim_id = c.claim_id '|| 
									   ' AND c.dist_sw = ''Y'' '||
									   ' AND NVL(c.cancel_sw, ''N'') = ''N'' '|| 
									   ' AND b.clm_stat_type = ''N'') '|| 
				   ' AND Check_User_Per_Line(line_cd,iss_cd,''GICLS032'')=1 ';
--  ELSIF p_event_cd = 243 THEN
  ELSIF v_event_desc = 'CLAIMS WITH UNPAID PREMIUM PROCESSING' THEN
  	 v_query := ' SELECT TO_CHAR(c.claim_id) col_value, '|| 
	                   ' c.line_cd||''-''||c.subline_cd||''-''||c.iss_cd||''-''||LTRIM(TO_CHAR(c.clm_yy, ''09''))||''-''||LTRIM(TO_CHAR(c.clm_seq_no, ''0000009'')) Tran_Dtl '|| 
				  ' FROM gicl_claims c ';
--  ELSIF p_event_cd = 244 THEN
  ELSIF v_event_desc = 'GENERATE SCSR' THEN
  	 v_query := ' SELECT TO_CHAR(A.claim_id) col_value, '||
	                   ' c.line_cd||''-''||c.subline_cd||''-''||c.iss_cd||''-''||LTRIM(TO_CHAR(c.clm_yy, ''09''))||''-''||LTRIM(TO_CHAR(c.clm_seq_no, ''0000009'')) Tran_Dtl '|| 
				  ' FROM gicl_claims c, gicl_advice A, gicl_clm_loss_exp b '|| 
				 ' WHERE c.claim_id = A.claim_id '||
				   ' AND A.advice_flag =''Y'' '||
				   ' AND A.claim_id = b.claim_id '||
				   ' AND A.advice_id = b.advice_id '||
				   ' AND A.batch_csr_id IS NULL '||
				   ' AND (A.apprvd_tag = ''N'' OR A.apprvd_tag IS NULL)';
--  ELSIF p_event_cd = 213 THEN
  ELSIF v_event_desc = 'RECEIPTS - CLOSE ACCOUNTING ENTRIES' THEN
  	 v_query := ' SELECT TO_CHAR(z.gacc_tran_id) col_value, '||
	            ' z.gibr_branch_cd||'' ''||z.or_date||'' ''||DECODE(z.or_no,NULL,NULL,z.or_pref_suf||''-''||z.or_no)||'' ''||z.payor Tran_Dtl'|| 
                  ' FROM giac_order_of_payts z'|| 
                 ' WHERE EXISTS (SELECT 1'||
                                 ' FROM giac_acctrans A'||
                				' WHERE A.tran_id = z.gacc_tran_id'|| 
                                  ' AND A.tran_flag = ''O'')';
  ELSIF v_event_desc = 'JV - CLOSE ACCOUNTING ENTRIES' THEN
  	 v_query := ' SELECT TO_CHAR(A.tran_id) col_value, '|| 				  
                       ' A.gibr_branch_cd||'' ''||A.tran_date||'' ''||DECODE(A.tran_seq_no,NULL,NULL,A.tran_year||''-''||A.tran_month||''-''||LTRIM(TO_CHAR(A.tran_seq_no, ''09999'')))||'' ''|| '||
                       ' DECODE(jv_no,NULL,NULL,jv_pref_suff||''-''||LTRIM(TO_CHAR(jv_no, ''099999'')) ) Tran_Dtl '||
                  ' FROM giac_acctrans A '||				  			  
                 ' WHERE tran_class = ''JV'' '||
                   ' AND A.tran_flag = ''O'' ';
  ELSIF v_event_desc = 'CM/DM - CLOSE ACCOUNTING ENTRIES' THEN
  	 v_query := ' SELECT TO_CHAR(z.gacc_tran_id) col_value, '||
                       ' z.branch_cd||'' ''||z.memo_date||'' ''||DECODE(z.memo_seq_no,NULL,NULL,z.memo_type||''-''||z.memo_year||''-''||LTRIM(TO_CHAR(z.memo_seq_no, ''099999'')) ) Tran_Dtl '||
                  ' FROM giac_cm_dm z '||
                 ' WHERE EXISTS (SELECT 1 '||
                                 ' FROM giac_acctrans '||
                				' WHERE tran_flag = ''O'' )';
  ELSIF v_event_desc = 'CANCEL OR' THEN
  	 v_query := ' SELECT TO_CHAR(z.gacc_tran_id) col_value, z.gibr_branch_cd||'' ''||z.or_date||'' ''||DECODE(z.or_no,NULL,NULL,z.or_pref_suf||''-''||z.or_no)||'' ''||z.payor Tran_Dtl'|| 
                  ' FROM giac_order_of_payts z'|| 
                 ' WHERE z.or_flag <> ''C'' ';								
  ELSIF v_event_desc = 'SPOIL OR' THEN
  	 v_query := ' SELECT TO_CHAR(z.gacc_tran_id) col_value, z.gibr_branch_cd||'' ''||z.or_date||'' ''||DECODE(z.or_no,NULL,NULL,z.or_pref_suf||''-''||z.or_no)||'' ''||z.payor Tran_Dtl '|| 
                  ' FROM giac_order_of_payts z '|| 
                 ' WHERE z.or_flag = ''P'' ';
  ELSIF v_event_desc = 'REINSTATE OR' THEN
  	 v_query := ' SELECT TO_CHAR(z.gacc_tran_id) col_value, z.gibr_branch_cd||'' ''||z.or_date||'' ''||DECODE(z.or_no,NULL,NULL,z.or_pref_suf||''-''||z.or_no)||'' ''||z.payor Tran_Dtl '|| 
                  ' FROM giac_order_of_payts z '|| 
                 ' WHERE EXISTS (SELECT 1 '||
				                 ' FROM giac_spoiled_or A '||
                                ' WHERE A.tran_id = z.gacc_tran_id) ';
  ELSIF v_event_desc = 'CANCEL REQUEST' THEN
  	 v_query := ' SELECT TO_CHAR(ref_id) col_value, '||
                       ' A.document_cd||''-''||A.branch_cd||''-''||A.line_cd||''-''||A.doc_year||''-''||A.doc_mm||''-''||LTRIM(TO_CHAR(A.doc_seq_no, ''099999'')) Tran_Dtl '||
                  ' FROM giac_payt_requests A ';								
  ELSIF v_event_desc = 'CANCEL DV' THEN
  	 v_query := ' SELECT TO_CHAR(gacc_tran_id) col_value, '|| 
                       ' DECODE(dv_no,NULL,NULL,dv_pref||''-''||LTRIM(TO_CHAR(dv_no, ''0999999999'')) )||'' ''|| '|| 
                       ' (SELECT z.document_cd||''-''||z.branch_cd||''-''||z.line_cd||''-''||z.doc_year||''-''||z.doc_mm||''-''||LTRIM(TO_CHAR(z.doc_seq_no, ''099999'')) '|| 
                	      ' FROM giac_payt_requests z, giac_payt_requests_dtl y '||
                		 ' WHERE z.ref_id = A.gprq_ref_id '||
                		   ' AND z.fund_cd = A.gibr_gfun_fund_cd '|| 
                		   ' AND z.branch_cd = A.gibr_branch_cd '||
                		   ' AND y.req_dtl_no = A.req_dtl_no '||
                		   ' AND z.ref_id = y.gprq_ref_id '||
                		   ' AND y.tran_id = A.gacc_tran_id) Tran_Dtl '|| 
                ' FROM giac_disb_vouchers A ';								
  ELSIF v_event_desc = 'CANCEL JV' THEN
  	 v_query := ' SELECT TO_CHAR(A.tran_id) col_value, '|| 				  
                       ' A.gibr_branch_cd||'' ''||A.tran_date||'' ''||DECODE(A.tran_seq_no,NULL,NULL,A.tran_year||''-''||A.tran_month||''-''||LTRIM(TO_CHAR(A.tran_seq_no, ''09999'')))||'' ''|| '||
                       ' DECODE(jv_no,NULL,NULL,jv_pref_suff||''-''||LTRIM(TO_CHAR(jv_no, ''099999'')) ) Tran_Dtl '||
                  ' FROM giac_acctrans A '||				  			  
                 ' WHERE tran_class = ''JV'' '||
                   ' AND A.tran_flag <> ''D'' ';
  ELSIF v_event_desc = 'CHANGE PAYMENT MODE' THEN
  	 v_query := ' SELECT TO_CHAR(iss_cd||''-''||prem_seq_no) col_value, '|| 
                       ' iss_cd|| ''-''|| LTRIM (TO_CHAR (prem_seq_no, ''099999999999'')) Tran_Dtl '|| 
                  ' FROM gipi_invoice '|| 
                 ' WHERE policy_id NOT IN (SELECT policy_id FROM giri_inpolbas) '||
                   ' AND iss_cd = DECODE(Check_User_Per_Iss_Cd_Acctg(NULL,iss_cd,''GIACS211''),1,iss_cd,NULL) ';
  ELSIF v_event_desc = 'COMMISSION VOUCHER - OVERRIDE' 
     OR v_event_desc = 'MODIFY COMMISSION' THEN
  	 v_query := ' SELECT TO_CHAR(iss_cd||''-''||prem_seq_no) col_value, '|| 
                       ' iss_cd|| ''-''|| LTRIM (TO_CHAR (prem_seq_no, ''099999999999'')) Tran_Dtl '|| 
                  ' FROM gipi_comm_invoice ';
  ELSIF v_event_desc = 'RECOVERY PAYMENTS' THEN
  	 v_query := ' SELECT TO_CHAR(gacc_tran_id) col_value, '|| 
                       ' (SELECT z.gibr_branch_cd||'' ''||z.tran_date||'' ''||DECODE(z.tran_seq_no,NULL,NULL,z.tran_year||''-''||z.tran_month||''-''||LTRIM(TO_CHAR(z.tran_seq_no, ''09999''))) '|| 
                          ' FROM giac_acctrans z '|| 
                         ' WHERE z.tran_id = a.gacc_tran_id) Tran_Dtl '|| 
                  ' FROM giac_loss_recoveries a';
--  ELSIF p_event_cd = 231 THEN
  ELSIF v_event_desc = 'POST' THEN
  	 v_query := ' SELECT TO_CHAR(par_id) col_value, '|| 
	                   ' line_cd||''-''|| iss_cd|| ''-''|| LTRIM (TO_CHAR (par_yy, ''09''))|| ''-''|| LTRIM (TO_CHAR (par_seq_no, ''0999999''))|| ''-''|| LTRIM (TO_CHAR (quote_seq_no, ''09'')) Tran_Dtl '|| 
				  ' FROM gipi_parlist '||
				 ' WHERE underwriter = USER '|| 
				   ' AND par_status < 10 '||
				   ' AND assign_sw = ''Y'' ';				  
  END IF;


  RETURN(v_query);
END;
/*******************/
FUNCTION workflow_update_user(p_event_cd IN NUMBER,
                              p_user IN VARCHAR2,
			      p_col_value IN VARCHAR2) RETURN VARCHAR2 IS
  v_query  VARCHAR2(32000):=NULL;
  v_event_desc  GIIS_EVENTS.event_desc%TYPE;
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 11/08/2004
--  Remarks   : This function was created to handle the transfer of  a transaction from
--              one user to another user.
*/
  FOR c1 IN (SELECT UPPER(event_desc) event_desc
               FROM GIIS_EVENTS
			  WHERE event_cd = p_event_cd)
  LOOP
    v_event_desc := c1.event_desc;
  END LOOP;
  IF v_event_desc IN ('QUOTATION TO PAR') THEN
  	 v_query := 'UPDATE GIPI_QUOTE SET USER_ID = '||''''||p_user||''''||' WHERE QUOTE_ID = '||''''||p_col_value||'''';
  ELSIF v_event_desc IN ('PAR-POLICY (READY FOR POSTING)','PAR-ENDORSEMENT (READY FOR POSTING)') THEN
  	 v_query := 'UPDATE GIPI_PARLIST SET UNDERWRITER = '||''''||p_user||''''||' WHERE PAR_ID = '||''''||p_col_value||'''';
  ELSIF v_event_desc IN ('CLAIMS WITH UNPAID PREMIUM PROCESSING') THEN
  	 v_query := 'UPDATE GICL_CLAIMS SET IN_HOU_ADJ = '||''''||p_user||''''||' WHERE CLAIM_ID = '||''''||p_col_value||'''';	 
  END IF;
  RETURN(v_query);
END;
/*******************/
FUNCTION get_popup_dir RETURN VARCHAR2 IS
  v_dir  VARCHAR2(32000):=NULL;
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 11/08/2004
--  Remarks   : This function was created to store the location of REAL POPUP.
*/
  v_dir := 'C:\PROGRAM FILES\REALPOPUP\';
  RETURN(v_dir);
END;
/*******************/
FUNCTION get_display_value(p_input IN VARCHAR2) RETURN VARCHAR2 IS
  v_output  VARCHAR2(32000):=NULL;
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 01/11/2005
--  Remarks   : This function was created to get the output value of the input query.
*/
  BEGIN
    EXECUTE IMMEDIATE p_input INTO v_output;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  v_output := NULL;	
  END;
  DBMS_OUTPUT.PUT_LINE(v_output);  
  RETURN(v_output);
END;
/*******************/
FUNCTION check_wf_user(p_event_mod_cd IN NUMBER,
                       p_passing_userid IN VARCHAR2,
                       p_userid IN VARCHAR2) RETURN BOOLEAN IS
  v_receiver_tag  GIIS_EVENTS.receiver_tag%TYPE;					   
  v_allow         BOOLEAN:=FALSE;
BEGIN
/*
--  Created By: A.R.C.
--  Created On: 01/13/2006
--  Remarks   : This function was created to check if user can process workflow.
*/
  FOR c1 IN (SELECT receiver_tag
			   FROM GIIS_EVENTS b, 
				    GIIS_EVENT_MODULES A
			  WHERE b.event_cd = A.event_cd
				AND A.event_mod_cd = p_event_mod_cd)
  LOOP
  	v_receiver_tag := c1.receiver_tag;
  	EXIT;
  END LOOP;	
  IF v_receiver_tag = 'Z' THEN
	  FOR c1 IN (SELECT 1
	               FROM GIIS_EVENT_MOD_USERS A
	              WHERE A.active_tag = 'Y'
	                AND A.event_mod_cd = p_event_mod_cd
	                AND A.passing_userid = p_passing_userid
	                AND A.userid IS NULL)
	  LOOP
	  	FOR c2 IN (SELECT 1
	  	             FROM giis_users
	  	            WHERE active_flag = 'Y'
	  	              AND workflow_tag = 'Y' 
	  	              AND user_id = p_userid)
	  	LOOP              
	  	  v_allow := TRUE;
	  	  EXIT;
	  	END LOOP;
	  	EXIT;
	  END LOOP;	  	 
  ELSIF v_receiver_tag <> 'Z' THEN
	  FOR c1 IN (SELECT 1
	               FROM GIIS_EVENT_MOD_USERS A
	              WHERE A.active_tag = 'Y'
	                AND A.event_mod_cd = p_event_mod_cd
	                AND A.passing_userid = p_passing_userid
	                AND A.userid = p_userid)
	  LOOP
	  	v_allow := TRUE;
	  	EXIT;
	  END LOOP;	
  END IF;	
  RETURN(v_allow);
END;

  /*
  **  Created by   : Andrew Robes 
  **  Date Created : April 06, 2010 
  **  Reference By : (WOFLO01 - Workflow)  
  **  Description  : procedure to save the created event 
  */ 
    PROCEDURE save_created_event(p_create        VARCHAR2,
                               p_event_cd      IN GIIS_EVENTS.event_cd%TYPE,
                               p_event_type    IN GIIS_EVENTS.event_type%TYPE,
                               p_user_id       IN GIIS_USERS.user_id%TYPE,
                               p_remarks       IN GIPI_USER_EVENTS.remarks%TYPE,
                               p_status        IN GIPI_USER_EVENTS.status%TYPE,
                               p_date_due      IN VARCHAR2,
                               p_col_value     IN VARCHAR2,
                               p_tran_dtl      IN VARCHAR2,
                               p_message_type  OUT VARCHAR2,
                               p_message       OUT VARCHAR2)
    IS                                    
--       the_rowcount           NUMBER;
--       --rg_id                  recordgroup;
--       --gc_id1                 groupcolumn;
--    --   gc_id2                 groupcolumn;
--    --   gc_id3                 groupcolumn;
--    --   gc_id4                 groupcolumn;
--    --   gc_id5                 groupcolumn;
--       v_event_user_mod       NUMBER;
--       v_event_col_cd         NUMBER;
       v_tran_id              NUMBER;
--       v_event_mod_cd2        NUMBER;
--       v_userid               VARCHAR2 (8);
--       v_old_userid           VARCHAR2 (8);
--       v_event_user_mod_new   NUMBER;
--       v_tran_id_new1         NUMBER;
--       v_tran_id_new2         NUMBER;
--       v_tran_id_new          NUMBER;
--       v_count                NUMBER;
--       v_last_record          NUMBER;
--       ed_ok                  BOOLEAN;
--       val                    VARCHAR2 (32000)                       := NULL;
--       v_tran2                VARCHAR2 (1)                           := 'N';
--       v_msgr                 NUMBER                 := giisp.v ('WORKFLOW_MSGR');
--       v_attach               VARCHAR2 (32000)                       := NULL;
       v_event_mod_cd         giis_event_modules.event_mod_cd%TYPE;
                                                              --A.R.C. 01.16.2006
       v_tran                 VARCHAR2 (1);                   --A.R.C. 01.16.2006
    BEGIN
       --VARIABLE.v_remarks := p_remarks;
       --VARIABLE.v_status := :remarks.status;
       --VARIABLE.v_date_due := :remarks.date_due;
       
       p_message_type := 'SUCCESS';
       v_event_mod_cd := giis_event_modules_pkg.get_event_mod_cd(p_event_cd, p_event_type);

    --         IF :user_list.user_tag = 'Y'
    --         THEN
                --A.R.C. 04.20.2006
--                IF p_event_type = 5
--                   AND wf.get_workflow_tran_list (p_event_cd) IS NULL
--                THEN
                   IF wf.check_wf_user (v_event_mod_cd, NVL(giis_users_pkg.app_user, USER), p_user_id)
                   THEN
                      v_tran := 'Y';
                      create_transfer_workflow_rec2 (p_event_cd, p_user_id, p_col_value, p_remarks, p_status, TO_DATE(p_date_due, 'MM-DD-YYYY'), p_tran_dtl, v_tran_id, p_message);
                      
                      --create_transfer_workflow_rec (p_event_cd, p_user_id, NULL);
                   ELSE
                      p_message := 'Access Denied. Cannot transfer transaction to ' || p_user_id;
                      p_message_type := 'ERROR';
                   END IF;
--                END IF;

    --      IF v_tran = 'Y'
    --      THEN                                                 --A.R.C. 01.16.2006
    --         FORMS_DDL ('COMMIT');
    --      END IF;

          IF v_tran = 'Y'
          THEN  
             --p_message := 'Transaction completed. Transaction ID is ' || v_tran_id;
             p_message := v_tran_id;         
          END IF;

    END save_created_event;

  /*
  **  Created by   : Andrew Robes 
  **  Date Created : 09.19.2011 
  **  Reference By : (WOFLO01 - Workflow)  
  **  Description  : procedure to save the created event 
  */ 
    /* Formatted on 2011/09/09 11:51 (Formatter Plus v4.8.8) */
    PROCEDURE transfer_event (
       p_tran_id          IN       gipi_user_events.tran_id%TYPE,
       p_event_mod_cd     IN       gipi_user_events.event_mod_cd%TYPE,
       p_event_col_cd     IN       gipi_user_events.event_col_cd%TYPE,
       p_event_user_mod   IN       gipi_user_events.event_user_mod%TYPE,
       p_user_id          IN       giis_users.user_id%TYPE,
       p_remarks          IN       gipi_user_events.remarks%TYPE,
       p_status           IN       gipi_user_events.status%TYPE,
       p_date_due         IN       VARCHAR2,--gipi_user_events.date_due%TYPE,
       p_event_cd           IN     gipi_user_events.event_cd%TYPE,
       p_event_type         IN     giis_events.event_type%TYPE,       
       p_multiple_assign_sw IN     giis_events.multiple_assign_sw%TYPE,
       p_receiver_tag     IN       giis_events.receiver_tag%TYPE,
       p_message_type     OUT      VARCHAR2,
       p_message          OUT      VARCHAR2
    )
    IS
       v_event_user_mod_new GIPI_USER_EVENTS.event_user_mod%TYPE;      
       v_tran                 VARCHAR2 (1);                   --A.R.C. 01.16.2006
       v_query                VARCHAR2(32767);
       v_date_received DATE;
    BEGIN
       p_message_type := 'SUCCESS';

       IF wf.check_wf_user (p_event_mod_cd,
                            NVL (giis_users_pkg.app_user, USER),
                            p_user_id
                           )
       THEN                                                    --A.R.C. 01.13.2006
          BEGIN
             SELECT event_user_mod
               INTO v_event_user_mod_new
               FROM giis_event_mod_users
              WHERE event_mod_cd = p_event_mod_cd
                AND passing_userid = NVL (giis_users_pkg.app_user, USER)
                AND NVL (userid, '0') =
                                      DECODE (p_receiver_tag,
                                              'Z', '0',
                                              p_user_id
                                             );
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_message := 'Invalid user.';
                p_message_type := 'ERROR';
          END;

          v_tran := 'Y';

          INSERT INTO gipi_user_events
                      (event_user_mod, event_col_cd, tran_id, SWITCH, col_value,
                       user_id, remarks, status, date_due)
             SELECT v_event_user_mod_new, p_event_col_cd, p_tran_id, 'N',
                    col_value, NVL (giis_users_pkg.app_user, USER), p_remarks,
                    p_status, TO_DATE(p_date_due, 'MM-DD-YYYY')                        --grace 03.05.2006
               FROM gipi_user_events
              WHERE event_user_mod = p_event_user_mod
                AND event_col_cd = p_event_col_cd
                AND tran_id = p_tran_id;
                
          v_date_received := DELAY(p_event_user_mod, p_event_col_cd, p_tran_id);
          INSERT INTO gipi_user_events_hist
                      (event_user_mod, event_col_cd, tran_id, col_value,
                       date_received, old_userid, new_userid, remarks)
             SELECT p_event_user_mod, p_event_col_cd, p_tran_id, col_value,
                    NVL(v_date_received, SYSDATE), NVL (giis_users_pkg.app_user, USER), p_user_id,
                    p_remarks
               FROM gipi_user_events
              WHERE event_user_mod = p_event_user_mod
                AND event_col_cd = p_event_col_cd
                AND tran_id = p_tran_id;

          FOR i IN (SELECT col_value
                      FROM gipi_user_events
                     WHERE event_user_mod = p_event_user_mod
                       AND event_col_cd = p_event_col_cd
                       AND tran_id = p_tran_id)
          LOOP
             --SHOW_VIEW ('WARNING2');
--             FOR c1 IN (SELECT event_cd, event_type, multiple_assign_sw
--                          FROM giis_events
--                         WHERE event_cd = p_event_cd)
--             LOOP
--                IF p_event_type IN (3, 4, 5)
--                   AND NVL (p_multiple_assign_sw, 'Y') = 'N'
--                THEN
--                   wf.workflow_update_user (c1.event_cd, p_user_id, i.col_value);
--                END IF;
--             END LOOP;
            IF p_event_type IN (3, 4, 5)
               AND NVL (p_multiple_assign_sw, 'Y') = 'N'
            THEN
               v_query := wf.workflow_update_user (p_event_cd, p_user_id, i.col_value);
               EXECUTE IMMEDIATE v_query;
            END IF;
          END LOOP;
       ELSE
          p_message :=
                    'Access Denied. Cannot transfer transaction to ' || p_user_id;
          p_message_type := 'ERROR';
       END IF;

--       IF v_tran = 'Y'
--       THEN                                                    --A.R.C. 01.13.2006
--          DELETE FROM gipi_user_events
--                WHERE event_user_mod = p_event_user_mod
--                  AND event_col_cd = p_event_col_cd
--                  AND tran_id = p_tran_id;
--       END IF;

       IF v_tran = 'Y'
       THEN
          p_message := p_tran_id;
       END IF;
    END transfer_event; 
  /*
  **  Created by   : Andrew Robes 
  **  Date Created : 12.22.2011 
  **  Reference By : (WOFLO01 - Workflow)  
  **  Description  : procedure to delete an event record by event_user_mod, event_col_cd and tran_id 
  */ 
  PROCEDURE del_gipi_user_event(
    p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
    p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
    p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE)
  IS
  BEGIN    		            
    DELETE FROM gipi_user_events
          WHERE event_user_mod = p_event_user_mod
            AND event_col_cd = p_event_col_cd
            AND tran_id = p_tran_id;
  END del_gipi_user_event;
    
  
  /*
  **  Created by   : Andrew Robes 
  **  Date Created : 12.22.2011 
  **  Reference By : (WOFLO01 - Workflow)  
  **  Description  : procedure executed when an event is deleted from the module 
  */   
  PROCEDURE del_event(p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
                      p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
                      p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE,
                      p_user_id        GIIS_USERS.user_id%TYPE)
  IS
  BEGIN    		   
    INSERT INTO gipi_user_events_hist
                (event_user_mod, event_col_cd, tran_id, col_value, date_received,
                 old_userid, new_userid)
       SELECT p_event_user_mod, p_event_col_cd,
              p_tran_id, col_value, SYSDATE, p_user_id, '-'
         FROM gipi_user_events
        WHERE event_user_mod = p_event_user_mod
          AND event_col_cd = p_event_col_cd
          AND tran_id = p_tran_id;
          
    DELETE FROM gipi_user_events
          WHERE event_user_mod = p_event_user_mod
            AND event_col_cd = p_event_col_cd
            AND tran_id = p_tran_id;
  END del_event;
          
  PROCEDURE update_event_status(p_event_user_mod GIPI_USER_EVENTS.event_user_mod%TYPE,
                                p_event_col_cd   GIPI_USER_EVENTS.event_col_cd%TYPE,
                                p_tran_id        GIPI_USER_EVENTS.tran_id%TYPE,
                                p_status         GIPI_USER_EVENTS.status%TYPE)
  IS
  BEGIN    		                 
    UPDATE gipi_user_events
       SET status = p_status
     WHERE event_user_mod = p_event_user_mod
       AND event_col_cd = p_event_col_cd
       AND tran_id = p_tran_id;
  END update_event_status;  
                  
END WF;
/



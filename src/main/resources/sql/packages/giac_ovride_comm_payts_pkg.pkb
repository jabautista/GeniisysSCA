CREATE OR REPLACE PACKAGE BODY CPI.GIAC_OVRIDE_COMM_PAYTS_PKG
AS
  /*
  **  Created by   :  Emman
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets GIAC Ovride Comm Payts details of specified transaction Id 
  */ 
  FUNCTION get_giac_ovride_comm_payts (p_gacc_tran_id		GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE)
    RETURN giac_ovride_comm_payts_tab PIPELINED
  IS
  	v_ovride_comm_payts				  giac_ovride_comm_payts_type;
  BEGIN
  	FOR i IN (SELECT gocp.gacc_tran_id, gocp.transaction_type, gocp.iss_cd, gocp.prem_seq_no, gocp.intm_no,
		  	 		 gocp.chld_intm_no, gocp.comm_amt, gocp.input_vat, gocp.wtax_amt, gocp.particulars,
					 gocp.user_id, gocp.last_update, gocp.foreign_curr_amt, gocp.convert_rt, gocp.currency_cd,
					 gcur.currency_desc
				FROM GIAC_OVRIDE_COMM_PAYTS gocp, GIIS_CURRENCY gcur
			  WHERE gocp.gacc_tran_id = p_gacc_tran_id
			    AND gocp.currency_cd  = gcur.main_currency_cd)
	LOOP
		v_ovride_comm_payts.gacc_tran_id				 := i.gacc_tran_id;
		v_ovride_comm_payts.transaction_type			 := i.transaction_type;
		v_ovride_comm_payts.iss_cd						 := i.iss_cd;
		v_ovride_comm_payts.prem_seq_no					 := i.prem_seq_no;
		v_ovride_comm_payts.intm_no						 := i.intm_no;
		v_ovride_comm_payts.child_intm_no				 := i.chld_intm_no;
		v_ovride_comm_payts.comm_amt					 := i.comm_amt;
		v_ovride_comm_payts.input_vat					 := i.input_vat;
		v_ovride_comm_payts.wtax_amt					 := i.wtax_amt;
		v_ovride_comm_payts.particulars					 := i.particulars;
		v_ovride_comm_payts.user_id						 := i.user_id;
		v_ovride_comm_payts.last_update					 := i.last_update;
		v_ovride_comm_payts.foreign_curr_amt			 := i.foreign_curr_amt;
		v_ovride_comm_payts.convert_rt					 := i.convert_rt;
		v_ovride_comm_payts.currency_cd					 := i.currency_cd;
		v_ovride_comm_payts.currency_desc				 := i.currency_desc;
		
		v_ovride_comm_payts.drv_comm_amt := i.comm_amt + nvl(i.input_vat, 0) - i.wtax_amt;
		
		GIAC_PARENT_COMM_INVOICE_PKG.get_parent_child_intm_name(i.intm_no,
																i.chld_intm_no,
																i.iss_cd,
																i.prem_seq_no,
																v_ovride_comm_payts.intermediary_name,
																v_ovride_comm_payts.child_intm_name);
																
        GIAC_PARENT_COMM_INVOICE_PKG.get_assd_policy_name(i.intm_no,
														  i.chld_intm_no,
														  i.iss_cd,
														  i.prem_seq_no,
														  v_ovride_comm_payts.policy_no,
														  v_ovride_comm_payts.assd_name);
	
		PIPE ROW(v_ovride_comm_payts);
	END LOOP;
  END;
  
    FUNCTION get_overide_comm_payts_iss_cd(p_user_id          GIIS_USERS.user_id%TYPE)
       RETURN overide_comm_payts_iss_cd_tab PIPELINED
    IS
       v_rec   overide_comm_payts_iss_cd_type;
    BEGIN
       FOR i IN (SELECT DISTINCT a.iss_cd, b.iss_name
                            FROM giac_parent_comm_invoice a, giis_issource b
                           WHERE a.iss_cd = b.iss_cd
                             AND (   EXISTS ( --added by steven 11.19.2014; to replace check_user_per_iss_cd_acctg2
                                        SELECT d.access_tag
                                          FROM giis_users a,
                                               giis_user_iss_cd b2,
                                               giis_modules_tran c,
                                               giis_user_modules d
                                         WHERE a.user_id = p_user_id
                                           AND b2.iss_cd = a.iss_cd
                                           AND c.module_id = 'GIACS040'
                                           AND a.user_id = b2.userid
                                           AND d.userid = a.user_id
                                           AND b2.tran_cd = c.tran_cd
                                           AND d.tran_cd = c.tran_cd
                                           AND d.module_id = c.module_id)
                                  OR EXISTS (
                                        SELECT d.access_tag
                                          FROM giis_users a,
                                               giis_user_grp_dtl b2,
                                               giis_modules_tran c,
                                               giis_user_grp_modules d
                                         WHERE a.user_id = p_user_id
                                           AND b2.iss_cd = a.iss_cd
                                           AND c.module_id = 'GIACS040'
                                           AND a.user_grp = b2.user_grp
                                           AND d.user_grp = a.user_grp
                                           AND b2.tran_cd = c.tran_cd
                                           AND d.tran_cd = c.tran_cd
                                           AND d.module_id = c.module_id)
                                 )
                        ORDER BY a.iss_cd)
       LOOP
          v_rec.branch_cd := i.iss_cd;
          v_rec.branch_name := i.iss_name;
          PIPE ROW (v_rec);
       END LOOP;
    END;
    
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets LOV list for Bill No. based on specified tran type
  **  Modifications: Included other details aside from bill no. Added validations after 1st loop for each transaction type 
                        copied from validate_giacs040_child_intm : shan 03.10.2015   
  */ 
    FUNCTION get_bill_no_by_tran_type (
        p_tran_type				GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
        p_iss_cd                GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
        p_prem_seq_no           GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
        p_new_bills             VARCHAR2,
        p_deleted_bills         VARCHAR2
    ) RETURN ovride_comm_payts_bill_no_tab PIPELINED
    IS
       v_bill_no_list    ovride_comm_payts_bill_no_type;
       v_var_with_prem   NUMBER (1)                                 := 0;
       v_var_prem_amt    giac_direct_prem_collns.premium_amt%TYPE   := 0;
       v_message         VARCHAR2 (100)                             := NULL;
       v_balance         giac_parent_comm_invoice.COMMISSION_AMT%TYPE;
       v_exist           VARCHAR2(1);
       v_include         VARCHAR2(1);
       
       p_comm_amt			  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
       p_foreign_curr_amt	  GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
       p_prev_comm_amt		  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
       p_prev_for_curr_amt    GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
       p_var_comm_amt		  NUMBER;
       p_var_comm_amt_def	  NUMBER;
       p_var_for_cur_amt_def  NUMBER;
       p_var_prem_amt		  NUMBER;
       p_var_percentage	 	  NUMBER;
       p_var_premium_payts	  NUMBER;
       p_message              VARCHAR2(300);
       p_var_currency_rt	  GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE;
       p_var_currency_cd	  GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE;
       p_var_currency_desc	  GIIS_CURRENCY.currency_desc%TYPE;
       p_var_foreign_curr_amt GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
    BEGIN
        IF giacp.v('NO_PREM_PAYT') = 'N' THEN
            BEGIN
                 SELECT SUM(premium_amt) PREM_AMT
                   INTO p_var_prem_amt
                   FROM giac_direct_prem_collns a,
                        giac_acctrans b
                  WHERE a.gacc_tran_id = b.tran_id
                    AND b.tran_flag <> 'D'
                    AND a.b140_iss_cd = p_iss_cd
                    AND a.b140_prem_seq_no = p_prem_seq_no
                    AND a.gacc_tran_id NOT IN(SELECT c.gacc_tran_id
                                                FROM giac_reversals c, 
                                                     giac_acctrans d
                                               WHERE c.reversing_tran_id = d.tran_id
                                                 AND d.tran_flag <> 'D'); 
            END;
        END IF;
        
       IF p_tran_type = 1
       THEN
          FOR i IN (SELECT DISTINCT iss_cd || '-' || TO_CHAR(prem_seq_no, 'FM000000000000') bill_no, iss_cd,
                                    prem_seq_no, intm_no, chld_intm_no, commission_amt
                               FROM giac_parent_comm_invoice h
                              WHERE commission_amt > 0
                                AND iss_cd = NVL(p_iss_cd, iss_cd)
                                AND prem_seq_no = NVL(p_prem_seq_no, prem_seq_no)
                                -- exclude newly added but not yet saved bills : shan 03.09.2015
                                AND ((p_new_bills IS NOT NULL
                                       AND (INSTR(p_new_bills, '#'||tran_id || '-' ||iss_cd ||'-'||prem_seq_no||'-'||intm_no||'-'||chld_intm_no||'#') = 0))
                                     OR p_new_bills IS NULL)
                           ORDER BY iss_cd, prem_seq_no)
          LOOP
             v_exist        := 'N';
             v_include      := 'Y';
             /*  This is to check whether a bill_no of the same intm_no,iss_cd,chld_intm_no already exist,
             **  provided that transaction_type is in (1,2).
             */
             p_comm_amt     := null;
             
             FOR j IN (SELECT a.*
                        FROM GIAC_OVRIDE_COMM_PAYTS A,
                             GIAC_ACCTRANS B
                       WHERE A.TRANSACTION_TYPE IN(1,2)
                         AND A.INTM_NO= i.INTM_NO
                         AND A.ISS_CD= i.ISS_CD
                         AND A.PREM_SEQ_NO= i.PREM_SEQ_NO
                         AND A.CHLD_INTM_NO= i.CHLD_INTM_NO
                         AND A.GACC_TRAN_ID=B.TRAN_ID
                         AND B.TRAN_FLAG!='D'
                         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                     FROM GIAC_REVERSALS X,
                                                          GIAC_ACCTRANS Y
                                                    WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                      AND Y.TRAN_FLAG !='D')
                        -- include newly deleted but not yet saved bills : shan 03.09.2015
                        AND ((p_deleted_bills IS NOT NULL
                               AND (INSTR(p_deleted_bills, '#'||a.gacc_tran_id || '-' ||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'#') = 0))
                              OR p_deleted_bills IS NULL))
             LOOP 
                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT1_PROCEDURE(j.iss_cd, j.prem_seq_no, j.intm_no, j.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                   v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_comm_amt, v_bill_no_list.prev_for_curr_amt, 
                                                                   p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def, p_var_prem_amt, p_var_percentage,
                                                                   p_var_premium_payts, p_deleted_bills);
                v_exist := 'Y';
                
                IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
                    IF NVL(v_bill_no_list.ovriding_comm_amt, 0) = 0 THEN
                        v_include := 'N';
                    END IF;
                ELSE 
                    IF NVL(v_bill_no_list.ovriding_comm_amt, 0) = 0 THEN
                        v_include := 'N';   
                    END IF;
                END IF;
             END LOOP;
             
             v_bill_no_list.bill_no := i.bill_no;
             v_bill_no_list.iss_cd := i.iss_cd;
             v_bill_no_list.prem_seq_no := i.prem_seq_no;
             v_bill_no_list.intm_no := i.intm_no;
             v_bill_no_list.chld_intm_no := i.chld_intm_no;
                 
             IF v_exist = 'N' THEN
                 GIAC_OVRIDE_COMM_PAYTS_PKG.GET_DEFAULT_VAL_PROCEDURE(p_tran_type, i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                        v_bill_no_list.prev_comm_amt, p_var_percentage, p_var_prem_amt, p_var_premium_payts, 
                                                                        p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def); 
             END IF;
             
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, 
                                                                    v_bill_no_list.intm_name, v_bill_no_list.chld_intm_name);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.policy_no, v_bill_no_list.assd_name);                            
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(i.intm_no, v_bill_no_list.ovriding_comm_amt, v_bill_no_list.input_vat);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, NULL, 
                                                                v_bill_no_list.wtax_amt);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                             v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);                                
             v_bill_no_list.net_comm := NVL(v_bill_no_list.ovriding_comm_amt, 0) + NVL(v_bill_no_list.input_vat, 0) - NVL(v_bill_no_list.wtax_amt, 0);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_VAL_CURRENCY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no,
																   v_bill_no_list.convert_rt, v_bill_no_list.currency_cd, v_bill_no_list.currency_desc, 
                                                                   p_var_currency_rt, p_var_currency_cd, p_var_currency_desc);            
             IF v_include = 'Y' THEN                 
                 PIPE ROW (v_bill_no_list);
             END IF;
          END LOOP;
          
       ELSIF p_tran_type = 2
       THEN
          FOR i IN (SELECT /*DISTINCT*/ gacc_tran_id, gocp.iss_cd || '-'
                                    || gocp.prem_seq_no bill_no,
                                    gocp.iss_cd, gocp.prem_seq_no,
                                    gocp.intm_no, gocp.chld_intm_no
                               FROM giac_ovride_comm_payts gocp
                              WHERE transaction_type = 1
                                AND NVL (comm_amt, 0) <> 0
                                AND iss_cd = NVL(p_iss_cd, iss_cd)
                                AND prem_seq_no = NVL(p_prem_seq_no, prem_seq_no)
                                AND ( SELECT SUM (a.comm_amt)
                                        FROM giac_ovride_comm_payts a,
                                              giac_parent_comm_invoice b,
                                              gipi_invoice c
                                        WHERE a.transaction_type IN (1, 2)
                                          AND a.intm_no = gocp.intm_no
                                          AND a.intm_no = b.intm_no
                                          AND a.chld_intm_no = b.chld_intm_no
                                          AND a.chld_intm_no = gocp.chld_intm_no
                                          AND a.iss_cd = b.iss_cd
                                          AND a.iss_cd = gocp.iss_cd
                                          AND a.prem_seq_no = gocp.prem_seq_no
                                          AND a.prem_seq_no = b.prem_seq_no
                                          AND b.iss_cd = c.iss_cd
                                          AND b.prem_seq_no = c.prem_seq_no
                                          AND a.gacc_tran_id = gocp.gacc_tran_id
                                     GROUP BY c.currency_rt) <> 0
                             -- exclude newly added but not yet saved bills : shan 03.09.2015
                                AND ((p_new_bills IS NOT NULL
                                       AND (INSTR(p_new_bills, '#'||iss_cd ||'-'||prem_seq_no||'-'||intm_no||'-'||chld_intm_no||'-'||(comm_amt*-1)||'#') = 0))
                                     OR p_new_bills IS NULL)
                           ORDER BY iss_cd, prem_seq_no)
          LOOP
                p_comm_amt := null;
                
                /*   This is to check whether there is an account to refund from.*/ 
                FOR TU IN(SELECT A.TRANSACTION_TYPE
                            FROM GIAC_OVRIDE_COMM_PAYTS A,
                                 GIAC_ACCTRANS B
                           WHERE A.TRANSACTION_TYPE =1
                             AND A.INTM_NO= i.INTM_NO
                             AND A.ISS_CD= i.ISS_CD
                             AND A.PREM_SEQ_NO= i.PREM_SEQ_NO
                             AND A.CHLD_INTM_NO= i.CHLD_INTM_NO
                             AND A.GACC_TRAN_ID=B.TRAN_ID
                             AND B.TRAN_FLAG!='D'
                             AND A.GACC_TRAN_ID=i.GACC_TRAN_ID
                             AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                         FROM GIAC_REVERSALS X,
                                                              GIAC_ACCTRANS Y
                                                        WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                          AND Y.TRAN_FLAG !='D')
                             AND (iss_cd, prem_seq_no, intm_no, chld_intm_no, comm_amt) NOT IN (SELECT iss_cd, prem_seq_no, intm_no, chld_intm_no, (comm_amt*-1)
                                                                                                  FROM giac_ovride_comm_Payts
                                                                                                 WHERE transaction_type = 2
                                                                                                   AND ((p_deleted_bills IS NOT NULL
                                                                                                           AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||(a.comm_amt*-1)||'#') = 0))
                                                                                                         OR p_deleted_bills IS NULL))
                             AND rownum = 1)
                LOOP
			        IF TU.TRANSACTION_TYPE IS NOT NULL THEN	
                        v_bill_no_list.bill_no := i.bill_no;
                        v_bill_no_list.iss_cd := i.iss_cd;
                        v_bill_no_list.prem_seq_no := i.prem_seq_no;
                        v_bill_no_list.intm_no := i.intm_no;
                        v_bill_no_list.chld_intm_no := i.chld_intm_no;
                        
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT3_PROCEDURE(i.gacc_tran_id, i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt,
                                                                          v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_comm_amt, v_bill_no_list.prev_for_curr_amt, 
                                                                          p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def, p_message, p_deleted_bills);    
                                            
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, 
                                                                                v_bill_no_list.intm_name, v_bill_no_list.chld_intm_name);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.policy_no, v_bill_no_list.assd_name); 
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(i.intm_no, v_bill_no_list.ovriding_comm_amt, v_bill_no_list.input_vat);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, NULL, 
                                                                            v_bill_no_list.wtax_amt);
                        v_bill_no_list.net_comm := NVL(v_bill_no_list.ovriding_comm_amt, 0) + NVL(v_bill_no_list.input_vat, 0) - NVL(v_bill_no_list.wtax_amt, 0);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                        v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);                                
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_VAL_CURRENCY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no,
                                                                               v_bill_no_list.convert_rt, v_bill_no_list.currency_cd, v_bill_no_list.currency_desc, 
                                                                               p_var_currency_rt, p_var_currency_cd, p_var_currency_desc); 
                                                                   
                        IF p_message = 'SUCCESS' THEN
                            PIPE ROW (v_bill_no_list);
                        END IF;
			        END IF;
                END LOOP;
          END LOOP;
       ELSIF p_tran_type = 3
       THEN
          FOR i IN (SELECT DISTINCT iss_cd || '-' || prem_seq_no bill_no, iss_cd,
                                    prem_seq_no, intm_no, chld_intm_no, commission_amt
                               FROM giac_parent_comm_invoice
                              WHERE commission_amt < 0
                                AND iss_cd = NVL(p_iss_cd, iss_cd)
                                AND prem_seq_no = NVL(p_prem_seq_no, prem_seq_no)
                                -- exclude newly added but not yet saved bills : shan 03.09.2015
                                AND ((p_new_bills IS NOT NULL
                                       AND (INSTR(p_new_bills, '#'||tran_id || '-' ||iss_cd ||'-'||prem_seq_no||'-'||intm_no||'-'||chld_intm_no||'#') = 0))
                                     OR p_new_bills IS NULL)
                           ORDER BY iss_cd, prem_seq_no)
          LOOP
             v_exist        := 'N';
             v_include      := 'Y';
             
             /*  This is to check whether a bill_no of the same intm_no,iss_cd,chld_intm_no already exist,
              **  provided that transaction_type is in (3,4).
              */
             
            FOR j IN(SELECT A.*
                        FROM GIAC_OVRIDE_COMM_PAYTS A,
                             GIAC_ACCTRANS B
                       WHERE A.TRANSACTION_TYPE IN(3,4)
                         AND A.INTM_NO=i.INTM_NO
                         AND A.ISS_CD=i.ISS_CD
                         AND A.PREM_SEQ_NO=i.PREM_SEQ_NO
                         AND A.CHLD_INTM_NO=i.CHLD_INTM_NO
                         AND A.GACC_TRAN_ID=B.TRAN_ID
                         AND B.TRAN_FLAG!='D'
                         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                     FROM GIAC_REVERSALS X,
                                                          GIAC_ACCTRANS Y
                                                    WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                      AND Y.TRAN_FLAG !='D')
                        -- include newly deleted but not yet saved bills : shan 03.09.2015
                        AND ((p_deleted_bills IS NOT NULL
                               AND (INSTR(p_deleted_bills, '#'||a.gacc_tran_id || '-' ||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'#') = 0))
                              OR p_deleted_bills IS NULL))
            LOOP
                GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT4_PROCEDURE(j.iss_cd, j.prem_seq_no, j.intm_no, j.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                   v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_comm_amt, v_bill_no_list.prev_for_curr_amt, 
                                                                   p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def, p_var_prem_amt, p_var_percentage,
                                                                   p_var_premium_payts, p_deleted_bills);
                v_exist := 'Y';
                
                IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
                    IF NVL(v_bill_no_list.ovriding_comm_amt, 0) = 0 THEN
                        v_include := 'N';
                    END IF;
                ELSE 
                    IF NVL(v_bill_no_list.ovriding_comm_amt, 0) = 0 THEN
                        v_include := 'N';   
                    END IF;
                END IF;
            END LOOP;
                                                     
             v_bill_no_list.bill_no := i.bill_no;
             v_bill_no_list.iss_cd := i.iss_cd;
             v_bill_no_list.prem_seq_no := i.prem_seq_no;
             v_bill_no_list.intm_no := i.intm_no;
             v_bill_no_list.chld_intm_no := i.chld_intm_no;
             
             IF v_exist = 'N' THEN
                 GIAC_OVRIDE_COMM_PAYTS_PKG.GET_DEFAULT_VAL_PROCEDURE(p_tran_type, i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                        v_bill_no_list.prev_comm_amt, p_var_percentage, p_var_prem_amt, p_var_premium_payts, 
                                                                        p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def); 
             END IF;
             
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, 
                                                                    v_bill_no_list.intm_name, v_bill_no_list.chld_intm_name);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.policy_no, v_bill_no_list.assd_name);                            
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(i.intm_no, v_bill_no_list.ovriding_comm_amt, v_bill_no_list.input_vat);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, NULL, 
                                                                v_bill_no_list.wtax_amt);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                             v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);                                
             v_bill_no_list.net_comm := NVL(v_bill_no_list.ovriding_comm_amt, 0) + NVL(v_bill_no_list.input_vat, 0) - NVL(v_bill_no_list.wtax_amt, 0);
             GIAC_OVRIDE_COMM_PAYTS_PKG.GET_VAL_CURRENCY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no,
																   v_bill_no_list.convert_rt, v_bill_no_list.currency_cd, v_bill_no_list.currency_desc, 
                                                                   p_var_currency_rt, p_var_currency_cd, p_var_currency_desc);            
             IF v_include = 'Y' THEN                 
                 PIPE ROW (v_bill_no_list);
             END IF;
          END LOOP;
       ELSIF p_tran_type = 4
       THEN
          FOR i IN (SELECT /*DISTINCT*/ gacc_tran_id, iss_cd || '-' || prem_seq_no bill_no, iss_cd,
                                    prem_seq_no ,
                                    intm_no, chld_intm_no, comm_amt
                               FROM giac_ovride_comm_payts a
                              WHERE transaction_type = 3
                                AND NVL (comm_amt, 0) <> 0
                                AND iss_cd = NVL(p_iss_cd, iss_cd)
                                AND prem_seq_no = NVL(p_prem_seq_no, prem_seq_no)                                
                                AND ((p_new_bills IS NOT NULL
                                       AND (INSTR(p_new_bills, '#'||iss_cd ||'-'||prem_seq_no||'-'||intm_no||'-'||chld_intm_no||'-'||(comm_amt*-1)||'#') = 0))
                                     OR p_new_bills IS NULL)
                               /* AND (iss_cd, prem_seq_no, intm_no, chld_intm_no, comm_amt) NOT IN (SELECT iss_cd, prem_seq_no, intm_no, chld_intm_no, (comm_amt*-1)
                                                                                                  FROM giac_ovride_comm_Payts
                                                                                                 WHERE transaction_type = 4
                                                                                                   AND ((p_deleted_bills IS NOT NULL
                                                                                                           AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||(a.comm_amt*-1)||'#') = 0))
                                                                                                         OR p_deleted_bills IS NULL))*/
                      ORDER BY iss_cd, prem_seq_no)
          LOOP
            /*   This is to check whether there is an account to refund from.*/
             FOR FO IN(SELECT A.TRANSACTION_TYPE
                            FROM GIAC_OVRIDE_COMM_PAYTS A,
                                 GIAC_ACCTRANS B
                           WHERE A.TRANSACTION_TYPE =3
                             AND A.INTM_NO=i.INTM_NO
                             AND A.ISS_CD=i.ISS_CD
                             AND A.PREM_SEQ_NO=i.PREM_SEQ_NO
                             AND A.CHLD_INTM_NO=i.CHLD_INTM_NO
                             AND A.GACC_TRAN_ID=B.TRAN_ID
                             AND A.GACC_TRAN_ID=i.GACC_TRAN_ID
                             AND B.TRAN_FLAG!='D'
                             AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                         FROM GIAC_REVERSALS X,
                                                              GIAC_ACCTRANS Y
                                                        WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                          AND Y.TRAN_FLAG !='D')
                             AND (iss_cd, prem_seq_no, intm_no, chld_intm_no, comm_amt) NOT IN (SELECT iss_cd, prem_seq_no, intm_no, chld_intm_no, (comm_amt*-1)
                                                                                                  FROM giac_ovride_comm_Payts
                                                                                                 WHERE transaction_type = 4
                                                                                                   AND ((p_deleted_bills IS NOT NULL
                                                                                                           AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||(a.comm_amt*-1)||'#') = 0))
                                                                                                         OR p_deleted_bills IS NULL))
                             /*AND ((p_deleted_bills IS NOT NULL
                                   AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||(a.comm_amt*-1)||'#') != 0))
                                 OR p_deleted_bills IS NULL)*/
                             AND rownum = 1)
              LOOP
                    IF FO.TRANSACTION_TYPE IS NOT NULL THEN
                        v_bill_no_list.bill_no := i.bill_no;
                        v_bill_no_list.iss_cd := i.iss_cd;
                        v_bill_no_list.prem_seq_no := i.prem_seq_no;
                        v_bill_no_list.intm_no := i.intm_no;
                        v_bill_no_list.chld_intm_no := i.chld_intm_no;
            
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT6_PROCEDURE(i.gacc_tran_id, i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt,
                                                                          v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_comm_amt, v_bill_no_list.prev_for_curr_amt, 
                                                                          p_var_comm_amt, p_var_comm_amt_def, p_var_for_cur_amt_def, p_message, p_deleted_bills);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, 
                                                                                v_bill_no_list.intm_name, v_bill_no_list.chld_intm_name);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.policy_no, v_bill_no_list.assd_name); 
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(i.intm_no, v_bill_no_list.ovriding_comm_amt, v_bill_no_list.input_vat);
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, NULL, 
                                                                            v_bill_no_list.wtax_amt);
                        v_bill_no_list.net_comm := NVL(v_bill_no_list.ovriding_comm_amt, 0) + NVL(v_bill_no_list.input_vat, 0) - NVL(v_bill_no_list.wtax_amt, 0);
                        
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no, v_bill_no_list.ovriding_comm_amt, 
                                                                        v_bill_no_list.foreign_curr_amt, v_bill_no_list.prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);                                
                        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_VAL_CURRENCY_PROCEDURE(i.iss_cd, i.prem_seq_no, i.intm_no, i.chld_intm_no,
                                                                               v_bill_no_list.convert_rt, v_bill_no_list.currency_cd, v_bill_no_list.currency_desc, 
                                                                               p_var_currency_rt, p_var_currency_cd, p_var_currency_desc); 
                        
                       -- IF p_message = 'SUCCESS' THEN
                            PIPE ROW (v_bill_no_list);
                        /*ELSE
                            raise_application_error(-20001, i.gacc_tran_id);
                        END IF;     */               
                    END IF;
              END LOOP;
          END LOOP;
       END IF;
    END get_bill_no_by_tran_type;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets the default bill no LOV listing
  */ 
  FUNCTION get_dflt_bill_no_listing(p_iss_cd	   			GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE)
    RETURN ovride_comm_payts_bill_no_tab PIPELINED
  IS
  	v_bill_no_list						 ovride_comm_payts_bill_no_type;
  BEGIN
    FOR i IN (SELECT DISTINCT iss_cd || '-' || prem_seq_no bill_no, iss_cd, prem_seq_no
			    FROM giac_parent_comm_invoice 
			   WHERE iss_cd = p_iss_cd)
	LOOP
		v_bill_no_list.bill_no	   	  := i.bill_no;
		v_bill_no_list.iss_cd	   	  := i.iss_cd;
		v_bill_no_list.prem_seq_no    := i.prem_seq_no;
		
		PIPE ROW(v_bill_no_list);
	END LOOP;
			
  END get_dflt_bill_no_listing;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure CHCK_PREM_PAYTS
  */ 
  PROCEDURE chck_prem_payts(p_iss_cd					   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  							p_prem_seq_no				   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
							p_var_with_prem				   IN OUT NUMBER,
							p_var_prem_amt				   IN OUT GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE,
							p_message					      OUT VARCHAR2)
  IS
	  prem_payts       GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE;
	  v_inv_prem_amt   GIPI_INVOICE.prem_amt%type;	
  BEGIN
    p_message := 'SUCCESS';
	
	BEGIN
		  SELECT nvl(round(prem_amt*currency_rt,2),0)
		    INTO v_inv_prem_amt
		    FROM gipi_invoice
		   WHERE iss_cd      = p_iss_cd
		     AND prem_seq_no = p_prem_seq_no;
	EXCEPTION
		  WHEN no_data_found THEN
			  p_message := 'No existing record in GIPI_INVOICE table.';	
	END;
		
	FOR i IN(SELECT SUM(premium_amt) PREM_AMT
	           FROM giac_direct_prem_collns a,
	                giac_acctrans b
	          WHERE a.gacc_tran_id = b.tran_id
	            AND b.tran_flag <> 'D'
	            AND a.b140_iss_cd = p_iss_cd
	            AND a.b140_prem_seq_no = p_prem_seq_no
	            AND a.gacc_tran_id NOT IN(SELECT c.gacc_tran_id
	                                        FROM giac_reversals c, 
	                                             giac_acctrans d
	                                       WHERE c.reversing_tran_id = d.tran_id
	                                         AND d.tran_flag <> 'D')) LOOP
	        
	     prem_payts := nvl(i.prem_amt,0);
	END LOOP;
	    IF (prem_payts = 0  AND v_inv_prem_amt <> 0) THEN  -- jeremy 01202010 to handle 0 net premium but with adjustments in commission (same w/giacs020)
	       p_message := 'No Premium Payment has been made for this Policy.';
	       p_var_with_prem := 1;
	    ELSE
	       p_var_prem_amt := v_inv_prem_amt; --prem_payts; -- changed to get the full amount as per BR : shan 03.09.2015
	       p_var_with_prem := 0;
	    END IF;
  END chck_prem_payts;

  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure CHCK_BALANCE. Also included the procedure CHCK_USER
  */ 
  PROCEDURE chck_balance(p_iss_cd 			IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  						 p_prem_seq_no		IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
						 p_module_name		IN	   VARCHAR2,
						 p_user_id	    	IN	   VARCHAR2,
						 p_var_switch		IN OUT NUMBER,
						 p_message			   OUT VARCHAR2)
  IS
	  V_BALANCE            GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE%TYPE;
	  DUMMY   			   VARCHAR2(5);
  BEGIN
  	  p_message := 'SUCCESS';
	  
	  FOR I IN(SELECT BALANCE_AMT_DUE
	             FROM GIAC_AGING_SOA_DETAILS
	            WHERE ISS_CD = p_iss_cd
	              AND PREM_SEQ_NO = p_prem_seq_no)LOOP
	  
	    V_BALANCE := NVL(I.BALANCE_AMT_DUE,0);
	   
	  END LOOP;
	  
	  IF V_BALANCE != 0 THEN
	       --CHCK_USER
		   DUMMY := GIAC_VALIDATE_USER_FN(/*USER*/ p_user_id,'MC',p_module_name);
		   IF DUMMY = 'FALSE' THEN
		      p_message := 'This Policy is not yet Fully Paid.';
		      p_var_switch := 1;
		   ELSE
		      --p_message := 'This Policy is not yet Fully Paid. Do you wish to Override ?','U',FALSE);
			  p_message := 'NOT_FULLY_PAID_OVERRIDE';
		   END IF;  
	  ELSE
	     NULL;
	  END IF;       
  END chck_balance;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_PERCENTAGE
  */
  PROCEDURE get_percentage(p_iss_cd		  	 	 	 	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  						   p_prem_seq_no				   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  						   p_var_prem_amt				   IN     NUMBER,
  						   p_var_percentage	 	 	 	   IN OUT NUMBER,
						   p_var_premium_payts			   IN OUT NUMBER)
  IS
	   var_prem_amt               gipi_invoice.prem_amt%type;
	   var_other_charges          gipi_invoice.other_charges%type;
	   var_notarial_fee           gipi_invoice.notarial_fee%type;
	   var_gi_prem_amt            gipi_invoice.prem_amt%type;
  BEGIN	  
	FOR a IN(SELECT prem_amt, other_charges, notarial_fee, currency_rt
	           FROM gipi_invoice
	          WHERE iss_cd = p_iss_cd
	            AND prem_seq_no = p_prem_seq_no)
	LOOP
	    var_prem_amt := nvl(a.prem_amt,0) * a.currency_rt;
	    var_other_charges := nvl(a.other_charges,0) * a.currency_rt;
	    var_notarial_fee := nvl(a.notarial_fee,0) * a.currency_rt;
	    var_gi_prem_amt := var_prem_amt + var_other_charges + var_notarial_fee;
	    p_var_percentage := p_var_prem_amt / var_gi_prem_amt;     
	    p_var_premium_payts := a.prem_amt;
	END LOOP;	 
  EXCEPTION
	WHEN ZERO_DIVIDE THEN
	    p_var_percentage := 1;      
  END get_percentage;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_DEFAULT_VAL_PROCEDURE
  **  			     Gets the default value of the comm_amt if there are no previous trn type available.
  */
  PROCEDURE get_default_val_procedure(p_transaction_type	   		 IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
  									  p_iss_cd						 IN		GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									  p_prem_seq_no					 IN		GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									  p_intm_no						 IN		GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									  p_chld_intm_no				 IN		GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									  p_comm_amt					 IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									  p_prev_comm_amt				 IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									  p_var_percentage				 IN OUT NUMBER,
									  p_var_prem_amt				 IN 	NUMBER,
									  p_var_premium_payts			 IN OUT NUMBER,
									  p_var_comm_amt				 IN OUT NUMBER,
									  p_var_comm_amt_def			 IN OUT NUMBER,
									  p_var_for_cur_amt_def			 IN OUT NUMBER)
  IS
  	  V_CURRT	GIPI_INVOICE.CURRENCY_RT%TYPE;
	  V_WTAX	GIAC_OVRIDE_COMM_PAYTS.WTAX_AMT%TYPE;
	  V_DFCT	GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	  V_FDEF        GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
	  V_COMM        GIAC_OVRIDE_COMM_PAYTS.COMM_AMT%TYPE;
	  V_COMM2       GIAC_OVRIDE_COMM_PAYTS.COMM_AMT%TYPE;
  BEGIN
	  IF P_TRANSACTION_TYPE IN(1,2,3,4) THEN
	      SELECT A.COMMISSION_AMT,B.CURRENCY_RT
	        INTO V_FDEF,V_CURRT
	        FROM GIAC_PARENT_COMM_INVOICE A,
	             GIPI_INVOICE B
	       WHERE A.ISS_CD=P_ISS_CD
	         AND A.ISS_CD=B.ISS_CD
	         AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
	         AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
	         AND A.INTM_NO=P_INTM_NO
	         AND A.CHLD_INTM_NO=P_CHLD_INTM_NO;
			 
	        GET_PERCENTAGE(p_iss_cd, p_prem_seq_no, p_var_prem_amt, p_var_percentage, p_var_premium_payts);
            p_var_percentage := NVL(p_var_percentage,1); --added by steven 11.20.2014
	        V_COMM := V_FDEF*P_VAR_PERCENTAGE;
	        V_COMM2 := V_COMM * V_CURRT;
	        P_COMM_AMT := V_COMM2;
	        P_VAR_COMM_AMT := V_COMM2;
	        P_VAR_COMM_AMT_DEF := V_COMM2;
	        P_PREV_COMM_AMT := V_COMM2;
	        P_VAR_FOR_CUR_AMT_DEF := V_FDEF;	
	  END IF;
  END get_default_val_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_PARENT_CHILD_PROCEDURE
  **  			     Gets the names of the parent and the child.
  */
  PROCEDURE get_parent_child_procedure(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  									   p_prem_seq_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  									   p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  									   p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_intermediary_name IN OUT GIIS_INTERMEDIARY.intm_name%TYPE,
									   p_child_intm_name   IN OUT GIIS_INTERMEDIARY.intm_name%TYPE)
  IS
  BEGIN
	  DECLARE
	    C_NAME        GIIS_INTERMEDIARY.intm_name%TYPE;
	    P_NAME        GIIS_INTERMEDIARY.intm_name%TYPE;
	  BEGIN
	    SELECT B.INTM_NAME,C.INTM_NAME PARENT
	       INTO C_NAME,P_NAME
	       FROM GIAC_PARENT_COMM_INVOICE A,
	            GIIS_INTERMEDIARY B,
	            GIIS_INTERMEDIARY C
	      WHERE A.INTM_NO = P_INTM_NO
	        AND A.CHLD_INTM_NO = P_CHLD_INTM_NO
	        AND A.INTM_NO = C.INTM_NO
	        AND A.CHLD_INTM_NO = B.INTM_NO
	        AND A.ISS_CD = P_ISS_CD
	        AND A.PREM_SEQ_NO = P_PREM_SEQ_NO;
	  P_INTERMEDIARY_NAME := P_NAME;
	  P_CHILD_INTM_NAME := C_NAME;
	  END;
  END get_parent_child_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_ASSD_POLICY_PROCEDURE
  **  			     Gets the the assd_name and the policy_id for each tran_type.
  */
  PROCEDURE get_assd_policy_procedure(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  									  p_prem_seq_no	   	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  									  p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  									  p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									  p_policy_no  		   IN OUT VARCHAR2,
									  p_assd_name     	   IN OUT GIIS_ASSURED.assd_name%TYPE)
  IS
  BEGIN
	  DECLARE
	   AS_NAME       GIIS_ASSURED.assd_name%TYPE;
	   POL_NO        VARCHAR2(100);
	  BEGIN
	    SELECT E.ASSD_NAME,
	       DECODE(A.ENDT_SEQ_NO,0,(A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||TO_CHAR(A.ISSUE_YY)||
	           '-'||LTRIM(TO_CHAR(A.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO,'09'))||'-'||
	           A.ENDT_ISS_CD||'-'||TO_CHAR(A.ENDT_YY)||'-'||TO_CHAR(A.ENDT_SEQ_NO)||'-'||A.ENDT_TYPE),
	           (A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||TO_CHAR(A.ISSUE_YY)||
	           '-'||LTRIM(TO_CHAR(A.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO,'09')))) POLICY_NO
	      INTO AS_NAME,POL_NO
	      FROM GIPI_POLBASIC A,
	           GIPI_INVOICE B,
	           GIPI_PARLIST C,
	           GIAC_PARENT_COMM_INVOICE D,
	           GIIS_ASSURED E
	     WHERE E.ASSD_NO = C.ASSD_NO
	       AND C.PAR_ID = A.PAR_ID
	       AND A.POLICY_ID = B.POLICY_ID
	       AND B.ISS_CD = D.ISS_CD
	       AND B.PREM_SEQ_NO = D.PREM_SEQ_NO
	       AND D.INTM_NO = P_INTM_NO
	       AND D.CHLD_INTM_NO = P_CHLD_INTM_NO
	       AND D.PREM_SEQ_NO = P_PREM_SEQ_NO
	       AND D.ISS_CD = P_ISS_CD;
	      P_POLICY_NO := POL_NO;
	      P_ASSD_NAME := AS_NAME;
	  END;
  END get_assd_policy_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_INPUT_VAT_AMT
  */
  PROCEDURE get_input_vat_amt(p_intm_no				IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  							  p_comm_amt			IN	   GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
							  p_input_vat			IN OUT GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE)
  IS
	  rate                 number;
  BEGIN
	  FOR A IN ( SELECT input_vat_rate
	               FROM giis_intermediary
	              WHERE intm_no = p_intm_no)
	  LOOP
	  	rate := a.input_vat_rate/100;
	    p_input_vat := p_comm_amt * rate;
	  END LOOP;
  END get_input_vat_amt;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_WTAX_AMT_PROCEDURE
  **  			     Gets the value for the wtax_amt.
  */
  PROCEDURE GET_WTAX_AMT_PROCEDURE(p_iss_cd	  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   IN	  GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt		   IN	  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_var_wtax_amt	   IN	  GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE,
								   p_wtax_amt		   IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE)
  IS
  BEGIN
	  DECLARE
	   WTAX_AMT    GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE;
	  BEGIN
		  SELECT ROUND(((((P_COMM_AMT/c.currency_rt)/B.COMMISSION_AMT)*B.WHOLDING_TAX)*C.CURRENCY_RT),4)
		    INTO WTAX_AMT
		    FROM GIAC_PARENT_COMM_INVOICE B,
		         GIPI_INVOICE C
		   WHERE B.PREM_SEQ_NO = C.PREM_SEQ_NO
		     AND B.ISS_CD = C.ISS_CD
		     AND B.INTM_NO = P_INTM_NO
		     AND B.CHLD_INTM_NO = P_CHLD_INTM_NO
		     AND B.ISS_CD = P_ISS_CD
		     AND B.PREM_SEQ_NO = P_PREM_SEQ_NO;
			
		    P_WTAX_AMT := WTAX_AMT;
	  EXCEPTION
		  WHEN NO_DATA_FOUND THEN
		       P_WTAX_AMT := P_VAR_WTAX_AMT;
	  END;
  END;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_FOREIGN_CURR_AMT
  **  			     Gets the value for the foreign currency amount.
  */
  PROCEDURE get_foreign_curr_amt(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								 p_prem_seq_no	   	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								 p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								 p_chld_intm_no	   	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								 p_comm_amt				  IN	 GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								 p_foreign_curr_amt	   	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_prev_for_curr_amt   	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_var_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								 p_var_for_cur_amt_def	  IN OUT NUMBER)
  IS
  BEGIN
	 DECLARE 
	  V_COMM_AMT   			GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE; 
	  V_CURRENCY_RATE   	GIPI_INVOICE.currency_rt%TYPE; --april
	  BEGIN
	    SELECT COMMISSION_AMT,B.CURRENCY_RT
	     INTO V_COMM_AMT,V_CURRENCY_RATE
	     FROM GIAC_PARENT_COMM_INVOICE A,GIPI_INVOICE B
	    WHERE A.ISS_CD = B.ISS_CD
	    	AND A.PREM_SEQ_NO = B.PREM_SEQ_NO
	    	AND A.ISS_CD = P_ISS_CD
	      AND A.PREM_SEQ_NO = P_PREM_SEQ_NO
	      AND A.INTM_NO = P_INTM_NO
	      AND A.CHLD_INTM_NO = P_CHLD_INTM_NO;
	      
	  IF P_FOREIGN_CURR_AMT IS NULL THEN
	     P_FOREIGN_CURR_AMT := V_COMM_AMT;
	     p_var_FOREIGN_CURR_AMT := V_COMM_AMT;
	     p_var_FOR_CUR_AMT_DEF := V_COMM_AMT;
	  ELSE 
	     P_FOREIGN_CURR_AMT := ROUND(P_COMM_AMT/V_CURRENCY_RATE,4);
	     p_var_FOREIGN_CURR_AMT := ROUND(P_COMM_AMT/V_CURRENCY_RATE,4);
	     P_PREV_FOR_CURR_AMT := ROUND(P_COMM_AMT/V_CURRENCY_RATE,4);
	  END IF;
	END;
  END get_foreign_curr_amt;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_COM_AMT3_PROCEDURE
  **  			     Gets the default value of the comm_amt when tran_type is = 2.
  */
  PROCEDURE get_com_amt3_procedure(p_gacc_tran_id  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
                                   p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_message			     OUT VARCHAR2,
                                   p_deleted_bills        IN     VARCHAR2)
  IS
	    A_COMM        GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	    AB_DIF        GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	    AB_AMT	  	  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	    CU_RT         GIPI_INVOICE.currency_rt%TYPE;
  BEGIN
  	  p_message := 'SUCCESS';
	  
	  BEGIN
	   SELECT SUM(A.COMM_AMT),NVL(C.CURRENCY_RT,0)
	     INTO A_COMM,CU_RT
	     FROM GIAC_OVRIDE_COMM_PAYTS A,
	          GIAC_PARENT_COMM_INVOICE B,
	          GIPI_INVOICE C,
              GIAC_ACCTRANS D
	    WHERE A.TRANSACTION_TYPE IN(1,2)
	      AND A.INTM_NO=P_INTM_NO
	      AND A.INTM_NO=B.INTM_NO
	      AND A.CHLD_INTM_NO=B.CHLD_INTM_NO
	      AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
	      AND A.ISS_CD=B.ISS_CD
	      AND A.ISS_CD=P_ISS_CD
	      AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
	      AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
	      AND B.ISS_CD=C.ISS_CD
	      AND B.PREM_SEQ_NO=C.PREM_SEQ_NO
          AND a.GACC_TRAN_ID = d.TRAN_ID
          AND A.GACC_TRAN_ID = P_GACC_TRAN_ID
          AND D.TRAN_FLAG!='D'
          AND ((p_deleted_bills IS NOT NULL
                         AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||a.comm_amt||'#') = 0))
                 OR p_deleted_bills IS NULL)
          AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                    FROM GIAC_REVERSALS X,
                                                         GIAC_ACCTRANS Y
                                                   WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                     AND Y.TRAN_FLAG !='D')  
	    GROUP BY C.CURRENCY_RT;                        
	  END;
	   
	 IF A_COMM = 0 THEN 
        IF p_deleted_bills IS NOT NULL THEN -- added to exclude deleted but not yet saved bills : shan 03.10.2015
            SELECT SUM(comm_amt), NVL(a.convert_rt, 0)              
	          INTO A_COMM,CU_RT
              FROM GIAC_OVRIDE_COMM_PAYTS a,
                   GIAC_ACCTRANS B
             WHERE A.TRANSACTION_TYPE =1
              AND A.GACC_TRAN_ID=B.TRAN_ID
              AND B.TRAN_FLAG!='D'
              AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                          FROM GIAC_REVERSALS X,
                                               GIAC_ACCTRANS Y
                                         WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                           AND Y.TRAN_FLAG !='D')
               AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||a.comm_amt||'#') != 0)
             GROUP BY a.convert_rt;             
             
           AB_DIF:=A_COMM*(-1);
           AB_AMT:=ROUND(AB_DIF*CU_RT,4);
           P_COMM_AMT:=AB_AMT;
           P_VAR_COMM_AMT:=AB_AMT;
           P_VAR_COMM_AMT_DEF:=AB_AMT;
           P_VAR_FOR_CUR_AMT_DEF:=ROUND(AB_AMT/CU_RT,4);
           P_FOREIGN_CURR_AMT:=ROUND(AB_AMT/CU_RT,4);
           P_PREV_COMM_AMT:=AB_AMT;
           P_PREV_FOR_CURR_AMT:=ROUND(AB_AMT/CU_RT,4);
        ELSE        
	        p_message := 'There is No Refundable amount for this Bill.';
        END IF;
	 ELSE
	   AB_DIF:=A_COMM*(-1);
	   AB_AMT:=ROUND(AB_DIF*CU_RT,4);
	   P_COMM_AMT:=AB_AMT;
	   P_VAR_COMM_AMT:=AB_AMT;
	   P_VAR_COMM_AMT_DEF:=AB_AMT;
	   P_VAR_FOR_CUR_AMT_DEF:=ROUND(AB_AMT/CU_RT,4);
	   P_FOREIGN_CURR_AMT:=ROUND(AB_AMT/CU_RT,4);
	   P_PREV_COMM_AMT:=AB_AMT;
	   P_PREV_FOR_CURR_AMT:=ROUND(AB_AMT/CU_RT,4);
	 END IF;
  END get_com_amt3_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_COM_AMT6_PROCEDURE
  **  			     Gets the default value of the comm_amt when tran_type is = 4.
  */
  PROCEDURE get_com_amt6_procedure(p_gacc_tran_id  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
  								   p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_message			     OUT VARCHAR2,
                                   p_deleted_bills        IN     VARCHAR2)
  IS
	   C_COMM        GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	   CD_AMT		 GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	   CUR_RT        GIPI_INVOICE.currency_rt%TYPE;
  BEGIN
     p_message := 'SUCCESS';
     
	  BEGIN
	    SELECT ABS(SUM(A.COMM_AMT)),NVL(C.CURRENCY_RT,0)
	      INTO C_COMM,CUR_RT
	      FROM GIAC_OVRIDE_COMM_PAYTS A,
	           GIAC_PARENT_COMM_INVOICE B,
	           GIPI_INVOICE C,
               GIAC_ACCTRANS D
	     WHERE A.TRANSACTION_TYPE IN(3,4)
	       AND A.INTM_NO=P_INTM_NO
	       AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
	       AND A.CHLD_INTM_NO=B.CHLD_INTM_NO
	       AND A.INTM_NO=B.INTM_NO
	       AND A.ISS_CD=B.ISS_CD
	       AND A.ISS_CD=P_ISS_CD
	       AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
	       AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
	       AND B.ISS_CD=C.ISS_CD
	       AND B.PREM_SEQ_NO=C.PREM_SEQ_NO
           AND A.GACC_TRAN_ID = p_gacc_tran_id
           AND A.GACC_TRAN_ID=D.TRAN_ID
           AND D.TRAN_FLAG!='D'
           AND ((p_deleted_bills IS NOT NULL -- include newly deleted bills
                         AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||a.comm_amt||'#') = 0))
                 OR p_deleted_bills IS NULL)
           AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                       FROM GIAC_REVERSALS X,
                                            GIAC_ACCTRANS Y
                                      WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                        AND Y.TRAN_FLAG !='D')    
         GROUP BY C.CURRENCY_RT  -- added by shan 11.25.2014
	     ORDER BY C.CURRENCY_RT;                        
	  END;
      
      IF c_comm = 0 THEN
            IF p_deleted_bills IS NOT NULL THEN -- added to exclude deleted but not yet saved bills : shan 03.10.2015
                SELECT SUM(comm_amt), NVL(a.convert_rt, 0)              
                  INTO C_COMM,CUR_RT
                  FROM GIAC_OVRIDE_COMM_PAYTS a,
                       GIAC_ACCTRANS B
                 WHERE A.TRANSACTION_TYPE = 3
                  AND A.GACC_TRAN_ID=B.TRAN_ID
                  AND B.TRAN_FLAG!='D'
                  AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                              FROM GIAC_REVERSALS X,
                                                   GIAC_ACCTRANS Y
                                             WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                               AND Y.TRAN_FLAG !='D')
                   AND (INSTR(p_deleted_bills, '#'||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'-'||a.comm_amt||'#') != 0)
                 GROUP BY a.convert_rt; 
                 
                 CD_AMT:=ROUND(C_COMM*CUR_RT,4);
                 P_COMM_AMT:=CD_AMT;
                 P_VAR_COMM_AMT:=CD_AMT;       
                 P_VAR_COMM_AMT_DEF:=CD_AMT;
                 P_VAR_FOR_CUR_AMT_DEF:=ROUND(CD_AMT/CUR_RT,4);
                 P_FOREIGN_CURR_AMT:=ROUND(CD_AMT/CUR_RT,4);
                 P_PREV_COMM_AMT:=CD_AMT;
                 P_PREV_FOR_CURR_AMT:=ROUND(CD_AMT/CUR_RT,4);
            ELSE
             p_message := 'There is No Refundable amount for this Bill.';
             RETURN;
            END IF; 
      ELSE
         CD_AMT:=ROUND(C_COMM*CUR_RT,4);
	     P_COMM_AMT:=CD_AMT;
	     P_VAR_COMM_AMT:=CD_AMT;       
	     P_VAR_COMM_AMT_DEF:=CD_AMT;
	     P_VAR_FOR_CUR_AMT_DEF:=ROUND(CD_AMT/CUR_RT,4);
	     P_FOREIGN_CURR_AMT:=ROUND(CD_AMT/CUR_RT,4);
	     P_PREV_COMM_AMT:=CD_AMT;
	     P_PREV_FOR_CURR_AMT:=ROUND(CD_AMT/CUR_RT,4);
      END IF;
  END get_com_amt6_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_COM_AMT1_PROCEDURE
  **  			     Gets the default value of the comm_amt when tran_type is = 1.
  */
  PROCEDURE get_com_amt1_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_var_prem_amt		  IN     NUMBER,
		  						   p_var_percentage	 	  IN OUT NUMBER,
								   p_var_premium_payts	  IN OUT NUMBER,
                                   p_deleted_bills        IN     VARCHAR2)
  IS
	      NEW_COMM      GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	      DEF_FOREIGN   GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
	      CUR_RT        GIPI_INVOICE.currency_rt%TYPE;
	      VAR_COMM_AMT  GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	      COMP_COMM     GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	      COMP_COMM2    GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
  BEGIN
	  SELECT C.CURRENCY_RT,NVL(B.COMMISSION_AMT * C.CURRENCY_RT,0),SUM(A.COMM_AMT)
	    INTO CUR_RT,NEW_COMM,VAR_COMM_AMT
	    FROM GIAC_OVRIDE_COMM_PAYTS A,
	         GIAC_PARENT_COMM_INVOICE B,
	         GIPI_INVOICE C,
             GIAC_ACCTRANS D
	   WHERE A.TRANSACTION_TYPE IN(1,2)
	     AND A.INTM_NO=P_INTM_NO
	     AND A.INTM_NO=B.INTM_NO
	     AND A.CHLD_INTM_NO=B.CHLD_INTM_NO
	     AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
	     AND A.ISS_CD=B.ISS_CD
	     AND A.ISS_CD=P_ISS_CD
	     AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
	     AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
	     AND B.ISS_CD=C.ISS_CD
	     AND B.PREM_SEQ_NO=C.PREM_SEQ_NO
         AND A.GACC_TRAN_ID=D.TRAN_ID
         AND D.TRAN_FLAG!='D'
         AND ((p_deleted_bills IS NOT NULL
                    AND (INSTR(p_deleted_bills, '#'||a.gacc_tran_id || '-' ||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'#') = 0))
               OR p_deleted_bills IS NULL)
         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                     FROM GIAC_REVERSALS X,
                                          GIAC_ACCTRANS Y
                                    WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                      AND Y.TRAN_FLAG !='D')
	   GROUP BY B.COMMISSION_AMT,C.CURRENCY_RT;
	     GET_PERCENTAGE(p_iss_cd, p_prem_seq_no, p_var_prem_amt, p_var_percentage, p_var_premium_payts);
         p_var_percentage := NVL(p_var_percentage,1); --added by steven 11.20.2014
	     COMP_COMM := NEW_COMM * P_VAR_PERCENTAGE;
	     COMP_COMM2 := COMP_COMM - VAR_COMM_AMT;
	     DEF_FOREIGN:=ROUND(COMP_COMM2/CUR_RT,4);
	     P_VAR_COMM_AMT:=COMP_COMM2;
	     P_VAR_COMM_AMT_DEF:=COMP_COMM2;
	     p_COMM_AMT:=COMP_COMM2;
	     P_VAR_FOR_CUR_AMT_DEF:=DEF_FOREIGN;
	     p_FOREIGN_CURR_AMT:=DEF_FOREIGN;
	     p_PREV_COMM_AMT:=COMP_COMM2;
	     p_PREV_FOR_CURR_AMT:=DEF_FOREIGN;
  END get_com_amt1_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_COM_AMT4_PROCEDURE
  **  			     Gets the default value of the comm_amt when tran_type is = 3.
  */
  PROCEDURE get_com_amt4_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
								   p_comm_amt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_foreign_curr_amt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_prev_comm_amt		  IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
								   p_prev_for_curr_amt    IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
								   p_var_comm_amt		  IN OUT NUMBER,
								   p_var_comm_amt_def	  IN OUT NUMBER,
								   p_var_for_cur_amt_def  IN OUT NUMBER,
								   p_var_prem_amt		  IN     NUMBER,
		  						   p_var_percentage	 	  IN OUT NUMBER,
								   p_var_premium_payts	  IN OUT NUMBER,
                                   p_deleted_bills        IN     VARCHAR2)
  IS	
	    NEW_COM                GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	    DEF_FOR                GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
	    V_DEFAULT              GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE;
	    CURR_RT                GIPI_INVOICE.currency_rt%TYPE;
	    VAR_COMMISSION_AMT     GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	    VAR_COMP_COMM          GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	    VAR_COMP_COMM2         GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;     
  BEGIN
	     SELECT C.CURRENCY_RT,SUM(A.COMM_AMT),NVL(B.COMMISSION_AMT * C.CURRENCY_RT,0)
	       INTO CURR_RT,NEW_COM,VAR_COMMISSION_AMT
	       FROM GIAC_OVRIDE_COMM_PAYTS A,
	            GIAC_PARENT_COMM_INVOICE B,
	            GIPI_INVOICE C,
                GIAC_ACCTRANS D
	      WHERE A.TRANSACTION_TYPE IN(3,4)
	        AND A.INTM_NO=P_INTM_NO
	        AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
	        AND A.CHLD_INTM_NO=B.CHLD_INTM_NO
	        AND A.INTM_NO=B.INTM_NO
	        AND A.ISS_CD=B.ISS_CD
	        AND A.ISS_CD=P_ISS_CD
	        AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
	        AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
	        AND B.ISS_CD=C.ISS_CD
	        AND B.PREM_SEQ_NO=C.PREM_SEQ_NO
            AND A.GACC_TRAN_ID=D.TRAN_ID
            AND D.TRAN_FLAG!='D'
            AND ((p_deleted_bills IS NOT NULL
                     AND (INSTR(p_deleted_bills, '#'||a.gacc_tran_id || '-' ||a.iss_cd ||'-'||a.prem_seq_no||'-'||a.intm_no||'-'||a.chld_intm_no||'#') = 0))
                  OR p_deleted_bills IS NULL)
            AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                        FROM GIAC_REVERSALS X,
                                             GIAC_ACCTRANS Y
                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                         AND Y.TRAN_FLAG !='D')
          GROUP BY B.COMMISSION_AMT, C.CURRENCY_RT;     -- added group by : shan 11.25.2014            
	     GET_PERCENTAGE(p_iss_cd, p_prem_seq_no, p_var_prem_amt, p_var_percentage, p_var_premium_payts);
	     VAR_COMP_COMM := VAR_COMMISSION_AMT * NVL(P_VAR_PERCENTAGE, 1);
	     VAR_COMP_COMM2 := ABS(VAR_COMP_COMM - NEW_COM); 
	     V_DEFAULT:=ROUND((VAR_COMP_COMM2*(-1))/CURR_RT,4);
	     P_COMM_AMT:=(VAR_COMP_COMM2*(-1));
	     P_VAR_COMM_AMT:=(VAR_COMP_COMM2*(-1)); 
	     P_VAR_COMM_AMT_DEF:=(VAR_COMP_COMM2*(-1));
	     P_VAR_FOR_CUR_AMT_DEF:=V_DEFAULT;
	     P_FOREIGN_CURR_AMT:=V_DEFAULT;
	     P_PREV_COMM_AMT:=(VAR_COMP_COMM2*(-1));
	     P_PREV_FOR_CURR_AMT:=V_DEFAULT;
  END get_com_amt4_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_VAL_CURRENCY_PROCEDURE
  **  			     Gets the value for the currency_cd,currency_rt 
  */
  PROCEDURE get_val_currency_procedure(p_iss_cd	  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
	  								   p_prem_seq_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
	  								   p_intm_no  	  	   	  IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
	  								   p_chld_intm_no	   	  IN	 GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_convert_rt			  IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_currency_cd		  IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_currency_desc		  IN OUT GIIS_CURRENCY.currency_desc%TYPE,
									   p_var_currency_rt	  IN OUT GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_var_currency_cd	  IN OUT GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_var_currency_desc	  IN OUT GIIS_CURRENCY.currency_desc%TYPE)
  IS
  BEGIN
	  DECLARE
		C_RT   GIPI_INVOICE.currency_rt%TYPE;
		C_CD   GIPI_INVOICE.currency_cd%TYPE;
		C_DESC GIIS_CURRENCY.currency_desc%TYPE;
	  BEGIN
		SELECT a.currency_cd,TO_CHAR(a.currency_rt,'9,999,999,999.00'),c.currency_desc
		  INTO C_CD,C_RT,C_DESC
		  FROM GIPI_INVOICE A,
		       GIAC_PARENT_COMM_INVOICE B,
		       GIIS_CURRENCY C
		 WHERE A.ISS_CD=B.ISS_CD
		   AND A.PREM_SEQ_NO=B.PREM_SEQ_NO
		   AND B.INTM_NO=P_INTM_NO
		   AND B.CHLD_INTM_NO=P_CHLD_INTM_NO
		   AND A.ISS_CD=P_ISS_CD
		   AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
		   AND A.CURRENCY_CD=C.MAIN_CURRENCY_CD;
		
		P_VAR_CURRENCY_RT:=C_RT;
		P_VAR_CURRENCY_CD:=C_CD;
		P_VAR_CURRENCY_DESC:=C_DESC; 
		P_CONVERT_RT:=C_RT;
		P_CURRENCY_CD:=C_CD;
		P_CURRENCY_DESC:=C_DESC;
	  END;
  END get_val_currency_procedure;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.14.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the procedure GET_VAL_CURRENCY_PROCEDURE
  **  			     Gets the value for the currency_cd,currency_rt 
  */
  PROCEDURE validate_giacs040_child_intm(p_transaction_type				IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
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
										 p_message						   OUT VARCHAR2,
                                         p_deleted_bills        IN     VARCHAR2)
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
                                                   p_var_premium_payts, p_deleted_bills);
                            GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
                            GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
                            GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
                            GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
                            GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
                          END IF;  

                          IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
                             IF P_COMM_AMT = 0 THEN
                                 p_message := 'COMMISSION_FULLY_PAID';
                                 P_VAR_SWITCH := 1;
                             end if;
                          ELSE 
                             IF P_COMM_AMT = 0 THEN
                                p_message := 'CANNOT_RELEASE_COMMISSION';
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
			                                         AND Y.TRAN_FLAG !='D')
                             AND rownum = 1)LOOP
			        IF TU.TRANSACTION_TYPE IS NOT NULL THEN
			
			              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT3_PROCEDURE(null, p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt,
											     p_foreign_curr_amt, p_prev_comm_amt, p_prev_for_curr_amt, p_var_comm_amt,
											   	 p_var_comm_amt_def, p_var_for_cur_amt_def, p_message, p_deleted_bills);
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
												   p_var_premium_payts, p_deleted_bills);
			               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_PARENT_CHILD_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_intermediary_name, p_child_intm_name);
			               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_ASSD_POLICY_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_policy_no, p_assd_name);
			               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_INPUT_VAT_AMT(p_intm_no, p_comm_amt, p_input_vat);
			               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
			               GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
			             END IF;
			          IF P_VAR_PREMIUM_PAYTS =  P_VAR_PREM_AMT THEN
			             IF P_COMM_AMT = 0 THEN
			                 p_message := 'COMMISSION_FULLY_PAID';
			                 P_VAR_SWITCH := 1;
			             end if;
			          ELSE 
			             IF P_COMM_AMT = 0 THEN
			                p_message := 'CANNOT_RELEASE_COMMISSION';
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
			
			              GIAC_OVRIDE_COMM_PAYTS_PKG.GET_COM_AMT6_PROCEDURE(null, p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt,
											     p_foreign_curr_amt, p_prev_comm_amt, p_prev_for_curr_amt, p_var_comm_amt,
											   	 p_var_comm_amt_def, p_var_for_cur_amt_def, p_message, p_deleted_bills);
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
		END;
	END validate_giacs040_child_intm;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.15.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Executes the WHEN-VALIDATE-ITEM trigger of COMM_AMT item in GOCP block
  **  			     Gets the value for the currency_cd,currency_rt 
  */
  PROCEDURE validate_giacs040_comm_amt(p_transaction_type				IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
			  							 p_iss_cd						IN 	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
										 p_prem_seq_no					IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
										 p_intm_no						IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
										 p_chld_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
			  							 p_comm_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_prev_comm_amt				IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
										 p_wtax_amt						IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_foreign_curr_amt	   	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_prev_for_curr_amt   	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_foreign_curr_amt	  		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
										 p_var_for_cur_amt_def	  		IN OUT NUMBER,
										 p_var_wtax_amt					IN 	   GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
										 p_var_comm_amt_def				IN	   GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE,
                                         p_add_update_btn               IN     VARCHAR2,
                                         p_current_bill                 IN      VARCHAR2,
										 p_message						   OUT VARCHAR2)
	IS
        v_outstanding_bal       GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE;
	BEGIN
		BEGIN	
            BEGIN
                SELECT ovriding_comm_amt 
                  INTO v_outstanding_bal
                  FROM TABLE(GIAC_OVRIDE_COMM_PAYTS_PKG.get_bill_no_by_tran_type(p_transaction_type, p_iss_cd, p_prem_seq_no, null, p_current_bill));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_outstanding_bal := 0;
            END;
            
          /*IF P_TRANSACTION_TYPE IN(1,3) AND UPPER(p_add_update_btn) = 'UPDATE' THEN
            FOR i IN (SELECT '1'
                        FROM GIAC_OVRIDE_COMM_PAYTS a,
                             GIAC_ACCTRANS B
                       WHERE A.transaction_type = DECODE(p_transaction_type, 1, 2, 4)
                         AND A.iss_cd = NVL(p_iss_cd, A.iss_cd)
                         AND A.prem_seq_no = NVL(p_prem_seq_no, A.prem_seq_no)
                         AND A.GACC_TRAN_ID=B.TRAN_ID
                         AND B.TRAN_FLAG!='D'
                         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                    FROM GIAC_REVERSALS X,
                                                         GIAC_ACCTRANS Y
                                                   WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                     AND Y.TRAN_FLAG !='D'))
            LOOP
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You cannot update this record, there is an existing refund for this Bill No.');
            END LOOP;
          END IF;*/
          
		  IF P_TRANSACTION_TYPE IN(2,3) THEN
		     IF P_COMM_AMT >=0 THEN
		        P_COMM_AMT:=P_PREV_COMM_AMT;
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        p_message := 'Only negative values are allowed for this transaction type';
				RETURN;	     
		     ELSIF P_COMM_AMT <p_var_COMM_AMT_DEF THEN
		        P_COMM_AMT:=P_PREV_COMM_AMT;
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		       IF P_TRAnsACTION_TYPE = 2 THEN
		          p_message := 'Cannot Refund More than '||to_char(p_var_comm_amt_def);
				  RETURN;
		       ELSIF P_TRANSACTION_TYPE = 3 THEN
		          p_message := 'Amount to be entered must not exceed '||to_char(p_var_comm_amt_def);
				  RETURN;
		       END IF;
             ELSIF ABS(P_COMM_AMT) > ABS(v_outstanding_bal) THEN
                p_message := 'Amount entered should not be greater than the outstanding balance.';
				RETURN;
		     ELSE 
		        P_PREV_COMM_AMT:=P_COMM_AMT;
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		     END IF;
		  END IF;
		
		  IF P_TRANSACTION_TYPE IN(1,4) THEN
		     IF P_COMM_AMT <= 0 THEN
		        P_COMM_AMT:=P_PREV_COMM_AMT;
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		        p_message := 'Amount entered is invalid';
				RETURN;
		
		     ELSIF P_COMM_AMT > p_var_COMM_AMT_DEF THEN
		        P_COMM_AMT:=P_PREV_COMM_AMT;
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		        GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);
		
		       IF P_TRANSACTION_TYPE = 1 THEN
		          p_message := 'Amount to be entered must not exceed '||to_char(p_var_comm_amt_def);
				  RETURN;
		       ELSIF P_TRANSACTION_TYPE = 4 THEN
		          p_message := 'Cannot Refund More than '||to_char(p_var_comm_amt_def);
				  RETURN;
		       END IF;
               
             ELSIF ABS(P_COMM_AMT) > ABS(v_outstanding_bal) THEN
                p_message := 'Amount entered should not be greater than the outstanding balance.';
				RETURN;		
		     ELSE
		         P_PREV_COMM_AMT:=P_COMM_AMT;
		         GIAC_OVRIDE_COMM_PAYTS_PKG.GET_WTAX_AMT_PROCEDURE(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_var_wtax_amt, p_wtax_amt);
		         GIAC_OVRIDE_COMM_PAYTS_PKG.GET_FOREIGN_CURR_AMT(p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no, p_comm_amt, p_foreign_curr_amt, p_prev_for_curr_amt, p_var_foreign_curr_amt, p_var_for_cur_amt_def);    
		     END IF;
		  END IF;
		  
		END;
	END validate_giacs040_comm_amt;
	
	PROCEDURE validate_giacs040_foreign_curr(p_transaction_type			IN     GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
			  								 p_iss_cd					IN	   GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
			  								 p_prem_seq_no				IN	   GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
											 p_intm_no					IN	   GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
											 p_chld_intm_no				IN	   GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
											 p_comm_amt					IN OUT GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
											 p_wtax_amt					IN OUT GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
											 p_drv_comm_amt				IN OUT NUMBER,
											 p_foreign_curr_amt			IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
											 p_prev_for_curr_amt		IN OUT GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
											 p_var_for_cur_amt_def		IN 	   GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE,
											 p_var_currency_rt			IN	   GIPI_INVOICE.currency_rt%TYPE,
											 p_message					   OUT VARCHAR2)
	IS 
	      F_CU_AMT           GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	      V_AMT              GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	      WH_TAX             GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE;
	      TAX_CO             GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE;
		  VAR_V_AMT			 GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
		  VAR_TAX_CO		 GIAC_PARENT_COMM_INVOICE.wholding_tax%TYPE;
		  VAR_NET			 GIAC_PARENT_COMM_INVOICE.commission_amt%TYPE;
	BEGIN
		p_message := 'SUCCESS';
		
		SELECT COMMISSION_AMT,WHOLDING_TAX
		    INTO F_CU_AMT,WH_TAX
		    FROM GIAC_PARENT_COMM_INVOICE
		   WHERE ISS_CD=P_ISS_CD
		     AND PREM_SEQ_NO=P_PREM_SEQ_NO
		     AND INTM_NO=P_INTM_NO
		     AND CHLD_INTM_NO=P_CHLD_INTM_NO;
			 
		IF P_TRANSACTION_TYPE IN(1,4) THEN
		  IF P_VAR_FOR_CUR_AMT_DEF<P_FOREIGN_CURR_AMT THEN
		        P_FOREIGN_CURR_AMT:=P_PREV_FOR_CURR_AMT;
		       p_message := 'Amount entered is invalid';
			   RETURN;
		  ELSIF P_FOREIGN_CURR_AMT <= 0 THEN
		        P_FOREIGN_CURR_AMT:=P_PREV_FOR_CURR_AMT;
		  ELSE
		     V_AMT:=ROUND(P_FOREIGN_CURR_AMT*P_VAR_CURRENCY_RT,4);
		     TAX_CO:=ROUND(((((V_AMT/P_VAR_currency_rt)/F_CU_AMT)*WH_TAX)*P_VAR_CURRENCY_RT),2);
		     VAR_V_AMT:=V_AMT;
		     VAR_TAX_CO:=TAX_CO;
		     VAR_NET:=V_AMT-TAX_CO;
		  END IF;
		END IF;
		
		IF P_TRANSACTION_TYPE IN(2,3) THEN
		   IF P_FOREIGN_CURR_AMT > 0 THEN
		    p_message := 'AMOUNT_NOT_NEGATIVE';
			RETURN;
		    P_Foreign_Curr_Amt:=P_PREV_FOR_CURR_AMT;	   
		   ELSIF P_VAR_FOR_CUR_AMT_DEF>P_FOREIGN_CURR_AMT THEN
		      P_FOREIGN_CURR_AMT:=P_PREV_FOR_CURR_AMT;
		      p_message := 'Amount entered is invalid';
			  RETURN;      
		   ELSE
		      V_AMT:=ROUND(P_FOREIGN_CURR_AMT*P_VAR_CURRENCY_RT,4);
		      TAX_CO:=ROUND(((((V_AMT/P_VAR_currency_rt)/F_CU_AMT)*WH_TAX)*P_VAR_CURRENCY_RT),2);
		      VAR_V_AMT:=V_AMT;
		      VAR_TAX_CO:=TAX_CO;
		      VAR_NET:=V_AMT-TAX_CO;
		
		   END IF;
		END IF;
		
		IF P_FOREIGN_CURR_AMT != TRUNC(P_PREV_FOR_CURR_AMT,2) THEN
		 P_COMM_AMT:=VAR_V_AMT;
		 P_WTAX_AMT:=VAR_TAX_CO;
		 P_DRV_COMM_AMT:=VAR_NET;
		END IF;
	END validate_giacs040_foreign_curr;
	
	/*
    **  Created by   :  Emman
    **  Date Created :  10.18.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  :  Save (Insert/Update) GIAC Overriding Comm Payts record
    */ 
	PROCEDURE set_giac_ovride_comm_payts(p_gacc_tran_id					GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
  									   p_transaction_type				GIAC_OVRIDE_COMM_PAYTS.transaction_type%TYPE,
									   p_iss_cd							GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									   p_prem_seq_no					GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									   p_intm_no						GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									   p_chld_intm_no					GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
									   p_comm_amt						GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
									   p_wtax_amt						GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
									   p_currency_cd					GIAC_OVRIDE_COMM_PAYTS.currency_cd%TYPE,
									   p_convert_rt						GIAC_OVRIDE_COMM_PAYTS.convert_rt%TYPE,
									   p_foreign_curr_amt				GIAC_OVRIDE_COMM_PAYTS.foreign_curr_amt%TYPE,
									   p_input_vat						GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
									   p_particulars					GIAC_OVRIDE_COMM_PAYTS.particulars%TYPE,
									   p_user_id						GIAC_OVRIDE_COMM_PAYTS.user_id%TYPE,
									   p_last_update					GIAC_OVRIDE_COMM_PAYTS.last_update%TYPE)
    IS
	BEGIN
		 MERGE INTO GIAC_OVRIDE_COMM_PAYTS
		 USING DUAL ON (gacc_tran_id = p_gacc_tran_id
		 	   		AND iss_cd		 = p_iss_cd
					AND prem_seq_no	 = p_prem_seq_no
					AND intm_no		 = p_intm_no
					AND chld_intm_no = p_chld_intm_no)
		 WHEN NOT MATCHED THEN
		 	 INSERT (gacc_tran_id, transaction_type, iss_cd, prem_seq_no, intm_no, chld_intm_no,
			 		 comm_amt, wtax_amt, currency_cd, convert_rt, foreign_curr_amt, input_vat,
					 particulars, user_id, last_update)
			 VALUES (p_gacc_tran_id, p_transaction_type, p_iss_cd, p_prem_seq_no, p_intm_no, p_chld_intm_no,
			 		 p_comm_amt, p_wtax_amt, p_currency_cd, p_convert_rt, p_foreign_curr_amt, p_input_vat,
					 p_particulars, p_user_id, p_last_update)
		 WHEN MATCHED THEN
		 	 UPDATE SET transaction_type	   = p_transaction_type,
			 			comm_amt			   = p_comm_amt,
						wtax_amt			   = p_wtax_amt,
						currency_cd			   = p_currency_cd,
						convert_rt			   = p_convert_rt,
						foreign_curr_amt	   = p_foreign_curr_amt,
						input_vat			   = p_input_vat,
						particulars			   = p_particulars,
						user_id				   = p_user_id,
						last_update			   = p_last_update;
	END set_giac_ovride_comm_payts;
	
	/*
    **  Created by   :  Emman
    **  Date Created :  10.18.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  : Deletes GIAC Overriding Comm Payts record
    */ 
	PROCEDURE del_giac_ovride_comm_payts(p_gacc_tran_id					GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
  									     p_iss_cd							GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
									   	 p_prem_seq_no					GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
									   	 p_intm_no						GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
									   	 p_chld_intm_no					GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE)
    IS
	BEGIN
		 DELETE
		   FROM GIAC_OVRIDE_COMM_PAYTS
		  WHERE gacc_tran_id = p_gacc_tran_id
		    AND iss_cd		 = p_iss_cd
			AND prem_seq_no	 = p_prem_seq_no
			AND intm_no		 = p_intm_no
			AND chld_intm_no = p_chld_intm_no;
	END del_giac_ovride_comm_payts;
	
  	/*
    **  Created by   :  Emman
    **  Date Created :  10.19.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  :  Executes the procedure AEG_INSERT_UPDATE_ACCT_ENTRIES on GIACS040
	**				    Determines whether the records will be updated or inserted in GIAC_ACCT_ENTRIES.
    */ 
	PROCEDURE aeg_insert_update_acct_entries
	    (p_gacc_branch_cd       GIAC_ACCTRANS.gibr_branch_cd%TYPE,
	     p_gacc_fund_cd         GIAC_ACCTRANS.gfun_fund_cd%TYPE,
	     p_gacc_tran_id         GIAC_ACCTRANS.tran_id%TYPE,
		 iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
	     iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
	     iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
	     iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
	     iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
	     iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
	     iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
	     iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
	     iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
	     iuae_sl_type_cd	    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
	     iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%TYPE,
	     iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
	     iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
	     iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
	     iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
	     iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE)
	IS	      
	     iuae_acct_entry_id     GIAC_ACCT_ENTRIES.ACCT_ENTRY_ID%TYPE;	     
	BEGIN
	  SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
	    INTO iuae_acct_entry_id
	    FROM giac_acct_entries
	   WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
	     AND gl_sub_acct_2       = iuae_gl_sub_acct_2
	     AND gl_sub_acct_3       = iuae_gl_sub_acct_3
	     AND gl_sub_acct_4       = iuae_gl_sub_acct_4
	     AND gl_sub_acct_5       = iuae_gl_sub_acct_5
	     AND gl_sub_acct_6       = iuae_gl_sub_acct_6
	     AND gl_sub_acct_7       = iuae_gl_sub_acct_7
	     AND sl_type_cd          = iuae_sl_type_cd
	     AND sl_cd               = iuae_sl_cd
	     AND generation_type     = iuae_generation_type
	     AND gl_acct_id          = iuae_gl_acct_id
	     AND gacc_gibr_branch_cd = p_gacc_branch_cd
	     AND gacc_gfun_fund_cd   = p_gacc_fund_cd
	     AND gacc_tran_id        = p_gacc_tran_id;
	  IF NVL(iuae_acct_entry_id,0) = 0 THEN
	    iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
	    INSERT into GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
	                                  gacc_gibr_branch_cd, acct_entry_id    ,
	                                  gl_acct_id         , gl_acct_category ,
	                                  gl_control_acct    , gl_sub_acct_1    ,
	                                  gl_sub_acct_2      , gl_sub_acct_3    ,
	                                  gl_sub_acct_4      , gl_sub_acct_5    ,
	                                  gl_sub_acct_6      , gl_sub_acct_7    ,
	                                  sl_type_cd         , sl_source_cd     ,
	                                  sl_cd              , debit_amt        ,
	                                  credit_amt         , generation_type  ,
	                                  user_id            , last_update)
	       VALUES (p_gacc_tran_id  , p_gacc_fund_cd,
	               p_gacc_branch_cd, iuae_acct_entry_id          ,
	               iuae_gl_acct_id               , iuae_gl_acct_category       ,
	               iuae_gl_control_acct          , iuae_gl_sub_acct_1          ,
	               iuae_gl_sub_acct_2            , iuae_gl_sub_acct_3          ,
	               iuae_gl_sub_acct_4            , iuae_gl_sub_acct_5          ,
	               iuae_gl_sub_acct_6            , iuae_gl_sub_acct_7          ,
	               iuae_sl_type_cd               , '1'                         ,
	               iuae_sl_cd                    , iuae_debit_amt              ,
	               iuae_credit_amt               , iuae_generation_type        ,
	               USER             			 , SYSDATE);
	  ELSE
	    UPDATE giac_acct_entries
	       SET debit_amt  = debit_amt  + iuae_debit_amt,
	           credit_amt = credit_amt + iuae_credit_amt
	     WHERE gl_sub_acct_1       = iuae_gl_sub_acct_1
	       AND gl_sub_acct_2       = iuae_gl_sub_acct_2
	       AND gl_sub_acct_3       = iuae_gl_sub_acct_3
	       AND gl_sub_acct_4       = iuae_gl_sub_acct_4
	       AND gl_sub_acct_5       = iuae_gl_sub_acct_5
	       AND gl_sub_acct_6       = iuae_gl_sub_acct_6
	       AND gl_sub_acct_7       = iuae_gl_sub_acct_7
	       AND sl_type_cd          = iuae_sl_type_cd
	       AND sl_cd               = iuae_sl_cd
	       AND generation_type     = iuae_generation_type
	       AND gl_acct_id          = iuae_gl_acct_id
	       AND gacc_gibr_branch_cd = p_gacc_branch_cd
	       AND gacc_gfun_fund_cd   = p_gacc_fund_cd
	       AND gacc_tran_id        = p_gacc_tran_id;
	  END IF;
	END aeg_insert_update_acct_entries;
	
	/*
    **  Created by   :  Emman
    **  Date Created :  10.19.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  :  Executes the procedure COMM_PAYABLE_PROC on GIACS040
    */ 
	PROCEDURE giacs040_comm_payable_proc (p_gacc_branch_cd       IN GIAC_ACCTRANS.gibr_branch_cd%TYPE,
									      p_gacc_fund_cd         IN GIAC_ACCTRANS.gfun_fund_cd%TYPE,
									      p_gacc_tran_id         IN GIAC_ACCTRANS.tran_id%TYPE,
			  							  v_intm_no     		 IN GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
	                             		  v_comm_amt    		 IN GIAC_OVRIDE_COMM_PAYTS.comm_amt%TYPE,
	                             		  v_wtax_amt    		 IN GIAC_OVRIDE_COMM_PAYTS.wtax_amt%TYPE,
	                             		  v_input_vat   		 IN GIAC_OVRIDE_COMM_PAYTS.input_vat%TYPE,
				     					  v_line_cd     		 IN GIIS_LINE.line_cd%TYPE,
										  p_message	   			 OUT VARCHAR2)
	IS
	  v_gl_intm_no    GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE;
	BEGIN
	  p_message := 'SUCCESS';
	
	  DECLARE
	    v_param_value_n GIAC_PARAMETERS.param_value_n%TYPE := 0;
	    x_intm_no       GIIS_INTERMEDIARY.intm_no%TYPE;
	    v_sl_cd         GIAC_ACCT_ENTRIES.sl_cd%TYPE;
	
	    V_GL_ACCT_CATEGORY   GIAC_ACCT_ENTRIES.GL_ACCT_CATEGORY%TYPE; 
	    V_GL_CONTROL_ACCT    GIAC_ACCT_ENTRIES.GL_CONTROL_ACCT%TYPE;
	    v_gl_sub_acct_1  GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
	    v_gl_sub_acct_2  GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
	    v_gl_sub_acct_3  GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
	    v_gl_sub_acct_4  GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
	    v_gl_sub_acct_5  GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
	    v_gl_sub_acct_6  GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
	    v_gl_sub_acct_7  GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
	
	    v_intm_type_level  GIAC_MODULE_ENTRIES.INTM_TYPE_LEVEL%TYPE;
	    v_LINE_DEPENDENCY_LEVEL   GIAC_MODULE_ENTRIES.LINE_DEPENDENCY_LEVEL%TYPE;
	    v_dr_cr_tag         GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
	    v_debit_amt   GIAC_ACCT_ENTRIES.debit_amt%TYPE;
	    v_credit_amt  GIAC_ACCT_ENTRIES.credit_amt%TYPE;
	    v_acct_entry_id GIAC_ACCT_ENTRIES.acct_entry_id%TYPE;
	    v_gen_type      GIAC_MODULES.generation_type%TYPE;
	    v_gl_acct_id    GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE;
	    v_sl_type_cd    GIAC_MODULE_ENTRIES.sl_type_cd%TYPE;--07/31/99 JEANNETTE
	    ws_line_cd	    GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
	
	  BEGIN
	
	    SELECT param_value_n
	    INTO   v_param_value_n
	    FROM   GIAC_PARAMETERS
	    WHERE  param_name = 'COMM_PAYABLE_TAKE_UP';
	    
	    IF v_param_value_n IN (1,2) THEN
	     BEGIN
	      SELECT NVL(a.parent_intm_no, intm_no),  b.acct_intm_cd
	      INTO  v_sl_cd, v_gl_intm_no    
	      FROM   GIIS_INTERMEDIARY A, GIIS_INTM_TYPE B
	      WHERE  A.intm_type = B.intm_type
	      AND    A.intm_no  =  v_intm_no;
	
	     EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	       v_sl_cd := v_intm_no;
	     END;
	    ELSIF v_param_value_n = 3 THEN -- PROC    1.2
	
	     BEGIN
	      SELECT NVL(a.parent_intm_no, intm_no)
	      INTO   v_sl_cd
	      FROM   GIIS_INTERMEDIARY A, GIIS_CO_INTRMDRY_TYPES B
	      WHERE  A.intm_type = B.co_intm_type
	      AND    A.intm_no  =  v_intm_no;
	     EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        p_message := 'COMM_PAYABLE_PROC - No data found in GIIS_CO_INTRMDRY_TYPES.';
			RETURN;
	     END;
	
	    END IF;
	
	    BEGIN
	      SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
	             NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
	             NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0), NVL(A.INTM_TYPE_LEVEL,0), A.dr_cr_tag,
	             B.generation_type, A.gl_acct_category, A.gl_control_acct,A.sl_type_cd,  LINE_DEPENDENCY_LEVEL  
	      INTO   V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
	             V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
	             V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7, V_INTM_TYPE_LEVEL, v_dr_cr_tag,
	             v_gen_type, v_gl_acct_category, v_gl_control_acct,v_sl_type_cd, v_LINE_DEPENDENCY_LEVEL  
	      FROM  GIAC_MODULE_ENTRIES A, GIAC_MODULES B
	      WHERE B.module_name = 'GIACS040' 
	      AND   A.item_no = 1
	      AND   B.module_id = A.module_id; 
	
	    EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        p_message := 'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No '||TO_CHAR(v_param_value_n)||'.';
			RETURN;
	    END;
	
	    GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, v_gl_intm_no,
			    v_gl_sub_acct_1, v_gl_sub_acct_2,
			    v_gl_sub_acct_3, v_gl_sub_acct_4,
			    v_gl_sub_acct_5, v_gl_sub_acct_6,
	                    v_gl_sub_acct_7);
	
	     IF v_LINE_DEPENDENCY_LEVEL != 0 THEN      
	        BEGIN
	          SELECT acct_line_cd
	            INTO ws_line_cd
	            FROM giis_line
	           WHERE line_cd = v_line_cd;
	        EXCEPTION
	          WHEN no_data_found THEN
	            p_message := 'No data found in giis_line.';
				RETURN;      
	        END;
	
	    GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_LINE_DEPENDENCY_LEVEL , ws_line_cd,    --v_sl_cd,
			    v_gl_sub_acct_1, v_gl_sub_acct_2,
			    v_gl_sub_acct_3, v_gl_sub_acct_4,
			    v_gl_sub_acct_5, v_gl_sub_acct_6,
	                    v_gl_sub_acct_7);
	
	     END IF;
	
	    GIAC_ACCT_ENTRIES_PKG.AEG_Check_Chart_Of_Accts(v_gl_acct_category,v_gl_control_acct,
	                             v_gl_sub_acct_1, v_gl_sub_acct_2,
	                             v_gl_sub_acct_3, v_gl_sub_acct_4,
	                             v_gl_sub_acct_5, v_gl_sub_acct_6,
	                             v_gl_sub_acct_7,v_gl_acct_id, p_message);
	
	    p_message := nvl(p_message, 'SUCCESS');
		
		IF p_message <> 'SUCCESS' THEN
		   RETURN;
		END IF;
	
	    IF  v_comm_amt > 0 THEN   -- PROC 8              
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
	    END IF;
	
	    GIAC_OVRIDE_COMM_PAYTS_PKG.aeg_insert_update_acct_entries(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
										v_gl_acct_category, v_gl_control_acct,
	                                    v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
	                                    v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
	                                    v_gl_sub_acct_7, v_sl_type_cd,'1',v_sl_cd, v_gen_type, 
	                                    v_gl_acct_id, v_debit_amt, v_credit_amt);
	
	    BEGIN
	      SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
	             NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
	             NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD, NVL(A.INTM_TYPE_LEVEL,0), A.dr_cr_tag,
	             B.generation_type, A.gl_acct_category, A.gl_control_acct
	      INTO   V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
	             V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
	             V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, V_INTM_TYPE_LEVEL, v_dr_cr_tag,
	             v_gen_type, v_gl_acct_category, v_gl_control_acct
	      FROM  GIAC_MODULE_ENTRIES A, GIAC_MODULES B
	      WHERE B.module_name = 'GIACS040' 
	      AND   A.item_no     = 2
	      AND   B.module_id   = A.module_id; 
	    EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        p_message := 'COMM PAYABLE PROC - No data found in GIAC_MODULE_ENTRIES.  Item No = 4.';
			RETURN;
	    END;
	
	    GIAC_ACCT_ENTRIES_PKG.aeg_check_level(v_intm_type_level, v_sl_cd,
			    v_gl_sub_acct_1, v_gl_sub_acct_2,
			    v_gl_sub_acct_3, v_gl_sub_acct_4,
			    v_gl_sub_acct_5, v_gl_sub_acct_6,
	                    v_gl_sub_acct_7);
	
	    GIAC_ACCT_ENTRIES_PKG.AEG_Check_Chart_Of_Accts(v_gl_acct_category,v_gl_control_acct,
	                             v_gl_sub_acct_1, v_gl_sub_acct_2,
	                             v_gl_sub_acct_3, v_gl_sub_acct_4,
	                             v_gl_sub_acct_5, v_gl_sub_acct_6,
	                             v_gl_sub_acct_7,v_gl_acct_id, p_message);  
								 
	    p_message := nvl(p_message, 'SUCCESS');
		
		IF p_message <> 'SUCCESS' THEN
		   RETURN;
		END IF; 
	
	    IF  v_wtax_amt > 0 THEN      
	      IF v_dr_cr_tag = 'D' THEN
	        v_debit_amt  := v_wtax_amt;
	        v_credit_amt := 0;
	      ELSE
	        v_debit_amt  := 0;
	        v_credit_amt := v_wtax_amt;
	      END IF;  
	    ELSIF v_wtax_amt < 0 THEN
	      IF v_dr_cr_tag = 'D' THEN
	        v_debit_amt  := 0;
	        v_credit_amt := v_wtax_amt * -1;
	      ELSE
	        v_debit_amt  := v_wtax_amt * -1;
	        v_credit_amt := 0;
	      END IF;    
	    END IF;
	
	     GIAC_OVRIDE_COMM_PAYTS_PKG.aeg_insert_update_acct_entries(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
		 								v_gl_acct_category, v_gl_control_acct,
	                                    v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
	                                    v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
	                                    v_gl_sub_acct_7,v_sl_type_cd,'1', v_sl_cd, v_gen_type, 
	                                    v_gl_acct_id, v_debit_amt, v_credit_amt);
	
	   IF nvl(v_input_vat,0) != 0 THEN
	 
	    BEGIN
	      SELECT A.GL_ACCT_CATEGORY, A.GL_CONTROL_ACCT, 
	             NVL(A.GL_SUB_ACCT_1,0), NVL(A.GL_SUB_ACCT_2,0), NVL(A.GL_SUB_ACCT_3,0), NVL(A.GL_SUB_ACCT_4,0), 
	             NVL(A.GL_SUB_ACCT_5,0), NVL(A.GL_SUB_ACCT_6,0), NVL(A.GL_SUB_ACCT_7,0),A.SL_TYPE_CD,
	             NVL(A.INTM_TYPE_LEVEL,0), A.dr_cr_tag,
	             B.generation_type, A.gl_acct_category, A.gl_control_acct
	      INTO   V_GL_ACCT_CATEGORY, V_GL_CONTROL_ACCT, 
	             V_GL_SUB_ACCT_1, V_GL_SUB_ACCT_2, V_GL_SUB_ACCT_3, V_GL_SUB_ACCT_4, 
	             V_GL_SUB_ACCT_5, V_GL_SUB_ACCT_6, V_GL_SUB_ACCT_7,V_SL_TYPE_CD, 
	             V_INTM_TYPE_LEVEL, v_dr_cr_tag,
	             v_gen_type, v_gl_acct_category, v_gl_control_acct
	      FROM  GIAC_MODULE_ENTRIES A, GIAC_MODULES B
	      WHERE B.module_name = 'GIACS040' 
	      AND   A.item_no     = 3
	      AND   B.module_id   = A.module_id; 
	    EXCEPTION
	      WHEN NO_DATA_FOUND THEN
	        p_message := 'INPUT V.A.T.C - No data found in GIAC_MODULE_ENTRIES.  Item No = 5.';
			RETURN;
	    END;
	
	
	    GIAC_ACCT_ENTRIES_PKG.AEG_Check_Chart_Of_Accts(v_gl_acct_category,v_gl_control_acct,
	                             v_gl_sub_acct_1, v_gl_sub_acct_2,
	                             v_gl_sub_acct_3, v_gl_sub_acct_4,
	                             v_gl_sub_acct_5, v_gl_sub_acct_6,
	                             v_gl_sub_acct_7,v_gl_acct_id, p_message);   
	
	    p_message := nvl(p_message, 'SUCCESS');
		
		IF p_message <> 'SUCCESS' THEN
		   RETURN;
		END IF;
	
	    IF  v_input_vat > 0 THEN          
	      IF v_dr_cr_tag = 'D' THEN
	        v_debit_amt  := v_input_vat;
	        v_credit_amt := 0;
	      ELSE
	        v_debit_amt  := 0;
	        v_credit_amt := v_input_vat;
	      END IF;  
	    ELSIF v_wtax_amt < 0 THEN
	      IF v_dr_cr_tag = 'D' THEN
	        v_debit_amt  := 0;
	        v_credit_amt := v_input_vat * -1;
	      ELSE
	        v_debit_amt  := v_input_vat * -1;
	        v_credit_amt := 0;
	      END IF;    
	    END IF;
	
	     GIAC_OVRIDE_COMM_PAYTS_PKG.aeg_insert_update_acct_entries(p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id,
		 								v_gl_acct_category, v_gl_control_acct,
	                                    v_gl_sub_acct_1,v_gl_sub_acct_2,v_gl_sub_acct_3,
	                                    v_gl_sub_acct_4,v_gl_sub_acct_5,v_gl_sub_acct_6,
	                                    v_gl_sub_acct_7,v_sl_type_cd,'1', v_sl_cd, v_gen_type, 
	                                    v_gl_acct_id, v_debit_amt, v_credit_amt);
	
	   END IF;
	  END;
	END giacs040_comm_payable_proc;
	
	/*
    **  Created by   :  Emman
    **  Date Created :  10.19.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  :  Executes the procedure AEG_PARAMETERS on GIACS040
    */ 
	PROCEDURE giacs040_aeg_parameters(p_gacc_tran_id			IN	   GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
			  						  p_gacc_branch_cd          IN 	   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
									  p_gacc_fund_cd         	IN 	   GIAC_ACCTRANS.gfun_fund_cd%TYPE,
			  						  p_var_module_name			IN	   GIAC_MODULES.module_name%TYPE,
									  p_message					   OUT VARCHAR2)
	IS   
	  /*
	  **  For PREMIUM RECEIVABLES...
	  */
	  cursor PR_cur is 
	      SELECT c.iss_cd iss_cd , c.comm_amt ,
	             c.prem_seq_no bill_no, a.line_cd ,
		     c.intm_no, a.type_cd, c.wtax_amt , 
	             c.input_vat
	      FROM gipi_polbasic a,
	           gipi_invoice  b, 
	           giac_OVRIDE_comm_payts c
	     WHERE a.policy_id    = b.policy_id
	       AND b.iss_cd       = c.iss_cd
	       AND b.prem_seq_no  = c.prem_seq_no
	       AND c.gacc_tran_id = p_gacc_tran_id;
	
	  -- Negative factor used for collection amt
	  negative_one     NUMBER := 1;
	  
	  v_var_module_id  		  GIAC_MODULES.module_id%TYPE;
	  v_var_gen_type		  GIAC_MODULES.generation_type%TYPE;
	
	BEGIN
	  p_message := 'SUCCESS';
	  
	  BEGIN
	    SELECT module_id,
	           generation_type
	      INTO v_var_module_id,
	           v_var_gen_type
	      FROM giac_modules
	     WHERE module_name  = p_var_module_name;
	  EXCEPTION
	    WHEN no_data_found THEN
	      p_message := 'No data found in GIAC MODULES.';
		  RETURN;
	  END;
	  /*
	  ** Call the deletion of accounting entry procedure.
	  */
	  --AEG_Delete_Acct_Entries;
	    DECLARE
		  dummy  VARCHAR2(1);
		  cursor AE is
		    SELECT '1'
		      FROM giac_acct_entries
		     WHERE gacc_tran_id    = p_gacc_tran_id
		       AND generation_type = v_var_gen_type;
		BEGIN
		  OPEN ae;
		  FETCH ae INTO dummy;
		  IF sql%found THEN
		    /**************************************************************************
		    *                                                                         *
		    * Delete all records existing in GIAC_ACCT_ENTRIES table having the same  *
		    * tran_id as p_gacc_tran_id.                                *
		    *                                                                         *
		    **************************************************************************/
		    delete FROM giac_acct_entries
		          WHERE gacc_tran_id    = p_gacc_tran_id
		            AND generation_type = v_var_gen_type;
		  END IF;
		END;
	  FOR PR_rec in PR_cur LOOP
	    /*
	    ** Premium receivables has a DR_CR_TAG of 'D' which means that
	    ** the normal take up is DEBIT.  It has to be multiplied by -1 to
	    ** make it on the CREDIT side but the value is still POSITIVE.
	    ** This is handled by the function ABS().
	    */
	
	    PR_rec.comm_amt := NVL(PR_REC.comm_amt, 0) * negative_one;
	
	    /*
	    ** Call the accounting entry generation procedure.
	    */
	     GIAC_OVRIDE_COMM_PAYTS_PKG.GIACS040_COMM_PAYABLE_PROC(
		 						p_gacc_branch_cd, p_gacc_fund_cd, p_gacc_tran_id, PR_rec.intm_no, PR_rec.comm_amt,
								PR_REC.wtax_amt, PR_REC.input_vat, PR_REC.line_cd, p_message);
	  END LOOP;
	END giacs040_aeg_parameters;
	
	/*
    **  Created by   :  Emman
    **  Date Created :  10.18.2010
    **  Reference By : (GIACS040 - Overriding Commission)
    **  Description  :  Executes the POST-FORMS-COMMIT trigger of GIACS040
    */ 
	PROCEDURE giacs040_post_forms_commit(p_gacc_tran_id			   IN	  GIAC_OVRIDE_COMM_PAYTS.gacc_tran_id%TYPE,
				  						 p_gacc_branch_cd          IN 	  GIAC_ACCTRANS.gibr_branch_cd%TYPE,
										 p_gacc_fund_cd            IN 	  GIAC_ACCTRANS.gfun_fund_cd%TYPE,
										 p_tran_source			   IN	  VARCHAR2,
										 p_or_flag				   IN	  VARCHAR2,
										 p_var_module_name		   IN	  GIAC_MODULES.module_name%TYPE,
										 p_message				      OUT VARCHAR2)
    IS
	BEGIN
	 IF p_tran_source IN ('OP', 'OR') THEN
	    if p_or_flag = 'P' THEN
	      NULL;
	    ELSE
	      GIAC_OP_TEXT_PKG.update_giac_op_text_giacs040(p_gacc_tran_id);
	    END IF;
	  END IF;
	  /* Creation of accounting entries...*/
	  BEGIN
	    GIAC_OVRIDE_COMM_PAYTS_PKG.giacs040_aeg_parameters(p_gacc_tran_id, p_gacc_branch_cd, p_gacc_fund_cd, p_var_module_name, p_message);
	  END;
	END giacs040_post_forms_commit;
    
    
    FUNCTION validate_tran_refund(
        p_tran_type     giac_ovride_comm_payts.transaction_type%type,
        p_iss_cd        giac_ovride_comm_payts.iss_cd%type,
        p_prem_seq_no   giac_ovride_comm_payts.prem_seq_no%type
    ) RETURN VARCHAR2
    AS
        v_message   VARCHAR2(100) := 'SUCCESS';
        v_cnt       NUMBER := 0;
    BEGIN
        IF p_tran_type = 2 THEN
            FOR i IN (SELECT A.TRANSACTION_TYPE
                            FROM GIAC_OVRIDE_COMM_PAYTS A,
                                 GIAC_ACCTRANS B
                           WHERE A.TRANSACTION_TYPE =1
                             AND A.ISS_CD=P_ISS_CD
                             AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
                             AND A.GACC_TRAN_ID=B.TRAN_ID
                             AND B.TRAN_FLAG!='D'
                             AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                    FROM GIAC_REVERSALS X,
			                                             GIAC_ACCTRANS Y
			                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
			                                         AND Y.TRAN_FLAG !='D'))
            LOOP
                v_cnt := v_cnt + 1;
                
                IF i.transaction_type IS NULL THEN
                    v_message := 'No transaction type 1 for this bill and intermediary.';
                END IF;
            END LOOP;
            
            IF v_cnt = 0 THEN
                v_message := 'No transaction type 1 for this bill and intermediary.';
            END IF;
        ELSIF p_tran_type = 4 THEN
            FOR i IN (SELECT A.TRANSACTION_TYPE
			                FROM GIAC_OVRIDE_COMM_PAYTS A,
			                     GIAC_ACCTRANS B
			               WHERE A.TRANSACTION_TYPE =3
			                 AND A.ISS_CD=P_ISS_CD
			                 AND A.PREM_SEQ_NO=P_PREM_SEQ_NO
			                 AND A.GACC_TRAN_ID=B.TRAN_ID
			                 AND B.TRAN_FLAG!='D'
			                 AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
			                                        FROM GIAC_REVERSALS X,
			                                             GIAC_ACCTRANS Y
			                                       WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
			                                         AND Y.TRAN_FLAG !='D'))
            LOOP
                v_cnt := v_cnt + 1;
                
                IF i.transaction_type IS NULL THEN
                    v_message := 'No transaction type 3 for this bill and intermediary.';
                END IF;
            END LOOP;            
            
            IF v_cnt = 0 THEN
                v_message := 'No transaction type 3 for this bill and intermediary.';
            END IF;
        END IF;
        
        RETURN v_message;       
    END validate_tran_refund;    
    
    PROCEDURE val_delete_rec(
        p_tran_type       giac_ovride_comm_payts.transaction_type%TYPE,
        p_iss_cd          giac_ovride_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_ovride_comm_payts.prem_seq_no%TYPE
    )
    AS
    BEGIN
        IF p_tran_type IN (1, 3) THEN
            FOR i IN (SELECT '1'
                        FROM GIAC_OVRIDE_COMM_PAYTS a,
                             GIAC_ACCTRANS B
                       WHERE A.transaction_type = DECODE(p_tran_type, 1, 2, 4)
                         AND A.iss_cd = NVL(p_iss_cd, A.iss_cd)
                         AND A.prem_seq_no = NVL(p_prem_seq_no, A.prem_seq_no)
                         AND A.GACC_TRAN_ID=B.TRAN_ID
                         AND B.TRAN_FLAG!='D'
                         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                    FROM GIAC_REVERSALS X,
                                                         GIAC_ACCTRANS Y
                                                   WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                     AND Y.TRAN_FLAG !='D'))
            LOOP
                RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#You cannot delete this record, there is an existing refund for this Bill No.');
            END LOOP;
        END IF;
    END val_delete_rec;
    
    
    FUNCTION validate_bill(
        p_tran_type       giac_ovride_comm_payts.transaction_type%TYPE,
        p_iss_cd          giac_ovride_comm_payts.iss_cd%TYPE,
        p_prem_seq_no     giac_ovride_comm_payts.prem_seq_no%TYPE
    ) RETURN VARCHAR2
    AS
        v_message   VARCHAR2(100) := 'SUCCESS';
    BEGIN
        --IF p_tran_type IN (1, 3) THEN
            FOR i IN (SELECT '1'
                        FROM GIAC_OVRIDE_COMM_PAYTS a,
                             GIAC_ACCTRANS B
                       WHERE A.transaction_type = DECODE(p_tran_type, 1, 2, 
                                                                      2, 1,
                                                                      3, 4,
                                                                      4, 3)
                         AND A.iss_cd = NVL(p_iss_cd, A.iss_cd)
                         AND A.prem_seq_no = NVL(p_prem_seq_no, A.prem_seq_no)
                         AND A.GACC_TRAN_ID=B.TRAN_ID
                         AND B.TRAN_FLAG = 'O'
                         AND A.GACC_TRAN_ID NOT IN(SELECT X.GACC_TRAN_ID
                                                    FROM GIAC_REVERSALS X,
                                                         GIAC_ACCTRANS Y
                                                   WHERE X.REVERSING_TRAN_ID=Y.TRAN_ID
                                                     AND Y.TRAN_FLAG !='D'))
            LOOP
                v_message := 'Commission payment transaction related to this invoice is still open.';
            END LOOP;
        --END IF;
        
        RETURN v_message;
    END validate_bill;

END GIAC_OVRIDE_COMM_PAYTS_PKG;
/



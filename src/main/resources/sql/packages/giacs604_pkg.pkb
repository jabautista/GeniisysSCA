CREATE OR REPLACE PACKAGE BODY CPI.GIACS604_PKG
AS
   FUNCTION get_giacs604_header (
        p_source_cd    giac_upload_file.source_cd%TYPE,
        p_file_no      giac_upload_file.file_no%TYPE,
        p_user_id      VARCHAR2
   )
   RETURN get_giacs604_header_tab PIPELINED
   IS
    v_list get_giacs604_header_type;
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_file
             WHERE transaction_type = 1 
               AND EXISTS (
                        SELECT *
                          FROM giac_file_source gfs
                         WHERE gfs.source_cd = p_source_cd
                           AND NVL (atm_tag, 'N') = 'Y')
               AND source_cd = NVL(p_source_cd, source_cd)
               AND file_no = NVL(p_file_no, file_no)
        )
        LOOP
            v_list.source_cd         :=  i.source_cd; 
            v_list.file_no           :=  i.file_no;
            v_list.file_name         :=  i.file_name;
            v_list.tran_date         :=  i.tran_date;
            v_list.tran_id           :=  i.tran_id;
            v_list.file_status       :=  i.file_status;
            v_list.transaction_type  :=  i.transaction_type;
            v_list.tran_class        :=  i.tran_class;
            v_list.upload_date       :=  i.upload_date;
            v_list.convert_date      :=  i.convert_date;
            v_list.payment_date      :=  i.payment_date;
            v_list.cancel_date       :=  i.cancel_date;
            
            v_list.no_of_records     :=  i.no_of_records;
            v_list.remarks           :=  i.remarks;
            
            BEGIN
                SELECT source_name
                  INTO v_list.dsp_source_name
                  FROM giac_file_source
                 WHERE source_cd = i.source_cd;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_list.dsp_source_name := NULL;
                WHEN OTHERS THEN
                  v_list.dsp_source_name := NULL;
            END;
            
            v_list.dsp_tran_class   := nvl(i.tran_class, 'COL'); 	
            v_list.nbt_or_date      := nvl(i.tran_date, SYSDATE);
            
            IF i.tran_class = 'JV' THEN
                FOR rec IN (SELECT jv_pref_suff||'-'||jv_no jv_number
                              FROM giac_acctrans
                             WHERE tran_id = i.tran_id)
                LOOP
                    v_list.dsp_or_req_jv_no := rec.jv_number;
                    EXIT;
                END LOOP;
                
            ELSIF i.tran_class = 'DV' THEN
                FOR rec IN (
                    SELECT gprq.document_cd || '-' || gprq.branch_cd || '-' || gprq.doc_year || '-' || gprq.doc_mm || '-' || gprq.doc_seq_no request_number
                      FROM giac_payt_requests gprq, giac_payt_requests_dtl gprqd
                     WHERE gprq.ref_id = gprqd.gprq_ref_id
                       AND gprqd.tran_id = i.tran_id
                       AND gprqd.gprq_ref_id >= 1
                )
                LOOP
                    v_list.dsp_or_req_jv_no := rec.request_number;
                    EXIT;
                END LOOP;
            END IF;	
            
            BEGIN
                SELECT a.grp_iss_cd
                  INTO v_list.branch_cd 
                  FROM giis_user_grp_hdr a,
                       giis_users b
                 WHERE a.user_grp = b.user_grp
                   AND b.user_id = p_user_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     v_list.branch_cd  := '';
            END; 
           
            PIPE ROW(v_list);
        END LOOP;
        RETURN;
   END;  
   
   FUNCTION get_giacs604_rec_list (
          p_source_cd           GIAC_UPLOAD_PREM.source_cd%TYPE,   
          p_file_no             GIAC_UPLOAD_PREM.file_no%TYPE,
          p_from                NUMBER,
          p_to                  NUMBER,
          p_bill_no             NUMBER,
          p_collection_amt      NUMBER,
          p_collection_amt_diff NUMBER, 
          p_prem_chk_flag       VARCHAR2,
          p_chk_remarks         VARCHAR2,
          p_order_by            VARCHAR2,
          p_asc_desc_flag       VARCHAR2
    ) 
        RETURN giacs604_rec_tab PIPELINED
    IS
        TYPE cur_type IS REF CURSOR;
        c       cur_type;
        v_rec   giacs604_rec_type;
        v_sql   VARCHAR2(9000);
        
        FUNCTION get_payment_details (
            p_bill_no    giac_upload_prem_atm_dtl.bill_no%TYPE,
            p_payor      giac_upload_prem_atm.payor%TYPE
        ) RETURN VARCHAR2 IS
        														  
          v_mean_check_class	VARCHAR2(20) := 'UNKNOWN CHECK CLASS';	
          v_payment_details		VARCHAR2(500);
          v_dummy_payt_dtl    VARCHAR2(100);

        BEGIN
            FOR rec IN (
                SELECT pay_mode, check_class, check_no, check_date, bank
                  FROM giac_upload_prem_atm_dtl
                 WHERE source_cd = p_source_cd
                   AND file_no = p_file_no
                   AND bill_no = nvl(p_bill_no, bill_no)
                   AND payor = p_payor
            )
            LOOP     
                IF rec.pay_mode = 'CA' THEN
                    v_dummy_payt_dtl := rec.pay_mode||'; ';			
                ELSIF	rec.pay_mode = 'CC' THEN
                    v_dummy_payt_dtl := rec.pay_mode||', '||rec.bank||', '||rec.check_no||'; ';
                ELSIF rec.pay_mode = 'CHK' THEN
                    BEGIN
                    SELECT upper(rv_meaning)
                      INTO v_mean_check_class
                      FROM cg_ref_codes
                     WHERE rv_domain LIKE 'GIAC_COLLECTION_DTL.CHECK_CLASS'
                         AND rv_low_value = rec.check_class;
                  EXCEPTION
                    WHEN no_data_found THEN
                      NULL;
                    WHEN OTHERS THEN
                      raise_application_error (-20001, 'Geniisys Exception#E#'||SQLERRM);
                  END;
                    v_dummy_payt_dtl := rec.pay_mode||', '||rec.bank||', '||v_mean_check_class||', '||rec.check_no||', '||to_char(rec.check_date,'MM/DD/RRRR')||'; ';	 
                ELSIF rec.pay_mode = 'CM' THEN
                    SELECT rec.pay_mode||', '||rec.bank||decode(rec.check_no, NULL, NULL,', '||rec.check_no)||decode(to_char(rec.check_date,'MM/DD/RRRR'), NULL, NULL,', '||to_char(rec.check_date,'MM/DD/RRRR'))||'; '
                      INTO v_dummy_payt_dtl
                FROM dual;
                END IF;	

                IF length(v_payment_details||v_dummy_payt_dtl) <= 500 THEN
                    v_payment_details := replace(v_payment_details, v_dummy_payt_dtl, NULL)||v_dummy_payt_dtl;
                ELSE
                    EXIT;
                END IF;
            END LOOP;
        		
          RETURN(v_payment_details);
        END;
        
    BEGIN
        v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                SELECT a.file_no,      
                                       a.source_cd,     
                                       a.bill_no,       
                                       a.iss_cd,        
                                       a.prem_seq_no,   
                                       a.policy_no,     
                                       a.collection_amt,
                                       a.net_amt_due,   
                                       a.prem_chk_flag, 
                                       a.chk_remarks,   
                                       a.payor,
                                       b.currency_cd,
                                       b.fcollection_amt, 
                                       b.convert_rate                                         
                                  FROM GIAC_UPLOAD_PREM_ATM a, GIAC_UPLOAD_PREM_ATM_DTL b, GIIS_ISSOURCE c
                                 WHERE a.source_cd = :p_source_cd
                                   AND a.file_no = :p_file_no
                                   AND a.source_cd = b.source_cd
                                   AND a.file_no = b.file_no
                                   AND a.iss_cd = c.iss_cd
                                   AND (c.acct_iss_cd || ''-'' || a.bill_no) = b.bill_no';
                                  
                                  
        IF p_bill_no IS NOT NULL THEN
           v_sql := v_sql || ' AND a.bill_no = ('|| p_bill_no ||')';
        END IF;
        
        IF p_collection_amt IS NOT NULL THEN
           v_sql := v_sql || ' AND a.collection_amt = ('|| p_collection_amt ||')';
        END IF;
        
      IF p_order_by IS NOT NULL THEN
        IF p_order_by = 'billNo' THEN        
          v_sql := v_sql || ' ORDER BY a.bill_no ';
        ELSIF p_order_by = 'collectionAmt' THEN
          v_sql := v_sql || ' ORDER BY a.collection_amt ';
        ELSIF p_order_by = 'premChkFlag' THEN
          v_sql := v_sql || ' ORDER BY a.prem_chk_flag ';
        ELSIF p_order_by = 'chkRemarks' THEN
          v_sql := v_sql || ' ORDER BY a.chk_remarks ';
        ELSIF p_order_by = 'dspCollnAmtDiff' THEN
          v_sql := v_sql || ' ORDER BY (a.collection_amt - a.net_amt_due) ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
      END IF;
      
      v_sql := v_sql || ' )innersql  ) outersql) mainsql WHERE rownum_ BETWEEN ' || p_from ||' AND ' || p_to;
      
      OPEN c FOR v_sql USING p_source_cd, p_file_no;
      LOOP                    
        FETCH c INTO
            v_rec.count_,                  
            v_rec.rownum_,                
            v_rec.file_no,                       
            v_rec.source_cd,               
            v_rec.bill_no,            
            v_rec.iss_cd,                    
            v_rec.prem_seq_no,            
            v_rec.policy_no,              
            v_rec.collection_amt,         
            v_rec.net_amt_due,            
            v_rec.prem_chk_flag,          
            v_rec.chk_remarks,            
            v_rec.payor,
            v_rec.currency_cd,        
            v_rec.fcollection_amt,    
            v_rec.convert_rate;    
            
            v_rec.dsp_payment_details := get_payment_details(v_rec.bill_no, v_rec.payor);
            
            FOR i IN (SELECT currency_desc
                FROM giis_currency
               WHERE main_currency_cd = v_rec.currency_cd)
            LOOP
                v_rec.dsp_currency := i.currency_desc;
                EXIT;
            END LOOP;
            
            IF v_rec.chk_remarks IS NOT NULL THEN
                IF v_rec.collection_amt IS NOT NULL AND v_rec.net_amt_due IS NOT NULL THEN
                    v_rec.dsp_colln_amt_diff := v_rec.collection_amt - v_rec.net_amt_due;
                END IF;
                
                v_rec.dsp_difference := 0;
                
                FOR i IN (SELECT currency_rt AS rate 
                            FROM GIPI_INVOICE
                           WHERE iss_cd = v_rec.iss_cd
                             AND prem_seq_no = v_rec.bill_no) 
                LOOP
                    v_rec.dsp_difference := NVL(v_rec.net_amt_due/i.rate,0);
                END LOOP;
                  
                v_rec.dsp_difference := v_rec.fcollection_amt - v_rec.dsp_difference;
                
            END IF;    
        EXIT WHEN c%NOTFOUND;  
        PIPE ROW (v_rec);
      END LOOP;      
      
      CLOSE c;
       
    END;
    
    PROCEDURE check_data_giacs604 (
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
   IS
        v_pol_flag              VARCHAR2(1);
        v_reg_policy_sw         VARCHAR2(1);
        v_prem_chk_flag         VARCHAR2(2);
        v_tot_amt_due           NUMBER;
        v_exists                BOOLEAN := FALSE;
        v_chk_remarks           VARCHAR2(2000);
        v_excluded_branch       VARCHAR2(4) := nvl(giacp.v('BRANCH_EXCLUDED_IN_UPLOAD'),'NONE');
        v_has_claim             BOOLEAN := FALSE;
        v_line_cd               gipi_polbasic.line_cd%TYPE;
        v_subline_cd            gipi_polbasic.subline_cd%TYPE;
        v_iss_cd                gipi_polbasic.iss_cd%TYPE;
        v_issue_yy              gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no              gipi_polbasic.renew_no%TYPE;
        v_policy_no             VARCHAR2(100);
   BEGIN
        FOR rec IN (
            SELECT a.bill_no, a.collection_amt, a.iss_cd,
                   SUBSTR (a.bill_no, INSTR (a.bill_no, '-', 1, 1) + 1) prem_seq_no
              FROM giac_upload_prem_atm a, giis_issource b
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND b.acct_iss_cd(+) = TO_NUMBER (SUBSTR (a.bill_no, 1, INSTR (a.bill_no, '-', 1, 1) - 1))
        )
        LOOP
            v_tot_amt_due := 0;
            v_prem_chk_flag := 'OK';                  
            v_chk_remarks := 'This bill is valid for uploading.';
            v_exists := FALSE;
            v_has_claim := FALSE;
            v_policy_no := NULL;
            
            IF rec.iss_cd IS NULL THEN
                v_prem_chk_flag := 'NE';
                v_chk_remarks := 'This bill does not exist.';
                GOTO update_table;
            ELSIF rec.iss_cd = v_excluded_branch THEN
                v_prem_chk_flag := 'EX';
                v_chk_remarks := 'This bill''s issuing source is '||v_excluded_branch||'.';
                GOTO update_table;
            ELSIF rec.iss_cd = 'RI' THEN
                v_prem_chk_flag := 'RI';
                v_chk_remarks := 'This is a reinsurance policy.';
                GOTO update_table;
            ELSIF check_user_per_iss_cd_acctg2(NULL,rec.iss_cd,'GIACS007', p_user_id)    = 0 THEN
                v_prem_chk_flag := 'NA';
                v_chk_remarks := 'User is not allowed to make collections for the branch of this policy.';
                GOTO update_table;    
            END IF;
            
            FOR rec_a IN (
                SELECT   gasd.iss_cd, gasd.prem_seq_no, SUM (balance_amt_due) bal_amt_due,
                         gpol.reg_policy_sw, gpol.pol_flag, gpol.line_cd, gpol.subline_cd,
                         gpol.iss_cd pol_iss_cd, gpol.issue_yy, gpol.pol_seq_no,
                         gpol.renew_no, RTRIM (gpol.line_cd) || '-' || RTRIM (gpol.subline_cd) || '-'
                         || RTRIM (gpol.iss_cd) || '-' || LTRIM (TO_CHAR (gpol.issue_yy, '99')) || '-'
                         || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999')) || DECODE (gpol.endt_seq_no, 0, NULL, '-'
                         || gpol.endt_iss_cd || '-' || LTRIM (TO_CHAR (gpol.endt_yy, '09')) || '-' || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                         || ' ' || RTRIM (gpol.endt_type)) || '-' || LTRIM (TO_CHAR (gpol.renew_no, '09')) || DECODE (gpol.pol_flag,
                         '4', ' (Cancelled Policy)', '5', ' (Spoiled Policy)', NULL ) policy_no
                    FROM giac_aging_soa_details gasd, gipi_polbasic gpol, gipi_invoice ginv
                   WHERE 1 = 1
                     AND ginv.prem_seq_no = gasd.prem_seq_no
                     AND ginv.iss_cd = gasd.iss_cd
                     AND gpol.policy_id = ginv.policy_id
                     AND ginv.prem_seq_no = rec.prem_seq_no
                     AND ginv.iss_cd = rec.iss_cd
                GROUP BY gasd.iss_cd,
                         gasd.prem_seq_no,
                         gpol.reg_policy_sw,
                         gpol.pol_flag,
                         gpol.line_cd,
                         gpol.subline_cd,
                         gpol.iss_cd,
                         gpol.issue_yy,
                         gpol.pol_seq_no,
                         gpol.renew_no, RTRIM (gpol.line_cd) || '-' || RTRIM (gpol.subline_cd) || '-'
                         || RTRIM (gpol.iss_cd) || '-' || LTRIM (TO_CHAR (gpol.issue_yy, '99')) || '-'
                         || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                         || DECODE (gpol.endt_seq_no, 0, NULL, '-' || gpol.endt_iss_cd || '-' || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                         || '-' || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                         || ' ' || RTRIM (gpol.endt_type)) || '-' || LTRIM (TO_CHAR (gpol.renew_no, '09'))
                         || DECODE (gpol.pol_flag, '4', ' (Cancelled Policy)', '5', ' (Spoiled Policy)', NULL) 
              )
              LOOP
                v_policy_no  := rec_a.policy_no;
                IF rec_a.pol_flag = '5' THEN
                    v_prem_chk_flag := 'SL';--spoiled
                    v_chk_remarks := 'This bill''s policy is already spoiled.';
                    GOTO update_table;
                END IF;
                
                IF rec_a.pol_flag = '4' THEN
                    FOR rec_d IN (
                        SELECT 'X'
                          FROM giac_cancelled_policies_v
                         WHERE line_cd = rec_a.line_cd
                           AND subline_cd = rec_a.subline_cd
                           AND iss_cd = rec_a.iss_cd
                           AND issue_yy = rec_a.issue_yy
                           AND pol_seq_no = rec_a.pol_seq_no
                           AND renew_no = rec_a.renew_no
                    )
                    LOOP
                        v_prem_chk_flag := 'CP';--cancelled
                        v_chk_remarks := 'This is a cancelled policy.';
                        GOTO update_table;
                    END LOOP;    
                END IF; 
                
                IF rec_a.reg_policy_sw = 'N' AND variables_prem_payt_for_sp <> 'Y' THEN
                  v_prem_chk_flag := 'SP';--special policy
                  v_chk_remarks := 'This is a special policy.';
                  GOTO update_table;
                ELSE
                    v_tot_amt_due := rec_a.bal_amt_due;
                END IF; 
                
                v_line_cd    := rec_a.line_cd;
                v_subline_cd := rec_a.subline_cd;
                v_iss_cd     := rec_a.pol_iss_cd;
                v_issue_yy   := rec_a.issue_yy;
                v_pol_seq_no := rec_a.pol_seq_no;
                v_renew_no   := rec_a.renew_no;            
                v_exists := TRUE;
                EXIT;
              END LOOP;
              
              IF NOT v_exists THEN
                v_prem_chk_flag := 'NE';
                v_chk_remarks := 'This bill does not exist.';
                GOTO update_table;
              END IF;
              
              IF v_tot_amt_due = 0 THEN
                --v_prem_chk_flag := 'OP';--over payment
                v_prem_chk_flag := 'FP';--Vincent 04282006: fully paid
                v_chk_remarks := 'This bill is already fully paid.';
              ELSIF rec.collection_amt > v_tot_amt_due THEN
                v_prem_chk_flag := 'OP';--over payment
                v_chk_remarks := 'This bill has a total balance amount due of '||ltrim(to_char(v_tot_amt_due, '999,999,999,990.90'))||'.';
              ELSIF rec.collection_amt < v_tot_amt_due THEN
                v_prem_chk_flag := 'PT';--partial payment
                v_chk_remarks := 'This is a partial payment. The total balance amount due for this bill is '||ltrim(to_char(v_tot_amt_due, '999,999,999,990.90'))||'.';
              END IF;
              
              --check if policy has existing claim records
              FOR rec_c IN (
                    SELECT 'X'
                      FROM gicl_claims a
                     WHERE 1 = 1
                       AND a.line_cd = v_line_cd
                       AND a.subline_cd = v_subline_cd
                       AND a.pol_iss_cd = v_iss_cd
                       AND a.issue_yy = v_issue_yy
                       AND a.pol_seq_no = v_pol_seq_no
                       AND a.renew_no = v_renew_no
              )
              LOOP
                IF v_prem_chk_flag = 'OP' THEN
                    v_prem_chk_flag := 'OC';
                    v_chk_remarks := v_chk_remarks||' This bill''s policy also has an existing claim.';
                ELSIF v_prem_chk_flag = 'PT' THEN
                    v_prem_chk_flag := 'PC';
                    v_chk_remarks := v_chk_remarks||' This bill''s policy also has an existing claim.';
                ELSIF v_prem_chk_flag = 'FP' THEN 
                    v_prem_chk_flag := 'FC';
                    v_chk_remarks := v_chk_remarks||' It also has an existing claim.';
                ELSIF    v_prem_chk_flag = 'OK' THEN
                    v_prem_chk_flag := 'WC';
                    v_chk_remarks := 'This bill''s policy has an existing claim.';
                END IF; 
                   
                EXIT;
              END LOOP; 
            
            
             <<update_table>>
            UPDATE giac_upload_prem_atm
               SET prem_chk_flag = v_prem_chk_flag,
                   chk_remarks = v_chk_remarks,
                   net_amt_due = v_tot_amt_due,
                   iss_cd = rec.iss_cd,
                   prem_seq_no = rec.prem_seq_no,
                   policy_no = v_policy_no
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND bill_no = rec.bill_no;
            
        END LOOP;
   END;
   
   PROCEDURE validate_print_or (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_fund_cd     OUT   VARCHAR2,
        p_branch_name OUT   VARCHAR2,
        p_fund_desc   OUT   VARCHAR2,
        p_tran_id     OUT   NUMBER
    )
    IS
    BEGIN
        BEGIN
           SELECT c.gibr_branch_cd, c.gibr_gfun_fund_cd, c.gacc_tran_id
             INTO p_branch_cd, p_fund_cd, p_tran_id
             FROM giac_order_of_payts c, giac_upload_prem_atm b, giac_upload_file a
            WHERE 1 = 1
              AND b.tran_id = c.gacc_tran_id
              AND a.source_cd = b.source_cd
              AND a.file_no = b.file_no
              AND a.source_cd = p_source_cd
              AND a.file_no = p_file_no
              AND ROWNUM = 1;
              
            BEGIN
                SELECT branch_name
                  INTO p_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = p_fund_cd 
                   AND branch_cd = p_branch_cd;
                
                SELECT fund_desc
                  INTO p_fund_desc
                  FROM giis_funds
                 WHERE fund_cd = p_fund_cd;
            END;    
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#O.R. does not exist in table: GIAC_ORDER_OF_PAYTS.');  	
        END;
        
    END;
    
    PROCEDURE validate_print_dv (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_gprq_ref_id OUT   VARCHAR2,
        p_doc_cd      OUT   VARCHAR2
    )
    IS
    BEGIN
        BEGIN
            SELECT document_cd, branch_cd
              INTO p_doc_cd, p_branch_cd
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                raise_application_error (-20001, 'Geniisys Exception#E#No record on GIAC_UPLOAD_DV_PAYT_DTL');
        END;
        
        BEGIN
            SELECT gprq_ref_id
              INTO p_gprq_ref_id
              FROM giac_payt_requests_dtl
             WHERE tran_id IN (SELECT tran_id
                                 FROM giac_upload_file
                                WHERE source_cd = p_source_cd 
                                  AND file_no = p_file_no)
               AND ROWNUM = 1;
		EXCEPTION 
			WHEN NO_DATA_FOUND THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Request does not exist in table: GIAC_PAYT_REQUESTS.');
		END;
        
        
    END;  
    
    PROCEDURE validate_print_jv (
        p_source_cd         VARCHAR2,
        p_file_no           VARCHAR2,
        p_fund_cd     OUT   VARCHAR2,
        p_branch_cd   OUT   VARCHAR2,
        p_tran_id     OUT   VARCHAR2
    )
    IS
    BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            p_fund_cd   :=  giacp.v('FUND_CD');
            p_branch_cd := i.branch_cd;
        END LOOP;
        
        FOR i IN(
            SELECT tran_id
              FROM giac_upload_file
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            p_tran_id := i.tran_id;
        END LOOP;
    END;  
    
    FUNCTION get_giac_upload_dv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_dv_payt_dtl_tab PIPELINED
   IS
     v_list giac_upload_dv_payt_dtl_type;
     v_exist    VARCHAR2(1) := 'N';
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_exist := 'Y';
            v_list.source_cd           :=   i.source_cd;    
            v_list.file_no             :=   i.file_no;
            v_list.document_cd         :=   i.document_cd;
            v_list.branch_cd           :=   i.branch_cd;
            v_list.line_cd             :=   i.line_cd;
            v_list.doc_year            :=   i.doc_year;
            v_list.doc_mm              :=   i.doc_mm;
            v_list.doc_seq_no          :=   i.doc_seq_no;
            v_list.gouc_ouc_id         :=   i.gouc_ouc_id;
            v_list.request_date        :=   i.request_date;
            v_list.payee_class_cd      :=   i.payee_class_cd;
            v_list.payee_cd            :=   i.payee_cd;
            v_list.payee               :=   i.payee;
            v_list.particulars         :=   i.particulars;
            v_list.dv_fcurrency_amt    :=   i.dv_fcurrency_amt;
            v_list.currency_rt         :=   i.currency_rt;
            v_list.payt_amt            :=   i.payt_amt;
            v_list.currency_cd         :=   i.currency_cd;


            BEGIN
               SELECT ouc_cd, ouc_name
                 INTO v_list.dsp_dept_cd, v_list.dsp_ouc_name 
                 FROM giac_oucs
                WHERE ouc_id = i.gouc_ouc_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_dept_cd    := '';
                  v_list.dsp_ouc_name   := '';
            END;
            
            BEGIN
                SELECT short_name
                  INTO v_list.dsp_fshort_name
                  FROM giis_currency 
                 WHERE main_currency_cd =  i.currency_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_fshort_name    := '';
            END;
            
            BEGIN
               SELECT param_value_v
                 INTO v_list.dsp_short_name 
                 FROM giac_parameters
                WHERE param_name LIKE 'DEFAULT_CURRENCY';
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_short_name     := '';
            END;
            
            BEGIN
                SELECT payee_last_name, payee_first_name, payee_middle_name
                  INTO v_list.payee_last_name, v_list.payee_first_name, v_list.payee_middle_name
                  FROM giis_payees
                 WHERE payee_class_cd = i.payee_class_cd
                   AND payee_no = i.payee_cd;
            EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                  v_list.payee_last_name    := '';
                  v_list.payee_first_name   := '';
                  v_list.payee_middle_name  := '';
            END;
            
            BEGIN
                SELECT document_name, line_cd_tag, yy_tag, mm_tag
                  INTO v_list.document_name, v_list.line_cd_tag, v_list.yy_tag, v_list.mm_tag
                  FROM giac_payt_req_docs
                 WHERE gibr_gfun_fund_cd = giacp.v('FUND_CD')
                   AND gibr_branch_cd = i.branch_cd
                   AND document_cd = i.document_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.document_name  := '';  
                  v_list.line_cd_tag    := '';
                  v_list.yy_tag         := '';
                  v_list.mm_tag         := '';
            END;
        
            PIPE ROW(v_list);
        END LOOP;
        
        IF v_exist = 'N' THEN
            BEGIN
               SELECT a.grp_iss_cd
                 INTO v_list.branch_cd
                 FROM giis_user_grp_hdr a, giis_users b
                WHERE a.user_grp = b.user_grp AND b.user_id = p_user_id;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.branch_cd := '';
            END;
            
            BEGIN
                SELECT param_value_v
                  INTO v_list.dsp_short_name
                  FROM giac_parameters
                 WHERE param_name LIKE 'DEFAULT_CURRENCY';
            END;
            
            v_list.source_cd           :=   p_source_cd; 
            v_list.file_no             :=   p_file_no;  
            
            v_list.v_exists := v_exist;
            
            PIPE ROW(v_list);
        END IF;
        RETURN;
   END;
   
   FUNCTION get_giac_upload_jv_payt_dtl(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2
   )
     RETURN giac_upload_jv_payt_dtl_tab PIPELINED
   IS
        v_list  giac_upload_jv_payt_dtl_type;
        v_exists    VARCHAR2(1) := 'N';
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no
        )
        LOOP
            v_exists        := 'Y';
            v_list.source_cd        :=  i.source_cd;      
            v_list.file_no          :=  i.file_no;        
            v_list.branch_cd        :=  i.branch_cd;      
            v_list.tran_date        :=  i.tran_date;      
            v_list.jv_tran_tag      :=  i.jv_tran_tag;    
            v_list.jv_tran_type     :=  i.jv_tran_type;   
            v_list.jv_tran_mm       :=  i.jv_tran_mm;     
            v_list.jv_tran_yy       :=  i.jv_tran_yy;     
            v_list.tran_year        :=  i.tran_year;      
            v_list.tran_month       :=  i.tran_month;
            v_list.tran_seq_no      :=  i.tran_seq_no;    
            v_list.jv_pref_suff     :=  i.jv_pref_suff;   
            v_list.jv_no            :=  i.jv_no;          
            v_list.particulars      :=  i.particulars;    
            
            
            BEGIN
                SELECT branch_name
                  INTO v_list.dsp_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = giacp.v ('FUND_CD') 
                   AND branch_cd = i.branch_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  v_list.dsp_branch_name := NULL;
            END;
            
            FOR c IN (
                SELECT jv_tran_cd, jv_tran_desc
                  FROM giac_jv_trans
                 WHERE jv_tran_cd = i.jv_tran_type
            ) 
            LOOP
                v_list.dsp_tran_desc := c.jv_tran_desc;
                EXIT;
            END LOOP;
            
            PIPE ROW (v_list);
        END LOOP;
        
        IF v_exists != 'Y' THEN
            v_list.v_exists := 'N';
            v_list.source_cd        :=  p_source_cd;      
            v_list.file_no          :=  p_file_no;  
            
            BEGIN
                SELECT a.grp_iss_cd 
                  INTO v_list.branch_cd
                  FROM giis_user_grp_hdr a, giis_users b
                 WHERE a.user_grp = b.user_grp 
                   AND b.user_id = p_user_id;
                   
                SELECT branch_name
                  INTO v_list.dsp_branch_name
                  FROM giac_branches
                 WHERE branch_cd = v_list.branch_cd
                   AND gfun_fund_cd = giacp.v ('FUND_CD');
                
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_list.branch_cd := '';
                    v_list.dsp_branch_name := '';
            END;
            
            PIPE ROW (v_list);
        END IF;
        
        RETURN;
   END;
   
   PROCEDURE upload_giacs604(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_user_id       VARCHAR2,
        p_or_date       VARCHAR2,
        p_payment_date  VARCHAR2,
        p_dcb_bank_cd       VARCHAR2,
        p_dcb_bank_acct_cd  VARCHAR2,
        p_tran_class    VARCHAR2,
        p_branch_cd     VARCHAR2
   )
   IS
        v_exist     VARCHAR2(1) := 'N';
   BEGIN
       upload_dpc_web.check_tran_mm (TO_DATE(p_or_date,'MM-DD-YYYY'));
       variables_branch_cd := p_branch_cd;
       upload_dpc_web.set_fixed_variables(variables_fund_cd, variables_branch_cd, variables_evat_cd);
       --upload_dpc_web.check_dcb_user(TO_DATE(p_or_date,'MM-DD-YYYY'), p_user_id);
       --upload_dpc_web.get_dcb_no(TO_DATE(p_or_date,'MM-DD-YYYY'), variables_dcb_no);
       upload_dpc_web.get_dcb_no2 (TO_DATE(p_or_date,'MM-DD-YYYY'), variables_dcb_no, v_exist);
       
       
       variables_upload_tag := 'Y';
       --giacs603_pkg.validate_policy(p_source_cd, p_file_no);
       giacs604_pkg.check_data_giacs604(p_source_cd, p_file_no, p_user_id);
       variables_upload_tag := 'N';	
       variables_user_id := p_user_id;
       variables_file_no := p_file_no;
       variables_source_cd := p_source_cd;
       variables_tran_class := p_tran_class;
       check_payment_details;
       
       
       IF p_tran_class = 'COL' THEN
            IF v_exist = 'N'
            THEN
               FOR a IN (SELECT (NVL (MAX (dcb_no), 0) + 1) new_dcb_no
                           FROM giac_colln_batch
                          WHERE fund_cd = variables_fund_cd
                            AND branch_cd = variables_branch_cd
                            AND dcb_year =
                                    TO_NUMBER (TO_CHAR (TO_DATE(p_or_date,'MM-DD-YYYY'), 'YYYY')))
               LOOP
                  variables_dcb_no := a.new_dcb_no;
                  EXIT;
               END LOOP;
                
               upload_dpc_web.create_dcb_no (variables_dcb_no,
                                             TO_DATE(p_or_date,'MM-DD-YYYY'),
                                             variables_fund_cd,
                                             variables_branch_cd,
                                             variables_user_id
                                            );
            END IF;
            
            GIACS604_PKG.gen_multiple_or(p_source_cd, p_file_no, p_or_date, p_payment_date, p_dcb_bank_cd, p_dcb_bank_acct_cd);
       ELSIF p_tran_class = 'DV' THEN
            GIACS604_PKG.gen_dv(p_source_cd, p_file_no);  
       ELSIF p_tran_class = 'JV' THEN
            GIACS604_PKG.gen_jv(p_source_cd, p_file_no); 
       END IF;
   END;
   
   PROCEDURE gen_multiple_or(
        p_source_cd     VARCHAR2,
        p_file_no       VARCHAR2,
        p_or_date       VARCHAR2,
        p_payment_date  VARCHAR2,
        p_dcb_bank_cd       VARCHAR2,
        p_dcb_bank_acct_cd  VARCHAR2
   )
   IS
        --acctrans
        v_tran_flag      giac_acctrans.tran_flag%TYPE;
        v_tran_class  	 giac_acctrans.tran_class%TYPE;  
        v_tran_class_no  giac_acctrans.tran_class_no%TYPE;  
        v_tran_year      giac_acctrans.tran_year%TYPE;
        v_tran_month     giac_acctrans.tran_month%TYPE; 
        v_tran_seq_no    giac_acctrans.tran_seq_no%TYPE;
      
        --order of payts
        v_cashier_cd	 giac_order_of_payts.cashier_cd%TYPE;
        v_particulars	 giac_order_of_payts.particulars%TYPE;
        v_or_colln_amt   giac_order_of_payts.collection_amt%TYPE;
    		
        --collection dtl
        v_currency_cd	 giac_collection_dtl.currency_cd%TYPE;
        v_currency_rt	 giac_collection_dtl.currency_rt%TYPE;
        v_bank_cd		 giac_collection_dtl.bank_cd%TYPE;
        v_pay_mode		 giac_collection_dtl.pay_mode%TYPE;
        
        --nieko Accounting Uploading GIACS604
        v_fc_amt            giac_collection_dtl.fcurrency_amt%TYPE;
        v_utility_tag       giac_file_source.utility_tag%TYPE;
        v_bank_sname        giac_banks.bank_sname%TYPE;
        v_check_class       giac_collection_dtl.check_class%TYPE;
        v_check_no          giac_collection_dtl.check_no%TYPE;
        v_check_date        DATE;
   BEGIN
     --nieko Accounting Uploading GIACS604, copied for loop for per-bill
     FOR rec IN (
           SELECT a.iss_cd, a.prem_seq_no, (b.acct_iss_cd || '-' || a.prem_seq_no) bill_no
             FROM giac_upload_prem_atm a, giis_issource b
            WHERE a.source_cd = p_source_cd 
              AND a.file_no = p_file_no
              AND a.iss_cd = b.iss_cd
     )
     LOOP
        FOR a IN (
            SELECT cashier_cd
              FROM giac_dcb_users
             WHERE dcb_user_id = variables_user_id
               AND gibr_fund_cd = variables_fund_cd
               AND gibr_branch_cd = variables_branch_cd
        )
        LOOP
            v_cashier_cd := a.cashier_cd;
            EXIT;
        END LOOP;
        
        
        FOR i IN (
            SELECT utility_tag
              FROM giac_file_source
             WHERE source_cd = p_source_cd
          )
        LOOP
          v_utility_tag := i.utility_tag;
          EXIT;
        END LOOP;
        
        --nieko Accounting Uploading GIACS604
        v_utility_tag := NVL(v_utility_tag, 'N');
        
        v_bank_cd := giacp.v('CM_UTILITY_ACCT');
		IF v_bank_cd IS NULL THEN
            raise_application_error (-20001, 'Geniisys Exception#E#Parameter CM_UTILITY_ACCT is not defined in table GIAC_PARAMETERS.');	
		END IF;	
        --nieko end
        
        v_tran_flag     := 'O';
	    v_tran_class  	:= 'COL';
	    v_tran_class_no := variables_dcb_no;
		v_currency_cd := 1;
		v_currency_rt := 1;
		v_pay_mode := 'CM';
        
        FOR rec_a IN (
              --nieko Accounting Uploading GIACS604, added giac_upload_prem_atm_dtl
              SELECT a.payor, SUM (a.collection_amt) or_colln_amt, b.currency_cd,
                         b.convert_rate, b.bank, b.pay_mode, b.check_class, b.check_no,
                         b.check_date
                FROM giac_upload_prem_atm a, giac_upload_prem_atm_dtl b
               WHERE a.source_cd = p_source_cd 
                 AND a.file_no = p_file_no
                 ANd a.source_cd = b.source_cd
                 AND a.file_no = b.file_no
                 AND a.iss_cd = rec.iss_cd
                 AND a.prem_seq_no = rec.prem_seq_no
                 AND b.bill_no = rec.bill_no
               GROUP BY a.payor, b.currency_cd, b.convert_rate, b.bank,
                         b.pay_mode, b.check_class, b.check_no, b.check_date
        )
        LOOP
            --nieko Accounting Uploading GIACS604
            IF v_utility_tag = 'N' THEN
                v_bank_cd := NULL;
                FOR i IN (
                    SELECT bank_cd
                      FROM giac_banks
                     WHERE bank_sname = rec_a.bank
                )
                LOOP
                  v_bank_cd := i.bank_cd;
                  EXIT;
                END LOOP;
                v_pay_mode := rec_a.pay_mode;
            END IF;
            
            v_check_class   := rec_a.check_class;
            v_check_no      := rec_a.check_no;
            v_check_date    := rec_a.check_date;
            v_currency_cd   := rec_a.currency_cd;  
            v_currency_rt   := rec_a.convert_rate; 
            v_fc_amt        := rec_a.or_colln_amt;
            v_or_colln_amt  := v_fc_amt * v_currency_rt;
            --nieko end
        
            v_or_colln_amt := rec_a.or_colln_amt;
            v_particulars := '-';
            variables_max_colln_amt := 0;
            variables_max_iss_cd		:= NULL;
            variables_max_prem_seq_no	:= NULL;
    	
            --variables for giac_acctrans			
            SELECT acctran_tran_id_s.NEXTVAL
              INTO variables_tran_id
              FROM SYS.DUAL;
    			
              variables_tran_date := to_date(p_or_date ||' '||to_char(SYSDATE,'HH:MI:SS AM'), 'MM-DD-YYYY HH:MI:SS AM');
              v_tran_year   := to_number(to_char(to_date(p_or_date, 'mm-dd-yyyy'),'YYYY'));
              v_tran_month  := to_number(to_char(to_date(p_or_date, 'mm-dd-yyyy'),'MM'));
              v_tran_seq_no := giac_sequence_generation(variables_fund_cd, variables_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', v_tran_year, v_tran_month);

              INSERT INTO giac_acctrans
                    (tran_id,              gfun_fund_cd,       gibr_branch_cd, 
                     tran_date,            tran_flag,          tran_year, 
                     tran_month,           tran_seq_no,        tran_class, 
                     tran_class_no,        user_id,            last_update)
                VALUES
                    (variables_tran_id,    variables_fund_cd,  variables_branch_cd, 
                     variables_tran_date,  v_tran_flag,        v_tran_year,
                     v_tran_month,         v_tran_seq_no,	   v_tran_class,       
                     v_tran_class_no,      variables_user_id,  SYSDATE);

                INSERT INTO giac_order_of_payts
                        (gacc_tran_id,         gibr_gfun_fund_cd,  gibr_branch_cd,       payor, 
                         or_date,              cashier_cd,         dcb_no,               or_flag, 
                         particulars,          collection_amt,     currency_cd,          gross_amt, 
                         gross_tag,            upload_tag,         user_id,              last_update)
                    VALUES
                        (variables_tran_id,    variables_fund_cd,  variables_branch_cd,  rec_a.payor,
                         variables_tran_date,  v_cashier_cd,       variables_dcb_no,     'N', 
                         v_particulars,        v_or_colln_amt,     v_currency_cd,        v_or_colln_amt, 
                         'Y', 	               'Y',                variables_user_id,    SYSDATE);                            
            
                --nieko Accounting Uploading GIACS604, copied from giacs603_pkg
                INSERT INTO giac_collection_dtl
                        (gacc_tran_id, item_no, currency_cd, currency_rt, pay_mode,
                         amount, particulars, bank_cd,
                         fcurrency_amt, gross_amt, fc_gross_amt, due_dcb_no,
                         due_dcb_date, user_id, last_update,
                         check_date,    dcb_bank_cd, dcb_bank_acct_cd,
                         check_class, check_no
                        )
                 VALUES (variables_tran_id, 1, v_currency_cd, v_currency_rt, v_pay_mode,
                         v_or_colln_amt, NULL,
                         DECODE (INSTR ('CHK, CC, CM', v_pay_mode), 0, NULL, v_bank_cd),
                         v_fc_amt, v_or_colln_amt, v_fc_amt, variables_dcb_no,
                         TRUNC (variables_tran_date), variables_user_id, SYSDATE,
                         DECODE (v_utility_tag,
                                 'N', DECODE (v_pay_mode, 'CHK', v_check_date, NULL),
                                 p_payment_date
                                ),
                         p_dcb_bank_cd, p_dcb_bank_acct_cd,
                         DECODE (INSTR ('CHK', v_pay_mode), 0, NULL, v_check_class),
                         DECODE (INSTR ('CHK, CC', v_pay_mode), 0, NULL, v_check_no)
                        );

                --generate acct entries for the O.R.
                upload_dpc_web.aeg_parameters(variables_tran_id, variables_branch_cd, variables_fund_cd, 'GIACS001', variables_user_id); --nieko Accounting Uploading GIACS604

                --*Process the payments for premium collns, prem deposit, etc.*--
                giacs604_pkg.process_payments(rec_a.payor); --nieko Accounting Uploading GIACS604

                --update the table giac_upload_prem_atm
                UPDATE giac_upload_prem_atm
                   SET tran_id = variables_tran_id,
                       tran_date = variables_tran_date
                 WHERE source_cd = p_source_cd 
                   AND file_no = p_file_no 
                   AND payor = rec_a.payor;	   				   		

		END LOOP rec_a;
        
        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;
         
		DELETE FROM giac_upload_jv_payt_dtl
		 WHERE source_cd = p_source_cd
   		   AND file_no = p_file_no;

		--update the table giac_upload_file
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_class = v_tran_class,
               tran_date = TRUNC (variables_tran_date)
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;
           
     END LOOP;        
   END;
   
   PROCEDURE process_payments (
        p_payor  giac_order_of_payts.payor%TYPE
   )
   IS
        v_rowcount 	 			NUMBER; 
        v_bill_no				giac_upload_prem_atm.bill_no%TYPE;
        v_iss_cd				giac_upload_prem_atm.iss_cd%TYPE;
        v_prem_seq_no			giac_upload_prem_atm.prem_seq_no%TYPE;
        v_policy_no				giac_upload_prem_atm.policy_no%TYPE;
        v_payor					giac_upload_prem_atm.payor%TYPE;
        v_prem_chk_flag			giac_upload_prem_atm.prem_chk_flag%TYPE;
        v_collection_amt		giac_upload_prem_atm.collection_amt%TYPE;
        v_net_amt_due			giac_upload_prem_atm.net_amt_due%TYPE;
        v_payment_details		VARCHAR2(500);	

        v_acct_payable_min  	NUMBER := giacp.n('ACCTS_PAYABLE_MIN');
        v_premcol_exp_max   	NUMBER := giacp.n('PREMCOL_EXP_MAX');
        v_sl_cd					giac_acct_entries.sl_cd%TYPE;
        v_aeg_item_no       	giac_module_entries.item_no%TYPE;
        v_prem_dep_amt      	giac_upload_prem_atm.collection_amt%TYPE := 0;
        v_acct_payable_amt      giac_upload_prem_atm.collection_amt%TYPE := 0;
        v_other_income_amt      giac_upload_prem_atm.collection_amt%TYPE := 0;
        v_other_expense_amt     giac_upload_prem_atm.collection_amt%TYPE := 0;
        v_dummy_expense_amt     giac_upload_prem_atm.collection_amt%TYPE;
        v_rem_colln_amt		  	giac_upload_prem_atm.collection_amt%TYPE;
        v_dummy_prem_chk_flag	giac_upload_prem_atm.prem_chk_flag%TYPE;

        v_policy_ctr        NUMBER := 0;
        v_assd_no		    NUMBER;
        v_intm_no           giac_order_of_payts.intm_no%TYPE;
        v_particulars	    giac_order_of_payts.particulars%TYPE := '-';
   BEGIN
        FOR i IN(
            SELECT *
              FROM giac_upload_prem_atm
             WHERE source_cd = variables_source_cd 
               AND file_no = variables_file_no
        )
        LOOP
            v_payor := i.payor;
            IF NVL(p_payor, v_payor) = v_payor THEN
                v_bill_no := i.bill_no;
                v_iss_cd  := i.iss_cd;
                v_prem_seq_no := i.prem_seq_no;
                v_policy_no := i.policy_no;
                v_prem_chk_flag := i.prem_chk_flag;
                v_collection_amt := i.collection_amt;
                v_net_amt_due := i.net_amt_due;
                
                IF v_prem_chk_flag IN ('SP','RI','EX','NA','NE') THEN --premium deposit
                    v_prem_dep_amt := v_prem_dep_amt + v_collection_amt;                
                ELSE --premium collection
                    IF v_net_amt_due < 0 AND v_prem_chk_flag IN  ('OP','OC') THEN
                        IF v_collection_amt >= v_acct_payable_min THEN
                            --accounts payable
                            v_sl_cd := get_pol_assd_no(v_iss_cd,v_prem_seq_no);
                            IF v_prem_chk_flag = 'OP' THEN
                                v_aeg_item_no := 1;
                            ELSE --'OC'
                                v_aeg_item_no := 8;
                            END IF;    
                            v_acct_payable_amt := v_acct_payable_amt + v_collection_amt;
                        ELSE
                            --other income
                            v_sl_cd := giacp.n('OTHER_INCOME_SL');
                            IF v_prem_chk_flag = 'OP' THEN
                                v_aeg_item_no := 2;
                            ELSE --'OC'
                                v_aeg_item_no := 9;
                            END IF;    
                            v_other_income_amt := v_other_income_amt + v_collection_amt;
                        END IF;                
                        upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS604', v_aeg_item_no, v_collection_amt, v_sl_cd, variables_user_id);                        
                    ELSIF v_prem_chk_flag IN ('OK','WC','PT','PC','OP','OC') THEN
                      v_dummy_prem_chk_flag    := v_prem_chk_flag;
                      v_dummy_expense_amt := 0;
        
                        --if partial payt and the diff is <= v_premcol_exp_max then pay the full amt and generate other expense
                        IF v_prem_chk_flag IN ('PT','PC') AND (v_net_amt_due - v_collection_amt <= v_premcol_exp_max) THEN
                            v_dummy_prem_chk_flag := 'OK';
                            v_dummy_expense_amt := v_net_amt_due - v_collection_amt;
                            --other expense
                            v_sl_cd := giacp.n('OTHER_EXPENSE_SL');
                            IF v_prem_chk_flag = 'PT' THEN
                                v_aeg_item_no := 14;
                            ELSE --'PC'
                                v_aeg_item_no := 15;
                            END IF;
                            upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS604', v_aeg_item_no, v_dummy_expense_amt, v_sl_cd, variables_user_id);
                            v_other_expense_amt := v_other_expense_amt + v_dummy_expense_amt;
                        END IF;
        
                        --insert the payment for the bills of the policy in giac_direct_prem_collns                
                        insert_premium_collns(v_iss_cd, v_prem_seq_no, v_collection_amt + v_dummy_expense_amt, v_dummy_prem_chk_flag, v_rem_colln_amt);
        
                        --determine the acct entry to be generated for the remaining amount
                        IF v_prem_chk_flag IN ('OP','OC') THEN
                            IF v_rem_colln_amt >= v_acct_payable_min THEN
                                --accounts payable
                                v_sl_cd := get_pol_assd_no(v_iss_cd,v_prem_seq_no);
                                IF v_prem_chk_flag = 'OP' THEN
                                    v_aeg_item_no := 1;
                                ELSE --'OC'
                                    v_aeg_item_no := 8;
                                END IF;
                                v_acct_payable_amt := v_acct_payable_amt + v_rem_colln_amt;
                            ELSE
                                --other income
                                v_sl_cd := giacp.n('OTHER_INCOME_SL');
                                IF v_prem_chk_flag = 'OP' THEN
                                    v_aeg_item_no := 2;
                                ELSE --'OC'
                                    v_aeg_item_no := 9;
                                END IF;
                                v_other_income_amt := v_other_income_amt + v_rem_colln_amt;
                            END IF;
                            upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS604', v_aeg_item_no, v_rem_colln_amt, v_sl_cd, variables_user_id);                            
                        END IF;
                    ELSE -- 'FP','CP','SL','FC'
                        IF v_prem_chk_flag = 'FP' THEN        
                            v_aeg_item_no := 3;
                        ELSIF v_prem_chk_flag = 'CP' THEN
                            v_aeg_item_no := 4;
                        ELSIF v_prem_chk_flag = 'SL' THEN
                            v_aeg_item_no := 5;
                        ELSIF v_prem_chk_flag = 'FC' THEN
                            v_aeg_item_no := 10;
                        END IF;    
                        --accounts payable
                        v_sl_cd := get_pol_assd_no(v_iss_cd, v_prem_seq_no);
                        upload_dpc_web.aeg_parameters_misc(variables_tran_id, 'GIACS604', v_aeg_item_no, v_collection_amt, v_sl_cd, variables_user_id);
                        v_acct_payable_amt := v_acct_payable_amt + v_collection_amt;
                    END IF;

                    IF variables_tran_class = 'COL' THEN
                        v_policy_ctr := v_policy_ctr + 1;
                        IF v_policy_ctr = 1 THEN
                            --get the address of the latest endt IF payment is for one policy only
                            FOR addr IN (SELECT address1 add1,address2 add2,address3 add3
                                                         FROM gipi_polbasic gpol, gipi_invoice ginv
                                                        WHERE gpol.address1 IS NOT NULL
                                                          AND gpol.policy_id = ginv.policy_id
                                                             AND ginv.iss_cd = v_iss_cd
                                                             AND ginv.prem_seq_no = v_prem_seq_no
                                                         ORDER BY endt_seq_no DESC)
                             LOOP
                                 UPDATE giac_order_of_payts
                                    SET address_1 = addr.add1, 
                                        address_2 = addr.add2,
                                        address_3 = addr.add3
                                 WHERE gacc_tran_id = variables_tran_id;
                                EXIT;
                             END LOOP addr;
                            
                            v_assd_no := get_pol_assd_no(v_iss_cd,v_prem_seq_no);
        
                            FOR tin_rec IN (SELECT assd_tin
                                                                FROM giis_assured
                                                             WHERE assd_tin IS NOT NULL
                                                               AND assd_no = v_assd_no)
                            LOOP
                                 UPDATE giac_order_of_payts
                                    SET tin = tin_rec.assd_tin 
                                 WHERE gacc_tran_id = variables_tran_id;
                                EXIT;
                            END LOOP;                                                                                               
                        ELSIF    v_policy_ctr = 2 THEN
                           --set the address to null IF payment is more than one policy
                            UPDATE giac_order_of_payts
                               SET address_1 = NULL, 
                                   address_2 = NULL,
                                   address_3 = NULL
                              WHERE gacc_tran_id = variables_tran_id;
                        END IF;              
                    END IF; --:guf.dsp_tran_class = 'COL'
                END IF;    --v_prem_chk_flag IN ('SP','RI','EX','NA','NE')
            END IF;
        END LOOP;
        
        /*
        ** nieko Accounting Uploading GIACS604 
        */
        upload_dpc_web.set_fixed_variables (variables_fund_cd, variables_branch_cd, variables_evat_cd);
       --generate the acct entries for the premium collns
        upload_dpc_web.gen_dpc_acct_entries(variables_tran_id, 'GIACS007', variables_user_id);            
        --generate the op_text
        gen_dpc_op_text;
            
        IF v_prem_dep_amt <> 0 THEN
            insert_prem_deposit(v_prem_dep_amt);
            upload_dpc_web.aeg_parameters_pdep(variables_tran_id, 'GIACS026', variables_user_id);
            gen_prem_dep_op_text;
        END IF;
            
        --generate op_text for accounts payable
        IF v_acct_payable_amt <> 0 THEN
            gen_misc_op_text('ACCOUNTS PAYABLE', v_acct_payable_amt); 
        END IF;
        --generate op_text for other income
        IF v_other_income_amt <> 0 THEN
            gen_misc_op_text('OTHER INCOME', v_other_income_amt);
        END IF;
        --generate op_text for other expense
        IF v_other_expense_amt <> 0 THEN
            gen_misc_op_text('OTHER EXPENSE', v_other_expense_amt * -1); 
        END IF;
        
        IF variables_tran_class = 'COL' THEN
            --get the intermediary number of the bill with the maximum collection amt    
            IF variables_max_colln_amt <> 0 THEN            
                BEGIN
                  SELECT intrmdry_intm_no
                    INTO v_intm_no
                    FROM gipi_comm_invoice
                   WHERE prem_seq_no = variables_max_prem_seq_no
                     AND iss_cd      = variables_max_iss_cd;
                EXCEPTION
                WHEN OTHERS THEN
                      v_intm_no := NULL;
                END;
            END IF;
            
            --update the intm_no and particulars of the O.R.
            v_particulars := get_or_particulars (variables_tran_id, v_acct_payable_amt, v_prem_dep_amt);
            UPDATE giac_order_of_payts
               SET particulars = v_particulars,
                   intm_no = v_intm_no
             WHERE gacc_tran_id = variables_tran_id;
            
            --update the particulars of the collection detail
            v_payment_details := get_payment_details_prc (NULL, NULL, NULL, NULL, NULL, NULL, p_payor, variables_source_cd , variables_file_no);        
            UPDATE giac_collection_dtl
               SET particulars = v_payment_details
             WHERE gacc_tran_id = variables_tran_id
               AND item_no = 1;
        END IF; 
        /*
        ** nieko end
        */        
   END;
   
    FUNCTION get_pol_assd_no (
        p_iss_cd        gipi_invoice.iss_cd%TYPE,
        p_prem_seq_no	gipi_invoice.prem_seq_no%TYPE
    )
    RETURN NUMBER 
    IS
        v_assd_no giis_assured.assd_no%TYPE;
    BEGIN
        FOR assd_rec IN (
            SELECT gpol.assd_no, gpol.par_id
              FROM gipi_polbasic gpol, gipi_invoice ginv
             WHERE gpol.policy_id = ginv.policy_id
               AND ginv.iss_cd = p_iss_cd
               AND ginv.prem_seq_no = p_prem_seq_no
        )
        LOOP	
            v_assd_no := assd_rec.assd_no;
            IF v_assd_no IS NULL THEN
                FOR assd_rec2 IN (
                    SELECT assd_no
                      FROM gipi_parlist
                     WHERE par_id = assd_rec.par_id
                )
                LOOP
                    v_assd_no := assd_rec2.assd_no;
                END LOOP;
            END IF;
            EXIT;
        END LOOP;

        RETURN(v_assd_no);
    END;
    
    
    PROCEDURE insert_premium_collns (
        p_iss_cd                      gipi_invoice.iss_cd%TYPE,
        p_prem_seq_no          gipi_invoice.prem_seq_no%TYPE,
        p_collection_amt       giac_direct_prem_collns.collection_amt%TYPE,
        p_prem_chk_flag        giac_upload_prem_atm.prem_chk_flag%TYPE,
        p_rem_colln_amt   OUT  giac_direct_prem_collns.collection_amt%TYPE
    ) 
    IS
        v_colln_amt         NUMBER := 0;
        v_rem_colln_amt     NUMBER := 0;
        v_assd_no           giis_assured.assd_no%TYPE;
        v_ins_colln_amt     NUMBER := 0;

    BEGIN
        v_rem_colln_amt := p_collection_amt;

        --get the bills of the policy where the collection will be distributed
        FOR rec IN (
              SELECT c.iss_cd, c.prem_seq_no, c.inst_no, c.balance_amt_due,
                     c.prem_balance_due, c.tax_balance_due, b.currency_cd, b.currency_rt,
                     a.booking_mth, a.booking_year, a.acct_ent_date, a.assd_no,
                     a.policy_id, a.par_id, a.reg_policy_sw
                FROM gipi_installment d,
                     giac_aging_soa_details c,
                     gipi_polbasic a,
                     gipi_invoice b
               WHERE 1 = 1
                 AND c.iss_cd = d.iss_cd
                 AND c.prem_seq_no = d.prem_seq_no
                 AND c.inst_no = d.inst_no
                 AND c.balance_amt_due <> 0
                 AND b.iss_cd = c.iss_cd
                 AND b.prem_seq_no = c.prem_seq_no
                 AND a.policy_id = b.policy_id
                 AND b.iss_cd = p_iss_cd
                 AND b.prem_seq_no = p_prem_seq_no
            ORDER BY 1, 2, 3
        )
        LOOP
             IF rec.reg_policy_sw <> 'N' OR (rec.reg_policy_sw = 'N' AND variables_prem_payt_for_sp = 'Y') THEN                        

                IF rec.assd_no IS NULL THEN
                  BEGIN
                    SELECT assd_no
                      INTO v_assd_no
                      FROM gipi_parlist
                     WHERE par_id = rec.par_id;
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        raise_application_error (-20001, 'Geniisys Exception#I#'||rec.iss_cd||'-'||to_char(rec.prem_seq_no)||' has no assured.');
                  END;
                END IF;
        
                --determine the tran type
                IF rec.balance_amt_due > 0 THEN
                  variables_transaction_type := 1;
                ELSE
                  variables_transaction_type := 3;
                END IF;
                
                --get the amt to be used for the bill
                IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC') THEN
                    v_colln_amt := rec.balance_amt_due;
                ELSE
                    IF v_rem_colln_amt < rec.balance_amt_due THEN
                        v_colln_amt := v_rem_colln_amt;
                    ELSE
                        v_colln_amt := rec.balance_amt_due;
                    END IF;                
                END IF;
        
                --initialize the variables
                variables_iss_cd      := rec.iss_cd;
                variables_prem_seq_no := rec.prem_seq_no;
                variables_inst_no     := rec.inst_no;    
                
                variables_max_collection_amt := rec.balance_amt_due;
                variables_max_premium_amt    := rec.prem_balance_due;
                variables_max_tax_amt        := rec.tax_balance_due;
        
                variables_collection_amt := v_colln_amt;
                variables_currency_cd    := rec.currency_cd;
                variables_convert_rate   := rec.currency_rt;
                
                --derive the premium and tax amts from the collection amt
                with_tax_allocation;
                
                --if it is an advanced payment, insert record in giac_advanced_payt
                IF to_date('01-'||rec.booking_mth||'-'||rec.booking_year,'DD-MON-YYYY') > variables_tran_date AND
                   rec.acct_ent_date IS NULL THEN
                    INSERT INTO giac_advanced_payt
                                (gacc_tran_id, policy_id, transaction_type,
                                 iss_cd, prem_seq_no, inst_no,
                                 premium_amt, tax_amt, booking_mth,
                                 booking_year, assd_no,
                                 user_id, last_update
                                )
                         VALUES (variables_tran_id, rec.policy_id, variables_transaction_type,
                                 variables_iss_cd, variables_prem_seq_no, variables_inst_no,
                                 variables_premium_amt, variables_tax_amt, rec.booking_mth,
                                 rec.booking_year, NVL (rec.assd_no, v_assd_no),
                                 variables_user_id, SYSDATE
                                );
                END IF;   
        
                INSERT INTO giac_direct_prem_collns
                            (gacc_tran_id, transaction_type, b140_iss_cd,
                             b140_prem_seq_no, inst_no,
                             collection_amt, premium_amt,
                             tax_amt, or_print_tag, currency_cd,
                             convert_rate, foreign_curr_amt,
                             user_id, last_update
                            )
                     VALUES (variables_tran_id, variables_transaction_type, variables_iss_cd,
                             variables_prem_seq_no, variables_inst_no,
                             variables_collection_amt, variables_premium_amt,
                             variables_tax_amt, 'N', variables_currency_cd,
                             variables_convert_rate, variables_foreign_curr_amt,
                             variables_user_id, SYSDATE
                            );
                
                --Populate these variables which will be used later to get the intermediary
                --of the bill with the greatest collection amt
                IF variables_tran_class = 'COL' AND variables_max_colln_amt < v_colln_amt THEN
                    variables_max_colln_amt     := v_colln_amt;
                    variables_max_iss_cd        := variables_iss_cd;
                    variables_max_prem_seq_no   := variables_prem_seq_no;
                END IF;            
        
                IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC') THEN
                        v_ins_colln_amt := v_ins_colln_amt + v_colln_amt;
                ELSE
                    v_rem_colln_amt := v_rem_colln_amt - v_colln_amt;
                END IF;    

            END IF; --rec.reg_policy_sw <> 'N'...

            --exit if the collection amt has been fully distributed
            IF v_rem_colln_amt = 0 THEN            
                EXIT;
            END IF;    
        END LOOP;

        IF p_prem_chk_flag IN ('OK', 'WC', 'OP', 'OC') THEN
          p_rem_colln_amt    := v_rem_colln_amt - v_ins_colln_amt;
        ELSE    
            p_rem_colln_amt := v_rem_colln_amt;
        END IF;
    END;
    
    
    --Vincent 02132006: recompute amounts (based from validations of GIACS007, with_tax_allocation)
    PROCEDURE with_tax_allocation
    IS
      vl_lt            NUMBER;
      v_prem           giac_direct_prem_collns.premium_amt%TYPE;
      v_name           VARCHAR2 (50) := 'PREM_TAX_PRIORITY';
      v_the_priority   VARCHAR2 (1);
    BEGIN
      v_prem := 0;
      /* Determine which is the priority between premium and tax amount
      ** in which the collection will be allocated.
      */
        v_the_priority := giacp.v(v_name);
      IF v_the_priority IS NULL THEN
            raise_application_error (-20001, 'Geniisys Exception#E#There is no existing '|| v_name|| ' parameter in GIAC_PARAMETERS table.');
      END IF;

      /* Recompute premium amount and tax amount based on the collection amount entered */
        IF v_the_priority = 'P' THEN
          /*
          ** Premium amount has higher priority than tax amount
          */
        IF nvl(variables_collection_amt, 0) = variables_max_collection_amt THEN
                variables_premium_amt := variables_max_premium_amt;
                variables_tax_amt     := variables_max_tax_amt;
            ELSIF abs(nvl(variables_collection_amt, 0)) <= abs(nvl(variables_max_premium_amt, 0)) THEN
                variables_premium_amt := variables_collection_amt;
                variables_tax_amt     := 0;
            ELSE
                variables_premium_amt := variables_max_premium_amt;
                variables_tax_amt     := nvl(variables_collection_amt,0) - nvl(variables_max_premium_amt,0);
        END IF;
        ELSE
        /*
        ** Tax amount has higher priority than premium amount
        */
        IF nvl(variables_collection_amt, 0) = variables_max_collection_amt THEN
                variables_premium_amt := variables_max_premium_amt;
                variables_tax_amt     := variables_max_tax_amt;
            ELSIF abs(nvl(variables_collection_amt, 0)) <= abs(variables_max_tax_amt) THEN
                variables_premium_amt := 0;
                variables_tax_amt     := variables_collection_amt;
            ELSE
                variables_premium_amt := nvl(variables_collection_amt, 0) - nvl(variables_max_tax_amt, 0);
                variables_tax_amt     := variables_max_tax_amt;
        END IF;
      END IF;
     
        variables_foreign_curr_amt := nvl(variables_collection_amt,0) / variables_convert_rate;

      -- Call procedure for the tax breakdown --
      IF variables_tax_amt = 0 THEN
            variables_premium_amt := variables_collection_amt;
            variables_tax_amt     := 0;
      ELSE 
          IF variables_transaction_type = 1 THEN
                upload_dpc_web.tax_alloc_type1(variables_tran_id,
                                               variables_transaction_type,
                                               variables_iss_cd,
                                               variables_prem_seq_no,
                                               variables_inst_no,
                                               variables_collection_amt,
                                               variables_premium_amt,
                                               variables_tax_amt,
                                               variables_max_premium_amt,
                                               variables_user_id,
                                               SYSDATE
                                               );
          ELSIF variables_transaction_type = 3 THEN 
                upload_dpc_web.tax_alloc_type3(variables_tran_id,
                                               variables_transaction_type,
                                               variables_iss_cd,
                                               variables_prem_seq_no,
                                               variables_inst_no,
                                               variables_collection_amt,
                                               variables_premium_amt,
                                               variables_tax_amt,
                                               variables_max_premium_amt,
                                               variables_user_id,
                                               SYSDATE
                                              );
          END IF;
        END IF;
    END with_tax_allocation;
    
    PROCEDURE gen_dv (
        p_source_cd     VARCHAR2, 
        p_file_no       VARCHAR2
    )
    IS
        the_rowcount                  NUMBER; 

        --acctrans
        v_tran_flag         giac_acctrans.tran_flag%TYPE;
        v_tran_class        giac_acctrans.tran_class%TYPE;  
        v_tran_date         giac_acctrans.tran_date%TYPE;

        --giac_payt_requests
        v_gouc_ouc_id       giac_payt_requests.gouc_ouc_id%TYPE;
        v_ref_id            giac_payt_requests.ref_id%TYPE;
        v_document_cd       giac_payt_requests.document_cd%TYPE;
        v_branch_cd         giac_payt_requests.branch_cd%TYPE;
        v_doc_seq_no        giac_payt_requests.doc_seq_no%TYPE;    
        v_request_date      giac_payt_requests.request_date%TYPE;
        v_dv_line_cd        giac_payt_requests.line_cd%TYPE;
        v_doc_year          giac_payt_requests.doc_year%TYPE;
        v_doc_mm            giac_payt_requests.doc_mm%TYPE;
        
        --giac_payt_requests_dtl
        v_req_dtl_no        giac_payt_requests_dtl.req_dtl_no%TYPE := 1;
        v_payee_class_cd    giac_payt_requests_dtl.payee_class_cd%TYPE;
        v_payee_cd          giac_payt_requests_dtl.payee_cd%TYPE;
        v_payee             giac_payt_requests_dtl.payee%TYPE;
        v_currency_cd       giac_payt_requests_dtl.currency_cd%TYPE;
        v_currency_rt       giac_payt_requests_dtl.currency_rt%TYPE;
        v_dv_fcurrency_amt  giac_payt_requests_dtl.payt_amt%TYPE;
        v_payt_amt          giac_payt_requests_dtl.payt_amt%TYPE;
        v_particulars       giac_payt_requests_dtl.particulars%TYPE;

    BEGIN
        SELECT COUNT (*)
          INTO the_rowcount
          FROM giac_upload_prem_atm
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        IF the_rowcount = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#No records found for upload.');
        END IF;  
        
        --get the values to be used
        BEGIN
            SELECT request_date, gouc_ouc_id, document_cd, branch_cd,
                   line_cd, doc_year, doc_mm, payee_class_cd, payee_cd,
                   payee, currency_cd, currency_rt, dv_fcurrency_amt, payt_amt,
                   particulars
              INTO v_request_date, v_gouc_ouc_id, v_document_cd, v_branch_cd,
                   v_dv_line_cd, v_doc_year, v_doc_mm, v_payee_class_cd, v_payee_cd,
                   v_payee, v_currency_cd, v_currency_rt, v_dv_fcurrency_amt, v_payt_amt,
                   v_particulars
              FROM giac_upload_dv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --raise_application_error (-20001, 'Geniisys Exception#E#No data found in table: giac_upload_dv_payt_dtl.'); --nieko Accounting Uploading GIACS604, rephrased message
                raise_application_error (-20001, 'Geniisys Exception#E#Please provide DV payment details');
        END; 
        
        --*insert in giac_acctrans*--
        SELECT acctran_tran_id_s.NEXTVAL
          INTO variables_tran_id
          FROM sys.dual;
                        
        v_tran_flag  := 'O';
        v_tran_class := 'DV';
        variables_tran_date := v_request_date;
        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd, tran_flag,
                     tran_date, tran_class, user_id, last_update
                    )
             VALUES (variables_tran_id, variables_fund_cd, v_branch_cd, v_tran_flag,
                     variables_tran_date, v_tran_class, variables_user_id, SYSDATE
                    );
        
        --*insert in giac_payt_requests*--
        SELECT gprq_ref_id_s.NEXTVAL
          INTO v_ref_id
          FROM SYS.DUAL;
          
        INSERT INTO giac_payt_requests
                    (gouc_ouc_id, ref_id, fund_cd, branch_cd,
                     document_cd, request_date, line_cd, doc_year,
                     doc_mm, with_dv, upload_tag, create_by, user_id, last_update
                    )
             VALUES (v_gouc_ouc_id, v_ref_id, variables_fund_cd, v_branch_cd,
                     v_document_cd, v_request_date, v_dv_line_cd, v_doc_year,
                     v_doc_mm, 'N', 'Y', variables_user_id, variables_user_id, SYSDATE
                    );
                    
        --*insert in giac_payt_requests_dtl*--
        INSERT INTO giac_payt_requests_dtl
                    (req_dtl_no, gprq_ref_id, payee_class_cd, payt_req_flag,
                     payee_cd, payee, currency_cd, currency_rt,
                     dv_fcurrency_amt, payt_amt, tran_id,
                     particulars, user_id, last_update
                    )
             VALUES (v_req_dtl_no, v_ref_id, v_payee_class_cd, 'N',
                     v_payee_cd, v_payee, v_currency_cd, v_currency_rt,
                     v_dv_fcurrency_amt, v_payt_amt, variables_tran_id,
                     v_particulars, variables_user_id, SYSDATE
                    );
                    
        BEGIN
           SELECT doc_seq_no
             INTO v_doc_seq_no
             FROM giac_payt_requests
            WHERE ref_id = v_ref_id;
        EXCEPTION
           WHEN OTHERS THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Error retrieving DOC_SEQ_NO.');
        END;
        
        --*Process the payments for premium collns, prem deposit, etc.*--
        giacs604_pkg.process_payments(NULL);
        
        --update the table giac_upload_dv_payt_dtl
        UPDATE giac_upload_dv_payt_dtl
           SET doc_seq_no = v_doc_seq_no
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;

       --delete record from table giac_upload_jv_payt_dtl since dv was created
        DELETE FROM giac_upload_jv_payt_dtl
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;

        --update the table giac_upload_prem_atm
        UPDATE giac_upload_prem_atm
           SET tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;

        --update the table giac_upload_file
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_class = v_tran_class,
               tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
         
    END;
    
    PROCEDURE gen_jv (
        p_source_cd     VARCHAR2, 
        p_file_no       VARCHAR2
    )
    IS
        the_rowcount 	 			NUMBER; 

        --acctrans
        v_branch_cd     giac_acctrans.gibr_branch_cd%TYPE;
        v_tran_year     giac_acctrans.tran_year%TYPE;
        v_tran_month    giac_acctrans.tran_month%TYPE;
        v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
        v_tran_date     giac_acctrans.tran_date%TYPE;
        v_jv_pref_suff  giac_acctrans.jv_pref_suff%TYPE;  
        v_jv_no         giac_acctrans.jv_no%TYPE;  
        v_particulars   giac_acctrans.particulars%TYPE;
        v_jv_tran_tag   giac_acctrans.jv_tran_tag%TYPE;
        v_jv_tran_type  giac_acctrans.jv_tran_type%TYPE;
        v_jv_tran_mm    giac_acctrans.jv_tran_mm%TYPE;
        v_jv_tran_yy    giac_acctrans.jv_tran_yy%TYPE;
        v_tran_flag     giac_acctrans.tran_flag%TYPE;
        v_tran_class    giac_acctrans.tran_class%TYPE;  
        v_tran_class_no giac_acctrans.tran_class_no%TYPE;
    BEGIN
        SELECT COUNT (*)
          INTO the_rowcount
          FROM giac_upload_prem_atm
         WHERE source_cd = p_source_cd
           AND file_no = p_file_no;
           
        IF the_rowcount = 0 THEN
            raise_application_error (-20001, 'Geniisys Exception#E#No records found for upload.');
        END IF; 
        
        --get the values to be used
        BEGIN
            SELECT branch_cd, tran_date, tran_year, tran_month, jv_pref_suff,
                   particulars, jv_tran_tag, jv_tran_type, jv_tran_mm,
                   jv_tran_yy
              INTO v_branch_cd, v_tran_date, v_tran_year, v_tran_month, v_jv_pref_suff,
                   v_particulars, v_jv_tran_tag, v_jv_tran_type, v_jv_tran_mm,
                   v_jv_tran_yy
              FROM giac_upload_jv_payt_dtl
             WHERE source_cd = p_source_cd 
               AND file_no = p_file_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --raise_application_error (-20001, 'Geniisys Exception#E#No data found in table: giac_upload_jv_payt_dtl.'); --nieko Accounting Uploading GIACS604, rephrased message
                raise_application_error (-20001, 'Geniisys Exception#E#Please provide JV payment details');
        END; 
        
        --*insert in giac_acctrans*--
        SELECT acctran_tran_id_s.NEXTVAL
          INTO variables_tran_id
          FROM SYS.DUAL;
          
        v_tran_flag     := 'O';
        v_tran_class    := 'JV';
        v_tran_class_no := giac_sequence_generation(variables_fund_cd, v_branch_cd, v_tran_class, v_tran_year, v_tran_month);
        v_jv_no    := v_tran_class_no;    
        variables_tran_date := v_tran_date;
        
        INSERT INTO giac_acctrans
                    (tran_id, gfun_fund_cd, gibr_branch_cd, tran_flag,
                     tran_date, tran_year, tran_month, tran_class,
                     tran_class_no, jv_pref_suff, jv_no, particulars,
                     jv_tran_tag, jv_tran_type, jv_tran_mm, jv_tran_yy, ae_tag,
                     upload_tag, user_id, last_update
                    )
             VALUES (variables_tran_id, variables_fund_cd, v_branch_cd, v_tran_flag,
                     v_tran_date, v_tran_year, v_tran_month, v_tran_class,
                     v_tran_class_no, v_jv_pref_suff, v_jv_no, v_particulars,
                     v_jv_tran_tag, v_jv_tran_type, v_jv_tran_mm, v_jv_tran_yy, 'N',
                     'Y', variables_user_id, SYSDATE
                    );
                    
        --*Process the payments for premium collns, prem deposit, etc.*--
        process_payments(NULL);
        
        /* Formatted on 2015/09/16 13:56 (Formatter Plus v4.8.8) */
        --update the table giac_upload_jv_payt_dtl
        UPDATE giac_upload_jv_payt_dtl
           SET jv_no = v_jv_no
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;

        --delete record from table giac_upload_dv_payt_dtl since jv was created
        DELETE FROM giac_upload_dv_payt_dtl
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;

        --update the table giac_upload_prem_atm
        UPDATE giac_upload_prem_atm
           SET tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;

        --update the table giac_upload_file
        UPDATE giac_upload_file
           SET upload_date = SYSDATE,
               file_status = 2,
               tran_class = v_tran_class,
               tran_id = variables_tran_id,
               tran_date = variables_tran_date
         WHERE source_cd = p_source_cd 
           AND file_no = p_file_no;
    END;
    
    PROCEDURE check_payment_details
    IS
    BEGIN
        IF variables_tran_class = 'DV' THEN
            FOR i IN(
                --BEGIN
                    SELECT *
                      FROM giac_upload_dv_payt_dtl
                     WHERE source_cd = variables_source_cd 
                       AND file_no = variables_file_no
                --EXCEPTION
                --    WHEN NO_DATA_FOUND THEN
                --        raise_application_error (-20001, 'Geniisys Exception#E#Please provide DV payment details');       
                --END;   
            )
            LOOP
                IF i.request_date IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Request date in the Payment Request Details is null.');
                ELSIF i.gouc_ouc_id IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Department in the Payment Request Details is null.');
                ELSIF i.document_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document code in the Payment Request Details is null.');
                ELSIF i.branch_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Branch code in the Payment Request Details is null.');
                ELSIF i.doc_year IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document year in the Payment Request Details is null.');
                ELSIF i.doc_mm IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Document month in the Payment Request Details is null.');
                ELSIF i.payee_class_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee class code in the Payment Request Details is null.');
                ELSIF i.payee_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee code in the Payment Request Details is null.');
                ELSIF i.payee IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payee in the Payment Request Details is null.');
                ELSIF i.currency_cd IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency code in the Payment Request Details is null.');
                ELSIF i.currency_rt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Currency rate in the Payment Request Details is null.');
                ELSIF i.dv_fcurrency_amt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                ELSIF i.payt_amt IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#E#Payment amount in the Payment Request Details is null.');
                ELSIF i.particulars    IS NULL THEN                               
                    raise_application_error (-20001, 'Geniisys Exception#E#Particulars in the Payment Request Details is null.');
                END IF;
            END LOOP;
            
        ELSIF variables_tran_class = 'JV' THEN
            FOR i IN(
                --BEGIN
                    SELECT *
                      FROM giac_upload_jv_payt_dtl
                     WHERE source_cd = variables_source_cd 
                       AND file_no = variables_file_no
                --EXCEPTION
                --   WHEN NO_DATA_FOUND THEN
                --       raise_application_error (-20001, 'Geniisys Exception#E#Please provide JV payment details');
                --END;   
            )
            LOOP
                IF i.tran_date IS NULL THEN 
                    raise_application_error (-20001, 'Geniisys Exception#Transaction date in the JV Details is null.');
                ELSIF i.branch_cd    IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#Branch code in the JV Details is null.');
                ELSIF i.tran_year    IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#Transaction year in the JV Details is null.');
                ELSIF i.tran_month IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#Transaction month in the JV Details is null.');
                ELSIF i.jv_pref_suff IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#JV prefix in the JV Details is null.');
                ELSIF i.particulars IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#Particulars in the JV Details is null.');      
                ELSIF i.jv_tran_tag IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#JV tran tag in the JV Details is null.');      
                ELSIF i.jv_tran_type IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#JV tran type in the JV Details is null.');      
                ELSIF i.particulars IS NULL THEN
                    raise_application_error (-20001, 'Geniisys Exception#Particulars in the JV Details is null.');      
                ELSIF i.jv_tran_tag = 'C' THEN
                    IF i.jv_tran_mm IS NULL THEN
                        raise_application_error (-20001, 'Geniisys Exception#JV tran month in the JV Details is null.');      
                    ELSIF i.jv_tran_yy IS NULL THEN
                        raise_application_error (-20001, 'Geniisys Exception#JV tran year in the JV Details is null.');      
                    END IF;
                END IF; 
            END LOOP;
        
        END IF;
    END;

    --nieko Accounting Uploading GIACS604 , copied from giacs603_pkg
    PROCEDURE gen_dpc_op_text
    IS
       CURSOR c IS
        SELECT a.b140_iss_cd iss_cd, a.b140_prem_seq_no prem_seq_no, a.inst_no,
               a.premium_amt, b.currency_cd, b.currency_rt
          FROM gipi_polbasic c, gipi_invoice b, giac_direct_prem_collns a
         WHERE a.b140_iss_cd = b.iss_cd
           AND a.b140_prem_seq_no = b.prem_seq_no
           AND b.iss_cd = c.iss_cd
           AND b.policy_id = c.policy_id
           AND gacc_tran_id = variables_tran_id;
    BEGIN
       BEGIN
          SELECT generation_type
            INTO variables_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS007';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error(-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;

        DELETE giac_op_text
         WHERE gacc_tran_id = variables_tran_id
           AND item_gen_type = variables_gen_type;

       variables_n_seq_no := 3;
       variables_zero_prem_op_text := 'Y';

       FOR c_rec IN c
       LOOP
          gen_dpc_op_text_prem (c_rec.iss_cd, c_rec.prem_seq_no,c_rec.inst_no,c_rec.premium_amt, c_rec.currency_cd, c_rec.currency_rt);
       END LOOP;

       variables_zero_prem_op_text := 'N';

     DELETE giac_op_text
      WHERE gacc_tran_id = variables_tran_id
        AND NVL (item_amt, 0) = 0
        AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd FROM giac_taxes)
        AND SUBSTR (item_text, 1, 9) <> 'PREMIUM ('
        AND item_gen_type = variables_gen_type;

       /*
       ** update giac_op_text
       ** where item_text = Taxes
       */
       UPDATE giac_op_text
          SET item_text = SUBSTR (item_text, 7, NVL (LENGTH (item_text), 0))
        WHERE gacc_tran_id = variables_tran_id
          AND LTRIM (SUBSTR (item_text, 1, 2), '0') IN (SELECT tax_cd FROM giac_taxes)
          AND SUBSTR (item_text, 1, 2) NOT IN ('CO', 'PR')
          AND item_gen_type = variables_gen_type;
    END;
    
    PROCEDURE insert_prem_deposit (
       p_collection_amt   giac_prem_deposit.collection_amt%TYPE
    )
    IS
    BEGIN
       INSERT INTO giac_prem_deposit
                   (gacc_tran_id, item_no, transaction_type, collection_amt,
                    dep_flag, currency_cd, convert_rate, foreign_curr_amt,
                    upload_tag, colln_dt, or_print_tag, or_tag,
                    user_id, last_update
                   )
            VALUES (variables_tran_id, 1, 1, p_collection_amt,
                    1, 1, 1, p_collection_amt,
                    'Y', TRUNC (variables_tran_date), 'N', 'N',
                    variables_user_id, SYSDATE
                   );
    END;
    
    PROCEDURE gen_prem_dep_op_text
    IS
       CURSOR c IS
          SELECT DISTINCT a.gacc_tran_id, a.collection_amt item_amt,
                 a.b140_iss_cd || '-' || LTRIM (TO_CHAR (a.b140_prem_seq_no, '09999999')) bill_no,
                 a.user_id, a.last_update, 'Premium Deposit' item_text,
                 a.currency_cd, a.foreign_curr_amt
            FROM giac_prem_deposit a
           WHERE gacc_tran_id = variables_tran_id;

       v_seq_no   giac_op_text.item_seq_no%TYPE   := 1;
    BEGIN
       BEGIN
          SELECT generation_type
            INTO variables_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS026';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;

       /* Remove first whatever records in giac_op_text. */
       DELETE FROM giac_op_text
             WHERE gacc_tran_id = variables_tran_id
               AND item_gen_type = variables_gen_type;

       FOR c_rec IN c
       LOOP
          INSERT INTO giac_op_text
                      (gacc_tran_id, item_gen_type, item_seq_no,
                       item_amt, user_id, last_update,
                       bill_no, item_text, print_seq_no,
                       currency_cd, foreign_curr_amt
                      )
               VALUES (c_rec.gacc_tran_id, variables_gen_type, v_seq_no,
                       c_rec.item_amt, c_rec.user_id, c_rec.last_update,
                       c_rec.bill_no, c_rec.item_text, v_seq_no,
                       c_rec.currency_cd, c_rec.foreign_curr_amt
                      );

          v_seq_no := v_seq_no + 1;
       END LOOP;
    END;
    
    PROCEDURE gen_misc_op_text (
       p_item_text   giac_op_text.item_text%TYPE,
       p_item_amt    giac_op_text.item_amt%TYPE
    )
    IS
       v_seq_no   giac_op_text.item_seq_no%TYPE;
    BEGIN
       BEGIN
          SELECT generation_type
            INTO variables_gen_type
            FROM giac_modules
           WHERE module_name = 'GIACS603';
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             raise_application_error (-20001, 'Geniisys Exception#E#This module does not exist in giac_modules.');
       END;

       SELECT NVL (MAX (item_seq_no), 0) + 1
         INTO v_seq_no
         FROM giac_op_text
        WHERE gacc_tran_id = variables_tran_id
          AND item_gen_type = variables_gen_type;

       INSERT INTO giac_op_text
                   (gacc_tran_id, item_seq_no, print_seq_no, item_amt,
                    item_gen_type, item_text, currency_cd, foreign_curr_amt,
                    user_id, last_update
                   )
            VALUES (variables_tran_id, v_seq_no, v_seq_no, p_item_amt,
                    variables_gen_type, p_item_text, 1, p_item_amt,
                    variables_user_id, SYSDATE
                   );
    END;
    
    FUNCTION get_or_particulars (
       p_tran_id            giac_acctrans.tran_id%TYPE,
       p_acct_payable_amt   NUMBER,
       p_prem_dep_amt       NUMBER
    )
       RETURN VARCHAR2
    IS
       v_particulars           giac_order_of_payts.particulars%TYPE;
       v_or_particulars_text   giac_order_of_payts.particulars%TYPE
                                               := giacp.v ('OR_PARTICULARS_TEXT');
       v_or_text               VARCHAR2 (1)                := giacp.v ('OR_TEXT');
       v_policies              giac_order_of_payts.particulars%TYPE;
       v_policies_full         giac_order_of_payts.particulars%TYPE;
       v_policies_partial      giac_order_of_payts.particulars%TYPE;
       v_or_pol_limit          NUMBER     := giacp.n ('OR_POL_PARTICULARS_LIMIT');
       v_pol_ctr               NUMBER                                 := 0;
       v_full_partial_flag     VARCHAR2 (1);
    BEGIN
       FOR rec_a IN (
            SELECT gdpc.gacc_tran_id, gdpc.b140_iss_cd iss_cd,
                     gdpc.b140_prem_seq_no prem_seq_no,
                     SUM (gdpc.collection_amt) colln_amt,
                        RTRIM (gpol.line_cd)
                     || '-'
                     || RTRIM (gpol.subline_cd)
                     || '-'
                     || RTRIM (gpol.iss_cd)
                     || '-'
                     || LTRIM (TO_CHAR (gpol.issue_yy, '99'))
                     || '-'
                     || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                     || DECODE (gpol.endt_seq_no,
                                0, NULL,
                                   '-'
                                || gpol.endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                                || ' '
                                || RTRIM (gpol.endt_type)
                               )
                     || '-'
                     || LTRIM (TO_CHAR (gpol.renew_no, '09')) policy_no
                FROM gipi_polbasic gpol, gipi_invoice ginv, giac_direct_prem_collns gdpc
               WHERE 1 = 1
                 AND gpol.policy_id = ginv.policy_id
                 AND gdpc.b140_iss_cd = ginv.iss_cd
                 AND gdpc.b140_prem_seq_no = ginv.prem_seq_no
                 AND gdpc.gacc_tran_id = p_tran_id
            GROUP BY gacc_tran_id,
                     b140_iss_cd,
                     b140_prem_seq_no,
                     gpol.line_cd,
                     gpol.subline_cd,
                     gpol.iss_cd,
                     gpol.issue_yy,
                     gpol.pol_seq_no,
                     gpol.renew_no,
                     gpol.endt_seq_no,
                        RTRIM (gpol.line_cd)
                     || '-'
                     || RTRIM (gpol.subline_cd)
                     || '-'
                     || RTRIM (gpol.iss_cd)
                     || '-'
                     || LTRIM (TO_CHAR (gpol.issue_yy, '99'))
                     || '-'
                     || LTRIM (TO_CHAR (gpol.pol_seq_no, '0999999'))
                     || DECODE (gpol.endt_seq_no,
                                0, NULL,
                                   '-'
                                || gpol.endt_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (gpol.endt_seq_no, '099999'))
                                || ' '
                                || RTRIM (gpol.endt_type)
                               )
                     || '-'
                     || LTRIM (TO_CHAR (gpol.renew_no, '09'))
            ORDER BY gpol.line_cd,
                     gpol.subline_cd,
                     gpol.iss_cd,
                     gpol.issue_yy,
                     gpol.pol_seq_no,
                     gpol.renew_no,
                     gpol.endt_seq_no
       )
       LOOP
          v_pol_ctr := v_pol_ctr + 1;

          IF v_pol_ctr > v_or_pol_limit THEN
             EXIT;
          END IF;

          IF NVL (v_or_text, 'N') = 'N' THEN
             IF NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN') = 'PB' THEN
                v_policies := v_policies || rec_a.policy_no || '/' || rec_a.iss_cd || '-' || LTRIM (TO_CHAR (rec_a.prem_seq_no, '99999999')) || ', ';
             ELSE
                v_policies := v_policies || rec_a.policy_no || '/';
             END IF;
          ELSE
             v_full_partial_flag := 'F';

             FOR rec_b IN (
                  SELECT DECODE (SUM (balance_amt_due), 0, 'F', 'P') full_partial
                    FROM giac_aging_soa_details
                   WHERE iss_cd = rec_a.iss_cd 
                     AND prem_seq_no = rec_a.prem_seq_no
                GROUP BY iss_cd, prem_seq_no
             )
             LOOP
                v_full_partial_flag := rec_b.full_partial;
                EXIT;
             END LOOP rec_b;

             IF v_full_partial_flag = 'F' THEN
                IF NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN') = 'PB' THEN
                   v_policies_full := v_policies_full || rec_a.policy_no || '/' || rec_a.iss_cd || '-' || LTRIM (TO_CHAR (rec_a.prem_seq_no, '99999999')) || ', ';
                ELSE
                   v_policies_full := v_policies_full || rec_a.policy_no || '/';
                END IF;
             ELSE
                IF NVL (giacp.v ('PREM_COLLN_PARTICULARS'), 'PN') = 'PB'
                THEN
                   v_policies_partial :=
                         v_policies_partial || rec_a.policy_no || '/' || rec_a.iss_cd || '-' || LTRIM (TO_CHAR (rec_a.prem_seq_no, '99999999')) || ', ';
                ELSE
                   v_policies_partial := v_policies_partial || rec_a.policy_no || '/';
                END IF;
             END IF;
          END IF;
       END LOOP rec_a;

       IF v_pol_ctr > v_or_pol_limit
       THEN
          v_particulars :=
                'Representing payment of premium and taxes for various policies.';
       ELSIF v_pol_ctr BETWEEN 1 AND v_or_pol_limit
       THEN
          IF NVL (v_or_text, 'N') = 'N' THEN
             v_particulars :=
                           SUBSTR (v_policies, 1, LENGTH (RTRIM (v_policies)) - 1);
          ELSE
             IF v_policies_full IS NOT NULL AND v_policies_partial IS NOT NULL THEN
                v_policies_full :=
                   SUBSTR (v_policies_full,
                           1,
                           LENGTH (RTRIM (v_policies_full)) - 1
                          );
                v_policies_partial :=
                   SUBSTR (v_policies_partial,
                           1,
                           LENGTH (RTRIM (v_policies_partial)) - 1
                          );
                v_particulars :=
                      giacp.v ('OR_PARTICULARS_FULL')
                   || ' '
                   || v_policies_full
                   || ', '
                   || giacp.v ('OR_PARTICULARS_TEXT2')
                   || ' '
                   || v_policies_partial;
             ELSIF v_policies_full IS NOT NULL THEN
                v_policies_full :=
                   SUBSTR (v_policies_full,
                           1,
                           LENGTH (RTRIM (v_policies_full)) - 1
                          );
                v_particulars :=
                          giacp.v ('OR_PARTICULARS_FULL') || ' '
                          || v_policies_full;
             ELSIF v_policies_partial IS NOT NULL THEN
                v_policies_partial :=
                   SUBSTR (v_policies_partial,
                           1,
                           LENGTH (RTRIM (v_policies_partial)) - 1
                          );
                v_particulars :=
                    giacp.v ('OR_PARTICULARS_PARTIAL') || ' '
                    || v_policies_partial;
             END IF;
          END IF;
       ELSE                                                          
          IF p_prem_dep_amt <> 0
          THEN
             v_particulars := 'Premium Deposit';
          ELSE
             v_particulars := 'Accounts Payable';
          END IF;
       END IF;

       RETURN (v_particulars);
    END;
    
    FUNCTION get_payment_details_prc (
       p_line_cd      giac_upload_prem.line_cd%TYPE,
       p_subline_cd   giac_upload_prem.subline_cd%TYPE,
       p_iss_cd       giac_upload_prem.iss_cd%TYPE,
       p_issue_yy     giac_upload_prem.issue_yy%TYPE,
       p_pol_seq_no   giac_upload_prem.pol_seq_no%TYPE,
       p_renew_no     giac_upload_prem.renew_no%TYPE,
       p_payor        giac_upload_prem.payor%TYPE,
       p_source_cd    VARCHAR2,
       p_file_no      VARCHAR2
    )
       RETURN VARCHAR2
    IS
       v_mean_check_class   VARCHAR2 (20)  := 'UNKNOWN CHECK CLASS';
       v_payment_details    VARCHAR2 (500);
       v_dummy_payt_dtl     VARCHAR2 (100);
    BEGIN
       FOR rec IN (
            SELECT pay_mode, check_class, check_no, check_date, bank
              FROM giac_upload_prem_dtl
             WHERE source_cd = p_source_cd
               AND file_no = p_file_no
               AND line_cd = NVL (p_line_cd, line_cd)
               AND subline_cd = NVL (p_subline_cd, subline_cd)
               AND iss_cd = NVL (p_iss_cd, iss_cd)
               AND issue_yy = NVL (p_issue_yy, issue_yy)
               AND pol_seq_no = NVL (p_pol_seq_no, pol_seq_no)
               AND renew_no = NVL (p_renew_no, renew_no)
               AND payor = p_payor
       )
       LOOP
          --get payment_details
          IF rec.pay_mode = 'CA' THEN
             v_dummy_payt_dtl := rec.pay_mode || '; ';
          ELSIF rec.pay_mode = 'CC' THEN
             v_dummy_payt_dtl :=
                 rec.pay_mode || ', ' || rec.bank || ', ' || rec.check_no || '; ';
          ELSIF rec.pay_mode = 'CHK' THEN
             BEGIN
                SELECT UPPER (rv_meaning)
                  INTO v_mean_check_class
                  FROM cg_ref_codes
                 WHERE rv_domain LIKE 'GIAC_COLLECTION_DTL.CHECK_CLASS'
                   AND rv_low_value = rec.check_class;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   NULL;
                WHEN OTHERS THEN
                   raise_application_error (-20001, 'Geniisys Exception#E#Exception occured.');
             END;

             v_dummy_payt_dtl :=
                   rec.pay_mode
                || ', '
                || rec.bank
                || ', '
                || v_mean_check_class
                || ', '
                || rec.check_no
                || ', '
                || TO_CHAR (rec.check_date, 'MM/DD/RRRR')
                || '; ';
          ELSIF rec.pay_mode = 'CM' THEN
             SELECT    rec.pay_mode
                    || ', '
                    || rec.bank
                    || DECODE (rec.check_no, NULL, NULL, ', ' || rec.check_no)
                    || DECODE (TO_CHAR (rec.check_date, 'MM/DD/RRRR'),
                               NULL, NULL,
                               ', ' || TO_CHAR (rec.check_date, 'MM/DD/RRRR')
                              )
                    || '; '
               INTO v_dummy_payt_dtl
               FROM DUAL;
          END IF;

          IF LENGTH (v_payment_details || v_dummy_payt_dtl) <= 500 THEN
             v_payment_details :=
                   REPLACE (v_payment_details, v_dummy_payt_dtl, NULL)
                || v_dummy_payt_dtl;
          ELSE
             EXIT;
          END IF;
       END LOOP;

       RETURN (v_payment_details);
    END;
    
    PROCEDURE gen_dpc_op_text_prem (
       p_iss_cd         IN   giac_direct_prem_collns.b140_iss_cd%TYPE,
       p_prem_seq_no    IN   giac_direct_prem_collns.b140_prem_seq_no%TYPE,
       p_inst_no        IN   giac_direct_prem_collns.inst_no%TYPE,
       p_premium_amt    IN   NUMBER,
       p_currency_cd    IN   giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   IN   giac_direct_prem_collns.convert_rate%TYPE
    )
    IS
       v_exist             VARCHAR2 (1);
       n_seq_no            NUMBER (2);
       v_tax_name          VARCHAR2 (100);
       v_tax_cd            NUMBER (2);
       v_sub_tax_amt       NUMBER (14, 2);
       v_currency_cd       giac_direct_prem_collns.currency_cd%TYPE;
       v_convert_rate      giac_direct_prem_collns.convert_rate%TYPE;
       v_prem_type         VARCHAR2 (1)                                := 'E';
       v_prem_text         VARCHAR2 (25);
       v_or_curr_cd        giac_order_of_payts.currency_cd%TYPE;
       v_def_curr_cd       giac_order_of_payts.currency_cd%TYPE
                                              := NVL (giacp.n ('CURRENCY_CD'), 1);
       --added the ff. variables
       v_inv_tax_amt       gipi_inv_tax.tax_amt%TYPE;
       v_inv_tax_rt        gipi_inv_tax.rate%TYPE;
       v_inv_prem_amt      gipi_invoice.prem_amt%TYPE;
       v_tax_colln_amt     giac_tax_collns.tax_amt%TYPE;
       v_premium_amt       gipi_invoice.prem_amt%TYPE;
       v_exempt_prem_amt   gipi_invoice.prem_amt%TYPE;
       v_init_prem_text    VARCHAR2 (25);
    BEGIN
       v_premium_amt := p_premium_amt;
       
       BEGIN
          SELECT DECODE (NVL (c.tax_amt, 0), 0, 'Z', 'V') prem_type,
                 c.tax_amt inv_tax_amt, c.rate inv_tax_rt,
                 b.prem_amt inv_prem_amt
            INTO v_prem_type,
                 v_inv_tax_amt, v_inv_tax_rt,
                 v_inv_prem_amt
            FROM gipi_invoice b, gipi_inv_tax c
           WHERE b.iss_cd = c.iss_cd
             AND b.prem_seq_no = c.prem_seq_no
             AND c.tax_cd = variables_evat_cd
             AND c.iss_cd = p_iss_cd
             AND c.prem_seq_no = p_prem_seq_no;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             NULL;
       END;
       
       IF v_prem_type = 'V' THEN
          v_prem_text := 'PREMIUM (VATABLE)';
          n_seq_no := 1;

          --separate the vatable and vat-exempt premiums for cases where the evat is peril dependent.
          --Note the 1 peso variance, as per Ms. J. If the difference is <= 1 then all the amt should
          --be for the vatable premium
          BEGIN
              IF ABS (v_inv_prem_amt - ROUND (v_inv_tax_amt / v_inv_tax_rt * 100, 2)) * p_convert_rate > 1 THEN 
                 BEGIN
                    SELECT NVL (tax_amt, 0)
                      INTO v_tax_colln_amt
                      FROM giac_tax_collns
                     WHERE gacc_tran_id = variables_tran_id
                       AND b160_iss_cd = p_iss_cd
                       AND b160_prem_seq_no = p_prem_seq_no
                       AND inst_no = p_inst_no
                       AND b160_tax_cd = variables_evat_cd;
                 EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                       v_tax_colln_amt := 0;
                 END;

                 IF v_tax_colln_amt <> 0
                 THEN
                    v_premium_amt := ROUND (v_tax_colln_amt / v_inv_tax_rt * 100, 2);
                    v_exempt_prem_amt := p_premium_amt - v_premium_amt;

                    IF ABS (v_exempt_prem_amt) <= 1
                    THEN
                       v_premium_amt := p_premium_amt;
                       v_exempt_prem_amt := NULL;
                    END IF;
                 END IF;
              END IF;
          EXCEPTION 
            WHEN ZERO_DIVIDE THEN
                raise_application_error (-20001, 'Geniisys Exception#E#Invalid tax rate, Please check VAT rate in tax charge maintenance');
          END;
       ELSIF v_prem_type = 'Z' THEN
          v_prem_text := 'PREMIUM (ZERO-RATED)';
          n_seq_no := 2;
       ELSE
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
       END IF;

       --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
       --should also be in the default  currency regardless of what currency_cd is in the invoice
       FOR b1 IN (
            SELECT currency_cd
              FROM giac_order_of_payts
             WHERE gacc_tran_id = variables_tran_id
       )
       LOOP
          v_or_curr_cd := b1.currency_cd;
          EXIT;
       END LOOP;

       IF v_or_curr_cd = v_def_curr_cd
       THEN
          v_convert_rate := 1;
          v_currency_cd := v_def_curr_cd;
       ELSE
          v_convert_rate := p_convert_rate;
          v_currency_cd := p_currency_cd;
       END IF;

       --insert the zero amts for the three types of premium
       IF variables_zero_prem_op_text = 'Y'
       THEN
          FOR rec IN 1 .. 3
          LOOP
             IF rec = 1
             THEN
                v_init_prem_text := 'PREMIUM (VATABLE)';
             ELSIF rec = 2
             THEN
                v_init_prem_text := 'PREMIUM (ZERO-RATED)';
             ELSE
                v_init_prem_text := 'PREMIUM (VAT-EXEMPT)';
             END IF;

             gen_dpc_op_text_prem2 (rec, 0, v_init_prem_text, v_currency_cd, v_convert_rate);
             variables_zero_prem_op_text := 'N';
          END LOOP;
       END IF;

       gen_dpc_op_text_prem2 (n_seq_no, v_premium_amt, v_prem_text, v_currency_cd, v_convert_rate);

       --insert the vat-exempt premium
       IF NVL (v_exempt_prem_amt, 0) <> 0
       THEN
          v_prem_text := 'PREMIUM (VAT-EXEMPT)';
          n_seq_no := 3;
          gen_dpc_op_text_prem2 (n_seq_no, v_exempt_prem_amt, v_prem_text, v_currency_cd, v_convert_rate);
       END IF;

       BEGIN
          FOR tax IN (
            SELECT b.b160_tax_cd, c.tax_name, b.tax_amt, a.currency_cd, a.convert_rate
              FROM giac_direct_prem_collns a, giac_taxes c, giac_tax_collns b
             WHERE 1 = 1
               AND a.gacc_tran_id = b.gacc_tran_id
               AND a.b140_iss_cd = b.b160_iss_cd
               AND a.b140_prem_seq_no = b.b160_prem_seq_no
               AND a.inst_no = b.inst_no
               AND c.fund_cd = variables_fund_cd
               AND b.b160_tax_cd = c.tax_cd
               AND b.inst_no = p_inst_no
               AND b.b160_prem_seq_no = p_prem_seq_no
               AND b.b160_iss_cd = p_iss_cd
               AND b.gacc_tran_id = variables_tran_id
          )
          LOOP
             v_tax_cd := tax.b160_tax_cd;
             v_tax_name := tax.tax_name;
             v_sub_tax_amt := tax.tax_amt;

             --check if the currency_cd in the O.R. is the default currency. If so, the amts inserted in giac_op_text
             --should also be in the default  currency regardless of what currency_cd is in the invoice
             IF v_or_curr_cd = v_def_curr_cd
             THEN
                v_convert_rate := 1;
                v_currency_cd := v_def_curr_cd;
             ELSE
                v_convert_rate := tax.convert_rate;
                v_currency_cd := tax.currency_cd;
             END IF;

             gen_dpc_op_text_tax (v_tax_cd, v_tax_name, v_sub_tax_amt, v_currency_cd, v_convert_rate);
          END LOOP;
       END;
    END; 
    
    PROCEDURE gen_dpc_op_text_prem2 (
       p_seq_no         NUMBER,
       p_premium_amt    gipi_invoice.prem_amt%TYPE,
       p_prem_text      VARCHAR2,
       p_currency_cd    giac_direct_prem_collns.currency_cd%TYPE,
       p_convert_rate   giac_direct_prem_collns.convert_rate%TYPE
    )
    IS
       v_exist   VARCHAR2 (1);
    BEGIN
       SELECT 'X'
         INTO v_exist
         FROM giac_op_text
        WHERE gacc_tran_id = variables_tran_id
          AND item_gen_type = variables_gen_type
          AND item_text = p_prem_text;

       UPDATE giac_op_text
          SET item_amt = NVL (item_amt, 0) + NVL (p_premium_amt, 0),
              foreign_curr_amt = NVL (foreign_curr_amt, 0) + NVL (p_premium_amt / p_convert_rate, 0)
        WHERE gacc_tran_id = variables_tran_id
          AND item_text = p_prem_text
          AND item_gen_type = variables_gen_type;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
          INSERT INTO giac_op_text
                      (gacc_tran_id, item_gen_type, item_seq_no,
                       item_amt, item_text, print_seq_no, currency_cd,
                       user_id, last_update, foreign_curr_amt
                      )
               VALUES (variables_tran_id, variables_gen_type, p_seq_no,
                       p_premium_amt, p_prem_text, p_seq_no, p_currency_cd,
                       variables_user_id, SYSDATE, p_premium_amt / p_convert_rate
                      );
    END;
    
    PROCEDURE gen_dpc_op_text_tax (
       p_tax_cd         NUMBER,
       p_tax_name       VARCHAR2,
       p_tax_amt        NUMBER,
       p_currency_cd    NUMBER,
       p_convert_rate   NUMBER
    )
    IS
       v_exist   VARCHAR2 (1);
    BEGIN
       BEGIN
          SELECT 'X'
            INTO v_exist
            FROM giac_op_text
           WHERE gacc_tran_id = variables_tran_id
             AND item_gen_type = variables_gen_type
             AND SUBSTR (item_text, 1, 5) = LTRIM (TO_CHAR (p_tax_cd, '09')) || '-' || LTRIM (TO_CHAR (p_currency_cd, '09'));

          UPDATE giac_op_text
             SET item_amt = NVL (item_amt, 0) + NVL (p_tax_amt, 0),
                 foreign_curr_amt = NVL (foreign_curr_amt, 0) + NVL (p_tax_amt / p_convert_rate, 0)
           WHERE gacc_tran_id = variables_tran_id
             AND item_gen_type = variables_gen_type
             AND SUBSTR (item_text, 1, 5) = LTRIM (TO_CHAR (p_tax_cd, '09')) || '-' || LTRIM (TO_CHAR (p_currency_cd, '09'));
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             BEGIN
                variables_n_seq_no := variables_n_seq_no + 1;

                INSERT INTO giac_op_text
                            (gacc_tran_id, item_gen_type, item_seq_no, 
                            item_amt, item_text, print_seq_no, 
                            currency_cd, user_id, last_update, foreign_curr_amt
                            )
                     VALUES (variables_tran_id, variables_gen_type,
                             variables_n_seq_no, p_tax_amt,
                                LTRIM (TO_CHAR (p_tax_cd, '09'))
                             || '-'
                             || LTRIM (TO_CHAR (p_currency_cd, '09'))
                             || '-'
                             || p_tax_name,
                             variables_n_seq_no, p_currency_cd, variables_user_id, SYSDATE,
                             p_tax_amt / p_convert_rate
                            );
             END;
       END;
    END;
    
    PROCEDURE validate_print_or2 (
        p_source_cd           VARCHAR2,
        p_file_no             VARCHAR2,
        p_branch_cd     OUT   VARCHAR2,
        p_fund_cd       OUT   VARCHAR2,
        p_branch_name   OUT   VARCHAR2,
        p_fund_desc     OUT   VARCHAR2,
        p_tran_id       OUT   NUMBER,
        p_upload_query  OUT   VARCHAR2
    )
    IS
    BEGIN
        BEGIN
           SELECT c.gibr_branch_cd, c.gibr_gfun_fund_cd, c.gacc_tran_id
             INTO p_branch_cd, p_fund_cd, p_tran_id
             FROM giac_order_of_payts c, giac_upload_prem_atm b, giac_upload_file a
            WHERE 1 = 1
              AND b.tran_id = c.gacc_tran_id
              AND a.source_cd = b.source_cd
              AND a.file_no = b.file_no
              AND a.source_cd = p_source_cd
              AND a.file_no = p_file_no
              AND ROWNUM = 1;
              
            BEGIN
                SELECT branch_name
                  INTO p_branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = p_fund_cd 
                   AND branch_cd = p_branch_cd;
                
                SELECT fund_desc
                  INTO p_fund_desc
                  FROM giis_funds
                 WHERE fund_cd = p_fund_cd;
            END;
            
            p_upload_query :=
                'SELECT c.gacc_tran_id '
             || 'FROM giac_order_of_payts c, giac_upload_prem_atm b, giac_upload_file a '
             || 'WHERE 1 = 1 '
             || 'AND b.tran_id = c.gacc_tran_id '
             || 'AND a.source_cd = b.source_cd '
             || 'AND a.file_no = b.file_no '
             || 'AND a.source_cd = '''
             || p_source_cd
             || ''''
             || 'AND a.file_no = '
             || p_file_no;   
                 
        EXCEPTION
           WHEN NO_DATA_FOUND THEN
              raise_application_error (-20001, 'Geniisys Exception#E#O.R. does not exist in table: GIAC_ORDER_OF_PAYTS.');  	
        END;
    END;
    
    PROCEDURE check_dcb_no (
        p_branch_cd       VARCHAR2,
        p_user_id         VARCHAR2,
        p_or_date         VARCHAR2
   )
   IS
        v_date      DATE;
        v_exist     VARCHAR2(1) := 'N';
   BEGIN
        
        v_date := TO_DATE(p_or_date,'MM-DD-YYYY');
   
        upload_dpc_web.set_fixed_variables(giacp.v('FUND_CD'), REGEXP_REPLACE( p_branch_cd, '\s'), giacp.n('EVAT'));
        upload_dpc_web.check_dcb_user (v_date, p_user_id);
        
        upload_dpc_web.get_dcb_no2 (v_date, variables_dcb_no, v_exist);

        IF v_exist = 'N'
        THEN
           raise_application_error (-20001,
                                  '#'
                               || 'There is no open DCB No. dated '
                               || TO_CHAR (v_date, 'fmMonth DD, YYYY')
                               || ' for this company/branch ('
                               || variables_fund_cd
                               || '/'
                               || variables_branch_cd
                               || ').'
                              );
        END IF;
   END check_dcb_no;
    --nieko end   
END; 
/


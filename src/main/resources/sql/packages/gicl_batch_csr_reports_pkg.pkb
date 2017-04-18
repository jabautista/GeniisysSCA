CREATE OR REPLACE PACKAGE BODY CPI.GICL_BATCH_CSR_REPORTS_PKG AS

  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 2, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **  Description  : This retrieves the details necessary for GICLR043 report
  **                  	
  */
    
  FUNCTION get_giclr043_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
    RETURN giclr043_report_tab PIPELINED IS
    
    v_report           giclr043_report_type;
    v_title            VARCHAR2(100);
    v_csr_attn         VARCHAR2(100);
    v_remark           VARCHAR2(200);
    v_return           VARCHAR2(1) := 'N';
    
    CURSOR main IS
        SELECT  b.batch_csr_id
          FROM  GICL_CLAIMS a
               ,GICL_BATCH_CSR b
               ,GICL_ADVICE c
               ,GICL_CLM_LOSS_EXP d
         WHERE a.claim_id = c.claim_id
           AND a.claim_id = d.claim_id 
           AND b.batch_csr_id = c.batch_csr_id
           AND b.batch_csr_id = p_batch_csr_id 
           AND c.advice_id = d.advice_id
        GROUP BY b.batch_csr_id;
    
    BEGIN
        FOR i IN main
        LOOP
            v_report.f_batch_csr_id := i.batch_csr_id;
            v_return := 'Y';
     
        END LOOP;
        
        IF v_return = 'N' THEN
            RETURN;
        END IF;
        
        /*f_title*/
        SELECT param_value_v
         INTO v_title
        FROM GIAC_PARAMETERS
        WHERE param_name = 'PREM_CSR_TITLE';
        
        /*f_csr_attn*/
        
        SELECT param_value_v
          INTO v_csr_attn
        FROM GIAC_PARAMETERS
        WHERE param_name = 'CSR_ATTN';
         
        /*f_settlement_remarks*/  
         BEGIN
            SELECT param_value_v
              INTO v_remark 
              FROM GIAC_PARAMETERS
             WHERE param_name LIKE 'BCSR_PAYT_REMARK';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_remark := 'As partial/full and final settlement of the above loss.';
          END;
        
        v_report.f_title                 := v_title;            
        v_report.f_csr_attn              := v_csr_attn;
        v_report.f_settlement_remarks    := v_remark;
        
        /*f_sum_paid_amt and f_currency_cd*/
        DECLARE
            v_sum_paid_amt          NUMBER := 0;
			v_gross_amt             NUMBER := 0;
            v_currency_cd           GIIS_CURRENCY.main_currency_cd%TYPE;
            v_count                 NUMBER := 0;
            
            CURSOR batch IS
                SELECT  a.line_cd ||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'|| LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'|| LPAD(TO_CHAR(a.renew_no),2,'0') POLICY
                       ,a.assured_name
                       ,a.dsp_loss_date
                       ,a.line_cd ||'-'|| a.subline_cd ||'-'|| a.iss_cd ||'-'|| LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.clm_seq_no),7,'0') claim
                       ,b.payee_class_cd
                       ,b.payee_cd
                       ,(d.advise_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) advise_amt
                       ,(d.net_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) net_amt
                       ,SUM(d.paid_amt* DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) paid_amt
                       ,b.batch_csr_id
                       ,c.convert_rate
                       ,c.currency_cd
                       ,a.claim_id
                       ,c.advice_id
                       ,d.clm_loss_id
                       ,d.claim_id clm_id
                       ,DECODE(d.clm_clmnt_no, NULL, 0, d.clm_clmnt_no) clm_clmnt_no
                  FROM  GICL_CLAIMS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d
                 WHERE a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id 
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id 
                   AND c.advice_id = d.advice_id
                 GROUP BY a.line_cd,a.subline_cd,a.pol_iss_cd,a.issue_yy,a.pol_seq_no,a.renew_no,
                        a.assured_name,a.dsp_loss_date,b.payee_class_cd,b.payee_cd,a.iss_cd,a.clm_yy,a.clm_seq_no,    
                        d.advise_amt,c.convert_rate,d.net_amt,d.paid_amt,b.batch_csr_id,a.claim_id,c.advice_id,d.clm_loss_id, d.claim_id,
                        d.clm_clmnt_no,d.clm_clmnt_no ,c.currency_cd   
                       ,d.currency_cd,c.orig_curr_rate;
        BEGIN
            FOR i IN batch
            LOOP
                v_sum_paid_amt := v_sum_paid_amt + NVL(i.paid_amt, 0);
				v_gross_amt   := v_gross_amt + NVL(i.net_amt, 0); -- added by: Nica 02.13.2013
                v_currency_cd := i.currency_cd;
                
                FOR rec IN (SELECT COUNT(*) claim
							  FROM GIIS_PAYEES a,
							       GIIS_PAYEE_CLASS b,
							       GICL_LOSS_EXP_BILL c
							 WHERE a.payee_class_cd = c.payee_class_cd
							   AND b.payee_class_cd = a.payee_class_cd
							   AND a.payee_no = c.payee_cd
							   AND c.claim_id = i.clm_id)
                LOOP
                    v_count := v_count + NVL(rec.claim, 0);
                END LOOP;
                
            END LOOP;
            
            v_report.f_sum_paid_amt := v_sum_paid_amt;
			v_report.f_gross_amt    := v_gross_amt;
            v_report.f_currency_cd  := v_currency_cd;
            
            /*rv_print_payees*/
            
            IF v_count = 0 THEN
                v_report.rv_print_payees := 'N';
            ELSE	
                v_report.rv_print_payees := 'Y';
            END IF;
        END;
        
        /*f_net_amt*/
        DECLARE
            v_net		GICL_CLM_LOSS_EXP.paid_amt%TYPE := 0;
            tax_amt     GICL_LOSS_EXP_TAX.tax_amt%TYPE := 0;
        BEGIN
  
            FOR i IN (SELECT SUM(a.paid_amt*a.currency_rate) net_amt
						  FROM GICL_CLM_LOSS_EXP a, 
                               GICL_LOSS_EXP_TAX b,
						       GICL_ADVICE c , 
                               GICL_BATCH_CSR d
						    WHERE a.claim_id = b.claim_id
						      AND a.clm_loss_id = b.clm_loss_id
						      AND a.claim_id = c.claim_id
						      AND a.advice_id = c.advice_id
						      AND b.tax_type = 'I' 
						      AND c.batch_csr_id = d.batch_csr_id
							  AND c.batcH_csr_id = p_batch_csr_id)
           LOOP
             v_net := i.net_amt;
           END LOOP;
            
            v_report.f_net_amt := v_net;
           
        END;
        
        /*f_short_name*/
        DECLARE
            v_currency     GIIS_CURRENCY.short_name%TYPE;
            
        BEGIN
            IF v_report.f_currency_cd IS NOT NULL THEN
              SELECT short_name                           
               INTO v_currency
               FROM GIIS_CURRENCY
              WHERE main_currency_cd = v_report.f_currency_cd;
           ELSE    
             SELECT param_value_v
               INTO v_currency
             FROM GIAC_PARAMETERS
             WHERE param_name = 'DEFAULT_CURRENCY'; 
           END IF;
           
           v_report.f_short_name := v_currency;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
              v_report.f_short_name := NULL;
        END;
        
        /*f_sum_net_ret, f_sum_treaty and f_sum_facul*/
        DECLARE
            v_sum_net_ret       NUMBER := 0;
            v_sum_treaty        NUMBER := 0;
            v_sum_facul         NUMBER := 0;
            
            CURSOR dist IS
                SELECT  b.batch_csr_id
                       ,SUM(DECODE (a.grp_seq_no, 1, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))), 0.00 )) net_ret
                       ,SUM(DECODE (a.grp_seq_no, 999, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))), 0.00)) facul
                       ,SUM(DECODE (a.grp_seq_no, 1, 0.00, 999, 0.00, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))))) treaty
                  FROM  GICL_LOSS_EXP_DS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d 
                 WHERE (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                   AND a.claim_id = c.claim_id 
                   AND a.claim_id = d.claim_id
                   AND a.clm_loss_id = d.clm_loss_id 
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id
                   AND c.advice_id = d.advice_id
                 GROUP BY b.batch_csr_id;
        BEGIN
            FOR d IN dist
            LOOP
                v_sum_net_ret := v_sum_net_ret + NVL(d.net_ret, 0);
                v_sum_treaty  := v_sum_treaty + NVL(d.treaty, 0);
                v_sum_facul   := v_sum_facul + NVL(d.facul, 0);
            END LOOP;
            
            v_report.f_sum_net_ret   := v_sum_net_ret;
            v_report.f_sum_treaty    := v_sum_treaty;
            v_report.f_sum_facul     := v_sum_facul;     
            
        END;
        
        /*f_v_sp*/
        v_report.f_v_sp :=  GICL_BATCH_CSR_REPORTS_PKG.get_v_sp(v_report.f_batch_csr_id, v_report.f_currency_cd, 
                                                                v_report.f_sum_paid_amt, v_report.f_sum_net_ret);
        /*rv_print_logo*/
        DECLARE                                                      
            v_ole_display    VARCHAR2(1);
        BEGIN
          SELECT param_value_v
            INTO v_ole_display
            FROM GIAC_PARAMETERS
           WHERE param_name = 'CSR_OLE_DISPLAY';
          
          IF v_ole_display = 'Y' THEN
            v_report.rv_print_logo := 'Y';
          ELSE
            v_report.rv_print_logo := 'N';
          END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_report.rv_print_logo := 'N';  
        END;
        
        /*rv_print_signatory*/
        
        DECLARE
        	v_switch		VARCHAR2(1);
        BEGIN
            FOR rec IN (SELECT param_value_v
                        FROM GIAC_PARAMETERS
                        WHERE param_name = 'CSR_PREPARED_BY')
            LOOP
                v_switch := rec.param_value_v;
            END LOOP;	
         	
            IF v_switch = 'Y' THEN
                v_report.rv_print_signatory := 'Y';
            ELSE           
                v_report.rv_print_signatory := 'N';
            END IF;	  
        END;
        
        PIPE ROW(v_report);
    
    END get_giclr043_rep_dtls;
    
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 2, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **  Description  : This retrieves list of claims displayed in GICLR043
  **                  	
  */
    
  FUNCTION get_giclr043_claim_list (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_claim_tab PIPELINED IS
  
      v_list          batch_csr_claim_type;
  
      BEGIN
        FOR i IN (SELECT c.advice_id
                       ,a.claim_id 
                       ,a.line_cd
                       ,a.subline_cd
                       ,a.pol_iss_cd
                       ,a.issue_yy
                       ,a.pol_seq_no
                       ,a.renew_no
                       ,a.iss_cd
                       ,a.clm_yy
                       ,a.clm_seq_no
                       ,b.batch_csr_id
                       ,a.assured_name
                       ,a.dsp_loss_date
                       ,SUM(d.paid_amt* DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) paid_amt
                       ,a.line_cd ||'-'|| 
                        a.subline_cd ||'-'|| 
                        a.pol_iss_cd ||'-'|| 
                        LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.renew_no),2,'0') policy_no
                       ,a.line_cd ||'-'|| 
                        a.subline_cd ||'-'|| 
                        a.iss_cd ||'-'|| 
                        LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0') claim_no
                   FROM GICL_CLAIMS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d
                 WHERE a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id
                   AND c.advice_id = d.advice_id
                 GROUP BY c.advice_id, a.claim_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                       a.iss_cd, a.clm_yy, a.clm_seq_no, b.batch_csr_id, a.assured_name,
                       a.dsp_loss_date
                 ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no)
        
        LOOP
            v_list.advice_id        :=  i.advice_id;         
            v_list.claim_id         :=  i.claim_id;   
            v_list.line_cd          :=  i.line_cd;   
            v_list.subline_cd       :=  i.subline_cd;   
            v_list.pol_iss_cd       :=  i.pol_iss_cd;   
            v_list.issue_yy         :=  i.issue_yy;   
            v_list.pol_seq_no       :=  i.pol_seq_no;   
            v_list.renew_no         :=  i.renew_no;   
            v_list.iss_cd           :=  i.iss_cd;  
            v_list.clm_yy           :=  i.clm_yy;   
            v_list.clm_seq_no       :=  i.clm_seq_no;   
            v_list.batch_csr_id     :=  i.batch_csr_id;  
            v_list.assured_name     :=  i.assured_name;  
            v_list.dsp_loss_date    :=  i.dsp_loss_date;   
            v_list.paid_amt         :=  i.paid_amt;   
            v_list.policy_no        :=  i.policy_no;  
            v_list.claim_no         :=  i.claim_no;
            v_list.intermdiary      :=  GICL_BATCH_CSR_REPORTS_PKG.get_batch_csr_intm(i.claim_id); 	 
            v_list.loss_cat_des	    :=  GICL_BATCH_CSR_REPORTS_PKG.get_batch_csr_loss_ctgry(i.line_cd, i.claim_id, i.advice_id); 
            PIPE ROW(v_list);   
        END LOOP;
                 
      END get_giclr043_claim_list;
      
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 3, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **                 GICLR044 - Final Batch CSR Report 	
  */
      
   FUNCTION get_batch_csr_dtl (p_batch_csr_id   GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_dtl_tab PIPELINED AS
     
     v_batch    batch_csr_dtl_type;
   
   BEGIN
      FOR i IN ( SELECT a.line_cd ||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'|| LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'|| LPAD(TO_CHAR(a.renew_no),2,'0') policy_no
                       ,a.assured_name
                       ,a.dsp_loss_date
                       ,a.line_cd ||'-'|| a.subline_cd ||'-'|| a.iss_cd ||'-'|| LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.clm_seq_no),7,'0') claim_no
                       ,b.payee_class_cd
                       ,b.payee_cd
                       ,(d.advise_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) advise_amt
                       ,(d.net_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) net_amt
                       ,SUM(d.paid_amt* DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) paid_amt
                       ,b.batch_csr_id
                       ,c.convert_rate
                       ,c.currency_cd
                       ,a.claim_id
                       ,c.advice_id
                       ,d.clm_loss_id
                       ,d.claim_id clm_id
                       ,DECODE(d.clm_clmnt_no, NULL, 0, d.clm_clmnt_no) clm_clmnt_no
                  FROM  GICL_CLAIMS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d
                 WHERE a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id 
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id 
                   AND c.advice_id = d.advice_id
                 GROUP BY a.line_cd,a.subline_cd,a.pol_iss_cd,a.issue_yy,a.pol_seq_no,a.renew_no,
                        a.assured_name,a.dsp_loss_date,b.payee_class_cd,b.payee_cd,a.iss_cd,a.clm_yy,a.clm_seq_no,    
                        d.advise_amt,c.convert_rate,d.net_amt,d.paid_amt,b.batch_csr_id,a.claim_id,c.advice_id,d.clm_loss_id, d.claim_id,
                        d.clm_clmnt_no,d.clm_clmnt_no ,c.currency_cd   
                       ,d.currency_cd,c.orig_curr_rate)
      LOOP
         v_batch.policy_no        :=  i.policy_no;
         v_batch.assured_name     :=  i.assured_name;
         v_batch.dsp_loss_date    :=  i.dsp_loss_date; 
         v_batch.claim_no         :=  i.claim_no; 
         v_batch.payee_class_cd   :=  i.payee_class_cd; 
         v_batch.payee_cd         :=  i.payee_cd; 
         v_batch.advise_amt       :=  i.advise_amt; 
         v_batch.net_amt          :=  i.net_amt; 
         v_batch.paid_amt         :=  i.paid_amt; 
         v_batch.batch_csr_id     :=  i.batch_csr_id; 
         v_batch.convert_rate     :=  i.convert_rate; 
         v_batch.currency_cd      :=  i.currency_cd; 
         v_batch.claim_id         :=  i.claim_id; 
         v_batch.advice_id        :=  i.advice_id;
         v_batch.clm_clmnt_no     :=  i.clm_clmnt_no;
         PIPE ROW(v_batch);
      END LOOP;
   END;
   
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 3, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **                 GICLR044 - Final Batch CSR Report	
  */
  
   FUNCTION get_batch_csr_payees(p_claim_id    GICL_LOSS_EXP_BILL.claim_id%TYPE)
     RETURN batch_csr_payee_tab PIPELINED IS
        
     v_payee        batch_csr_payee_type;
     
   BEGIN
      FOR i IN (SELECT b.class_desc,
                       a.payee_last_name,
                       c.doc_number,
                       c.doc_type,
                       c.claim_id,
                       c.payee_cd,
                       c.payee_class_cd,
                       c.claim_loss_id
                  FROM GIIS_PAYEES a,
                       GIIS_PAYEE_CLASS b,
                       GICL_LOSS_EXP_BILL c
                 WHERE a.payee_class_cd = c.payee_class_cd
                   AND b.payee_class_cd = a.payee_class_cd
                   AND a.payee_no = c.payee_cd
                   AND c.claim_id = p_claim_id)
      LOOP
         v_payee.class_desc      :=  i.class_desc;      
         v_payee.payee_last_name :=  i.payee_last_name; 
         v_payee.doc_number      :=  i.doc_number;  
         v_payee.doc_type        :=  i.doc_type; 
         v_payee.claim_id        :=  i.claim_id;
         v_payee.payee_cd        :=  i.payee_cd;
         v_payee.payee_class_cd  :=  i.payee_class_cd;
         v_payee.claim_loss_id   :=  i.claim_loss_id;
           
          FOR rec IN (SELECT rv_meaning
                FROM cg_ref_codes
               WHERE rv_domain = 'GICL_LOSS_EXP_BILL.DOC_TYPE'
                 AND rv_low_value = i.doc_type)
          LOOP
            v_payee.bill_title := rec.rv_meaning;
          END LOOP;
          	
         PIPE ROW(v_payee);          
      END LOOP;
   END;
   
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 3, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **                 GICLR044 - Final Batch CSR Report 	
  */
  
   FUNCTION get_batch_csr_intm(p_claim_id   GICL_CLAIMS.claim_id%TYPE)
     RETURN VARCHAR2 IS
      v_intm           VARCHAR2(250);
      v_print_name     VARCHAR2(1);

    BEGIN
      v_intm := NULL;
      
      BEGIN
        SELECT param_value_v
          INTO v_print_name
          FROM GIAC_PARAMETERS
         WHERE param_name = 'PRINT_INTM_NAME';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_print_name := 'N';
      END;
      
      IF v_print_name = 'N' THEN
         FOR i IN (SELECT DISTINCT TO_CHAR(c.intm_no)||'/'||NVL(c.ref_intm_cd,' ')INTM
                     FROM GICL_CLAIMS a, GICL_INTM_ITMPERIL b, GIIS_INTERMEDIARY c
                    WHERE a.claim_id = b.claim_id 
                      AND b.intm_no = c.intm_no
                      AND a.claim_id = p_claim_id) 
         LOOP
           
             IF v_intm IS NULL THEN
                v_intm := i.INTM;
             ELSIF v_intm IS NOT NULL THEN
                v_intm := v_intm ||CHR(10)||i.INTM;    
             END IF;
         END LOOP;
      
      ELSE  
        FOR i IN (SELECT DISTINCT TO_CHAR(c.intm_no)||'/'||NVL(c.ref_intm_cd,' ')||
                         '/'||c.intm_name INTM
                    FROM GICL_CLAIMS a, GICL_INTM_ITMPERIL b, GIIS_INTERMEDIARY c
                   WHERE a.claim_id = b.claim_id 
                     AND b.intm_no = c.intm_no
                     AND a.claim_id = p_claim_id) 
        LOOP

            IF v_intm IS NULL THEN
               v_intm := i.INTM;
            ELSIF v_intm IS NOT NULL THEN
               v_intm := v_intm ||CHR(10)||i.INTM;    
            END IF;
        END LOOP;

      END IF;

      RETURN(v_intm);
    END;
    
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 3, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **                 GICLR044 - Final Batch CSR Report 	
  */
    
   FUNCTION get_batch_csr_loss_ctgry(p_line_cd      GICL_CLAIMS.line_cd%TYPE,
                                    p_claim_id     GICL_CLAIMS.claim_id%TYPE,
                                    p_advice_id    GICL_ADVICE.advice_id%TYPE) 
     RETURN VARCHAR2 IS
      v_loss_cat_des    VARCHAR2(500); --from 100 to 500 to fix ORA-06502 - Halley 11.06.13

    BEGIN
      v_loss_cat_des := null;
          
      FOR i IN (SELECT c.loss_cat_des
                  FROM GIIS_LOSS_CTGRY c, GICL_ITEM_PERIL a, GICL_CLM_LOSS_EXP b
                 WHERE c.loss_cat_cd = a.loss_cat_cd
                   AND a.claim_id = b.claim_id
                   AND a.item_no = b.item_no
                   AND a.peril_cd = b.peril_cd
                   and c.line_cd = p_line_cd
                   and b.claim_id = p_claim_id
                   and b.advice_id = p_advice_id) 
      LOOP

        IF v_loss_cat_des IS NULL THEN
          v_loss_cat_des := i.loss_cat_des;
        ELSIF v_loss_cat_des IS NOT NULL THEN
          v_loss_cat_des := v_loss_cat_des ||'/'||i.loss_cat_des;    
        END IF;
      END LOOP;
    
      RETURN(v_loss_cat_des);
    END;
    
     /*
     **  Created by   : Veronica V. Raymundo
     **  Date Created : January 3, 2012
     **  Reference By : GICLR043 - Preliminary Batch CSR Report
     **                  	
     */
    FUNCTION get_v_sp (p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE,
                       p_currency_cd  IN  GIIS_CURRENCY.main_currency_cd%TYPE,
                       p_sum_paid_amt IN  NUMBER,
                       p_sum_net_ret  IN  NUMBER ) 
    RETURN VARCHAR2 IS
        v_payee                 VARCHAR2(2000);
        var_v_sp                VARCHAR2(2000);
        var_instr               NUMBER;
        var_lgt_payt            NUMBER;
        var_paid_amt1           NUMBER;
        var_paid_amt1t          NUMBER := 0;
        var_paid_amt1m          NUMBER := 0;
        var_paid_amt1b          NUMBER := 0;
        var_paid_amt2           NUMBER := 0;
        var_spaid_amt1          VARCHAR2(200);
        var_spaid_amt1t         VARCHAR2(200);
        var_spaid_amt1m         VARCHAR2(200);
        var_spaid_amt1b         VARCHAR2(200);
        var_spaid_amt2          VARCHAR2(200);
        var_length              NUMBER := 0;
        var_length1             NUMBER := 0;
        var_length2             NUMBER := 0;
        var_amt                 NUMBER := 0;
        var_currency            GIIS_CURRENCY.currency_desc%TYPE;
        var_currency_sn         GIIS_CURRENCY.short_name%type;
        currency                VARCHAR2(100); 

    BEGIN
            
      BEGIN
         SELECT DECODE(a.payee_first_name, NULL, a.payee_last_name,
                a.payee_first_name ||' '|| a.payee_middle_name ||' '|| a.payee_last_name) payee_name
           INTO v_payee
           FROM GIIS_PAYEES a, GICL_BATCH_CSR b
          WHERE a.payee_class_cd = b.payee_class_cd
            AND a.payee_no = b.payee_cd
            AND b.batch_csr_id = p_batch_csr_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          NULL;
      END;
      
      BEGIN
       IF p_currency_cd IS NOT NULL THEN
          SELECT currency_desc, short_name                           
           INTO var_currency, var_currency_sn
           FROM GIIS_CURRENCY
          WHERE main_currency_cd = p_currency_cd;
       ELSE    
         SELECT currency_desc, short_name                           
           INTO var_currency, var_currency_sn
           FROM GIIS_CURRENCY
          WHERE short_name IN(SELECT param_value_v
                                FROM GIAC_PARAMETERS
                               WHERE param_name = 'DEFAULT_CURRENCY'); 
       END IF;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          NULL;
      END; 
       
         SELECT INSTR(TO_CHAR(p_sum_paid_amt), '.', 1)    
           INTO var_instr
          FROM dual;

         var_length := NVL(LENGTH(TO_CHAR(p_sum_paid_amt * 100 )), 0);

       IF var_instr = 0 THEN
           var_paid_amt1 := p_sum_paid_amt;  
       ELSE
           SELECT SUBSTR(TO_CHAR(p_sum_paid_amt), 1, var_instr - 1)
               INTO var_paid_amt1
           FROM dual;
     
           SELECT SUBSTR(TO_CHAR(p_sum_paid_amt), var_instr + 1, NVL(LENGTH(TO_CHAR(p_sum_net_ret)), 0))
               INTO var_paid_amt2
           FROM dual;
         END IF;

       SELECT NVL(lENGTH(TO_CHAR(var_paid_amt1)), 0)
            INTO var_lgt_payt
       FROM dual;

       IF var_lgt_payt <= 6  THEN

            var_paid_amt1t  :=  var_paid_amt1;
            var_length1 := NVL(LENGTH(TO_CHAR(var_paid_amt1t)), 0);

       ELSIF var_lgt_payt IN (9,8,7)  THEN

             SELECT SUBSTR(TO_CHAR(var_paid_amt1), var_lgt_payt - 5, var_lgt_payt)
                 INTO var_paid_amt1t
             FROM dual;

             var_length1 := NVL(LENGTH(TO_CHAR(var_paid_amt1t)), 0);

             SELECT SUBSTR(TO_CHAR(var_paid_amt1),0,var_lgt_payt - var_length1)
                 INTO var_paid_amt1m 
             FROM dual;

       ELSIF var_lgt_payt in (10,11,12)  THEN

             SELECT SUBSTR(TO_CHAR(var_paid_amt1), var_lgt_payt - 5, var_lgt_payt)
                  INTO var_paid_amt1t
             FROM dual;
             var_length1 := NVL(LENGTH(TO_CHAR(var_paid_amt1t)), 0);

             SELECT SUBSTR(TO_CHAR(var_paid_amt1), var_lgt_payt - 8, 3)
                  INTO var_paid_amt1m
                  FROM dual;
             var_length2 := NVL(length(to_char(var_paid_amt1m)), 0);

             SELECT SUBSTR(TO_CHAR(var_paid_amt1),0,var_lgt_payt - var_length2-var_length1)
                 INTO var_paid_amt1b
             FROM dual;

         END IF;

         IF var_length = 2 then
            var_amt := p_sum_paid_amt * 100;
         END IF;
         IF var_paid_amt2 != 0 AND var_paid_amt1 IS NOT NULL THEN
             var_spaid_amt2 := 'AND'||' '||GICL_BATCH_CSR_REPORTS_PKG.spell_amount(var_paid_amt2) ||' '||'CENTAVOS';
         ELSIF
             var_paid_amt2 != 0 AND var_paid_amt1 is null THEN
             var_spaid_amt2 := GICL_BATCH_CSR_REPORTS_PKG.spell_amount(var_amt) ||' '||'CENTAVOS ONLY';
         ELSE
             var_spaid_amt2 := NULL;
         END IF;

         IF var_paid_amt1t != 0 THEN
             var_spaid_amt1t := GICL_BATCH_CSR_REPORTS_PKG.spell_amount(var_paid_amt1t);
         ELSE
             var_spaid_amt1t := NULL;
         END IF;

         IF var_paid_amt1m != 0 THEN
             var_spaid_amt1m := GICL_BATCH_CSR_REPORTS_PKG.spell_amount(var_paid_amt1m) ||' '|| 'MILLION';
         ELSE
             var_spaid_amt1m := NULL;
         END IF;

         IF var_paid_amt1b != 0 THEN
             var_spaid_amt1b := GICL_BATCH_CSR_REPORTS_PKG.spell_amount(var_paid_amt1b) ||' '|| 'BILLION';
         ELSE
             var_spaid_amt1b := NULL;
         END IF;

         var_v_sp := '       Please issue a check in favor of '||v_payee||
                     ' in '||var_currency||' : '||DH_UTIL.check_protect(p_sum_paid_amt,currency,TRUE)||' only (' ||var_currency_sn
                     || ' ' ||LTRIM(TO_CHAR(p_sum_paid_amt,'999,999,999,999.00')) ||'), under the following :';
        RETURN(var_v_sp);
    END;
    
     /*
      **  Created by   : Veronica V. Raymundo
      **  Date Created : January 4, 2012
      **  Reference By : GICLR043 - Preliminary Batch CSR Report
      **                 GICLR044 - Final Batch CSR Report 	
      */
    
     FUNCTION get_giclr043_signatory(p_report_id    IN  GIAC_DOCUMENTS.report_id%TYPE,
                                     p_line_cd      IN  GIAC_DOCUMENTS.line_cd%TYPE,
                                     p_branch_cd    IN  GIAC_DOCUMENTS.branch_cd%TYPE,
                                     p_user_id      IN  GIIS_USERS.user_id%TYPE,
                                     p_batch_csr_id IN  GICL_BATCH_CSR.batch_csr_id%TYPE)
      RETURN batch_csr_signatory_tab PIPELINED IS
      
     v_sign         batch_csr_signatory_type;
     v_claim_id     GICL_CLAIMS.claim_id%type;
     
     BEGIN
     
         -- marco - 03.25.2014 - comment out
        /* SELECT claim_id
          INTO v_claim_id
          FROM gicl_advice
         WHERE batch_csr_id = p_batch_csr_id; */
         
--        FOR i IN ( SELECT a.report_no, b.item_no, b.LABEL, c.signatory, c.designation
--                  FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c 
--                 WHERE a.report_no = b.report_no 
--                   AND a.report_id = b.report_id 
--                   AND a.report_id = p_report_id 
--                   AND NVL(a.line_cd, '@')= NVL(p_line_cd,'@') 
--                   AND NVL(a.branch_cd, '@') = NVL(p_branch_cd,'@')
--                   AND b.signatory_id = c.signatory_id     
--                    UNION
--                   SELECT  1 rep_no, 1 item_no, 'Prepared By :' lbel, user_name, ' ' designation
--                    FROM GIIS_USERS
--                   WHERE user_id = p_user_id)

-- <<-- Modified by Makoy Monta?o 12/16/2013 -->>
     
--        FOR i IN (SELECT DISTINCT b.item_no, b.LABEL, c.signatory, c.designation
--                  FROM GIAC_DOCUMENTS a, GIAC_REP_SIGNATORY b, GIIS_SIGNATORY_NAMES c 
--                 WHERE a.report_no = b.report_no 
--                   AND a.report_id = b.report_id 
--                   AND a.report_id = p_report_id
--                   AND b.signatory_id = c.signatory_id     
--                    UNION
--                   SELECT 1 item_no, 'Prepared By :' lbel, user_name, ' ' designation
--                    FROM GIIS_USERS
--                   WHERE user_id = p_user_id
--                   ORDER BY 1)

--          Modified By Reynante Manalad 12.18.2013

        FOR i IN (SELECT distinct a.signatory, a.designation, b.item_no item_no,b.label
                    FROM GIIS_SIGNATORY_NAMES a,
                         GIAC_REP_SIGNATORY b,
                         GICL_CLAIMS c,
                         GIAC_DOCUMENTS d
                   --WHERE c.claim_id = v_claim_id
                   WHERE c.claim_id IN (SELECT claim_id
                                          FROM gicl_advice
                                         WHERE batch_csr_id = p_batch_csr_id) -- marco - 03.25.2014 - to handle multiple claims per batch csr
                     AND c.line_cd = NVL(d.line_cd,c.line_cd)
                     --AND c.pol_iss_cd = NVL(d.branch_cd,c.pol_iss_cd)
                     AND c.iss_cd = NVL(d.branch_cd, c.iss_cd) --marco - 03.25.2014
                     AND b.report_no = d.report_no --marco - 03.25.2014
                     AND d.report_id = p_report_id
                     AND b.report_id = d.report_id
                     AND a.signatory_id = b.signatory_id
                   UNION
                        SELECT  user_name, ' ' designation,0 item_no, 'Prepared By :' lbel --marco - 03.25.2014 - changed item_no to 0
                          FROM GIIS_USERS
                        WHERE user_id = p_user_id
                ORDER BY item_no)
                
        LOOP
            --v_sign.report_no    := i.report_no; --Commented out by Makoy Monta?o 12/16/2013
            v_sign.item_no      := i.item_no;
            v_sign.label        := i.label;
            v_sign.signatory    := i.signatory;
            v_sign.designation  := i.designation;
            PIPE ROW(v_sign);
        END LOOP;
     END;
  
         
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 3, 2012
  **  Reference By : GICLR043 - Preliminary Batch CSR Report
  **                 GICLR044 - Final Batch CSR Report 	
  */
   
  FUNCTION spell_amount(v_payt_amt NUMBER) 
  RETURN VARCHAR2 IS
      v_spelled_amount   VARCHAR2(2000);
    
   BEGIN
     
    SELECT UPPER(TO_CHAR(TO_DATE(TO_CHAR(ABS(v_payt_amt)),'j'),'jsp'))
      INTO v_spelled_amount
    FROM dual;
          

    IF v_payt_amt < 0 THEN 
      v_spelled_amount := 'Negative ' || v_spelled_amount;
    END IF;
      
    RETURN(v_spelled_amount);
    
   END spell_amount;
   
   
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 4, 2012
  **  Reference By : GICLR044 - Final Batch CSR Report
  **  Description  : This retrieves the details necessary for GICLR044 report
  **                  	
  */
  
   FUNCTION get_giclr044_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
    RETURN giclr044_report_tab PIPELINED IS
    
    v_report           giclr044_report_type;
    v_title            VARCHAR2(100);
    v_csr_attn         VARCHAR2(100);
    v_remark           VARCHAR2(200);
    v_bcsr_no          VARCHAR2(50);
    v_return           VARCHAR2(1) := 'N';
    
    CURSOR main IS
        SELECT  b.batch_csr_id
          FROM  GICL_CLAIMS a
               ,GICL_BATCH_CSR b
               ,GICL_ADVICE c
               ,GICL_CLM_LOSS_EXP d
         WHERE a.claim_id = c.claim_id
           AND a.claim_id = d.claim_id
           AND b.batch_csr_id = c.batch_csr_id
           AND b.batch_csr_id = p_batch_csr_id
           AND c.advice_id = d.advice_id
         GROUP BY b.batch_csr_id;
    
    BEGIN
        FOR i IN main
        LOOP
            v_report.f_batch_csr_id := i.batch_csr_id;
            v_return := 'Y';
     
        END LOOP;
        
        IF v_return = 'N' THEN
            RETURN;
        END IF;
        
        /*f_title*/
        SELECT param_value_v
         INTO v_title
        FROM GIAC_PARAMETERS
        WHERE param_name = 'FINAL_CSR_TITLE';
        
        /*f_csr_attn*/
        
        SELECT param_value_v
          INTO v_csr_attn
        FROM GIAC_PARAMETERS
        WHERE param_name = 'CSR_ATTN';
        
        BEGIN
            SELECT b.document_cd||'-'||b.branch_cd||'-'||LTRIM(TO_CHAR(b.doc_year))||'-'||
                   LTRIM(TO_CHAR(b.doc_mm))||'-'||LPAD(LTRIM(TO_CHAR(b.doc_seq_no)),6,'0')
             INTO v_bcsr_no
             FROM GICL_BATCH_CSR a, 
                  GIAC_PAYT_REQUESTS b,
                  GIAC_PAYT_REQUESTS_DTL c
            WHERE a.ref_id = b.ref_id
              AND b.ref_id = c.gprq_ref_id
              AND c.payt_req_flag <> 'X'
              AND a.batch_csr_id = p_batch_csr_id;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_bcsr_no := NULL; 
        END;
         
        /*f_settlement_remarks*/  
         BEGIN
            SELECT param_value_v
              INTO v_remark 
              FROM giac_parameters
             WHERE param_name LIKE 'BCSR_PAYT_REMARK';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_remark := 'As partial/full and final settlement of the above loss.';
          END;
        
        v_report.f_title                 := v_title;            
        v_report.f_csr_attn              := v_csr_attn;
        v_report.f_settlement_remarks    := v_remark;
        v_report.f_bcsr_no               := v_bcsr_no;
        
        /*f_sum_paid_amt and f_currency_cd*/
        DECLARE
            v_sum_paid_amt          NUMBER := 0;
			v_gross_amt             NUMBER := 0;
            v_currency_cd           GIIS_CURRENCY.main_currency_cd%TYPE;
            v_count                 NUMBER := 0;
            
            CURSOR batch IS
                SELECT  a.line_cd ||'-'|| a.subline_cd||'-'|| a.pol_iss_cd ||'-'|| LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'|| LPAD(TO_CHAR(a.renew_no),2,'0') policy_no
                       ,a.assured_name
                       ,a.dsp_loss_date
                       ,a.line_cd ||'-'|| a.subline_cd ||'-'|| a.iss_cd ||'-'|| LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'|| LPAD(TO_CHAR(a.clm_seq_no),7,'0') claim
                       ,b.payee_class_cd
                       ,b.payee_cd
                       ,(d.advise_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) advise_amt 
                       ,(d.net_amt * DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) net_amt
                       ,SUM(d.paid_amt* DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) paid_amt
                       ,b.batch_csr_id
                       ,c.convert_rate
                       ,c.currency_cd
                       ,a.claim_id
                       ,c.advice_id
                       ,d.clm_loss_id
                       ,d.claim_id clm_id
                       ,DECODE(d.clm_clmnt_no, null, 0, d.clm_clmnt_no) clm_clmnt_no
                  FROM  GICL_CLAIMS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d
                 WHERE a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id
                   AND c.advice_id = d.advice_id
                 GROUP BY a.line_cd,a.subline_cd,a.pol_iss_cd,a.issue_yy,a.pol_seq_no,a.renew_no,
                          a.assured_name,a.dsp_loss_date,b.payee_class_cd,b.payee_cd,a.iss_cd,a.clm_yy,a.clm_seq_no,    
                          d.advise_amt,c.convert_rate,d.net_amt,d.paid_amt,b.batch_csr_id,a.claim_id,c.advice_id,d.clm_loss_id, d.claim_id,
                          d.clm_clmnt_no,d.clm_clmnt_no ,c.currency_cd        
                         ,d.currency_cd,c.orig_curr_rate;
        BEGIN
            FOR i IN batch
            LOOP
                v_sum_paid_amt := v_sum_paid_amt + NVL(i.paid_amt, 0);
                v_gross_amt    := v_gross_amt + NVL(i.net_amt, 0);
				v_currency_cd := i.currency_cd;
                
                FOR rec IN (SELECT COUNT(*) claim
  							  FROM GIIS_PAYEES a,
							       GIIS_PAYEE_CLASS b,
							       GICL_LOSS_EXP_BILL c
							 WHERE a.payee_class_cd = c.payee_class_cd
							   AND b.payee_class_cd = a.payee_class_cd
							   AND a.payee_no = c.payee_cd
							   AND c.claim_id = i.clm_id)
                LOOP
                    v_count := v_count + NVL(rec.claim, 0);
                END LOOP;
                
            END LOOP;
            
            v_report.f_sum_paid_amt := v_sum_paid_amt;
            v_report.f_gross_amt 	:= v_gross_amt; -- added by: Nica 02.13.2013
			v_report.f_currency_cd  := v_currency_cd;
            
            /*rv_print_payees*/
            
            IF v_count = 0 THEN
                v_report.rv_print_payees := 'N';
            ELSE    
                v_report.rv_print_payees := 'Y';
            END IF;
        END;
        
        /*f_net_amt*/
        DECLARE
            v_net       GICL_CLM_LOSS_EXP.paid_amt%TYPE := 0;
            tax_amt     GICL_LOSS_EXP_TAX.tax_amt%TYPE := 0;
        BEGIN
  
            FOR i IN (SELECT SUM(a.paid_amt* DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) net_amt
                      FROM GICL_CLM_LOSS_EXP a,
                           GICL_ADVICE c , GICL_BATCH_CSR d
                      WHERE a.claim_id = c.claim_id
                        AND a.advice_id = c.advice_id
                        AND c.batch_csr_id = d.batch_csr_id
                        AND c.batch_csr_id = p_batch_csr_id)
           LOOP
             v_net := i.net_amt;
           END LOOP;
            
            v_report.f_net_amt := v_net;
           
        END;
        
        /*f_short_name*/
        DECLARE
            v_currency     GIIS_CURRENCY.short_name%TYPE;
            
        BEGIN
            IF v_report.f_currency_cd IS NOT NULL THEN
              SELECT short_name                           
               INTO v_currency
               FROM GIIS_CURRENCY
              WHERE main_currency_cd = v_report.f_currency_cd;
           ELSE    
             SELECT param_value_v
               INTO v_currency
             FROM GIAC_PARAMETERS
             WHERE param_name = 'DEFAULT_CURRENCY'; 
           END IF;
           
           v_report.f_short_name := v_currency;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
              v_report.f_short_name := NULL;
        END;
        
        /*f_sum_net_ret, f_sum_treaty and f_sum_facul*/
        DECLARE
            v_sum_net_ret       NUMBER := 0;
            v_sum_treaty        NUMBER := 0;
            v_sum_facul         NUMBER := 0;
            
            CURSOR dist IS
                SELECT b.batch_csr_id, 
                       SUM(DECODE (a.grp_seq_no, 1, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))), 0.00 )) net_ret,
                       SUM(DECODE (a.grp_seq_no, 999, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))), 0.00)) facul,
                       SUM(DECODE (a.grp_seq_no, 1, 0.00, 999, 0.00, a.shr_le_adv_amt*(DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))))) treaty
                  FROM GICL_LOSS_EXP_DS a
                      ,GICL_BATCH_CSR b
                      ,GICL_ADVICE c
                      ,GICL_CLM_LOSS_EXP d 
                 WHERE (a.negate_tag = 'N' OR a.negate_tag IS NULL)
                   AND a.claim_id = c.claim_id 
                   AND a.claim_id = d.claim_id
                   AND a.clm_loss_id = d.clm_loss_id 
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id
                   AND c.advice_id = d.advice_id
                 GROUP BY b.batch_csr_id;
        BEGIN
            FOR d IN dist
            LOOP
                v_sum_net_ret := v_sum_net_ret + NVL(d.net_ret, 0);
                v_sum_treaty  := v_sum_treaty + NVL(d.treaty, 0);
                v_sum_facul   := v_sum_facul + NVL(d.facul, 0);
            END LOOP;
            
            v_report.f_sum_net_ret   := v_sum_net_ret;
            v_report.f_sum_treaty    := v_sum_treaty;
            v_report.f_sum_facul     := v_sum_facul;     
            
        END;
        
        /*f_v_sp*/
        v_report.f_v_sp :=  GICL_BATCH_CSR_REPORTS_PKG.get_v_sp(v_report.f_batch_csr_id, v_report.f_currency_cd, 
                                                                v_report.f_sum_paid_amt, v_report.f_sum_net_ret);
        /*rv_print_logo*/
        DECLARE                                                      
            v_ole_display    VARCHAR2(1);
        BEGIN
          SELECT param_value_v
            INTO v_ole_display
            FROM GIAC_PARAMETERS
           WHERE param_name = 'CSR_OLE_DISPLAY';
          
          IF v_ole_display = 'Y' THEN
            v_report.rv_print_logo := 'Y';
          ELSE
            v_report.rv_print_logo := 'N';
          END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_report.rv_print_logo := 'N';  
        END;
        
        /*rv_print_signatory*/
        
        DECLARE
            v_switch        VARCHAR2(1);
        BEGIN
            FOR rec IN (SELECT param_value_v
                        FROM GIAC_PARAMETERS
                        WHERE param_name = 'CSR_PREPARED_BY')
            LOOP
                v_switch := rec.param_value_v;
            END LOOP;    
             
            IF v_switch = 'Y' THEN
                v_report.rv_print_signatory := 'Y';
            ELSE           
                v_report.rv_print_signatory := 'N';
            END IF;      
        END;
        
        PIPE ROW(v_report);
    
    END get_giclr044_rep_dtls;
    
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 9, 2012
  **  Reference By : GICLR044 - Final Batch CSR Report
  **  Description  : This retrieves list of claims displayed in GICLR044
  **                  	
  */
    
  FUNCTION get_giclr044_claim_list (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_claim_tab PIPELINED IS
  
      v_list          batch_csr_claim_type;
  
      BEGIN
        FOR i IN (SELECT c.advice_id
                       ,a.claim_id 
                       ,a.line_cd
                       ,a.subline_cd
                       ,a.pol_iss_cd
                       ,a.issue_yy
                       ,a.pol_seq_no
                       ,a.renew_no
                       ,a.iss_cd
                       ,a.clm_yy
                       ,a.clm_seq_no
                       ,b.batch_csr_id
                       ,a.assured_name
                       ,a.dsp_loss_date
                       ,SUM(d.paid_amt* DECODE(d.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) paid_amt
                       ,a.line_cd ||'-'|| 
                        a.subline_cd ||'-'|| 
                        a.pol_iss_cd ||'-'|| 
                        LPAD(TO_CHAR(a.issue_yy),2,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.pol_seq_no),7,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.renew_no),2,'0') policy_no
                       ,a.line_cd ||'-'|| 
                        a.subline_cd ||'-'|| 
                        a.iss_cd ||'-'|| 
                        LPAD(TO_CHAR(a.clm_yy),2,'0') ||'-'|| 
                        LPAD(TO_CHAR(a.clm_seq_no),7,'0') claim_no
                   FROM GICL_CLAIMS a
                       ,GICL_BATCH_CSR b
                       ,GICL_ADVICE c
                       ,GICL_CLM_LOSS_EXP d
                 WHERE a.claim_id = c.claim_id
                   AND a.claim_id = d.claim_id
                   AND b.batch_csr_id = c.batch_csr_id
                   AND b.batch_csr_id = p_batch_csr_id
                   AND c.advice_id = d.advice_id
                 GROUP BY a.claim_id, c.advice_id, a.line_cd, a.subline_cd, a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                       a.iss_cd, a.clm_yy, a.clm_seq_no, b.batch_csr_id, a.assured_name,
                       a.dsp_loss_date
                 ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no)
        
        LOOP
            v_list.advice_id        :=  i.advice_id;         
            v_list.claim_id         :=  i.claim_id;   
            v_list.line_cd          :=  i.line_cd;   
            v_list.subline_cd       :=  i.subline_cd;   
            v_list.pol_iss_cd       :=  i.pol_iss_cd;   
            v_list.issue_yy         :=  i.issue_yy;   
            v_list.pol_seq_no       :=  i.pol_seq_no;   
            v_list.renew_no         :=  i.renew_no;   
            v_list.iss_cd           :=  i.iss_cd;  
            v_list.clm_yy           :=  i.clm_yy;   
            v_list.clm_seq_no       :=  i.clm_seq_no;   
            v_list.batch_csr_id     :=  i.batch_csr_id;  
            v_list.assured_name     :=  i.assured_name;  
            v_list.dsp_loss_date    :=  i.dsp_loss_date;   
            v_list.paid_amt         :=  i.paid_amt;   
            v_list.policy_no        :=  i.policy_no;  
            v_list.claim_no         :=  i.claim_no;
            v_list.intermdiary      :=  GICL_BATCH_CSR_REPORTS_PKG.get_batch_csr_intm(i.claim_id); 	 
            v_list.loss_cat_des	    :=  GICL_BATCH_CSR_REPORTS_PKG.get_batch_csr_loss_ctgry(i.line_cd, i.claim_id, i.advice_id); 
            PIPE ROW(v_list);   
        END LOOP;
                 
      END get_giclr044_claim_list;
      
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : January 9, 2012
  **  Reference By : GICLR044B - Batch CSR Detail Report
  **  Description  : This retrieves the details necessary for GICLR044B report
  **                  	
  */
      
    FUNCTION get_giclr044B_rep_dtls (p_batch_csr_id  GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN giclr044B_report_tab PIPELINED AS
     
     v_report           giclr044B_report_type;
     v_cur_claim_id     GICL_CLAIMS.claim_id%TYPE;
     
     BEGIN
         FOR i IN (SELECT DISTINCT a.claim_id, 
                           c.tran_id, a.line_cd,
                           a.line_cd||'-'|| 
                           a.subline_cd||'-'|| 
                           a.iss_cd ||'-'||
                           LTRIM(TO_CHAR(a.clm_yy,'09'))||'-'||
                           LTRIM(TO_CHAR( a.CLM_SEQ_NO,'0000009')) claim_number
                          ,a.LINE_CD||'-'|| 
                           a.subline_cd||'-'|| 
                           a.pol_iss_cd ||'-'||
                           LTRIM(TO_CHAR( a.ISSUE_YY,'09')) || '-' ||
                           LTRIM(TO_CHAR( a.POL_SEQ_NO,'0000009')) || '-'||
                           LTRIM(TO_CHAR( a.RENEW_NO,'09')) policy_number
                          ,a.assured_name, 
                           d.paid_amt,
                           d.peril_cd 
                      FROM GICL_CLAIMS a, 
                           GICL_ADVICE b, 
                           GICL_BATCH_CSR c, 
                           GICL_CLM_LOSS_EXP d
                     WHERE a.claim_id  = b.claim_id
                       AND d.advice_id = b.advice_id
                       AND c.batch_csr_id = p_batch_csr_id
                       AND b.batch_csr_id = c.batch_csr_id
                     ORDER BY claim_number)
         LOOP
             v_report.claim_id       := i.claim_id;     
             v_report.tran_id        := i.tran_id;    
             v_report.line_cd        := i.line_cd;   
             v_report.claim_no       := i.claim_number;   
             v_report.policy_no      := i.policy_number;    
             v_report.assured_name   := i.assured_name;           	 
             v_report.peril_cd       := i.peril_cd;    
             v_report.paid_amt       := i.paid_amt;    
             
            DECLARE 
             v_prt   GIAC_PAYT_REQUESTS_DTL.particulars%TYPE;
             v_indx  NUMBER;

            BEGIN

              FOR p IN(SELECT particulars
                         FROM GICL_BATCH_CSR
                        WHERE batch_csr_id = p_batch_csr_id)
              LOOP
                v_prt := p.particulars;
                EXIT;
              END LOOP;
              
              v_indx := INSTR(UPPER(v_prt), ' (SEE');
              v_report.particulars := SUBSTR(v_prt, 1, v_indx);
            END;
            
            BEGIN
              SELECT b.document_cd||'-'||b.branch_cd||'-'||LTRIM(TO_CHAR(b.doc_year))||'-'||
                     LTRIM(TO_CHAR(b.doc_mm))||'-'||LTRIM(TO_CHAR(b.doc_seq_no))
                INTO v_report.bcsr_no
                FROM GICL_BATCH_CSR a, GIAC_PAYT_REQUESTS b, GIAC_PAYT_REQUESTS_DTL c
               WHERE a.ref_id         = b.ref_id
                 AND b.ref_id         = c.gprq_ref_id
                 AND c.payt_req_flag <> 'X'
                 AND a.batch_csr_id   = p_batch_csr_id;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_report.bcsr_no := NULL; 
  
            END;
            
            BEGIN
             SELECT peril_sname
              INTO v_report.peril_sname
              FROM GIIS_PERIL
             WHERE line_cd = i.line_cd
               AND peril_cd = i.peril_cd;
            EXCEPTION
             WHEN NO_DATA_FOUND THEN 
             v_report.peril_sname := NULL;
           END;
           
           DECLARE
              v_intm		   	VARCHAR2(50);
           BEGIN
               v_report.intermdiary := NULL;
               
               FOR inter IN (SELECT DISTINCT TO_CHAR(c.intm_no) INTM_NO,UPPER(nvl(c.ref_intm_cd,' ')) REF_CD  
                           FROM GICL_CLAIMS a, 
                                GICL_INTM_ITMPERIL b, 
                                GIIS_INTERMEDIARY c
                          WHERE a.claim_id = b.claim_id 
                            AND b.intm_no  = c.intm_no
                            AND a.claim_id = i.claim_id)
               LOOP

                IF inter.ref_cd = ' ' THEN
                  v_intm := inter.intm_no;
                ELSE
                  v_intm := inter.intm_no||'/'||inter.ref_cd;
                END IF;
                  
                  v_report.intermdiary := v_intm;
               END LOOP;

           END;
           
           IF(v_cur_claim_id = i.claim_id) THEN
             v_report.claim_no       := NULL;   
             v_report.policy_no      := NULL;    
             v_report.assured_name   := NULL;
             v_report.intermdiary    := NULL;
           END IF;
           
           v_cur_claim_id := i.claim_id;
              
           PIPE ROW(v_report);        
         
         END LOOP;
     END get_giclr044B_rep_dtls;
	 
	 /*
	  **  Created by   : Veronica V. Raymundo
	  **  Date Created : February 13, 2012
	  **  Reference By : GICLR043 - Preliminary Batch CSR Report
	                     GICLR044B - Batch CSR Detail Report
	  **  Description  : This retrieves the Input VAT list
	  **                  	
	  */
	 
	 FUNCTION get_batch_csr_vat (p_batch_csr_id   GICL_BATCH_CSR.batch_csr_id%TYPE)
     RETURN batch_csr_tax_tab PIPELINED AS
	 
	 v_vat_list		batch_csr_tax_type;
	 
	 BEGIN
	 	FOR i IN (SELECT  b.w_tax
					   ,SUM(b.tax_amt * DECODE(a.currency_cd,GIACP.N('CURRENCY_CD'),1,c.currency_cd,1,NVL(c.orig_curr_rate,c.convert_rate))) b_tax_amt
					   ,d.batch_csr_id
				  FROM  GICL_CLM_LOSS_EXP a
					   ,GICL_LOSS_EXP_TAX b
					   ,GICL_ADVICE c
					   ,GICL_BATCH_CSR d
				 WHERE  a.claim_id = b.claim_id
				   AND  a.clm_loss_id = b.clm_loss_id
				   AND  a.claim_id = c.claim_id
				   AND  a.advice_id = c.advice_id
				   AND  b.tax_type = 'I'
				   AND  c.batch_csr_id = d.batch_csr_id
				   AND  d.batch_csr_id = p_batch_csr_id
				 GROUP  BY b.w_tax,d.batch_csr_id)
		LOOP
			v_vat_list.batch_csr_id := i.batch_csr_id;
			v_vat_list.b_tax_amt    := i.b_tax_amt;
			v_vat_list.w_tax 		:= i.w_tax;
			PIPE ROW(v_vat_list);
	    END LOOP;
	END;
     
END GICL_BATCH_CSR_REPORTS_PKG;
/



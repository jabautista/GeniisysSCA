CREATE OR REPLACE PACKAGE BODY CPI.GIACS087_PKG
AS
    --Modified by pjsantos 11/8/2016,added parameters for optimization GENQA 5817
    FUNCTION get_main_records(  p_filter_dsp_ref_no     VARCHAR2,
                                p_filter_fund_cd        VARCHAR2,
                                p_filter_branch_cd      VARCHAR2,
                                p_filter_batch_year     VARCHAR2,
                                p_filter_batch_mm       VARCHAR2,
                                p_filter_batch_seq_no   VARCHAR2,
                                p_filter_batch_date     VARCHAR2,
                                p_filter_payee_cd       VARCHAR2,
                                p_filter_payee_class_cd VARCHAR2,
                                p_filter_dsp_payee      VARCHAR2,
                                p_filter_batch_flag     VARCHAR2,
                                p_order_by              VARCHAR2,      
                                p_asc_desc_flag         VARCHAR2,      
                                p_first_row             NUMBER,        
                                p_last_row              NUMBER)
        RETURN main_tab PIPELINED
    IS
        rec     main_type;
        --Added by pjsantos 11/8/2016,added parameters for optimization GENQA 5817
        TYPE cur_type IS REF CURSOR;      
        c        cur_type;                
        v_sql    VARCHAR2(32767);
        --pjsantos end
    BEGIN
--        FOR i IN (
         v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT  batch_dv_id       ,
                                            fund_cd           ,
                                            branch_cd         ,
                                            batch_year        ,
                                            batch_mm          ,
                                            batch_seq_no      ,
                                            batch_date        ,
                                            DECODE(batch_flag, ''X'', ''Y'', ''N'') batch_flg        ,
                                            payee_class_cd    ,
                                            payee_cd          ,
                                            (SELECT payee_last_name||DECODE(payee_first_name,NULL,'''','', '') ||
                                                    payee_first_name||DECODE(payee_middle_name,NULL,'''','' '') ||
                                                    payee_middle_name pname
                                               FROM giis_payees z
                                              WHERE z.payee_no       = a.payee_cd
                                                AND z.payee_class_cd = a.payee_class_cd
                                                AND ROWNUM = 1) dsp_payee         , 
                                            particulars       ,
                                            tran_id           ,
                                            paid_amt          ,
                                            fcurr_amt         ,
                                            currency_cd       ,
                                            convert_rate      ,
                                            user_id           ,
                                            last_update       ,
                                            payee_remarks     ,
                                            (SELECT z.document_cd||''-''||z.branch_cd||''-''||
                                                    z.doc_year||''-''||TO_CHAR(z.doc_mm, ''00'')||''-''||TO_CHAR(z.doc_seq_no,''000000'') ref_no 
                                               FROM giac_payt_requests z, giac_payt_requests_dtl b
                                              WHERE z.ref_id = b.gprq_ref_id 
                                                AND b.tran_id = a.tran_id
                                                AND ROWNUM = 1)  dsp_ref_no       
                    FROM giac_batch_dv a
                   WHERE 1=1 ';
                   
                   IF p_filter_fund_cd IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND fund_cd = UPPER('''||p_filter_fund_cd||''') ';
                   END IF;
                   IF p_filter_branch_cd IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND branch_cd = UPPER('''||p_filter_branch_cd||''') ';
                   END IF;
                   IF p_filter_batch_year IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND batch_year = '''||p_filter_batch_year||''' ';
                   END IF;
                   IF p_filter_batch_mm IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND batch_mm = '''||p_filter_batch_mm||''' ';
                   END IF;
                   IF p_filter_batch_seq_no IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND batch_seq_no = '''||p_filter_batch_seq_no||''' ';
                   END IF;
                   IF p_filter_batch_date IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND TRUNC(batch_date) = TO_DATE('''||p_filter_batch_date||''', ''MM-DD-RRRR'') ';
                   END IF;
                   IF p_filter_payee_cd IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND payee_cd = '''||p_filter_payee_cd||''' ';
                   END IF;
                   IF p_filter_payee_class_cd IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND payee_class_cd = UPPER('''||p_filter_payee_class_cd||''') ';
                   END IF;
                   IF p_filter_batch_flag IS NOT NULL
                    THEN
                     v_sql := v_sql ||' AND DECODE(batch_flag, ''X'', ''Y'', ''N'') = NVL(UPPER('''||p_filter_batch_flag||'''), DECODE(batch_flag, ''X'', ''Y'', ''N''))  ';
                   END IF;        
                     
     IF p_order_by IS NOT NULL 
      THEN
        IF p_order_by = 'fundCd branchCd batchYear batchMM batchSeqNo'
         THEN      
          IF p_asc_desc_flag = 'DESC'
           THEN   
            v_sql := v_sql || '  ORDER BY fund_cd DESC, branch_cd DESC , batch_year DESC, batch_mm DESC, batch_seq_no ';
          ELSE
             v_sql := v_sql || '  ORDER BY fund_cd , branch_cd  , batch_year , batch_mm , batch_seq_no ';
          END IF;
        ELSIF  p_order_by = 'batchDate'
         THEN
          v_sql := v_sql || ' ORDER BY batch_date ';
        ELSIF  p_order_by = 'payeeCd payeeClassCd dspPayee payeeRemarks'
         THEN
          IF p_asc_desc_flag = 'DESC'
           THEN     
            v_sql := v_sql || ' ORDER BY payee_cd DESC, payee_class_cd DESC, dsp_payee DESC, payee_remarks ';
          ELSE
            v_sql := v_sql || ' ORDER BY payee_cd , payee_class_cd, dsp_payee, payee_remarks ';
          END IF;
        ELSIF  p_order_by = 'batchFlag'
         THEN
          v_sql := v_sql || ' ORDER BY batch_flag '; 
        ELSIF  p_order_by = 'dspRefNo'
         THEN
          v_sql := v_sql || ' ORDER BY dsp_ref_no ';         
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    END IF;
    IF p_filter_dsp_ref_no IS NOT NULL
     THEN
       v_sql := v_sql ||' ) innersql ';                 
       v_sql := v_sql ||' WHERE UPPER(TRIM(dsp_ref_no)) LIKE UPPER('''||p_filter_dsp_ref_no||''') ';
    END IF;
    IF p_filter_dsp_payee IS NOT NULL
     THEN
       v_sql := v_sql ||' ) innersql ';                 
       v_sql := v_sql ||' WHERE UPPER(dsp_payee) LIKE UPPER('''||p_filter_dsp_payee||''') ';
    END IF;
    IF p_filter_dsp_ref_no IS NOT NULL OR p_filter_dsp_payee IS NOT NULL
     THEN
        v_sql := v_sql || ' ) outersql) mainsql WHERE rownum_ BETWEEN ' || p_first_row || ' AND '|| p_last_row;
    ELSE
        v_sql := v_sql || ' ) innersql ) outersql) mainsql WHERE rownum_ BETWEEN ' || p_first_row || ' AND '|| p_last_row;
    END IF;
    
    OPEN c FOR v_sql;
        LOOP
            FETCH c INTO  
            rec.count_,
            rec.rownum_,
            rec.batch_dv_id       ,
            rec.fund_cd           ,
            rec.branch_cd         ,
            rec.batch_year        ,
            rec.batch_mm          ,
            rec.batch_seq_no      ,
            rec.batch_date        ,
            rec.batch_flag        ,
            rec.payee_class_cd    ,
            rec.payee_cd          ,
            rec.dsp_payee         , 
            rec.particulars       ,
            rec.tran_id           ,
            rec.paid_amt          ,
            rec.fcurr_amt         ,
            rec.currency_cd       ,
            rec.convert_rate      ,
            rec.user_id           ,
            rec.last_update       ,
            rec.payee_remarks     ,
            rec.dsp_ref_no        ;     
            /*rec.batch_dv_id     := i.batch_dv_id;
            rec.fund_cd         := i.fund_cd;
            rec.branch_cd       := i.branch_cd;
            rec.batch_year      := i.batch_year;
            rec.batch_mm        := i.batch_mm;
            rec.batch_seq_no    := i.batch_seq_no;
            rec.batch_date      := i.batch_date;
            rec.batch_flag      := i.batch_flg;
            rec.payee_class_cd  := i.payee_class_cd;
            rec.payee_cd        := i.payee_cd;
            rec.particulars     := i.particulars;
            rec.tran_id         := i.tran_id;
            rec.paid_amt        := i.paid_amt;
            rec.fcurr_amt       := i.fcurr_amt;
            rec.currency_cd     := i.currency_cd;
            rec.convert_rate    := i.convert_rate;
            rec.user_id         := i.user_id;
            rec.last_update     := i.last_update;
            rec.payee_remarks   := i.payee_remarks;
            
            FOR j IN (SELECT payee_last_name||DECODE(payee_first_name,NULL,'',', ') ||
                             payee_first_name||DECODE(payee_middle_name,NULL,'',' ') ||
                             payee_middle_name pname
                        FROM giis_payees a
                       WHERE a.payee_no       = i.payee_cd
                         AND a.payee_class_cd = i.payee_class_cd)
            LOOP
                rec.dsp_payee := j.pname;
            END LOOP;
            
            FOR c IN (SELECT a.document_cd||'-'||a.branch_cd||'-'||
                               a.doc_year||'-'||a.doc_mm||'-'||a.doc_seq_no ref_no 
                        FROM giac_payt_requests a, giac_payt_requests_dtl b
                       WHERE a.ref_id = b.gprq_ref_id 
                         AND b.tran_id = i.tran_id    */          
                        /*UNION 
                        SELECT b.batch_dv_id, b.jv_tran_id tran_id, a.gibr_branch_cd branch_cd, 
                               a.tran_class||'-'||a.gibr_branch_cd||'-'||a.tran_year||'-'||
                               a.tran_month||'-'||a.tran_seq_no ref_no, a.particulars 
                        FROM giac_acctrans a, giac_batch_dv_dtl b 
                        WHERE a.tran_id = b.jv_tran_id
                          AND batch_dv_id = :giac_batch_dv.batch_dv_id
            LOOP
                rec.dsp_ref_no := c.ref_no;
                EXIT;
            END LOOP;)*/
  
            EXIT WHEN c%NOTFOUND;              
         PIPE ROW (rec);
       END LOOP;       
      CLOSE c;  
    END get_main_records; 
    
    
    FUNCTION get_batch_details(
        p_batch_dv_id       giac_batch_dv.BATCH_DV_ID%type
    ) RETURN batch_details_tab PIPELINED
    AS
        rec     batch_details_type;
    BEGIN
        FOR i IN ( SELECT d.batch_dv_id, a.line_cd, a.iss_cd, a.advice_year, a.advice_seq_no, a.paid_amt paid_amt2, a.currency_cd, 
                          DECODE(a.currency_cd, giacp.n('CURRENCY_CD'), 1, a.convert_rate) convert_rate, a.advice_flag, a.user_id, 
                          a.last_update, a.advice_id, a.claim_id, a.apprvd_tag, a.paid_fcurr_amt, b.payee_cd, b.payee_class_cd, 
                          b.payee_type, b.clm_loss_id, decode(b.currency_cd, giacp.n('CURRENCY_CD'), 1, a.convert_rate) conv_rt, 
                          b.net_amt, b.paid_amt paid_amt, b.currency_cd loss_curr_cd, c.clm_stat_cd, a.payee_remarks 
                     FROM gicl_claims c, 
                          gicl_advice a, 
                          gicl_clm_loss_exp b, 
                          giac_batch_dv_dtl d 
                    WHERE a.claim_id = d.claim_id 
                      and a.advice_id = d.advice_id 
                      AND a.advice_id <> 0 
                      and b.claim_id = d.claim_id 
                      and b.clm_loss_id = d.clm_loss_id 
                      and c.claim_id = a. claim_id 
                      AND a.claim_id = b.claim_id 
                      AND batch_csr_id IS NULL
                      AND d.BATCH_DV_ID = p_batch_dv_id )
        LOOP
            rec.batch_dv_id     := i.batch_dv_id;
            rec.line_cd         := i.line_cd;
            rec.iss_cd          := i.iss_cd;
            rec.advice_year     := i.advice_year;
            rec.advice_seq_no   := i.advice_seq_no;
            rec.paid_amt2       := i.paid_amt2;
            rec.currency_cd     := i.currency_cd;
            rec.convert_rate    := i.convert_rate;
            rec.advice_flag     := i.advice_flag;
            rec.user_id         := i.user_id;
            rec.last_update     := i.last_update;
            rec.advice_id       := i.advice_id;
            rec.claim_id        := i.claim_id;
            rec.apprvd_tag      := i.apprvd_tag;
            rec.paid_fcurr_amt  := i.paid_fcurr_amt;
            rec.payee_cd        := i.payee_cd;
            rec.payee_class_cd  := i.payee_class_cd;
            rec.payee_type      := i.payee_type;
            rec.clm_loss_id     := i.clm_loss_id;
            rec.net_amt         := i.net_amt;
            rec.paid_amt        := i.paid_amt;
            rec.loss_curr_cd    := i.loss_curr_cd;
            rec.clm_stat_cd     := i.clm_stat_cd;
            rec.payee_remarks   := i.payee_remarks;
            
            FOR x in (SELECT line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no,
                               pol_iss_cd, issue_yy, pol_seq_no, renew_no,
                               assd_no, assured_name, dsp_loss_date
                          FROM gicl_claims
                         WHERE claim_id = i.claim_id)
            LOOP
                rec.nbt_clm_line_cd := x.line_cd;
                rec.nbt_clm_subline_cd := x.subline_cd;
                rec.nbt_clm_iss_cd := x.iss_cd;
                rec.nbt_clm_clm_yy := x.clm_yy;
                rec.nbt_clm_clm_seq_no := x.clm_seq_no;
                    
                rec.nbt_pol_line_cd := x.line_cd;
                rec.nbt_pol_subline_cd := x.subline_cd;
                rec.nbt_pol_pol_iss_cd := x.pol_iss_cd;
                rec.nbt_pol_issue_yy := x.issue_yy;
                rec.nbt_pol_pol_seq_no := x.pol_seq_no;
                rec.nbt_pol_renew_no := x.renew_no;
                    
                rec.nbt_assd_no := x.assd_no;
                rec.nbt_assd_name := x.assured_name;
                    
                rec.nbt_dsp_loss_date := x.dsp_loss_date;                    
            END LOOP;
            
            FOR x IN (SELECT clm_stat_desc
                          FROM giis_clm_stat a
                         WHERE a.clm_stat_cd = i.clm_stat_cd)
            LOOP      
                rec.nbt_clm_stat_desc := x.clm_stat_desc;
            END LOOP; 
            
            FOR x IN (SELECT payee_last_name||DECODE(payee_first_name,NULL,'',', ')||
                               payee_first_name||DECODE(payee_middle_name,NULL,'',' ')||
                               payee_middle_name pname
                          FROM giis_payees a
                         WHERE a.payee_no = i.payee_cd
                           AND a.payee_class_cd = i.payee_class_cd)
            LOOP      
                rec.nbt_payee := x.pname;
            END LOOP;   
            
            IF rec.currency_cd = giacp.n('CURRENCY_CD') THEN
                rec.nbt_paid_amt := rec.paid_amt * i.conv_rt;
                rec.nbt_paid_fcurr_amt := rec.paid_amt * i.conv_rt;
            ELSE 
                IF rec.loss_curr_cd = giacp.n('CURRENCY_CD') THEN
                    rec.nbt_paid_amt := rec.paid_amt / i.conv_rt;
                    rec.nbt_paid_fcurr_amt := rec.paid_amt / i.conv_rt;
                ELSE
                    rec.nbt_paid_amt := rec.paid_amt;
                    rec.nbt_paid_fcurr_amt := rec.paid_amt;
                END IF;          
            END IF;
        
            IF p_batch_dv_id IS NULL THEN
                rec.chk_gen     := 'N';
            ELSE
                rec.chk_gen     := 'Y';
            END IF;
            
            PIPE ROW(rec);
        END LOOP;    
    END get_batch_details;
    
    
    FUNCTION get_acct_entries(
        p_batch_dv_id       giac_batch_dv.BATCH_DV_ID%type
    ) RETURN acct_entries_tab PIPELINED
    AS
        rec     acct_entries_type;
    BEGIN
        FOR h IN( SELECT c.batch_dv_id, c.tran_id, a.branch_cd, 
                         a.document_cd||'-'||a.branch_cd||'-'||a.doc_year||'-'||a.doc_mm||'-'||a.doc_seq_no ref_no, 
                         b.particulars 
                    FROM giac_payt_requests a, 
                         giac_payt_requests_dtl b, 
                         giac_batch_dv c 
                   WHERE a.ref_id = b.gprq_ref_id 
                     AND b.tran_id = c.tran_id 
                     AND c.batch_dv_id = p_batch_dv_id
                   UNION 
                  SELECT b.batch_dv_id, b.jv_tran_id tran_id, a.gibr_branch_cd branch_cd, 
                         a.tran_class||'-'||a.gibr_branch_cd||'-'||a.tran_year||'-'||a.tran_month||'-'||a.tran_seq_no ref_no, 
                         a.particulars 
                    FROM giac_acctrans a, 
                         giac_batch_dv_dtl b 
                   WHERE a.tran_id = b.jv_tran_id
                     AND b.batch_dv_id = p_batch_dv_id)
        LOOP
            rec.batch_dv_id     := h.batch_dv_id;
            rec.tran_id         := h.tran_id;
            rec.branch_cd       := h.branch_cd;
            rec.ref_no          := h.ref_no;
            rec.particulars     := h.particulars;
            
            PIPE ROW(rec);
        END LOOP;
    END get_acct_entries;
    
    
    FUNCTION get_acct_entries_dtl(
        p_tran_id       giac_batch_dv.TRAN_ID%type
    ) RETURN acct_entries_dtl_tab PIPELINED
    AS
        rec     acct_entries_dtl_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM giac_acct_entries
                   WHERE gacc_tran_id = p_tran_id)
        LOOP
            rec.gacc_tran_id        := i.gacc_tran_id;
            rec.gacc_gfun_fund_cd   := i.gacc_gfun_fund_cd;
            rec.gacc_gibr_branch_cd := i.gacc_gibr_branch_cd;
            rec.acct_entry_id       := i.acct_entry_id;
            rec.gl_acct_id          := i.gl_acct_id;
            rec.gl_acct_category    := i.gl_acct_category;
            rec.gl_control_acct     := i.gl_control_acct;
            rec.gl_sub_acct_1       := i.gl_sub_acct_1;
            rec.gl_sub_acct_2       := i.gl_sub_acct_2;
            rec.gl_sub_acct_3       := i.gl_sub_acct_3;
            rec.gl_sub_acct_4       := i.gl_sub_acct_4;
            rec.gl_sub_acct_5       := i.gl_sub_acct_5;
            rec.gl_sub_acct_6       := i.gl_sub_acct_6;
            rec.gl_sub_acct_7       := i.gl_sub_acct_7;
            rec.sl_cd               := i.sl_cd;
            rec.debit_amt           := i.debit_amt;
            rec.credit_amt          := i.credit_amt;
            
            rec.gl_acct_no          := i.gl_acct_category || '-' || LPAD(i.gl_control_acct, 2, 0) || '-' || LPAD(i.gl_sub_acct_1, 2, 0) || '-' || LPAD(i.gl_sub_acct_2, 2, 0)
                                        || '-' || LPAD(i.gl_sub_acct_3, 2, 0) || '-' || LPAD(i.gl_sub_acct_4, 2, 0) || '-' || LPAD(i.gl_sub_acct_5, 2, 0) 
                                        || '-' || LPAD(i.gl_sub_acct_6, 2, 0) || '-' || LPAD(i.gl_sub_acct_7, 2, 0);
        
            FOR a IN   (SELECT gl_acct_name
                          FROM giac_chart_of_accts  
                         WHERE gl_acct_category = i.gl_acct_category
                           AND gl_control_acct = i.gl_control_acct
                           AND gl_sub_acct_1 = i.gl_sub_acct_1
                           AND gl_sub_acct_2 = i.gl_sub_acct_2
                           AND gl_sub_acct_3 = i.gl_sub_acct_3
                           AND gl_sub_acct_4 = i.gl_sub_acct_4
                           AND gl_sub_acct_5 = i.gl_sub_acct_5
                           AND gl_sub_acct_6 = i.gl_sub_acct_6
                           AND gl_sub_acct_7 = i.gl_sub_acct_7)
                                       
            LOOP
                rec.gl_acct_name := a.gl_acct_name;               
            END LOOP; 
  
            PIPE ROW(rec);
        END LOOP;
    END get_acct_entries_dtl;
    
END GIACS087_PKG;
/



CREATE OR REPLACE PACKAGE BODY CPI.GIACS081_PKG
AS
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.15.2013
   **  Reference By : GIACS081
   **  Remarks      : branch LOV for Replenishment of Revolving Fund
   */
   FUNCTION get_replenishment_branch(
        p_branch    GIAC_BRANCHES.branch_name%TYPE,
        p_user_id   giis_users.user_id%TYPE
   )
        RETURN replenish_branch_tab PIPELINED
   IS
        v_rep   replenish_branch_type;
    BEGIN
        FOR q IN (SELECT branch_cd, branch_name
                    FROM GIAC_BRANCHES
                   WHERE CHECK_USER_PER_ISS_CD_ACCTG2(NULL, branch_cd, 'GIACS081', p_user_id) = 1
                     AND (UPPER(branch_cd) LIKE UPPER(NVL(p_branch,'%')) OR UPPER(branch_name) LIKE UPPER(NVL(p_branch,'%')))
                ORDER BY branch_cd)
        LOOP
            v_rep.branch_cd     := q.branch_cd;
            v_rep.branch_name   := q.branch_name;
            PIPE ROW(v_rep);
        END LOOP;
    END get_replenishment_branch;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.16.2013
   **  Reference By : GIACS081
   **  Remarks      : replenishment main details
   */
    FUNCTION get_replenishment(p_user_id  VARCHAR2) -- added parameter : shan 10.08.2014    
        RETURN replenish_rev_fund_tab PIPELINED
    IS
        v_rep   replenish_rev_fund_type;    
    BEGIN
        FOR q IN (SELECT replenish_id, branch_cd, replenish_seq_no, revolving_fund_amt, replenishment_amt, 
                         replenish_tran_id, replenish_year, create_by, create_date 
                    FROM GIAC_REPLENISH_DV
                   WHERE branch_cd IN (SELECT iss_cd
                                         FROM GIIS_ISSOURCE
                                        WHERE CHECK_USER_PER_ISS_CD_ACCTG2 (NULL,iss_cd, 'GIACS081', p_user_id) = 1)            
                ORDER BY branch_cd, replenish_id DESC)
        LOOP
            FOR w IN (SELECT branch_name
	        	        FROM giac_branches
	                   WHERE branch_cd = q.branch_cd)
            LOOP
                v_rep.replenish_id       := q.replenish_id;
                v_rep.branch_cd          := q.branch_cd;
                v_rep.branch             := w.branch_name;--q.branch_cd ||'-'|| w.branch_name; Gzelle 11.22.2013
                v_rep.replenishment_no   := q.replenish_year ||'-'|| q.replenish_seq_no;
                v_rep.replenish_seq_no   := q.replenish_seq_no;
                v_rep.revolving_fund_amt := q.revolving_fund_amt;
                v_rep.replenishment_amt  := q.replenishment_amt;
                v_rep.replenish_tran_id  := q.replenish_tran_id;
                v_rep.replenish_year     := q.replenish_year;
                v_rep.create_by          := q.create_by;
                v_rep.create_date        := q.create_date;
                PIPE ROW(v_rep);
            END LOOP;
        END LOOP;
    END get_replenishment;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.16.2013
   **  Reference By : GIACS081
   **  Remarks      : replenishment details
   */
    FUNCTION get_replenishment_details(
        p_replenish_id      giac_replenish_dv_dtl.replenish_id%TYPE,
        p_branch_cd         giac_branches.branch_cd%TYPE,
        p_check_date_from   VARCHAR2,
        p_check_date_to     VARCHAR2,        
        p_modify_rec        VARCHAR2
    )        
        RETURN replenish_detail_tab PIPELINED
    IS
        v_rep           replenish_detail_type;
        v_branch        GIAC_BRANCHES.branch_cd%TYPE;
    BEGIN
        IF p_modify_rec = 'N'   --retrieve existing records
        THEN
            FOR q IN (SELECT c.replenish_id, TO_CHAR(b.check_date,'MM-DD-YYYY') check_date, c.dv_tran_id, a.dv_pref, a.dv_no, b.check_pref_suf,
                             b.check_no, d.document_cd,d.branch_cd, d.line_cd, LTRIM(TO_CHAR(d.doc_year,'0999')) doc_year,
                             LTRIM(TO_CHAR(d.doc_mm,'09')) doc_mm, LTRIM(TO_CHAR(d.doc_seq_no, '099999')) doc_seq_no,
                             a.gprq_ref_id, c.check_item_no, a.payee, a.particulars, c.amount
                        FROM giac_replenish_dv_dtl c,
                             giac_payt_requests d,
                             giac_disb_vouchers a,
                             giac_chk_disbursement b
                       WHERE b.gacc_tran_id = a.gacc_tran_id
                         AND c.dv_tran_id = a.gacc_tran_id
                         AND d.ref_id = a.gprq_ref_id
                         AND c.check_item_no = b.item_no
                         AND replenish_id = p_replenish_id)
            LOOP
                v_rep.replenish_id   := q.replenish_id;
                v_rep.replenish_sw   := 'Y';
                v_rep.check_date     := q.check_date;
                v_rep.dv_tran_id     := q.dv_tran_id; 
                --v_rep.dv_pref        := q.dv_pref;
                v_rep.dv_no          := q.dv_pref ||'-'|| q.dv_no;
                --v_rep.check_pref_suf := q.check_pref_suf;
                v_rep.check_no       := q.check_pref_suf ||'-'|| q.check_no;
                v_rep.request_no     := q.document_cd 
                                        ||'-'|| q.branch_cd
                                        ||'-'|| q.line_cd
                                        ||'-'|| q.doc_year
                                        ||'-'|| q.doc_mm
                                        ||'-'|| q.doc_seq_no;
                --v_rep.gprq_ref_id    := q.gprq_ref_id;
                v_rep.check_item_no  := q.check_item_no;
                v_rep.payee          := q.payee;
                v_rep.particulars    := q.particulars;
                v_rep.amount         := q.amount;
                PIPE ROW(v_rep);
            END LOOP;
        ELSIF p_modify_rec = 'Y'    --retrieve records for modification 
        THEN
            FOR w IN (SELECT *
                        FROM (SELECT TO_CHAR(b.check_date,'MM-DD-YYYY') check_date, a.gacc_tran_id, 0 replenish_id,c.gibr_branch_cd,b.amount, b.item_no, c.tran_date, 
                                     a.dv_pref, a.dv_no, b.check_pref_suf, b.check_no, d.document_cd, d.branch_cd, d.line_cd, 
                                     LTRIM(TO_CHAR(d.doc_year,'0999')) doc_year, LTRIM(TO_CHAR(d.doc_mm,'09')) doc_mm,
                                     LTRIM(TO_CHAR(d.doc_seq_no, '099999')) doc_seq_no, d.ref_id, a.payee, a.particulars, 'N' replenished_tag 
                                FROM giac_acctrans c, 
                                     giac_payt_requests d, 
                                     giac_disb_vouchers a, 
                                     giac_chk_disbursement b 
                               WHERE a.gacc_tran_id = b.gacc_tran_id 
                                 AND b.gacc_tran_id = c.tran_id 
                                 AND d.ref_id = a.gprq_ref_id 
                                 AND b.check_stat = 2 
                                 AND c.tran_flag IN ('C', 'P') 
                                 AND NVL (a.replenished_tag, 'N') <> 'Y' 
                                 AND NOT EXISTS (SELECT '1' 
                                                   FROM giac_reversals x, giac_acctrans y 
                                                  WHERE x.reversing_tran_id = y.tran_id 
                                                    AND x.gacc_tran_id = a.gacc_tran_id 
                                                    AND y.tran_flag <> 'D')
                             UNION
                              SELECT TO_CHAR(b.check_date,'MM-DD-YYYY') check_date, c.dv_tran_id, c.replenish_id, '' gibr_branch_cd, c.amount, c.check_item_no, sysdate, 
                                     a.dv_pref, a.dv_no, b.check_pref_suf, b.check_no, d.document_cd, d.branch_cd, d.line_cd,
                                     LTRIM(TO_CHAR(d.doc_year,'0999')) doc_year, LTRIM(TO_CHAR(d.doc_mm,'09')) doc_mm, 
                                     LTRIM(TO_CHAR(d.doc_seq_no, '009')) doc_seq_no, a.GPRQ_REF_ID, a.payee, a.particulars, 'N' replenished_tag 
                                FROM giac_replenish_dv_dtl c, 
                                     giac_payt_requests d, 
                                     giac_disb_vouchers a, 
                                     giac_chk_disbursement b 
                               WHERE b.gacc_tran_id = a.gacc_tran_id 
                                 AND c.dv_tran_id = a.gacc_tran_id 
                                 AND d.ref_id = a.gprq_ref_id 
                                 AND c.check_item_no = b.item_no
                                 AND replenish_id <> p_replenish_id
                             UNION
                              SELECT TO_CHAR(b.check_date,'MM-DD-YYYY') check_date, c.dv_tran_id, c.replenish_id, '' gibr_branch_cd, c.amount, c.check_item_no, sysdate, 
                                     a.dv_pref, a.dv_no, b.check_pref_suf, b.check_no, d.document_cd, d.branch_cd, d.line_cd, 
                                     LTRIM(TO_CHAR(d.doc_year,'0999')) doc_year, LTRIM(TO_CHAR(d.doc_mm,'09')) doc_mm, 
                                     LTRIM(TO_CHAR(d.doc_seq_no, '099999')) doc_seq_no, a.GPRQ_REF_ID, a.payee, a.particulars, 'Y' replenished_tag 
                                FROM giac_replenish_dv_dtl c, 
                                     giac_payt_requests d, 
                                     giac_disb_vouchers a, 
                                     giac_chk_disbursement b 
                               WHERE b.gacc_tran_id = a.gacc_tran_id 
                                 AND c.dv_tran_id = a.gacc_tran_id 
                                 AND d.ref_id = a.gprq_ref_id 
                                 AND c.check_item_no = b.item_no
                                 AND replenish_id = p_replenish_id)
                       WHERE replenish_id = p_replenish_id
                          OR gibr_branch_cd = p_branch_cd
                    ORDER BY replenish_id DESC) 
            LOOP
                v_rep.replenish_id   := w.replenish_id;
                v_rep.replenish_sw   := w.replenished_tag;
                v_rep.check_date     := w.check_date;
                v_rep.dv_tran_id     := w.gacc_tran_id; 
                --v_rep.dv_pref        := w.dv_pref;
                v_rep.dv_no          := w.dv_pref ||'-'|| w.dv_no;
                --v_rep.check_pref_suf := w.check_pref_suf;
                v_rep.check_no       := w.check_pref_suf ||'-'|| w.check_no;
                v_rep.request_no     := w.document_cd 
                                        ||'-'|| w.branch_cd
                                        ||'-'|| w.line_cd
                                        ||'-'|| w.doc_year
                                        ||'-'|| w.doc_mm
                                        ||'-'|| w.doc_seq_no;
                --v_rep.gprq_ref_id    := w.ref_id;
                v_rep.check_item_no  := w.item_no;
                v_rep.payee          := w.payee;
                v_rep.particulars    := w.particulars;
                v_rep.amount         := w.amount;
                PIPE ROW(v_rep);       
            END LOOP;
        ELSIF p_modify_rec = 'X'
        THEN
            FOR e IN(SELECT a.gacc_tran_id, c.gibr_branch_cd, c.tran_date, a.dv_pref, a.dv_no,
                            b.check_pref_suf, b.check_no, d.document_cd, d.branch_cd, d.line_cd,
                            LTRIM(TO_CHAR(d.doc_year,'0999')) doc_year, LTRIM(TO_CHAR(d.doc_mm,'09')) doc_mm, 
                            LTRIM(TO_CHAR(d.doc_seq_no, '099999')) doc_seq_no, b.amount, b.item_no, a.payee,
                            a.particulars,TO_CHAR(b.check_date,'MM-DD-YYYY') check_date, 'N' replenished_tag 
                       FROM giac_acctrans c,
                            giac_payt_requests d,
                            giac_disb_vouchers a,
                            giac_chk_disbursement b
                      WHERE a.gacc_tran_id = b.gacc_tran_id
                        AND b.gacc_tran_id = c.tran_id
                        AND d.ref_id = a.gprq_ref_id
                        AND b.check_stat = 2
                        AND c.tran_flag IN ('C', 'P')
                        AND NVL (a.replenished_tag, 'N') <> 'Y'
                        AND NOT EXISTS ( SELECT '1'
                                           FROM giac_reversals x, giac_acctrans y
                                          WHERE x.reversing_tran_id = y.tran_id
                                            AND x.gacc_tran_id = a.gacc_tran_id
                                            AND y.tran_flag <> 'D')
                        AND TRUNC (tran_date) BETWEEN NVL (TRUNC (TO_DATE(p_check_date_from,'MM-DD-YYYY')), tran_date)
                        AND NVL (TRUNC (TO_DATE(p_check_date_to,'MM-DD-YYYY')),tran_date)
                        AND c.gibr_branch_cd = NVL (p_branch_cd, c.gibr_branch_cd))
            LOOP
                v_rep.replenish_sw   := e.replenished_tag;
                v_rep.check_date     := e.check_date;
                v_rep.dv_tran_id     := e.gacc_tran_id; 
                --v_rep.dv_pref        := e.dv_pref;
                v_rep.dv_no          := e.dv_pref ||'-'|| e.dv_no;
                --v_rep.check_pref_suf := e.check_pref_suf;
                v_rep.check_no       := e.check_pref_suf ||'-'|| e.check_no;
                v_rep.request_no     := e.document_cd 
                                        ||'-'|| e.branch_cd
                                        ||'-'|| e.line_cd
                                        ||'-'|| e.doc_year
                                        ||'-'|| e.doc_mm
                                        ||'-'|| e.doc_seq_no;
                v_rep.check_item_no  := e.item_no;
                v_rep.payee          := e.payee;
                v_rep.particulars    := e.particulars;
                v_rep.amount         := e.amount;
                PIPE ROW(v_rep);
            END LOOP;  
        END IF;                 
    END get_replenishment_details;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.18.2013
   **  Reference By : GIACS081
   **  Remarks      : replenishment accounting entries/summarized
   */    
    FUNCTION get_rep_acct_entries(
        p_tran_id           giac_acct_entries.gacc_tran_id%TYPE
    )
        RETURN rep_acct_entries_tab PIPELINED
    IS
        v_rep   rep_acct_entries_type;
    BEGIN
        FOR q IN (SELECT TO_CHAR(a.gl_acct_category)|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_7,'09')) gl_acct_code,
                         LTRIM(TO_CHAR(a.sl_cd, '099999999999')) sl_cd, sum(a.debit_amt) debit_amt, sum(a.credit_amt) credit_amt, 
                         a.sl_type_cd, b.gl_acct_name, c.replenish_id, a.gacc_gfun_fund_cd, 
                         a.gacc_gibr_branch_cd, a.gl_acct_id, a.gacc_tran_id
                   FROM  giac_chart_of_accts b, giac_replenish_dv_dtl c, giac_acct_entries a 
                   WHERE a.gl_acct_id = b.gl_acct_id 
                     AND a.gacc_tran_id = c.dv_tran_id 
                     AND gacc_tran_id = p_tran_id           
                GROUP BY a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1, a.gl_sub_acct_2, 
                         a.gl_sub_acct_3, a.gl_sub_acct_4, a.gl_sub_acct_5, a.gl_sub_acct_6, 
                         a.gl_sub_acct_7, a.sl_cd, a.sl_type_cd, b.gl_acct_name,c.replenish_id, 
                         a.gacc_gfun_fund_cd, a.gacc_gibr_branch_cd, a.gl_acct_id, a.gacc_tran_id
                ORDER BY a.gl_acct_category, a.gl_control_acct, a.gl_sub_acct_1, a.gl_sub_acct_2, 
                         a.gl_sub_acct_3, a.gl_sub_acct_4, a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7)
        LOOP
            v_rep.gl_acct_code  := q.gl_acct_code;
            v_rep.debit_amt     := q.debit_amt;
            v_rep.credit_amt    := q.credit_amt;
            v_rep.gl_acct_name  := q.gl_acct_name;
            v_rep.replenish_id  := q.replenish_id;
            v_rep.sl_cd         := q.sl_cd;
            v_rep.gacc_tran_id  := q.gacc_tran_id;
            v_rep.fund_cd       := q.gacc_gfun_fund_cd;
            v_rep.branch_cd     := q.gacc_gibr_branch_cd;
            
            FOR w IN (SELECT sl_name 
                        FROM giac_sl_lists 
                       WHERE sl_type_cd = q.sl_type_cd
                         AND sl_cd = q.sl_cd)
            LOOP
                v_rep.sl_name  := w.sl_name;
            END LOOP;
                
            FOR e IN (SELECT SUM(NVL(debit_amt,0)) sum_debit, SUM(NVL(credit_amt,0)) sum_credit
                        FROM giac_acct_entries
                       WHERE gacc_tran_id = v_rep.gacc_tran_id
                         AND gacc_gfun_fund_cd = v_rep.fund_cd
                         AND gacc_gibr_branch_cd = v_rep.branch_cd)
            LOOP
                v_rep.total_debit   := NVL (e.sum_debit, 0);
                v_rep.total_credit  := NVL (e.sum_credit, 0);
            END LOOP;
                v_rep.balance := v_rep.total_debit - v_rep.total_credit;
            PIPE ROW(v_rep); 
        END LOOP;    
    END get_rep_acct_entries;          


    FUNCTION get_rep_sum_acct_entries(
        p_replenish_id      giac_replenish_dv_dtl.replenish_id%TYPE
    )
        RETURN rep_acct_entries_tab PIPELINED
    IS
        v_rep   rep_acct_entries_type;
    BEGIN
        FOR q IN (SELECT TO_CHAR(a.gl_acct_category)|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_control_acct,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_1,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_2,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_3,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_4,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_5,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_6,'09'))|| ' - ' ||
                         LTRIM(TO_CHAR(a.gl_sub_acct_7,'09')) gl_acct_code,
                         LTRIM(TO_CHAR(a.sl_cd, '099999999999')) sl_cd, sum(a.debit_amt) debit_amt, sum(a.credit_amt) credit_amt, 
                         b.gl_acct_name, c.replenish_id, a.sl_type_cd
          FROM  giac_chart_of_accts b, giac_replenish_dv_dtl c, giac_acct_entries a 
          WHERE a.gl_acct_id = b.gl_acct_id
            AND a.gacc_tran_id = c.dv_tran_id
            AND replenish_id = p_replenish_id
       GROUP BY a.gl_acct_category, a.gl_control_acct,
                a.gl_sub_acct_1, a.gl_sub_acct_2, a.gl_sub_acct_3, a.gl_sub_acct_4,
                a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7, a.sl_cd, a.sl_type_cd,
                b.gl_acct_name,c.replenish_id, '1', a.gacc_gfun_fund_cd,
                a.gacc_gibr_branch_cd, '1', a.gl_acct_id
       ORDER BY a.gl_acct_category, a.gl_control_acct,
                a.gl_sub_acct_1, a.gl_sub_acct_2, a.gl_sub_acct_3, a.gl_sub_acct_4,
                a.gl_sub_acct_5, a.gl_sub_acct_6, a.gl_sub_acct_7)
        LOOP
            v_rep.gl_acct_code  := q.gl_acct_code;
            v_rep.debit_amt     := q.debit_amt;
            v_rep.credit_amt    := q.credit_amt;
            v_rep.gl_acct_name  := q.gl_acct_name;
            v_rep.replenish_id  := q.replenish_id;
            v_rep.sl_cd         := q.sl_cd;
            
            FOR w IN (SELECT sl_name 
                        FROM giac_sl_lists 
                       WHERE sl_type_cd = q.sl_type_cd
                         AND sl_cd = q.sl_cd)
            LOOP
                v_rep.sl_name  := w.sl_name;
            END LOOP;            
            
            FOR e IN (SELECT  sum(a.debit_amt) sum_debit, sum(a.credit_amt) sum_credit 
                        FROM  giac_chart_of_accts b, giac_replenish_dv_dtl c, giac_acct_entries a 
                       WHERE a.gl_acct_id = b.gl_acct_id
                         AND a.gacc_tran_id = c.dv_tran_id
                         AND c.replenish_id = p_replenish_id)
            LOOP
                v_rep.total_debit   := e.sum_debit;
                v_rep.total_credit  := e.sum_credit;
            END LOOP;
                v_rep.balance := v_rep.total_debit - v_rep.total_credit;           
            PIPE ROW(v_rep);
        END LOOP;
    END get_rep_sum_acct_entries;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 04.22.2013
   **  Modified     : 04.26.2013
   **  Reference By : GIACS081 - CREATE_UPDATE_BATCH program unit
   **  Remarks      : insert/update replenishment master record and child record
   */    
       
    PROCEDURE set_replenish_master_record(
        p_branch_cd          giac_replenish_dv.branch_cd%TYPE,
        p_revolving_fund     giac_replenish_dv.revolving_fund_amt%TYPE,
        p_total_tagged       giac_replenish_dv.replenishment_amt%TYPE,
        p_user_id            giis_users.user_id%TYPE
    )
    IS
        v_replenish_no  NUMBER;
        v_replenish_id  NUMBER;
        v_replenish_yr  NUMBER := TO_NUMBER(TO_CHAR(sysdate, 'RRRR'));
    BEGIN
        FOR i IN (SELECT NVL(MAX(replenish_seq_no),0) + 1	rep_no
                    FROM giac_replenish_dv
                   WHERE branch_cd = p_branch_cd                             
                     AND replenish_year = v_replenish_yr)
        LOOP
            v_replenish_no := i.rep_no;
        END LOOP;
            
        SELECT replenish_id_s.nextval
          INTO v_replenish_id
          FROM dual;
        
        INSERT INTO giac_replenish_dv
                    (replenish_id,       branch_cd,      replenish_seq_no,   revolving_fund_amt, 
                     replenishment_amt,  create_by,      create_date,        replenish_year)
             VALUES (v_replenish_id,	 p_branch_cd, 	 v_replenish_no,     p_revolving_fund,
                     p_total_tagged,   	 p_user_id,      SYSDATE,		     v_replenish_yr);
    END set_replenish_master_record;
            
    PROCEDURE set_rev_fund(
        p_replenish_id       giac_replenish_dv.replenish_id%TYPE,
        p_revolving_fund     giac_replenish_dv.revolving_fund_amt%TYPE    
    )        
    IS
    BEGIN
        UPDATE giac_replenish_dv 
           SET revolving_fund_amt = p_revolving_fund
         WHERE replenish_id = p_replenish_id;
    END set_rev_fund;
    
    PROCEDURE set_replenish_dv (
       p_replenish_id     giac_replenish_dv.replenish_id%TYPE,
       p_revolving_fund   giac_replenish_dv.revolving_fund_amt%TYPE,
       p_total_tagged     giac_replenish_dv.replenishment_amt%TYPE,
       p_user_id          giis_users.user_id%TYPE
    )
    IS
       v_replenish_id     giac_replenish_dv.replenish_id%TYPE;  --added by Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238
    BEGIN
    
        SELECT MAX(replenish_id)                                --added by Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238
          INTO v_replenish_id
          FROM giac_replenish_dv;
        
       FOR i IN (SELECT dv_tran_id
                   FROM giac_replenish_dv_dtl
                  WHERE replenish_id = NVL(p_replenish_id, v_replenish_id)) --p_replenish_id) Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238 : added p_replenish_id shan 10.27.2014
       LOOP
          UPDATE giac_disb_vouchers
             SET replenished_tag = 'N'
           WHERE gacc_tran_id = i.dv_tran_id;
       END LOOP;

       --delete the original detail records of the batch which will be replaced by the code below
       DELETE FROM giac_replenish_dv_dtl
             WHERE replenish_id = NVL(p_replenish_id, v_replenish_id); --p_replenish_id; Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238 : added p_replenish_id shan 10.27.2014

          --update the master record when updating batch that have additional child records
       UPDATE giac_replenish_dv
          SET revolving_fund_amt = p_revolving_fund,
              replenishment_amt = p_total_tagged,
              create_by = p_user_id,
              create_date = SYSDATE
        WHERE replenish_id = NVL(p_replenish_id, v_replenish_id);--p_replenish_id; Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238 : added p_replenish_id shan 10.27.2014
    END set_replenish_dv;
    
    PROCEDURE set_replenish_detail(
        p_replenish_id       giac_replenish_dv.replenish_id%TYPE,
        p_tran_id            giac_replenish_dv_dtl.dv_tran_id%TYPE,
        p_item_no            giac_replenish_dv_dtl.check_item_no%TYPE,
        p_amount             giac_replenish_dv_dtl.amount%TYPE            
    )
    IS
    v_replenish_id     giac_replenish_dv.replenish_id%TYPE;     --added by Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238
    BEGIN
    
        SELECT MAX(replenish_id)                                --added by Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238
        INTO v_replenish_id
        FROM giac_replenish_dv;
        
        INSERT INTO giac_replenish_dv_dtl
             VALUES (NVL(p_replenish_id, v_replenish_id), p_tran_id, p_item_no, p_amount, 'Y');  --p_replenish_id Gzelle 11.19.2013 UCPBGEN-Phase 3 SR#1238 : added p_replenish_id shan 10.27.2014
        
        UPDATE giac_disb_vouchers
           SET replenished_tag = 'Y'
         WHERE gacc_tran_id = p_tran_id;
                 
    END set_replenish_detail;    
       
END GIACS081_PKG;
/



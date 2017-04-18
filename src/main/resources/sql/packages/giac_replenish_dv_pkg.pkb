CREATE OR REPLACE PACKAGE BODY CPI.giac_replenish_dv_pkg
IS
   FUNCTION get_replinish_no_lov (p_find_text VARCHAR2)
      RETURN giac_replenish_dv_tab PIPELINED
   IS
      v_rep   giac_replenish_dv_type;
   BEGIN
      FOR i IN (SELECT a.*
                  FROM (SELECT   replenish_id,
                                    branch_cd
                                 || '-'
                                 || replenish_year
                                 || '-'
                                 || replenish_seq_no replenish_no,
                                 replenishment_amt
                            FROM giac_replenish_dv
                           WHERE replenish_tran_id IS NULL
                        ORDER BY branch_cd, replenish_year, replenish_seq_no) a
                 WHERE a.replenishment_amt LIKE NVL (p_find_text, '%%')
                    OR UPPER (a.replenish_no) LIKE
                                               NVL (UPPER (p_find_text), '%%'))
      LOOP
         v_rep.replenish_id := i.replenish_id;
         v_rep.replenish_no := i.replenish_no;
         v_rep.replenishment_amt := i.replenishment_amt;
         PIPE ROW (v_rep);
      END LOOP;
   END;

   FUNCTION get_giacs016_rf_detail_list (
      p_replenish_id   giac_replenish_dv.replenish_id%TYPE,
      p_find_text      VARCHAR2
   )
      RETURN giacs016_rf_detail_tab PIPELINED
   IS
      v_rf_dtl   giacs016_rf_detail_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giac_replenish_dv_dtl
                 WHERE replenish_id = p_replenish_id)
      LOOP
         FOR a IN (SELECT a.branch_cd, d.dv_pref, d.dv_no, c.check_pref_suf,
                          c.check_no, f.document_cd, f.branch_cd req_branch,
                          f.line_cd, f.doc_year, f.doc_mm, f.doc_seq_no,
                          c.payee, d.particulars
                     FROM giac_replenish_dv a,
                          giac_chk_disbursement c,
                          giac_disb_vouchers d,
                          giac_payt_requests_dtl e,
                          giac_payt_requests f
                    WHERE 1 = 1
                      AND c.gacc_tran_id = d.gacc_tran_id
                      AND d.gacc_tran_id = e.tran_id
                      AND e.gprq_ref_id = f.ref_id
                      AND a.replenish_id = p_replenish_id
                      AND c.gacc_tran_id = i.dv_tran_id
                      AND c.item_no = i.check_item_no)
         LOOP
            FOR a IN (SELECT a.branch_cd, d.dv_pref, d.dv_no,
                             c.check_pref_suf, c.check_no, f.document_cd,
                             f.branch_cd req_branch, f.line_cd, f.doc_year,
                             f.doc_mm, f.doc_seq_no, c.payee, d.particulars
                        FROM giac_replenish_dv a,
                             giac_chk_disbursement c,
                             giac_disb_vouchers d,
                             giac_payt_requests_dtl e,
                             giac_payt_requests f
                       WHERE 1 = 1
                         AND c.gacc_tran_id = d.gacc_tran_id
                         AND d.gacc_tran_id = e.tran_id
                         AND e.gprq_ref_id = f.ref_id
                         AND a.replenish_id = p_replenish_id
                         AND c.gacc_tran_id = i.dv_tran_id
                         AND c.item_no = i.check_item_no)
            LOOP
               v_rf_dtl.dsp_branch_cd := a.branch_cd;
               v_rf_dtl.dsp_dv_pref := a.dv_pref;
               v_rf_dtl.dsp_dv_no := a.dv_no;
               v_rf_dtl.dsp_check_pref_suf := a.check_pref_suf;
               v_rf_dtl.dsp_check_no := a.check_no;
               v_rf_dtl.dsp_document_cd := a.document_cd;
               v_rf_dtl.dsp_req_branch := a.req_branch;
               v_rf_dtl.dsp_line_cd := a.line_cd;
               v_rf_dtl.dsp_doc_year := a.doc_year;
               v_rf_dtl.dsp_doc_mm := a.doc_mm;
               v_rf_dtl.dsp_doc_seq_no := a.doc_seq_no;
               v_rf_dtl.dsp_payee := a.payee;
               v_rf_dtl.dsp_particulars := a.particulars;
            END LOOP;
         END LOOP;

         v_rf_dtl.dsp_amount := i.amount;
         v_rf_dtl.dsp_include_tag := i.include_tag;
		 v_rf_dtl.dv_tran_id := i.dv_tran_id;
		 v_rf_dtl.check_item_no := i.check_item_no; -- shan 10.09.2014
         PIPE ROW (v_rf_dtl);
      END LOOP;
   END;

   PROCEDURE get_rf_detail_amounts (
      p_replenish_id                giac_replenish_dv_dtl.replenish_id%TYPE,
      v_dsp_requested_amt     OUT   giac_replenish_dv_dtl.amount%TYPE,
      v_dsp_disapproved_amt   OUT   giac_replenish_dv_dtl.amount%TYPE,
      v_dsp_approved_amt      OUT   giac_replenish_dv_dtl.amount%TYPE
   )
   IS
   BEGIN
      FOR r IN (SELECT NVL (SUM (amount), 0) requested
                  FROM giac_replenish_dv_dtl
                 WHERE replenish_id = p_replenish_id)
      LOOP
         v_dsp_requested_amt := r.requested;
      END LOOP;

      FOR a IN (SELECT NVL (SUM (amount), 0) approved
                  FROM giac_replenish_dv_dtl
                 WHERE replenish_id = p_replenish_id AND include_tag = 'Y')
      LOOP
         v_dsp_approved_amt := a.approved;
      END LOOP;

      FOR d IN (SELECT NVL (SUM (amount), 0) disapproved
                  FROM giac_replenish_dv_dtl
                 WHERE replenish_id = p_replenish_id AND include_tag = 'N')
      LOOP
         v_dsp_disapproved_amt := d.disapproved;
      END LOOP;
   END;
   
   PROCEDURE update_include_tag (
      p_replenish_id   giac_replenish_dv_dtl.replenish_id%TYPE,
      p_dv_tran_id     giac_replenish_dv_dtl.dv_tran_id%TYPE,
      p_check_item_no  giac_replenish_dv_dtl.CHECK_ITEM_NO%TYPE,    -- shan 10.03.2014
      p_include_tag    giac_replenish_dv_dtl.include_tag%TYPE
   )
   
   is
   
   begin
    update  giac_replenish_dv_dtl
    set include_tag = p_include_tag
    where replenish_id = p_replenish_id and dv_tran_id = p_dv_tran_id and check_item_no = p_check_item_no;  -- added check_item_no : shan 10.09.2014
    
   end;
   
   PROCEDURE giacs016_acct_ent_post_query (
       p_replenish_id           giac_batch_dv.tran_id%TYPE,
      p_total_debit    OUT   NUMBER,
      p_total_credit   OUT   NUMBER
   )
   IS
           BEGIN
              SELECT SUM(debit_amt), SUM(credit_amt)
              INTO p_total_debit, p_total_credit
              FROM giac_acct_entries
             WHERE gacc_tran_id IN (SELECT dv_tran_id
                                        FROM giac_replenish_dv_dtl
                                                   WHERE replenish_id = p_replenish_id
                                                     AND include_tag = 'Y');
          EXCEPTION
            WHEN no_data_found THEN
              p_total_debit := null;
                 p_total_credit := null;
          END;
   
   END;
/



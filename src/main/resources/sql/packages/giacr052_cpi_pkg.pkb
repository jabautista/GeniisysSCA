CREATE OR REPLACE PACKAGE BODY CPI.giacr052_cpi_pkg
AS
   FUNCTION get_disb_details (p_tran_id giac_disb_vouchers.gacc_tran_id%TYPE)
      RETURN giac_disb_tab PIPELINED
   IS
      v_disb   giac_disb_type;
   BEGIN
      FOR rec IN (SELECT a.gacc_tran_id gacc_tran_id, b.short_name, b.currency_desc,
                         UPPER (a.payee) upper_payee,
                         TO_CHAR (c.check_date,
                                  'FMMonth DD, YYYY') check_date,
                         a.dv_pref || '-'
                         || LPAD (a.dv_no, 10, 0) "VOUCHER_NO",
                         TO_CHAR (a.dv_amt, 'FM99,999,999,999,990.00')
                                                                      dv_amt,
                         a.particulars particulars, a.dv_amt dv_amt_in_words,
                            '***'
                         || TO_CHAR (c.amount, 'FM99,999,999,999,990.00')
                         || '***' check_amt,
                         c.amount check_amt_in_words,
                            check_pref_suf
                         || '-'
                         || LPAD (check_no, 10, 0) check_no,
                         giacp.v ('COMPANY_NAME') company_name
                    FROM giac_disb_vouchers a,
                         giis_currency b,
                         giac_chk_disbursement c,
                         DUAL
                   WHERE a.gacc_tran_id = c.gacc_tran_id
                     AND a.gacc_tran_id = NVL (p_tran_id, a.gacc_tran_id)
                     AND a.currency_cd = b.main_currency_cd)
      LOOP
         v_disb.gacc_tran_id := rec.gacc_tran_id;
         v_disb.short_name := rec.short_name;
         v_disb.payee := rec.upper_payee;
         v_disb.chck_date := rec.check_date;
         v_disb.voucher_no := rec.voucher_no;
         v_disb.dv_amt := rec.dv_amt;
         v_disb.particulars := rec.particulars;
         v_disb.dv_amt_in_words :=
            dh_util.check_protect2 (rec.dv_amt_in_words,
                                    NULL, --bert 
                                    FALSE
                                   );
         v_disb.check_amt := rec.check_amt;
         v_disb.check_amt_in_words :=
            dh_util.check_protect2 (rec.check_amt_in_words,
                                    NULL, --bert
                                    FALSE
                                   );
         v_disb.check_no := rec.check_no;
         v_disb.company_name := rec.company_name;
         PIPE ROW (v_disb);
      END LOOP;
   END;

   FUNCTION get_gl_account_dtls (
      p_tran_id   giac_acct_entries.gacc_tran_id%TYPE
   )
      RETURN gl_accounts_tab PIPELINED
   IS
      v_gl_rec   gl_accounts_type;
   BEGIN
--      FOR gl IN (SELECT get_gl_acct_no (b.gl_acct_id) gl_acct_no,
--                        b.gl_acct_sname, a.debit_amt, a.credit_amt
--                   FROM giac_acct_entries a, giac_chart_of_accts b
--                  WHERE a.gl_acct_id = b.gl_acct_id
--                    AND a.gacc_tran_id = p_tran_id)
      FOR gl IN (SELECT get_gl_acct_no (b.gl_acct_id) gl_acct_no,
                        b.gl_acct_sname, SUM(a.debit_amt) debit_amt, SUM(a.credit_amt) credit_amt
                   FROM giac_acct_entries a, giac_chart_of_accts b
                  WHERE a.gl_acct_id = b.gl_acct_id
                    AND a.gacc_tran_id = p_tran_id
                   GROUP BY b.gl_acct_id, b.gl_acct_sname)
      LOOP
         v_gl_rec.gl_acct_number := gl.gl_acct_no;
         v_gl_rec.gl_acct_sname := gl.gl_acct_sname;
         v_gl_rec.debit_amt := gl.debit_amt;
         v_gl_rec.credit_amt := gl.credit_amt;
         PIPE ROW (v_gl_rec);
      END LOOP;
   END;

   FUNCTION get_signatories (
      p_tran_id     giac_disb_vouchers.gacc_tran_id%TYPE,
      p_report_id   giac_documents.report_id%TYPE,
      p_branch_cd   giac_documents.branch_cd%TYPE,
      p_user_id     giac_users.user_id%TYPE
   )
      RETURN signatories_tab PIPELINED
   IS
      v_sig   signatories_type;
   BEGIN
      FOR appr IN (SELECT NVL (signatory, ' ') appr_signatory,
                          NVL (designation, ' ') appr_designation
                     FROM (SELECT 0 item_no, user_name signatory, designation
                             FROM giac_chk_disbursement a, giac_users b
                            WHERE a.user_id = b.user_id
                              AND gacc_tran_id =
                                               NVL (p_tran_id, a.gacc_tran_id)
                           UNION
                           SELECT b.item_no, c.signatory, c.designation
                             FROM giac_documents a,
                                  giac_rep_signatory b,
                                  giis_signatory_names c
                            WHERE a.report_no = b.report_no
                              AND a.report_id = b.report_id
                              AND a.report_id = NVL (p_report_id, 'GIACR052')
                              AND NVL (a.branch_cd, p_branch_cd) = p_branch_cd
                              AND b.signatory_id = c.signatory_id
                           MINUS
                           SELECT b.item_no, c.signatory, c.designation
                             FROM giac_documents a,
                                  giac_rep_signatory b,
                                  giis_signatory_names c
                            WHERE a.report_no = b.report_no
                              AND a.report_id = b.report_id
                              AND a.report_id = NVL (p_report_id, 'GIACR052')
                              AND a.branch_cd IS NULL
                              AND EXISTS (
                                     SELECT 1
                                       FROM giac_documents
                                      WHERE report_id =
                                                 NVL (p_report_id, 'GIACR052')
                                        AND branch_cd = p_branch_cd)
                              AND b.signatory_id = c.signatory_id)
                    WHERE item_no = 2)
      LOOP
         v_sig.app_signatory := appr.appr_signatory;
         v_sig.app_designation := appr.appr_designation;
      END LOOP;

--      FOR prep IN (SELECT NVL (signatory, ' ') prep_signatory,
--                          NVL (designation, ' ') prep_designation
--                     FROM (SELECT 0 item_no, user_name signatory, designation
--                             FROM giac_chk_disbursement a, giac_users b
--                            WHERE a.user_id = b.user_id
--                              AND gacc_tran_id =
--                                               NVL (p_tran_id, a.gacc_tran_id)
--                           UNION
--                           SELECT b.item_no, c.signatory, c.designation
--                             FROM giac_documents a,
--                                  giac_rep_signatory b,
--                                  giis_signatory_names c
--                            WHERE a.report_no = b.report_no
--                              AND a.report_id = b.report_id
--                              AND a.report_id = NVL (p_report_id, 'GIACR052')
--                              AND NVL (a.branch_cd, p_branch_cd) = p_branch_cd
--                              AND b.signatory_id = c.signatory_id
--                           MINUS
--                           SELECT b.item_no, c.signatory, c.designation
--                             FROM giac_documents a,
--                                  giac_rep_signatory b,
--                                  giis_signatory_names c
--                            WHERE a.report_no = b.report_no
--                              AND a.report_id = b.report_id
--                              AND a.report_id = NVL (p_report_id, 'GIACR052')
--                              AND a.branch_cd IS NULL
--                              AND EXISTS (
--                                     SELECT 1
--                                       FROM giac_documents
--                                      WHERE report_id =
--                                                 NVL (p_report_id, 'GIACR052')
--                                        AND branch_cd = p_branch_cd)
--                              AND b.signatory_id = c.signatory_id)
--                    WHERE item_no = 0)
--      LOOP
--         v_sig.prep_signatory := prep.prep_signatory;
--         v_sig.prep_designation := prep.prep_designation;
--      END LOOP;
      FOR prep IN (SELECT user_name prep_signatory,
                          designation prep_designation
                     FROM giac_users
                    WHERE user_id = p_user_id)
      LOOP
         v_sig.prep_signatory := prep.prep_signatory;
         v_sig.prep_designation := prep.prep_designation;
      END LOOP;

      FOR chck IN (SELECT NVL (signatory, ' ') chk_signatory,
                          NVL (designation, ' ') chk_designation
                     FROM (SELECT 0 item_no, user_name signatory, designation
                             FROM giac_chk_disbursement a, giac_users b
                            WHERE a.user_id = b.user_id
                              AND gacc_tran_id =
                                               NVL (p_tran_id, a.gacc_tran_id)
                           UNION
                           SELECT b.item_no, c.signatory, c.designation
                             FROM giac_documents a,
                                  giac_rep_signatory b,
                                  giis_signatory_names c
                            WHERE a.report_no = b.report_no
                              AND a.report_id = b.report_id
                              AND a.report_id = NVL (p_report_id, 'GIACR052')
                              AND NVL (a.branch_cd, p_branch_cd) = p_branch_cd
                              AND b.signatory_id = c.signatory_id
                           MINUS
                           SELECT b.item_no, c.signatory, c.designation
                             FROM giac_documents a,
                                  giac_rep_signatory b,
                                  giis_signatory_names c
                            WHERE a.report_no = b.report_no
                              AND a.report_id = b.report_id
                              AND a.report_id = NVL (p_report_id, 'GIACR052')
                              AND a.branch_cd IS NULL
                              AND EXISTS (
                                     SELECT 1
                                       FROM giac_documents
                                      WHERE report_id =
                                                 NVL (p_report_id, 'GIACR052')
                                        AND branch_cd = p_branch_cd)
                              AND b.signatory_id = c.signatory_id)
                    WHERE item_no = 1)
      LOOP
         v_sig.chck_signatory := chck.chk_signatory;
         v_sig.chck_designation := chck.chk_designation;
      END LOOP;

      PIPE ROW (v_sig);
   END;
END;
/

DROP PACKAGE BODY CPI.GIACR052_CPI_PKG;


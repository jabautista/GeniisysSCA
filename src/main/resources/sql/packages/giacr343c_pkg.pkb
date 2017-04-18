CREATE OR REPLACE PACKAGE BODY cpi.giacr343c_pkg
AS
   FUNCTION get_giacr343c_records (
      p_period_tag       VARCHAR2,
      p_cutoff_date      VARCHAR2,
      p_ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
      p_subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
      p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
      p_sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE
   )
      RETURN report_details_tab PIPELINED
   IS
      v_rec      report_details_type;
      v_exists   BOOLEAN                            := FALSE;
      v_knock    giac_acct_entries.debit_amt%TYPE;
      v_bal      giac_acct_entries.debit_amt%TYPE;
   BEGIN
      SELECT UPPER (cpi.giisp.v ('COMPANY_NAME'))
        INTO v_rec.company_name
        FROM SYS.DUAL;

      SELECT UPPER (cpi.giisp.v ('COMPANY_ADDRESS'))
        INTO v_rec.company_address
        FROM SYS.DUAL;

      v_rec.report_title := 'SUMMARIZED OUTSTANDING REPORT AS OF ' || TO_CHAR (TO_DATE (p_cutoff_date, 'MM-DD-YYYY'), 'fmMonth DD, YYYY');

      FOR y IN (SELECT a.tran_id
                  FROM giac_acctrans a
                 WHERE DECODE (p_period_tag,
                                'P', TRIM (a.posting_date),
                                     TRIM (a.tran_date)
                              ) <= TO_DATE (p_cutoff_date, 'MM-DD-YYYY')
                   AND a.tran_flag IN ('C', 'P'))
      LOOP
         FOR x IN (SELECT a.*,
                             a.ledger_cd
                          || ' - '
                          || a.subledger_cd
                          || ' - '
                          || a.transaction_cd
                          || ' - '
                          || a.sl_cd
                          || ' - '
                          || a.acct_seq_no acct_ref_no, b.ledger_desc, c.transaction_desc
                     FROM giac_gl_acct_ref_no a, giac_gl_account_types b, giac_gl_transaction_types c
                    WHERE a.ledger_cd = NVL (p_ledger_cd, a.ledger_cd)
                      AND a.subledger_cd = NVL (p_subledger_cd, a.subledger_cd)
                      AND a.transaction_cd = NVL (p_transaction_cd, a.transaction_cd)
                      AND a.sl_cd = NVL (p_sl_cd, a.sl_cd)
                      AND a.acct_tran_type = 'S'
                      AND a.gacc_tran_id = y.tran_id
                      AND NVL (a.spoil_sw, 'N') <> 'Y'
                      AND a.ledger_cd = b.ledger_cd
                      AND c.ledger_cd = a.ledger_cd
                      AND c.subledger_cd = a.subledger_cd
                      AND c.transaction_cd = a.transaction_cd
                      AND a.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                   FROM giac_reversals))
         LOOP
            FOR z IN (SELECT DECODE (h.dr_cr_tag,
                                     'C', DECODE (x.acct_tran_type,
                                                  'S', a.credit_amt,
                                                  0
                                                 ),
                                     'D', DECODE (x.acct_tran_type,
                                                  'S', a.debit_amt,
                                                  0
                                                 )
                                    ) setup_amt,
                             a.gacc_tran_id, a.acct_tran_type, h.dr_cr_tag,
                             h.gslt_sl_type_cd
                        FROM giac_acct_entries a,
                             giac_chart_of_accts h
                       WHERE a.gl_acct_id = x.gl_acct_id
                         AND h.gl_acct_id = a.gl_acct_id
                         AND a.sl_cd = x.sl_cd
                         AND a.gacc_tran_id = y.tran_id
                         AND x.acct_ref_no = a.acct_ref_no)
            LOOP
                v_exists                := TRUE;
                v_rec.v_exists          := 'TRUE';
                v_rec.acct_ref_no       := x.acct_ref_no;
                v_rec.ledger_cd         := x.ledger_cd;
                v_rec.ledger_desc       := x.ledger_desc;
                v_rec.subledger_cd      := x.subledger_cd;
                v_rec.transaction_cd    := x.transaction_cd;
                v_rec.transaction_desc  := x.transaction_desc;
                v_rec.sl_cd             := x.sl_cd;
                v_rec.gl_acct_cd        := get_gl_acct_no (x.gl_acct_id);
                v_rec.gl_acct_name      := get_gl_acct_name (x.gl_acct_id);            
                v_rec.sl_name           := get_sl_name(x.sl_cd, z.gslt_sl_type_cd, '1');

               BEGIN
                  SELECT NVL (DECODE (z.dr_cr_tag,
                                      'C', SUM (debit_amt),
                                      'D', SUM (credit_amt)
                                     ),
                              0
                             ) knock_off_amt
                    INTO v_knock
                    FROM giac_acct_entries, giac_acctrans
                   WHERE acct_tran_type = 'K'
                     AND sl_cd = x.sl_cd
                     AND gl_acct_id = x.gl_acct_id
                     AND acct_ref_no = x.acct_ref_no
                     AND gacc_tran_id = tran_id
                     AND DECODE (p_period_tag,
                                 'P', TRIM (posting_date),
                                 TRIM (tran_date)
                                ) <= TO_DATE (p_cutoff_date, 'MM-DD-YYYY')
                     AND tran_flag IN ('C', 'P');
               EXCEPTION
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_knock := 0;
                  WHEN NO_DATA_FOUND
                  THEN
                     v_knock := 0;
               END;

               v_bal := z.setup_amt - v_knock;
               v_rec.balance := v_bal;
               PIPE ROW (v_rec);
            END LOOP;

         END LOOP;
      END LOOP;

      IF v_exists <> TRUE
      THEN
         v_rec.v_exists := 'FALSE';
         PIPE ROW (v_rec);
      END IF;
   END;
END;
/
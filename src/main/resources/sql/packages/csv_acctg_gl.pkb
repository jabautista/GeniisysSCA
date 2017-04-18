CREATE OR REPLACE PACKAGE BODY CPI.CSV_ACCTG_GL
AS
    FUNCTION get_giacr343a_csv (
       p_period_tag       VARCHAR2,
       p_cutoff_date      VARCHAR2,
       p_ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
       p_subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
       p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
       p_sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE
    )
       RETURN giacr343a_csv_tab PIPELINED
    IS
       v_rec    giacr343a_csv_type;
       v_cnt    NUMBER             := 0;
       v_code   VARCHAR2 (500);
    BEGIN
       FOR i IN (SELECT   a.acct_ref_no, h.dr_cr_tag, a.acct_tran_type,
                          a.credit_amt, a.debit_amt,
                             d.ledger_cd
                          || ' - '
                          || d.subledger_cd
                          || ' - '
                          || d.transaction_cd code,
                          DECODE (h.dr_cr_tag,
                                  'C', DECODE (a.acct_tran_type,
                                               'S', a.credit_amt,
                                               0
                                              ),
                                  'D', DECODE (a.acct_tran_type,
                                               'S', a.debit_amt,
                                               0
                                              )
                                 ) setup_amt,
                          DECODE (h.dr_cr_tag,
                                  'C', DECODE (a.acct_tran_type,
                                               'K', a.debit_amt,
                                               0
                                              ),
                                  'D', DECODE (a.acct_tran_type,
                                               'K', a.credit_amt,
                                               0
                                              )
                                 ) knock_off_amt,
                          (  (DECODE (h.dr_cr_tag,
                                      'C', DECODE (a.acct_tran_type,
                                                   'S', a.credit_amt,
                                                   0
                                                  ),
                                      'D', DECODE (a.acct_tran_type,
                                                   'S', a.debit_amt,
                                                   0
                                                  )
                                     )
                             )
                           - (DECODE (h.dr_cr_tag,
                                      'C', DECODE (a.acct_tran_type,
                                                   'K', a.debit_amt,
                                                   0
                                                  ),
                                      'D', DECODE (a.acct_tran_type,
                                                   'K', a.credit_amt,
                                                   0
                                                  )
                                     )
                             )
                          ) balance,
                          a.sl_cd, a.gl_acct_id,
                          cpi.get_gl_acct_no (a.gl_acct_id) gl_acct_cd,
                          cpi.get_gl_acct_name (a.gl_acct_id) gl_acct_name,
                          b.tran_date, b.tran_id,
                          cpi.get_ref_no (b.tran_id) tran_ref_no, b.tran_class,
                          b.particulars, d.ledger_cd, d.subledger_cd,
                          d.transaction_cd, e.ledger_desc, f.subledger_desc,
                          g.transaction_desc, h.gslt_sl_type_cd
                     FROM giac_acct_entries a,
                          giac_acctrans b,
                          giac_gl_acct_ref_no d,
                          giac_gl_account_types e,
                          giac_gl_subaccount_types f,
                          giac_gl_transaction_types g,
                          giac_chart_of_accts h
                    WHERE DECODE (p_period_tag,
                                  'P', TRIM (b.posting_date),
                                  TRIM (b.tran_date)
                                 ) <= TO_DATE (p_cutoff_date, 'MM-DD-YYYY')
                      AND d.ledger_cd = NVL (p_ledger_cd, d.ledger_cd)
                      AND d.subledger_cd = NVL (p_subledger_cd, d.subledger_cd)
                      AND d.transaction_cd =
                                          NVL (p_transaction_cd, d.transaction_cd)
                      AND d.sl_cd = NVL (p_sl_cd, d.sl_cd)
                      AND a.gacc_tran_id = b.tran_id
                      AND a.gacc_tran_id = d.gacc_tran_id
                      AND d.ledger_cd = e.ledger_cd
                      AND d.subledger_cd = f.subledger_cd
                      AND d.transaction_cd = g.transaction_cd
                      AND g.ledger_cd = d.ledger_cd
                      AND g.subledger_cd = d.subledger_cd
                      AND a.gl_acct_id = f.gl_acct_id
                      AND b.tran_flag IN ('C', 'P')
                      AND h.gl_acct_id = d.gl_acct_id
                      AND a.acct_ref_no =
                                d.ledger_cd
                             || ' - '
                             || d.subledger_cd
                             || ' - '
                             || d.transaction_cd
                             || ' - '
                             || d.sl_cd
                             || ' - '
                             || d.acct_seq_no
                      AND NVL (d.spoil_sw, 'N') <> 'Y'
                      AND a.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                   FROM giac_reversals)
                 ORDER BY a.acct_ref_no, tran_ref_no)
       LOOP
          v_cnt := v_cnt + 1;

          IF v_cnt = 1
          THEN
             v_code := i.acct_ref_no;
          --v_bal := i.balance;
          END IF;

          IF v_code = i.acct_ref_no
          THEN
             IF v_cnt <> 1
             THEN
                NULL;
             --v_bal := v_bal + i.balance;
             END IF;
          ELSE
             --v_bal := i.balance;
             v_code := i.acct_ref_no;
          END IF;

          v_rec.acct_ref_no     := i.acct_ref_no;
          v_rec.sl_cd           := i.sl_cd;
          v_rec.setup_amt       := i.setup_amt;
          v_rec.knock_off_amt   := i.knock_off_amt;
          --v_rec.balance       := i.balance;
          v_rec.gl_acct_cd      := i.gl_acct_cd;
          v_rec.gl_acct_name    := i.gl_acct_name;
          v_rec.tran_date       := i.tran_date;
          v_rec.tran_ref_no     := i.tran_ref_no;

            IF i.tran_class = 'COL' THEN
                BEGIN
                    SELECT particulars
                      INTO v_rec.particulars
                      FROM giac_order_of_payts
                     WHERE gacc_tran_id = i.tran_id;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                        v_rec.particulars := NULL;
                    WHEN TOO_MANY_ROWS THEN
                        v_rec.particulars := NULL;                        
                END;
            ELSIF i.tran_class = 'DV' THEN
                BEGIN
                    SELECT particulars
                      INTO v_rec.particulars
                      FROM giac_disb_vouchers
                     WHERE gacc_tran_id = i.tran_id;
                EXCEPTION 
                    WHEN NO_DATA_FOUND THEN
                        v_rec.particulars := NULL;
                    WHEN TOO_MANY_ROWS THEN
                        v_rec.particulars := NULL;                        
                END;                 
            ELSE
                v_rec.particulars := i.particulars;
            END IF;
          
          v_rec.sl_name             := get_sl_name(i.sl_cd, i.gslt_sl_type_cd, '1');
          v_rec.ledger_type         := i.ledger_cd;
          v_rec.subledger_cd        := i.subledger_cd;
          v_rec.transaction_cd      := i.transaction_cd;
          v_rec.ledger_desc         := i.ledger_desc;
          v_rec.subledger_desc      := i.subledger_desc;
          v_rec.transaction_desc    := i.transaction_desc;
          PIPE ROW (v_rec);
       END LOOP;
    END get_giacr343a_csv;

    FUNCTION get_giacr343b_csv (
       p_period_tag       VARCHAR2,
       p_cutoff_date      VARCHAR2,
       p_ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
       p_subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
       p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE
    )
       RETURN giacr343b_csv_tab PIPELINED
    IS
       v_rec   giacr343b_csv_type;
    BEGIN
       FOR i IN
          (SELECT   a.ledger_cd, a.ledger_desc, a.gl_acct_cd, a.gl_acct_id,
                    a.gl_acct_name, a.transaction_cd, a.transaction_desc,
                    SUM (setup_amt) setup_amt, SUM (knock_off_amt) knock_off_amt,
                    (SUM (setup_amt) - SUM (knock_off_amt)) balance
               FROM (SELECT   d.ledger_cd, e.ledger_desc, a.gl_acct_id,
                              cpi.get_gl_acct_no (a.gl_acct_id) gl_acct_cd,
                              cpi.get_gl_acct_name (a.gl_acct_id) gl_acct_name,
                              d.transaction_cd, g.transaction_desc,
                              d.subledger_cd,
                              DECODE (h.dr_cr_tag,
                                      'C', DECODE (a.acct_tran_type,
                                                   'S', a.credit_amt,
                                                   0
                                                  ),
                                      'D', DECODE (a.acct_tran_type,
                                                   'S', a.debit_amt,
                                                   0
                                                  )
                                     ) setup_amt,
                              DECODE (h.dr_cr_tag,
                                      'C', DECODE (a.acct_tran_type,
                                                   'K', a.debit_amt,
                                                   0
                                                  ),
                                      'D', DECODE (a.acct_tran_type,
                                                   'K', a.credit_amt,
                                                   0
                                                  )
                                     ) knock_off_amt
                         FROM giac_acct_entries a,
                              giac_acctrans b,
                              giac_gl_acct_ref_no d,
                              giac_gl_account_types e,
                              giac_gl_subaccount_types f,
                              giac_gl_transaction_types g,
                              giac_chart_of_accts h
                        WHERE DECODE (p_period_tag,
                                      'P', TRIM (b.posting_date),
                                      TRIM (b.tran_date)
                                     ) <= TO_DATE (p_cutoff_date, 'MM-DD-YYYY')
                          AND d.ledger_cd = NVL (p_ledger_cd, d.ledger_cd)
                          AND d.subledger_cd = NVL (p_subledger_cd, d.subledger_cd)
                          AND d.transaction_cd = NVL (p_transaction_cd, d.transaction_cd)
                          AND a.gacc_tran_id = b.tran_id
                          AND a.gacc_tran_id = d.gacc_tran_id
                          AND d.ledger_cd = e.ledger_cd
                          AND d.subledger_cd = f.subledger_cd
                          AND d.transaction_cd = g.transaction_cd
                          AND g.ledger_cd = d.ledger_cd
                          AND g.subledger_cd = d.subledger_cd
                          AND a.gl_acct_id = f.gl_acct_id
                          AND b.tran_flag IN ('C', 'P')
                          AND h.gl_acct_id = d.gl_acct_id
                          AND a.acct_ref_no =
                                    d.ledger_cd
                                 || ' - '
                                 || d.subledger_cd
                                 || ' - '
                                 || d.transaction_cd
                                 || ' - '
                                 || d.sl_cd
                                 || ' - '
                                 || d.acct_seq_no
                          AND NVL (d.spoil_sw, 'N') <> 'Y'
                          AND a.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                       FROM giac_reversals)
                     ORDER BY d.ledger_cd, d.gl_acct_id, d.transaction_cd) a,
                    giac_gl_transaction_types b
              WHERE a.transaction_cd = b.transaction_cd
                AND a.subledger_cd = b.subledger_cd
                AND a.ledger_cd = b.ledger_cd
           GROUP BY a.ledger_cd,
                    a.ledger_desc,
                    a.gl_acct_cd,
                    a.gl_acct_name,
                    a.transaction_cd,
                    a.transaction_desc,
                    a.gl_acct_id
           ORDER BY a.ledger_cd, a.gl_acct_id, a.transaction_cd)
       LOOP
          v_rec.gl_acct_cd       := i.gl_acct_cd;
          v_rec.gl_acct_name     := i.gl_acct_name;
          v_rec.ledger_type      := i.ledger_cd;
          v_rec.transaction_cd   := i.transaction_cd;
          v_rec.ledger_desc      := i.ledger_desc;
          v_rec.transaction_desc := i.transaction_desc;
          v_rec.setup_amt        := i.setup_amt;
          v_rec.knock_off_amt    := i.knock_off_amt;
          PIPE ROW (v_rec);
       END LOOP;
    END get_giacr343b_csv;        

    FUNCTION get_giacr343c_csv (
       p_period_tag       VARCHAR2,
       p_cutoff_date      VARCHAR2,
       p_ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
       p_subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
       p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
       p_sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE
    )
       RETURN giacr343c_csv_tab PIPELINED
    IS
       v_rec   giacr343c_csv_type;
    BEGIN
       FOR i IN
          (SELECT   *
               FROM TABLE (giacr343c_pkg.get_giacr343c_records (p_period_tag,
                                                                p_cutoff_date,
                                                                p_ledger_cd,
                                                                p_subledger_cd,
                                                                p_transaction_cd,
                                                                p_sl_cd
                                                               )
                          )
           ORDER BY ledger_cd,
                    gl_acct_cd,
                    subledger_cd,
                    transaction_cd,
                    sl_cd,
                    acct_ref_no)
       LOOP
          v_rec.gl_type          := i.ledger_cd;
          v_rec.gl_description   := i.ledger_desc;
          v_rec.gl_acct_cd       := i.gl_acct_cd;
          v_rec.gl_acct_name     := i.gl_acct_name;
          v_rec.group_cd         := i.subledger_cd;
          v_rec.transaction_cd   := i.transaction_cd;
          v_rec.transaction_desc := i.transaction_desc;
          v_rec.sl_cd            := i.sl_cd;
          v_rec.sl_name          := i.sl_name;
          v_rec.acct_ref_no      := i.acct_ref_no;
          v_rec.running_balance  := i.balance;
          
          PIPE ROW (v_rec);
       END LOOP;
    END get_giacr343c_csv;     
END; 
/


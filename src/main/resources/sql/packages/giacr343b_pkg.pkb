CREATE OR REPLACE PACKAGE BODY CPI.giacr343b_pkg
AS
    FUNCTION get_outstanding_balance (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE
    )
        RETURN outstanding_balance_tab PIPELINED
    IS
        v_rec       outstanding_balance;
        v_exists    BOOLEAN := FALSE;
    BEGIN
        SELECT UPPER(cpi.giisp.v('COMPANY_NAME'))
          INTO v_rec.company_name
          FROM sys.dual;
          
        SELECT UPPER(cpi.giisp.v('COMPANY_ADDRESS'))
          INTO v_rec.company_address
          FROM sys.dual;
          
        v_rec.report_title := 'SUMMARIZED OUTSTANDING REPORT AS OF ' || TO_CHAR(TO_DATE (p_cutoff_date, 'MM-DD-YYYY'),'fmMonth DD, YYYY');
          
          FOR i IN(SELECT a.ledger_cd, d.ledger_desc, a.transaction_cd, e.transaction_desc,
                          c.debit_amt, c.credit_amt, a.acct_tran_type,
                          get_gl_acct_no (a.gl_acct_id) gl_acct_cd,
                          get_gl_acct_name (a.gl_acct_id) gl_acct_name
                     FROM giac_gl_acct_ref_no a,
                          giac_acctrans b,
                          giac_acct_entries c,
                          giac_gl_account_types d,
                          giac_gl_transaction_types e
                    WHERE a.gacc_tran_id = b.tran_id
                      AND c.gacc_tran_id = a.gacc_tran_id
                      AND c.acct_tran_type = a.acct_tran_type
                      AND c.sl_cd = a.sl_cd
                      AND c.gl_acct_id = a.gl_acct_id
                      AND d.ledger_cd = a.ledger_cd
                      AND e.ledger_cd = a.ledger_cd
                      AND e.subledger_cd = a.subledger_cd
                      AND e.transaction_cd = a.transaction_cd
                      AND c.acct_ref_no = a.ledger_cd
                                           || ' - '
                                           || a.subledger_cd
                                           || ' - '
                                           || a.transaction_cd
                                           || ' - '
                                           || a.sl_cd
                                           || ' - '
                                           || a.acct_seq_no
                      AND b.tran_flag IN ('C', 'P')
                      AND NVL (a.spoil_sw, 'N') <> 'Y'
                      AND DECODE (p_period_tag, 'P', TRIM(b.posting_date), TRIM(b.tran_date)) <= TO_DATE (p_cutoff_date, 'MM-DD-YYYY')
                      AND a.ledger_cd LIKE NVL (p_ledger_cd, '%')
                      AND a.subledger_cd LIKE NVL (p_subledger_cd, '%')
                      AND a.transaction_cd LIKE NVL (p_transaction_cd, '%')
                      AND a.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                   FROM giac_reversals)
                 ORDER BY a.ledger_cd, a.gl_acct_id, a.transaction_cd)
          LOOP
            v_exists             := TRUE;
            v_rec.v_exists      := 'TRUE';
            v_rec.gl_acct_cd     := i.gl_acct_cd;
            v_rec.gl_acct_name   := i.gl_acct_name;
            v_rec.ledger_cd      := i.ledger_cd;
            v_rec.transaction_cd := i.transaction_cd;
            v_rec.ledger_desc    := i.ledger_desc;
            v_rec.transaction_desc := i.transaction_desc;
            v_rec.setup_amt      := 0;
            v_rec.knock_off_amt  := 0;
            
            IF i.acct_tran_type = 'S' THEN
                v_rec.setup_amt := i.debit_amt + i.credit_amt;
            ELSIF i.acct_tran_type = 'K' THEN
                v_rec.knock_off_amt := i.debit_amt + i.credit_amt;
            END IF;
            
            PIPE ROW(v_rec);
          END LOOP;
          
          IF v_exists  <> TRUE
          THEN
            v_rec.v_exists := 'FALSE';
            PIPE ROW(v_rec);
          END IF;
    END;
END;
/

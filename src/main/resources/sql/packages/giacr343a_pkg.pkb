CREATE OR REPLACE PACKAGE BODY CPI.giacr343a_pkg
AS
    FUNCTION get_outstanding_balance (
        p_period_tag        VARCHAR2,
        p_cutoff_date       VARCHAR2,
        p_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE,
        p_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE,
        p_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE,
        p_sl_cd             giac_gl_acct_ref_no.sl_cd%TYPE
    )
        RETURN outstanding_balance_tab PIPELINED
    IS
        v_rec    outstanding_balance;
        v_exists BOOLEAN := FALSE;
    BEGIN
        SELECT UPPER(cpi.giisp.v('COMPANY_NAME'))
          INTO v_rec.company_name
          FROM dual;
          
        SELECT UPPER(cpi.giisp.v('COMPANY_ADDRESS'))
          INTO v_rec.company_address
          FROM dual;
        
        v_rec.report_title := 'DETAILED OUTSTANDING REPORT AS OF ' || TO_CHAR(TO_DATE (p_cutoff_date, 'MM-DD-YYYY'),'fmMonth DD, YYYY');
    
        FOR i IN(SELECT a.acct_ref_no,
                        h.dr_cr_tag,
                        a.acct_tran_type,
                        a.credit_amt,
                        a.debit_amt,
                        DECODE(h.dr_cr_tag,
                                         'C', DECODE(A.ACCT_TRAN_TYPE, 'S', a.credit_amt,0), 
                                         'D', DECODE(A.ACCT_TRAN_TYPE, 'S', a.debit_amt, 0)
                                         ) setup_amt,
                        DECODE(h.dr_cr_tag,
                                         'C', DECODE(A.ACCT_TRAN_TYPE, 'K', a.debit_amt, 0), 
                                         'D', DECODE(A.ACCT_TRAN_TYPE, 'K', a.credit_amt, 0)
                                         ) knock_off_amt,  
                        ((DECODE(h.dr_cr_tag,
                                         'C', DECODE(A.ACCT_TRAN_TYPE, 'S', a.credit_amt,0), 
                                         'D', DECODE(A.ACCT_TRAN_TYPE, 'S', a.debit_amt, 0)
                                         )) - 
                         (DECODE(h.dr_cr_tag,
                                         'C', DECODE(A.ACCT_TRAN_TYPE, 'K', a.debit_amt, 0), 
                                         'D', DECODE(A.ACCT_TRAN_TYPE, 'K', a.credit_amt, 0)
                                         ))
                        ) balance, 
                        a.sl_cd,
                        a.gl_acct_id,
                        cpi.get_gl_acct_no(a.gl_acct_id) gl_acct_cd,
                        cpi.get_gl_acct_name(a.gl_acct_id) gl_acct_name,
                        b.tran_date,
                        b.tran_id,
                        cpi.get_ref_no(b.tran_id) tran_ref_no,
                        b.tran_class,
                        b.particulars,
                        d.ledger_cd,
                        d.subledger_cd,
                        d.transaction_cd,
                        e.ledger_desc,
                        f.subledger_desc,
                        g.transaction_desc,
                        h.gslt_sl_type_cd
                   FROM giac_acct_entries a,
                        giac_acctrans b,
                        giac_gl_acct_ref_no d,
                        giac_gl_account_types e,
                        giac_gl_subaccount_types f,
                        giac_gl_transaction_types g,
                        giac_chart_of_accts h
                  WHERE DECODE(p_period_tag, 'P', TRIM(b.posting_date), TRIM(b.tran_date)) <= TO_DATE(p_cutoff_date, 'MM-DD-YYYY')
                    AND d.ledger_cd = NVL(p_ledger_cd, d.ledger_cd)
                    AND d.subledger_cd = NVL(p_subledger_cd, d.subledger_cd)
                    AND d.transaction_cd = NVL(p_transaction_cd, d.transaction_cd)
                    AND d.sl_cd = NVL(p_sl_cd, d.sl_cd)
                    AND a.gacc_tran_id = b.tran_id
                    AND a.gacc_tran_id = d.gacc_tran_id
                    AND d.ledger_cd = e.ledger_cd
                    AND d.subledger_cd = f.subledger_cd
                    AND g.ledger_cd = d.ledger_cd
                    AND g.subledger_cd = d.subledger_cd
                    AND d.transaction_cd = g.transaction_cd
                    AND a.gl_acct_id = f.gl_acct_id
                    AND a.acct_ref_no =   d.ledger_cd
                                           || ' - '
                                           || d.subledger_cd
                                           || ' - '
                                           || d.transaction_cd
                                           || ' - '
                                           || d.sl_cd
                                           || ' - '
                                           || d.acct_seq_no
                    AND b.tran_flag IN('C','P')
                    AND h.gl_acct_id = d.gl_acct_id
                    AND NVL(d.spoil_sw,'N') <> 'Y'
                    AND a.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                 FROM giac_reversals)
                  ORDER BY a.acct_ref_no, tran_ref_no)
        LOOP
            v_exists := TRUE;
            v_rec.v_exists      := 'TRUE';
            
            v_rec.acct_ref_no   := i.acct_ref_no;
            v_rec.acct_tran_type := i.acct_tran_type;
            v_rec.debit_amt     := i.debit_amt;
            v_rec.credit_amt    := i.credit_amt;
            v_rec.setup_amt     := i.setup_amt;
            v_rec.knock_off_amt := i.knock_off_amt;
            v_rec.balance       := i.balance;
            v_rec.sl_cd         := i.sl_cd;
            v_rec.gl_acct_cd    := i.gl_acct_cd;
            v_rec.gl_acct_name  := i.gl_acct_name;
            v_rec.tran_date     := i.tran_date;
            v_rec.tran_ref_no   := i.tran_ref_no;
            v_rec.tran_class    := i.tran_class;
            
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
            
            v_rec.sl_name           := get_sl_name(i.sl_cd, i.gslt_sl_type_cd, '1');
            v_rec.ledger_cd         := i.ledger_cd;
            v_rec.subledger_cd      := i.subledger_cd;
            v_rec.transaction_cd    := i.transaction_cd;
            v_rec.ledger_desc       := i.ledger_desc;
            v_rec.subledger_desc    := i.subledger_desc;
            v_rec.transaction_desc  := i.transaction_desc;
            
            PIPE ROW(v_rec);
        END LOOP;
        
        IF v_exists <> TRUE
        THEN
            v_rec.v_exists := 'FALSE';
            PIPE ROW(v_rec);
        END IF;
    END;
END;
/

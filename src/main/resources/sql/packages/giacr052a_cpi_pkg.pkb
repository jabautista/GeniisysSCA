CREATE OR REPLACE PACKAGE BODY CPI.GIACR052A_CPI_PKG AS

   FUNCTION populate_giacr052a_records (
        p_tran_id         VARCHAR2
       )
       RETURN giacr052a_record_tab PIPELINED
    AS
       v_rec              giacr052a_record_type;
       
    BEGIN     
       FOR i IN (SELECT   a.gibr_gfun_fund_cd || '-' || a.gibr_branch_cd || '-' || a.dv_pref || '-' || TO_CHAR (a.dv_no, 'FM0999999999') dv_no,
                          a.dv_pref || '-' || TO_CHAR (a.dv_no, 'FM0999999999') dv_no2, --added by: Nica 12.27.2013
                          e.bank_sname || '   ' || d.bank_acct_no bank_account,
                          '#' || TO_CHAR (c.check_no, 'FM0999999999') check_number,
                          (SELECT RTRIM (XMLAGG (XMLELEMENT (e, z.bank_sname || ' ' || '#' || TO_CHAR (x.check_no, 'FM0999999999')
                                 || '    ')).EXTRACT ('//text()'), ',')
                             FROM giac_chk_disbursement x,
                                  giac_bank_accounts y,
                                  giac_banks z
                            WHERE x.bank_acct_cd = y.bank_acct_cd
                              AND y.bank_cd = z.bank_cd
                              AND x.gacc_tran_id = a.gacc_tran_id) check_number2,
                          b.short_name || ' ' || TO_CHAR (c.amount, 'FM99,999,999,999,990.00') check_amt,
                          TRUNC (c.check_date) chk_date,
                          b.short_name || ' ' || TO_CHAR (a.dv_fcurrency_amt, 'FM99,999,999,999,990.00') dv_amt,
                          UPPER (a.payee) payee, a.particulars, a.user_id prepared_by,
                          get_payment_request_no (a.gacc_tran_id) payment_request
                     FROM giac_disb_vouchers a,
                          giis_currency b,
                          giac_chk_disbursement c,
                          giac_bank_accounts d,
                          giac_banks e
                    WHERE 1 = 1
                      AND a.gacc_tran_id  = NVL (p_tran_id, a.gacc_tran_id)
                      AND a.currency_cd   = b.main_currency_cd
                      AND a.gacc_tran_id  = c.gacc_tran_id
                      AND c.bank_acct_cd  = d.bank_acct_cd
                      AND d.bank_cd       = e.bank_cd
                 GROUP BY a.gibr_gfun_fund_cd || '-' || a.gibr_branch_cd || '-' || a.dv_pref || '-' || TO_CHAR (a.dv_no, 'FM0999999999'),
                          a.dv_pref || '-' || TO_CHAR (a.dv_no, 'FM0999999999'),
                          c.item_no, e.bank_sname, d.bank_acct_no, '#' || TO_CHAR (c.check_no, 'FM0999999999'),
                          a.gacc_tran_id, b.short_name || ' ' || TO_CHAR (c.amount, 'FM99,999,999,999,990.00'),
                          TRUNC (c.check_date), b.short_name || ' ' || TO_CHAR (a.dv_fcurrency_amt, 'FM99,999,999,999,990.00'),
                          UPPER (a.payee), a.particulars, a.user_id
                 ORDER BY c.item_no)
                                 
       LOOP
            v_rec.dv_no                 := i.dv_no;
            v_rec.dv_no2                := i.dv_no2;
            v_rec.bank_account          := i.bank_account;
            v_rec.check_number          := i.check_number;
            v_rec.check_number2         := i.check_number2;
            v_rec.check_amt             := i.check_amt;
            v_rec.chk_date              := i.chk_date;
            v_rec.dv_amt                := i.dv_amt;
            v_rec.payee                 := i.payee;
            v_rec.particulars           := i.particulars;
            v_rec.prepared_by           := i.prepared_by;
            v_rec.payment_request       := i.payment_request;
            v_rec.curr_date             := TO_CHAR (SYSDATE, 'MM-DD-YYYY');
            v_rec.curr_time             := TO_CHAR (SYSDATE, 'HH:MI:SSAM');
            
            PIPE ROW (v_rec);
       END LOOP;

       RETURN;
    END;

    FUNCTION populate_giacr052a_ent (
      p_tran_id           VARCHAR2
      )
       RETURN giacr052a_ent_tab PIPELINED
    AS
       v_ent   giacr052a_ent_type;
       
    BEGIN
       FOR j IN (SELECT   TO_CHAR(gl_acct_category)||'-'||gl_control_acct||'-'
                                ||gl_sub_acct_1||'-'||gl_sub_acct_2||'-'||gl_sub_acct_3||'-'
                                ||gl_sub_acct_4||'-'||gl_sub_acct_5||'-'||gl_sub_acct_6||'-'
                                ||gl_sub_acct_7 gl_acct_no,
                          get_gl_acct_name (gl_acct_id) gl_acct_name,
                          SUM (debit_amt) debit_amt, SUM (credit_amt) credit_amt
                     FROM giac_acct_entries
                    WHERE gacc_tran_id = NVL (p_tran_id, gacc_tran_id)
                 GROUP BY TO_CHAR(gl_acct_category)||'-'||gl_control_acct||'-'
                                ||gl_sub_acct_1||'-'||gl_sub_acct_2||'-'||gl_sub_acct_3||'-'
                                ||gl_sub_acct_4||'-'||gl_sub_acct_5||'-'||gl_sub_acct_6||'-'
                                ||gl_sub_acct_7,
                          get_gl_acct_name (gl_acct_id))
       
       LOOP
            v_ent.gl_acct_no        := j.gl_acct_no;
            v_ent.gl_acct_name      := j.gl_acct_name;
            v_ent.debit_amt         := j.debit_amt;
            v_ent.credit_amt        := j.credit_amt;
       
            PIPE ROW (v_ent);
       END LOOP;
       
       RETURN;
       
    END populate_giacr052a_ent;
      
END giacr052a_cpi_pkg;
/

DROP PACKAGE BODY CPI.GIACR052A_CPI_PKG;


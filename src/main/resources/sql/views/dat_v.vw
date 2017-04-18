DROP VIEW CPI.DAT_V;

/* Formatted on 2015/05/15 10:39 (Formatter Plus v4.8.8) */
CREATE OR REPLACE FORCE VIEW cpi.dat_v (aname,
                                        lname,
                                        fname,
                                        mname,
                                        tin,
                                        bir_tax_cd,
                                        percent_rate,
                                        income_amt,
                                        wholding_tax_amt
                                       )
AS
   SELECT      b.payee_last_name
            || ' '
            || b.payee_first_name
            || ' '
            || b.payee_middle_name aname,
            b.payee_last_name lname, b.payee_first_name fname,
            b.payee_middle_name mname,
            DECODE (INSTR (b.tin, '-'),
                    4,  LPAD (b.tin, 3)
                     || ''
                     || LPAD (SUBSTR (b.tin, 5), 3)
                     || ''
                     || LPAD (SUBSTR (b.tin, 9), 3),
                    b.tin
                   ) tin,
            c.bir_tax_cd, c.percent_rate, SUM (d.income_amt) income_amt,
            SUM (d.wholding_tax_amt) wholding_tax_amt
       FROM giac_acctrans a,
            giis_payees b,
            giac_wholding_taxes c,
            giac_taxes_wheld d,
            giis_payee_class e
      WHERE c.whtax_id = d.gwtx_whtax_id
        AND b.payee_class_cd = e.payee_class_cd
        AND b.payee_class_cd = d.payee_class_cd
        AND b.payee_no = d.payee_cd
        AND a.tran_id = d.gacc_tran_id
        AND a.tran_flag <> 'D'
        AND d.gacc_tran_id NOT IN (
                  SELECT e.gacc_tran_id
                    FROM giac_reversals e, giac_acctrans f
                   WHERE e.reversing_tran_id = f.tran_id
                         AND f.tran_flag <> 'D')
   GROUP BY    b.payee_last_name
            || ' '
            || b.payee_first_name
            || ' '
            || b.payee_middle_name,
            b.payee_last_name,
            b.payee_first_name,
            b.payee_middle_name,
            b.tin,
            c.bir_tax_cd,
            c.percent_rate
   ORDER BY 1;



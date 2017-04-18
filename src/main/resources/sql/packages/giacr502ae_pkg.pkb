CREATE OR REPLACE PACKAGE BODY CPI.GIACR502AE_PKG       
AS
/*
**Created by : Benedict G. Castillo
**Date Created: 07/24/2013
**Description: GIACR502AE : TRIAL BALANCE REPORT
*/
   FUNCTION populate_giacr502ae (
      p_branch      VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_tran_mm     VARCHAR2,
      p_tran_yr     VARCHAR2
   )
      RETURN giacr502ae_tab PIPELINED
   AS
      v_rec            giacr502ae_type;
      v_not_exist      BOOLEAN         := TRUE;
      v_trans_debit    NUMBER (18, 2);
      v_trans_credit   NUMBER (18, 2);
      v_unadjust       NUMBER (18, 2);
      v_deb            NUMBER (18, 2);
      v_cr             NUMBER (18, 2);
      v_posting_dt  GIAC_ACCTRANS.posting_date%TYPE := LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_yr,'MM/RRRR'));--Added by pjsantos 12/02/2016, for optimization GENQA 5870
   BEGIN
      v_rec.company_name := giisp.v ('COMPANY_NAME');
      v_rec.company_address := giisp.v ('COMPANY_ADDRESS');

      IF NVL (p_tran_mm, 0) <= 0 OR NVL (p_tran_mm, 0) > 12
      THEN
         v_rec.as_of :=
                  'As of ' || NVL (p_tran_mm, 0) || ' '
                  || TO_CHAR (p_tran_yr);
      ELSE
         v_rec.as_of :=
               'As of '
            || RTRIM (TO_CHAR (TO_DATE (TO_CHAR (p_tran_mm), 'MM'), 'Month'))
            || ' '
            || TO_CHAR (p_tran_yr);
      END IF;

      IF p_branch = 'N'
      THEN
         FOR i IN
            (SELECT   b.gl_acct_id, get_gl_acct_no (a.gl_acct_id) acct_no,
                      b.gl_acct_name,
                      SUM (DECODE (SIGN (a.beg_debit_amt - a.beg_credit_amt),
                                   1, (a.beg_debit_amt - a.beg_credit_amt),
                                   0
                                  )
                          ) beg_debit,
                      SUM (ABS (DECODE (SIGN (  a.beg_debit_amt
                                              - a.beg_credit_amt
                                             ),
                                        -1, (a.beg_debit_amt
                                             - a.beg_credit_amt),
                                        0
                                       )
                               )
                          ) beg_credit,
                      SUM (a.trans_debit_bal) trans_debit,
                      SUM (a.trans_credit_bal) trans_credit,
                      SUM (DECODE (SIGN (a.trans_balance),
                                   1, a.trans_balance,
                                   0
                                  )
                          ) end_debit,
                      SUM (ABS (DECODE (SIGN (a.trans_balance),
                                        -1, a.trans_balance,
                                        0
                                       )
                               )
                          ) end_credit, c.debit_amt, c.credit_amt
                 FROM giac_finance_yr a, giac_chart_of_accts b, 
                         (/*Moved here by pjsantos 12/08/2016 for optimization GENQA 5870*/
                           SELECT SUM(debit_amt) debit_amt,  SUM(credit_amt) credit_amt, y.gl_acct_id
                             FROM GIAC_ACCTRANS x,
                                  GIAC_ACCT_ENTRIES y
                            WHERE x.tran_id         = y.gacc_tran_id
                              AND ae_tag            = 'Y'
                              AND x.posting_date    = v_posting_dt
                         GROUP BY y.gl_acct_id) c
                          /*pjsantos end*/       
                WHERE a.gl_acct_id = b.gl_acct_id
                  AND tran_year = p_tran_yr
                  AND tran_mm = p_tran_mm
                  AND b.gl_acct_id = c.gl_acct_id(+)--Added by pjsantos 12/08/2016, for optimization GENQA 5870
--                  AND p_branch = 'N'  removed by pjsantos 12/08/2016, option already handled in if-else statement GENQA 5870
             GROUP BY b.gl_acct_id,
                      get_gl_acct_no (a.gl_acct_id),
                      b.gl_acct_name,
                      c.credit_amt,
                      c.debit_amt                     
             ORDER BY get_gl_acct_no (a.gl_acct_id), b.gl_acct_name)
         LOOP
            v_not_exist := FALSE;
            v_trans_debit := 0;
            v_trans_credit := 0;
            v_unadjust := 0;
            v_deb := NVL(i.debit_amt,0);
            v_cr  := NVL(i.credit_amt,0);
            /*v_deb :=
               (trial_balance.get_debit_adjusting (i.gl_acct_id,
                                                   NULL,
                                                   p_tran_yr,
                                                   p_tran_mm
                                                  )
               );
            v_cr :=
               (trial_balance.get_credit_adjusting (i.gl_acct_id,
                                                    NULL,
                                                    p_tran_yr,
                                                    p_tran_mm
                                                   )
               );*/ --Moved codes in main query by pjsantos 12/02/2016, GENQA 5870    
                                   
            v_trans_debit := NVL (i.trans_debit, 0) - NVL (v_deb, 0);
            v_trans_credit := NVL (i.trans_credit, 0) - NVL (v_cr, 0);
            v_unadjust :=
                 (NVL (i.beg_debit, 0) + NVL (v_trans_debit, 0))
               - (NVL (i.beg_credit, 0) + NVL (v_trans_credit, 0));
            v_rec.acct_no := i.acct_no;
            v_rec.acct_name := i.gl_acct_name;
            v_rec.beg_debit := i.beg_debit;
            v_rec.beg_credit := i.beg_credit;
            v_rec.trans_debit := v_trans_debit;
            v_rec.trans_credit := v_trans_credit;

            IF NVL (v_unadjust, 0) >= 0
            THEN
               v_rec.unadjusted_debit := v_unadjust;
            ELSE
               v_rec.unadjusted_debit := 0;
            END IF;

            IF NVL (v_unadjust, 0) < 0
            THEN
               v_rec.unadjusted_credit := ABS (v_unadjust);
            ELSE
               v_rec.unadjusted_credit := 0;
            END IF;

            v_rec.adjust_debit := NVL(v_deb,0);
            v_rec.adjust_credit := NVL(v_cr,0);
            v_rec.end_debit := i.end_debit;
            v_rec.end_credit := i.end_credit;
            v_rec.branch_name := NULL;
            v_deb := 0;
            v_cr := 0;
            PIPE ROW (v_rec);
         END LOOP;
      ELSIF p_branch = 'Y'
      THEN
         FOR z IN
            (SELECT   a.gl_acct_id, fund_cd, branch_cd,
                      get_gl_acct_no (a.gl_acct_id) acct_no, b.gl_acct_name,
                      SUM (DECODE (SIGN (a.beg_debit_amt - a.beg_credit_amt),
                                   1, (a.beg_debit_amt - a.beg_credit_amt),
                                   0
                                  )
                          ) beg_debit,
                      SUM (ABS (DECODE (SIGN (  a.beg_debit_amt
                                              - a.beg_credit_amt
                                             ),
                                        -1, (a.beg_debit_amt
                                             - a.beg_credit_amt),
                                        0
                                       )
                               )
                          ) beg_credit,
                      SUM (a.trans_debit_bal) trans_debit,
                      SUM (a.trans_credit_bal) trans_credit,
                      SUM (DECODE (SIGN (a.trans_balance),
                                   1, a.trans_balance,
                                   0
                                  )
                          ) end_debit,
                      SUM (ABS (DECODE (SIGN (a.trans_balance),
                                        -1, a.trans_balance,
                                        0
                                       )
                               )
                          ) end_credit, c.debit_amt, c.credit_amt                       
                 FROM giac_finance_yr a, giac_chart_of_accts b,
                  (/*Moved here by pjsantos 12/08/2016 for optimization GENQA 5870*/
                           SELECT SUM(debit_amt) debit_amt,  SUM(credit_amt) credit_amt, y.gl_acct_id, x.gibr_branch_cd
                             FROM GIAC_ACCTRANS x,
                                  GIAC_ACCT_ENTRIES y
                            WHERE x.tran_id         = y.gacc_tran_id
                              AND ae_tag            = 'Y'
                              AND x.posting_date    = v_posting_dt
                         GROUP BY y.gl_acct_id, x.gibr_branch_cd) c
                          /*pjsantos end*/   
                WHERE a.gl_acct_id = b.gl_acct_id
                  AND tran_year = p_tran_yr
                  AND tran_mm = p_tran_mm
                  AND a.gl_acct_id = c.gl_acct_id(+)
                  AND a.branch_cd = c.gibr_branch_cd(+)
--                  AND p_branch = 'Y' removed by pjsantos 12/08/2016, option already handled in if-else statement GENQA 5870
                  AND branch_cd = NVL (p_branch_cd, branch_cd)
             GROUP BY a.gl_acct_id,
                      fund_cd,
                      branch_cd,
                      get_gl_acct_no (a.gl_acct_id), 
                      b.gl_acct_name,
                      c.credit_amt,
                      c.debit_amt   
             ORDER BY fund_cd,
                      branch_cd,
                      get_gl_acct_no (a.gl_acct_id),
                      b.gl_acct_name)
         LOOP
            v_not_exist := FALSE;

            --<<br>> removed by pjsantos, GENQA 5870
            FOR v IN (SELECT branch_name
                        FROM giac_branches
                       WHERE gfun_fund_cd = z.fund_cd
                         AND branch_cd = z.branch_cd
                         AND ROWNUM = 1)
            LOOP
               v_rec.branch_name := v.branch_name;
           --    EXIT br;removed by pjsantos, GENQA 5870
            END LOOP;

            v_trans_debit := 0;
            v_trans_credit := 0;
            v_unadjust := 0;
            v_deb := NVL(z.debit_amt,0);
            v_cr  := NVL(z.credit_amt,0);
            /*v_deb :=
               (trial_balance.get_debit_adjusting (z.gl_acct_id,
                                                   z.branch_cd,
                                                   p_tran_yr,
                                                   p_tran_mm
                                                  )
               );
            v_cr :=
               (trial_balance.get_credit_adjusting (z.gl_acct_id,
                                                    z.branch_cd,
                                                    p_tran_yr,
                                                    p_tran_mm
                                                   )
               );*/--Moved codes in main query by pjsantos 12/02/2016, GENQA 5870
            v_trans_debit := NVL (z.trans_debit, 0) - NVL (v_deb, 0);
            v_trans_credit := NVL (z.trans_credit, 0) - NVL (v_cr, 0);
            v_unadjust :=
                 (NVL (z.beg_debit, 0) + NVL (v_trans_debit, 0))
               - (NVL (z.beg_credit, 0) + NVL (v_trans_credit, 0));
            v_rec.acct_no := z.acct_no;
            v_rec.acct_name := z.gl_acct_name;
            v_rec.beg_debit := z.beg_debit;
            v_rec.beg_credit := z.beg_credit;
            v_rec.trans_debit := v_trans_debit;
            v_rec.trans_credit := v_trans_credit;

            IF NVL (v_unadjust, 0) >= 0
            THEN
               v_rec.unadjusted_debit := v_unadjust;
            ELSE
               v_rec.unadjusted_debit := 0;
            END IF;

            IF NVL (v_unadjust, 0) < 0
            THEN
               v_rec.unadjusted_credit := ABS (v_unadjust);
            ELSE
               v_rec.unadjusted_credit := 0; 
            END IF;

            v_rec.adjust_debit := NVL(v_deb,0);
            v_rec.adjust_credit := NVL(v_cr,0);
            v_rec.end_debit := z.end_debit;
            v_rec.end_credit := z.end_credit;
            v_deb := 0;
            v_cr  := 0;
            PIPE ROW (v_rec);
         END LOOP;
      END IF;
      --pjsantos end
      IF v_not_exist
      THEN
         v_rec.flag := 'T';
         PIPE ROW (v_rec);
      END IF;
   END populate_giacr502ae;
END GIACR502AE_PKG;
/



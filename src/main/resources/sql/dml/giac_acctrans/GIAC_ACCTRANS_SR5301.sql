SET DEFINE ON
SET colsep ','
SET echo off
SET feedback off
SET linesize 10000
SET sqlprompt ''
SET trimspool on
SET headsep off
COLUMN dcol new_value SYSDATE noprint
SELECT TO_CHAR (SYSDATE, 'mmddyyyyhhmm') dcol FROM DUAL;
SPOOL C:\GENIISYS_WEB\record_backup\GIAC_ACCTRANS_5301-&sysdate

/* Created by: Albert 02.02.2016
** Purpose: Backup affected data as per SR 5301
** Conditions:
**   - DV Print Tag is dv printed / all checks printed
**   - Transaction Status is Open
**   - Total debit and credit amounts in Accounting Entries are balanced
*/ 
     SELECT b.*
       FROM giac_disb_vouchers a,
            giac_acctrans b,
            giac_chk_disbursement c,
            (  SELECT gacc_tran_id,
                      SUM (NVL (debit_amt, 0)) debit,
                      SUM (NVL (credit_amt, 0)) credit
                 FROM giac_acct_entries
             GROUP BY gacc_tran_id
               HAVING SUM (NVL (debit_amt, 0)) = SUM (NVL (credit_amt, 0))) d
      WHERE     a.gacc_tran_id = b.tran_id
            AND a.gacc_tran_id = c.gacc_tran_id
            AND a.gacc_tran_id = d.gacc_tran_id
            AND a.print_tag = 6
            AND b.tran_flag = 'O'
            AND TRUNC (tran_date) > '08-JAN-2016'
   ORDER BY DECODE (giacp.n ('DISB_TRAN_DATE'),
                    1, a.dv_date,
                    2, c.check_date,
                    3, c.check_print_date,
                    b.tran_date);

SPOOL OFF;

/* Created by: Albert 02.01.2016
** Purpose: To close DV transactions that already have printed DV and checks but are still open 
** Conditions:
**   - DV Print Tag is dv printed / all checks printed
**   - Transaction Status is Open
**   - Total debit and credit amounts in Accounting Entries are balanced
*/

BEGIN
   FOR x
      IN (  SELECT b.*
              FROM giac_disb_vouchers a,
                   giac_acctrans b,
                   giac_chk_disbursement c,
                   (  SELECT gacc_tran_id,
                             SUM (NVL (debit_amt, 0)) debit,
                             SUM (NVL (credit_amt, 0)) credit
                        FROM giac_acct_entries
                    GROUP BY gacc_tran_id
                      HAVING SUM (NVL (debit_amt, 0)) =
                                SUM (NVL (credit_amt, 0))) d
             WHERE     a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = c.gacc_tran_id
                   AND a.gacc_tran_id = d.gacc_tran_id
                   AND a.print_tag = 6
                   AND b.tran_flag = 'O'
                   AND TRUNC (tran_date) > '08-JAN-2016'
          ORDER BY DECODE (giacp.n ('DISB_TRAN_DATE'),
                           1, a.dv_date,
                           2, c.check_date,
                           3, c.check_print_date,
                           b.tran_date))
   LOOP
      GIACS052_PKG.UPDATE_GIAC (x.tran_id, x.gibr_branch_cd, x.gfun_fund_cd);
   END LOOP;
   
COMMIT;
END;
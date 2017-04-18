DROP FUNCTION CPI.OLD_TRAN_NO;

CREATE OR REPLACE FUNCTION CPI.old_tran_no (
   p_tran_year     NUMBER,
   p_tran_month    NUMBER,
   p_tran_seq_no   NUMBER
) RETURN NUMBER
IS
   recfound   NUMBER := 0;
BEGIN
   FOR i IN (SELECT DISTINCT a.tran_id
                        FROM giac_acctrans a, giac_unidentified_collns b
                       WHERE a.tran_id = b.gacc_tran_id
                         AND a.gfun_fund_cd = 'CPI'
                         AND a.gibr_branch_cd = 'HO'
                         AND a.tran_year =
                                DECODE (p_tran_year,
                                        NULL, a.tran_year,
                                        p_tran_year
                                       )
                         AND a.tran_month =
                                DECODE (p_tran_month,
                                        NULL, a.tran_month,
                                        p_tran_month
                                       )
                         AND a.tran_seq_no =
                                DECODE (p_tran_seq_no,
                                        NULL, a.tran_seq_no,
                                        p_tran_seq_no
                                       )
                         AND a.tran_flag != 'D'
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM giac_acctrans c, giac_reversals d
                                 WHERE c.tran_id = d.reversing_tran_id
                                   AND d.gacc_tran_id = a.tran_id
                                   AND c.tran_flag != 'D')
                         AND a.tran_id != 54814
                         AND b.gunc_gacc_tran_id IS NULL
                         AND b.transaction_type = '1')
   LOOP
      recfound := recfound + 1;
   END LOOP;
   RETURN recfound;
END;
/



DROP FUNCTION CPI.GET_BOOKED_COMM_AMT;

CREATE OR REPLACE FUNCTION CPI.get_booked_comm_amt ( 
   p_iss_cd        VARCHAR2,
   p_prem_seq_no   NUMBER,
   p_intm_no       NUMBER,
   p_date          DATE
)
   RETURN NUMBER
IS
   v_comm_amt   NUMBER (20, 2);
/* judyann 03062013; to get the commissions booked during month-end production */
BEGIN
   FOR ic IN (SELECT a.iss_cd, a.prem_seq_no, b.currency_rt,
                     
                     --SUM(a.commission_amt*b.currency_rt) commission_amt
                     a.commission_amt * b.currency_rt commission_amt
                --mikel 03.06.2013
              FROM   gipi_comm_invoice a, gipi_invoice b, gipi_polbasic c
               WHERE a.iss_cd = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
                 AND b.policy_id = c.policy_id
                 AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                 AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
                 AND a.intrmdry_intm_no = NVL (p_intm_no, a.intrmdry_intm_no)
                 --mikel 08.31.2013
                 AND LAST_DAY(b.acct_ent_date) = LAST_DAY(p_date)           --Modified by pjsantos 04/05/2017, added LAST_DAY  to get all records within the month GENQA 5973
              --GROUP BY a.iss_cd, a.prem_seq_no
              UNION ALL
              SELECT a.iss_cd, a.prem_seq_no, b.currency_rt,
                     
                     --SUM(a.commission_amt*b.currency_rt)*-1 commission_amt
                     a.commission_amt * b.currency_rt * -1 commission_amt
                --mikel 03.06.2013
              FROM   gipi_comm_invoice a, gipi_invoice b, gipi_polbasic c
               WHERE a.iss_cd = b.iss_cd
                 AND a.prem_seq_no = b.prem_seq_no
                 AND b.policy_id = c.policy_id
                 AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                 AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
                 AND a.intrmdry_intm_no = NVL (p_intm_no, a.intrmdry_intm_no)
                 --mikel 08.31.2013
                 AND LAST_DAY(b.spoiled_acct_ent_date) = LAST_DAY(p_date)  --Modified by pjsantos 04/05/2017, added LAST_DAY to get all records within the month GENQA 5973
                                                     --GROUP BY a.iss_cd, a.prem_seq_no
            )
   LOOP
      v_comm_amt := ic.commission_amt;

      FOR mc IN (SELECT p.commission_amt
                   FROM giac_prev_comm_inv p
                  WHERE p.comm_rec_id IN (
                           SELECT MIN (n.comm_rec_id)
                             FROM giac_new_comm_inv n, gipi_invoice i
                            WHERE n.iss_cd = i.iss_cd
                              AND n.prem_seq_no = i.prem_seq_no
                              AND i.iss_cd = p_iss_cd
                              AND i.prem_seq_no = p_prem_seq_no
                              AND n.tran_flag = 'P'
                              AND NVL (delete_sw, 'N') = 'N'
                              AND n.acct_ent_date >= i.acct_ent_date)
                    AND LAST_DAY(p.acct_ent_date) = LAST_DAY(p_date))     --Modified by pjsantos 04/05/2017, added LAST_DAY  to get all records within the month GENQA 5973
      LOOP
         v_comm_amt := mc.commission_amt * ic.currency_rt;
      END LOOP;

      --albert 09162013; to handle policies with multiple intermediaries
      FOR abc IN (SELECT p.commission_amt
                    FROM giac_prev_comm_inv p
                   WHERE p.comm_rec_id IN (
                            SELECT MIN (n.comm_rec_id)
                              FROM giac_new_comm_inv n, gipi_invoice i
                             WHERE n.iss_cd = i.iss_cd
                               AND n.prem_seq_no = i.prem_seq_no
                               AND i.iss_cd = p_iss_cd
                               AND i.prem_seq_no = p_prem_seq_no
                               AND n.tran_flag = 'P'
                               AND NVL (delete_sw, 'N') = 'N'
                               AND n.acct_ent_date >= i.acct_ent_date)
                     AND LAST_DAY(p.acct_ent_date) = LAST_DAY(p_date)     --Modified by pjsantos 04/05/2017, added LAST_DAY  to get all records within the month GENQA 5973
                     AND p.intm_no = p_intm_no)
      LOOP
         v_comm_amt := abc.commission_amt * ic.currency_rt;
      END LOOP;
   --end albert 09162013
   END LOOP;

   RETURN (v_comm_amt);
END get_booked_comm_amt;
/



DROP FUNCTION CPI.GET_BOOKED_COMM_AMT2;

CREATE OR REPLACE FUNCTION CPI.get_booked_comm_amt2 (
   p_iss_cd                  VARCHAR2,
   p_prem_seq_no             NUMBER,
   p_intm_no                 NUMBER,                        --mikel 08.31.2013
   p_acct_ent_date           DATE,
   p_spoiled_acct_ent_date   DATE,
   p_mm_year                 VARCHAR2,
   p_extract_mm              VARCHAR2,
   p_extract_year            VARCHAR2
)
   RETURN NUMBER
IS
   v_comm_amt       NUMBER (20, 2);
   v_comm_amt2      NUMBER (20, 2);
   v_paramdate      VARCHAR2 (10)  := giacp.v ('24TH_METHOD_PARAMDATE');
   v_exclude_mn     VARCHAR2 (10)
                                := NVL (giacp.v ('EXCLUDE_MARINE_24TH'), 'N');
   v_mn             VARCHAR2 (10)  := giisp.v ('LINE_CODE_MN');
   v_mm_year_mn1    VARCHAR2 (30);
   v_mm_year_mn2    VARCHAR2 (30);
   v_start_date     DATE
                   := TO_DATE (giacp.v ('24TH_METHOD_START_DATE'), 'MM-YYYY');
   v_mm_year        VARCHAR2 (30);
   v_mn_24th_comp   VARCHAR2 (1)   := giacp.v ('MARINE_COMPUTATION_24TH');
/* judyann 03062013; to get the commissions booked during month-end production */
BEGIN
   v_mm_year :=
      LPAD (TO_CHAR (p_extract_mm), 2, '0') || '-'
      || TO_CHAR (p_extract_year);
   v_mm_year_mn1 :=
         TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_extract_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'MM'
                 )
      || '-'
      || TO_CHAR (  TO_DATE (   LPAD (TO_CHAR (p_extract_mm), 2, '0')
                             || '-'
                             || TO_CHAR (p_extract_year),
                             'MM-YYYY'
                            )
                  - 1,
                  'YYYY'
                 );
   v_mm_year_mn2 :=
       LPAD (TO_CHAR (p_extract_mm), 2, '0') || '-'
       || TO_CHAR (p_extract_year);

   FOR ic IN
      (SELECT a.iss_cd, a.prem_seq_no, b.currency_rt,

              --SUM(a.commission_amt*b.currency_rt) commission_amt
              a.commission_amt * b.currency_rt commission_amt--mikel 03.06.2013
              ,'N' spld_sw --mikel 08.31.2013
       FROM   gipi_comm_invoice a, gipi_invoice b, gipi_polbasic c
        WHERE a.iss_cd = b.iss_cd
          AND a.prem_seq_no = b.prem_seq_no
          AND b.policy_id = c.policy_id
          AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
          AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
          AND a.intrmdry_intm_no = NVL (p_intm_no, a.intrmdry_intm_no)
          --mikel 08.31.2013
          --AND TO_CHAR (b.acct_ent_date, 'MM-YYYY') = v_mm_year--albert 08222013
          AND (    LAST_DAY (b.acct_ent_date) >= v_start_date
               AND LAST_DAY (b.acct_ent_date) <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
              )
          AND (   (v_exclude_mn = 'Y' AND c.line_cd <> v_mn)
               OR (       v_exclude_mn = 'N'
                      AND v_mn_24th_comp = '1'
                      AND (       c.line_cd = v_mn
                              AND (   (    v_paramdate = 'A'
                                       AND TO_CHAR (b.acct_ent_date,
                                                    'MM-YYYY') IN
                                               (v_mm_year_mn1, v_mm_year_mn2)
                                      )
                                   OR (    v_paramdate = 'E'
                                       AND (TO_CHAR (b.acct_ent_date,
                                                     'MM-YYYY'
                                                    ) IN
                                               (v_mm_year_mn1, v_mm_year_mn2)
                                           )
                                      )
                                  )
                           OR c.line_cd <> v_mn
                          )
                   OR v_mn_24th_comp = '2' AND c.line_cd = c.line_cd
                  )
              )
       --GROUP BY a.iss_cd, a.prem_seq_no, b.currency_rt
       UNION ALL
       SELECT a.iss_cd, a.prem_seq_no, b.currency_rt,

              --SUM(a.commission_amt*b.currency_rt)*-1 commission_amt
              a.commission_amt * b.currency_rt * -1 commission_amt--mikel 03.06.2013
         ,'Y' spld_sw --mikel 08.31.2013
       FROM   gipi_comm_invoice a, gipi_invoice b, gipi_polbasic c
        WHERE a.iss_cd = b.iss_cd
          AND a.prem_seq_no = b.prem_seq_no
          AND b.policy_id = c.policy_id
          AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
          AND a.prem_seq_no = NVL (p_prem_seq_no, a.prem_seq_no)
          AND a.intrmdry_intm_no = NVL (p_intm_no, a.intrmdry_intm_no)
          --mikel 08.31.2013
          --AND TO_CHAR (b.spoiled_acct_ent_date, 'MM-YYYY') = v_mm_year--albert 08222013
          AND (    LAST_DAY (b.spoiled_acct_ent_date) <=
                                     LAST_DAY (TO_DATE (p_mm_year, 'MM-YYYY'))
               AND LAST_DAY (b.spoiled_acct_ent_date) >= v_start_date
              )
          AND (   (v_exclude_mn = 'Y' AND c.line_cd <> v_mn)
               OR (       v_exclude_mn = 'N'
                      AND v_mn_24th_comp = '1'
                      AND (       c.line_cd = v_mn
                              AND (   (    v_paramdate = 'A'
                                       AND TO_CHAR (b.spoiled_acct_ent_date,
                                                    'MM-YYYY'
                                                   ) IN
                                               (v_mm_year_mn1, v_mm_year_mn2)
                                      )
                                   OR (    v_paramdate = 'E'
                                       AND (TO_CHAR (b.spoiled_acct_ent_date,
                                                     'MM-YYYY'
                                                    ) IN
                                               (v_mm_year_mn1, v_mm_year_mn2)
                                           )
                                      )
                                  )
                           OR c.line_cd <> v_mn
                          )
                   OR v_mn_24th_comp = '2' AND c.line_cd = c.line_cd
                  )
              )
               --GROUP BY a.iss_cd, a.prem_seq_no, b.currency_rt
      )
   LOOP
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
                              AND n.acct_ent_date > i.acct_ent_date)
                    --and P.ACCT_ENT_DATE = p_acct_ent_date --mikel 08.31.2013
                    AND (   (    p.acct_ent_date = p_acct_ent_date
                             AND LAST_DAY (p_acct_ent_date) >= v_start_date
                             AND ic.spld_sw = 'N'
                            )
                         OR (    p.acct_ent_date = p_spoiled_acct_ent_date
                             AND LAST_DAY (p_spoiled_acct_ent_date) >= v_start_date
                             AND ic.spld_sw = 'Y'
                            )
                        ))
      LOOP
         v_comm_amt := mc.commission_amt * ic.currency_rt;
      END LOOP;

      --albert 09162013, to handle policies with multiple intermedaries
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
                              AND n.acct_ent_date > i.acct_ent_date)
                    --and P.ACCT_ENT_DATE = p_acct_ent_date --mikel 08.31.2013
                    AND p.intm_no = p_intm_no
                    AND (   (    p.acct_ent_date = p_acct_ent_date
                             AND LAST_DAY (p_acct_ent_date) >= v_start_date
                             AND ic.spld_sw = 'N'
                            )
                         OR (    p.acct_ent_date = p_spoiled_acct_ent_date
                             AND LAST_DAY (p_spoiled_acct_ent_date) >= v_start_date
                             AND ic.spld_sw = 'Y'
                            )
                        ))
      LOOP
         v_comm_amt := abc.commission_amt * ic.currency_rt;
      END LOOP;
      --end albert 09162013

      v_comm_amt2 := NVL(v_comm_amt2, 0) + NVL(v_comm_amt, ic.commission_amt);
      --v_comm_amt2 := NVL (v_comm_amt, ic.commission_amt);    --albert 08302013
   END LOOP;

   RETURN (v_comm_amt2);
END get_booked_comm_amt2;
/



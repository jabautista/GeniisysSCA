CREATE OR REPLACE PACKAGE BODY CPI.gipir902e_pkg
AS
   FUNCTION get_cols (
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2
   )
      RETURN col_tab PIPELINED
   IS
      v   col_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.block_risk
                           FROM (SELECT   (DECODE (NVL (a1.risk_cd, '*'),
                                                   '*', a3.block_desc,
                                                      (SELECT risk_desc
                                                         FROM giis_risks
                                                        WHERE risk_cd =
                                                                    a1.risk_cd)
                                                   || ' / '
                                                   || a3.block_desc
                                                  )
                                          ) block_risk,
                                          SUM (a1.ann_tsi_amt) sum_insured
                                     FROM gipi_polriskloss_item_ext a1,
                                          giis_block a3,
                                          (SELECT b11.policy_id
                                             FROM gicl_claims a11,
                                                  gipi_polriskloss_item_ext b11,
                                                  gicl_risk_loss_profile_ext3 c11
                                            WHERE a11.line_cd = 'FI'
                                              AND NVL(a11.subline_cd, '*******') = NVL(p_subline_cd, NVL(a11.subline_cd, '*******'))
                                              AND a11.line_cd = b11.line_cd
                                              AND a11.subline_cd = b11.subline_cd
                                              AND a11.issue_yy = b11.issue_yy
                                              AND a11.pol_iss_cd = b11.iss_cd
                                              AND a11.pol_seq_no = b11.pol_seq_no
                                              AND a11.renew_no = b11.renew_no
                                              AND a11.claim_id = c11.claim_id) a4
                                    WHERE a1.line_cd = 'FI'
                                      AND NVL(a1.subline_cd, '*******') = NVL(p_subline_cd, NVL(a1.subline_cd, '*******'))
                                      AND a1.block_id = a3.block_id
                                      AND a1.user_id = p_user_id
                                      AND a1.policy_id = a4.policy_id(+)
                                 GROUP BY a1.policy_id, a1.risk_cd,
                                          block_desc) a,
                                (SELECT range_from, range_to
                                   FROM gipi_risk_loss_profile_item
                                  WHERE 1 = 1
                                    AND line_cd = 'FI'
                                    AND NVL (subline_cd, '@@@') = NVL (p_subline_cd, NVL (subline_cd, '@@@'))
                                    AND loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy')
                                    AND loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy')) b
                          WHERE a.sum_insured BETWEEN b.range_from AND b.range_to
                       ORDER BY a.block_risk)
      LOOP
         v.block_risk := i.block_risk;
         PIPE ROW (v);
      END LOOP;
   END;
   
   FUNCTION get_rep (
      p_subline_cd       VARCHAR2,
      p_user_id          VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_loss_date_to     VARCHAR2   
   )
      RETURN rep_tab PIPELINED
   IS
      v rep_type;
            
      TYPE col_type IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
      cols col_type;
      
      TYPE v_detail_type IS RECORD (
         block_risk  VARCHAR2(200),
         range_from  NUMBER,
         risk_count  NUMBER,
         sum_insured NUMBER,
         prem_amt    NUMBER,
         loss_amt    NUMBER
      );
      
      TYPE v_detail_tab IS TABLE OF v_detail_type;
      
      details v_detail_tab;
      
      v_col_count NUMBER := 0;
      v_row_count NUMBER := 0;
      
      v_risk_count   NUMBER;   
      v_sum_insured  NUMBER;
      v_prem_amt     NUMBER;
      v_loss_amt     NUMBER;
      
      v_tot_risk_count   NUMBER;   
      v_tot_sum_insured  NUMBER;
      v_tot_prem_amt     NUMBER;
      v_tot_loss_amt     NUMBER;
   BEGIN
   
      v.date_from := TRIM(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_from, 'mm-dd-yyyy'), 'YYYY');
      v.date_to := TRIM(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_date_to, 'mm-dd-yyyy'), 'YYYY');
      v.loss_date_from := TRIM(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), 'YYYY');
      v.loss_date_to := TRIM(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'Month')) || ' ' || TO_NUMBER(TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'dd')) || ', ' || TO_CHAR(TO_DATE(p_loss_date_to, 'mm-dd-yyyy'), 'YYYY');
   
      SELECT block_risk, range_from, risk_count, sum_insured, prem_amt, loss_amt
        BULK COLLECT INTO details
        FROM (SELECT a.block_risk, b.range_from, SUM (a.sum_insured) sum_insured,
                     SUM (a.prem_amt) prem_amt, SUM (a.loss_amt) loss_amt,
                     SUM (a.risk_count) risk_count
                FROM (SELECT   a1.line_cd, a1.subline_cd, a1.iss_cd, a1.issue_yy,
                               a1.pol_seq_no, a1.renew_no,
                               (DECODE (NVL (a1.risk_cd, '*'),
                                        '*', a3.block_desc,
                                           (SELECT risk_desc
                                              FROM giis_risks
                                             WHERE risk_cd = a1.risk_cd)
                                        || ' / '
                                        || a3.block_desc
                                       )
                               ) block_risk,
                               SUM (a1.ann_tsi_amt) sum_insured,
                               SUM (a2.prem_amt) prem_amt,
                               SUM (NVL (a4.loss_amt, 0)) loss_amt,
                               COUNT (a1.ann_tsi_amt) risk_count
                          FROM gipi_polriskloss_item_ext a1,
                               gipi_item a2,
                               giis_block a3,
                               (SELECT   SUM (c11.loss_amt) loss_amt, b11.policy_id,
                                         c11.block_id, c11.risk_cd
                                    FROM gicl_claims a11,
                                         gipi_polriskloss_item_ext b11,
                                         gicl_risk_loss_profile_ext3 c11
                                   WHERE a11.line_cd = 'FI'
                                     AND NVL (a11.subline_cd, '********') =
                                            NVL (p_subline_cd,
                                                 NVL (a11.subline_cd, '********')
                                                )
                                     AND a11.user_id = p_user_id
                                     AND a11.line_cd = b11.line_cd
                                     AND a11.subline_cd = b11.subline_cd
                                     AND a11.issue_yy = b11.issue_yy
                                     AND a11.pol_iss_cd = b11.iss_cd
                                     AND a11.pol_seq_no = b11.pol_seq_no
                                     AND a11.renew_no = b11.renew_no
                                     AND a11.claim_id = c11.claim_id
                                GROUP BY b11.policy_id, c11.block_id, c11.risk_cd) a4
                         WHERE a1.policy_id = a2.policy_id
                           AND a1.item_no = a2.item_no
                           AND a1.line_cd = 'FI'
                           AND NVL (a1.subline_cd, '********') =
                                       NVL (p_subline_cd, NVL (a1.subline_cd, '********'))
                           AND a1.block_id = a3.block_id
                           AND a1.user_id = p_user_id
                           AND a1.policy_id = a4.policy_id(+)
                      GROUP BY a1.line_cd,
                               a1.subline_cd,
                               a1.iss_cd,
                               a1.issue_yy,
                               a1.pol_seq_no,
                               a1.renew_no,
                               a1.risk_cd,
                               block_desc
                      ORDER BY block_risk, sum_insured) a,
                     (SELECT range_from, range_to
                        FROM gipi_risk_loss_profile_item x
                       WHERE line_cd = 'FI'
                         AND loss_date_from = TO_DATE (p_loss_date_from, 'mm-dd-yyyy')
                         AND loss_date_to = TO_DATE (p_loss_date_to, 'mm-dd-yyyy')
                         AND NVL (subline_cd, '*******') = NVL (p_subline_cd, NVL (subline_cd, '*******'))
                         AND user_id = p_user_id) b
               WHERE a.sum_insured BETWEEN b.range_from AND b.range_to
            GROUP BY b.range_from, a.block_risk
            ORDER BY b.range_from, a.block_risk ASC);
   
      SELECT *
        BULK COLLECT INTO cols
        FROM TABLE (gipir902e_pkg.get_cols(p_subline_cd, p_user_id, p_loss_date_from, p_loss_date_to))
   UNION ALL
      SELECT 'Grand Total' FROM DUAL;  
   
      FOR i IN
         (SELECT   *
            FROM (SELECT range_from, range_to,
                            LTRIM (TO_CHAR (range_from, '999,999,999,999,999'))
                         || ' - '
                         || LTRIM (DECODE ((LTRIM (TO_CHAR (range_to,
                                                            '999,999,999,999,999'
                                                           )
                                                  )
                                           ),
                                           '100,000,000,000,000', 'OVER',
                                           (TO_CHAR (range_to, '999,999,999,999,999')
                                           )
                                          )
                                  ) ranges
                    FROM gipi_risk_loss_profile_item
                   WHERE line_cd = 'FI'
                     AND NVL (subline_cd, '********') = NVL (p_subline_cd, NVL (subline_cd, '********'))
                     AND loss_date_from = TO_DATE (p_loss_date_from, 'mm-dd-yyyy')
                     AND loss_date_to = TO_DATE (p_loss_date_to, 'mm-dd-yyyy'))
        ORDER BY range_from)
      LOOP
      
         v.range_from := i.range_from;
         v.ranges := i.ranges;
         v_tot_risk_count   := 0;   
         v_tot_sum_insured  := 0;
         v_tot_prem_amt     := 0;
         v_tot_loss_amt     := 0;
         
         FOR k IN cols.FIRST..cols.LAST
         LOOP
         
            FOR j IN details.FIRST..details.LAST
            LOOP
               v_risk_count := 0;
               v_sum_insured := 0;
               v_prem_amt := 0;
               v_loss_amt := 0;
               IF details(j).range_from = i.range_from AND details(j).block_risk = cols(k) THEN
                  v_risk_count := details(j).risk_count;
                  v_sum_insured := details(j).sum_insured;
                  v_prem_amt := details(j).prem_amt;
                  v_loss_amt := details(j).loss_amt;
                  
                  v_tot_risk_count := v_tot_risk_count + v_risk_count;
                  v_tot_sum_insured := v_tot_sum_insured + v_sum_insured;
                  v_tot_prem_amt := v_tot_prem_amt + v_prem_amt;
                  v_tot_loss_amt := v_tot_loss_amt + v_loss_amt;
                  EXIT;
               END IF;
            END LOOP details;
            
            IF k = cols.LAST THEN
               v_risk_count := v_tot_risk_count;
               v_sum_insured := v_tot_sum_insured;
               v_prem_amt := v_tot_prem_amt;
               v_loss_amt := v_tot_loss_amt;
            END IF;
         
            v_col_count := v_col_count + 1;            
            IF v_col_count = 1 THEN
               v.block_risk1 := cols(k);
               v.risk_count1 := v_risk_count;
               v.sum_insured1 := v_sum_insured;
               v.prem_amt1 := v_prem_amt;
               v.loss_amt1 := v_loss_amt;
               
               v.block_risk2 := NULL;
               v.block_risk3 := NULL;               
               v.risk_count2 := NULL;
               v.risk_count3 := NULL;
               v.sum_insured2 := NULL;
               v.sum_insured3 := NULL;
               v.prem_amt2 := NULL;
               v.prem_amt3 := NULL;
               v.loss_amt2 := NULL;
               v.loss_amt3 := NULL;
               
               v_row_count := v_row_count + 1;
               v.row_no := v_row_count;
            ELSIF v_col_count = 2 THEN
               v.block_risk2 := cols(k);
               v.risk_count2 := v_risk_count;
               v.sum_insured2 := v_sum_insured;
               v.prem_amt2 := v_prem_amt;
               v.loss_amt2 := v_loss_amt;               
               
               v.block_risk3 := NULL;                              
               v.risk_count3 := NULL;               
               v.sum_insured3 := NULL;               
               v.prem_amt3 := NULL;               
               v.loss_amt3 := NULL;
            ELSE
               v.block_risk3 := cols(k);
               v.risk_count3 := v_risk_count;
               v.sum_insured3 := v_sum_insured;
               v.prem_amt3 := v_prem_amt;
               v.loss_amt3 := v_loss_amt;
               
               v_col_count := 0;
               
               PIPE ROW(v);
            END IF;
         
         END LOOP cols;
      
      IF v_col_count <> 0 THEN
         PIPE ROW(v);
      END IF;
      
      v_row_count := 0;
      v_col_count := 0;
      
      END LOOP i;
   END get_rep;
      
END;
/



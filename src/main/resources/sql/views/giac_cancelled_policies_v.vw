/* Formatted on 10/26/2016 9:45:12 AM (QP5 v5.227.12220.39754) */
CREATE OR REPLACE FORCE VIEW CPI.GIAC_CANCELLED_POLICIES_V
(
   POLICY_ID,
   TSI_AMT,
   PREM_AMT,
   LINE_CD,
   SUBLINE_CD,
   ISS_CD,
   ISSUE_YY,
   POL_SEQ_NO,
   RENEW_NO,
   ASSD_NAME,
   INCEPT_DATE,
   EXPIRY_DATE,
   REG_POLICY_SW,--Added by pjsantos 10/26/2016, for optimization GENQA 5753.
   CANCELLATION_TAG
)
AS
   SELECT a.policy_id,
          a.tsi_amt,
          a.prem_amt,
          a.line_cd,
          a.subline_cd,
          a.iss_cd,
          a.issue_yy,
          a.pol_seq_no,
          a.renew_no,
          c.assd_name,
          a.incept_date,
          a.expiry_date,
          a.reg_policy_sw,
          'F' cancellation_tag
     FROM gipi_polbasic a, giis_assured c
    WHERE     1 = 1
          AND a.assd_no = c.assd_no
          AND (a.line_cd,
               a.subline_cd,
               a.iss_cd,
               a.issue_yy,
               a.pol_seq_no,
               a.renew_no) IN
                 /* rad 09/05/2011 optimization: changed from exist to IN */
                 (  SELECT /*+ INDEX(giac_aging_soa_details gagd_pk) */
                          x.line_cd,
                           x.subline_cd,
                           x.iss_cd,
                           x.issue_yy,
                           x.pol_seq_no,
                           x.renew_no
                      FROM gipi_polbasic x, giac_aging_soa_details y
                     WHERE     1 = 1
                           AND x.policy_id = y.policy_id
                         --  AND x.iss_cd = y.iss_cd                                                                --removed by pjsantos 10/26/2016 for optimization GENQA 5753
                           AND x.pol_flag = '4'
                           AND (y.total_amount_due > 0 or y.total_amount_due < 0) /*added by VJ 020309*/            --modified by pjsantos 10/26/2016 for optimization GENQA 5753.
                           AND (y.total_amount_due > y.total_payments or  y.total_amount_due < y.total_payments)     --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                           /*added by VJ 020409*/
                           AND (y.balance_amt_due > 0 or y.balance_amt_due < 0)   /*added by VJ 020509*/            --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                    HAVING SUM (y.balance_amt_due) = 0
                  --AND SUM (y.total_amount_due) = 0 /* commented out by mikel 02.21.2012;  for pro-rata cancellation */
                  --AND SUM (ABS (y.total_payments)) = 0 /* mikel 02.21.2012 */
                  GROUP BY x.line_cd,
                           x.subline_cd,
                           x.iss_cd,
                           x.issue_yy,
                           x.pol_seq_no,
                           x.renew_no)
          AND a.pol_flag = '4'
          AND a.endt_seq_no = 0
   UNION                /* for cancellations cancelling another endorsement */
   SELECT a.policy_id,
          a.tsi_amt,
          a.prem_amt,
          a.line_cd,
          a.subline_cd,
          a.iss_cd,
          a.issue_yy,
          a.pol_seq_no,
          a.renew_no,
          c.assd_name,
          a.incept_date,
          a.expiry_date,
          a.reg_policy_sw, 
          'E' cancellation_tag
     FROM gipi_polbasic a, giis_assured c
    WHERE     1 = 1
          AND a.assd_no = c.assd_no
          AND EXISTS
                 (SELECT 'X'
                    FROM (  SELECT /*+ INDEX(giac_aging_soa_details gagd_pk) */
                                  SUM (balance_amt_due) balance1,
                                   SUM (total_amount_due) due1,
                                   SUM (total_payments) payt1,
                                   x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no
                              FROM gipi_polbasic x, giac_aging_soa_details y
                             WHERE     1 = 1
                                   AND x.policy_id = y.policy_id
                                  -- AND x.iss_cd = y.iss_cd                                                             --removed by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND x.cancelled_endt_id IS NULL
                                   AND (y.total_amount_due > 0 or y.total_amount_due < 0) /*added by VJ 020309*/        --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > y.total_payments or y.total_amount_due < y.total_payments)  --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   /*added by VJ 020409*/
                                   AND (y.balance_amt_due > 0 or y.balance_amt_due < 0) /*added by VJ 020509*/          --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                  /* AND x.policy_id IN
                                          (SELECT cancelled_endt_id
                                             FROM gipi_polbasic z
                                            WHERE     z.line_cd = x.line_cd
                                                  AND z.subline_cd =
                                                         x.subline_cd
                                                  AND z.iss_cd = x.iss_cd
                                                  AND z.issue_yy = x.issue_yy
                                                  AND z.pol_seq_no =
                                                         x.pol_seq_no
                                                  AND z.renew_no = x.renew_no
                                                  AND z.cancelled_endt_id
                                                         IS NOT NULL
                                                  AND z.endt_seq_no > 0)*/                                              --replaced by  codes below pjsantos 10/26/2016 for optimization GENQA 5753   
                                  AND EXISTS (SELECT 1    
                                                FROM gipi_polbasic z
                                               WHERE 1=1
                                                AND z.endt_seq_no > 0 
                                                AND x.policy_id = z.cancelled_endt_id)                       
                          GROUP BY x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no) e1,
                         (  SELECT /*+ INDEX(giac_aging_soa_details gagd_pk) */
                                  SUM (balance_amt_due) balance2,
                                   SUM (total_amount_due) due2,
                                   SUM (total_payments) payt2,
                                   x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no
                              FROM gipi_polbasic x, giac_aging_soa_details y
                             WHERE     1 = 1
                                   AND x.policy_id = y.policy_id
                                 --  AND x.iss_cd = y.iss_cd                                                             --removed by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND x.cancelled_endt_id IS NOT NULL
                                   AND (y.total_amount_due > 0  or y.total_amount_due < 0)/*added by VJ 020309*/        --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > y.total_payments or y.total_amount_due < y.total_payments)  --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   /*added by VJ 020309*/
                                   AND (y.balance_amt_due > 0 or y.balance_amt_due < 0) /*added by VJ 020509*/          --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                          GROUP BY x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no) e2
                   WHERE     e1.line_cd = e2.line_cd
                         AND e1.subline_cd = e2.subline_cd
                         AND e1.iss_cd = e2.iss_cd
                         AND e1.issue_yy = e2.issue_yy
                         AND e1.pol_seq_no = e2.pol_seq_no
                         AND e1.renew_no = e2.renew_no
                         AND e1.line_cd = a.line_cd
                         AND e1.subline_cd = a.subline_cd
                         AND e1.iss_cd = a.iss_cd
                         AND e1.issue_yy = a.issue_yy
                         AND e1.pol_seq_no = a.pol_seq_no
                         AND e1.renew_no = a.renew_no
                         AND e1.balance1 + e2.balance2 = 0
                         AND e1.due1 + e2.due2 = 0
                         AND ABS (e1.payt1) - ABS (e2.payt2) = 0)
          AND a.endt_seq_no = 0
          AND a.pol_flag <> '4'                         /*added by VJ 012909*/
   UNION             /* for endorsements cancelling the outstanding balance */
   SELECT a.policy_id,
          a.tsi_amt,
          a.prem_amt,
          a.line_cd,
          a.subline_cd,
          a.iss_cd,
          a.issue_yy,
          a.pol_seq_no,
          a.renew_no,
          c.assd_name,
          a.incept_date,
          a.expiry_date,
          a.reg_policy_sw,
          'O' cancellation_tag
     FROM gipi_polbasic a, giis_assured c
    WHERE     1 = 1
          AND a.assd_no = c.assd_no
          AND EXISTS
                 (SELECT 'X'
                    FROM (  SELECT /*+ INDEX(giac_aging_soa_details gagd_pk) */
                                  SUM (balance_amt_due) balance,
                                   SUM (total_amount_due) total_due,
                                   SUM (total_payments) payt,
                                   x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no
                              FROM gipi_polbasic x, giac_aging_soa_details y
                             WHERE     1 = 1
                                   AND x.policy_id = y.policy_id
                                 --  AND x.iss_cd = y.iss_cd                                                             --removed by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > 0  or y.total_amount_due < 0) /*added by VJ 020309*/       --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > y.total_payments or y.total_amount_due < y.total_payments)  --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   /*added by VJ 020409*/
                                   AND (y.balance_amt_due > 0 or y.balance_amt_due < 0) /*added by VJ 020509*/          
                                   AND x.endt_seq_no NOT IN
                                          (SELECT MAX (endt_seq_no)
                                             FROM gipi_polbasic z
                                            WHERE     z.line_cd = x.line_cd
                                                  AND z.subline_cd = 
                                                         x.subline_cd
                                                  AND z.iss_cd = x.iss_cd
                                                  AND z.issue_yy = x.issue_yy 
                                                  AND z.pol_seq_no =
                                                         x.pol_seq_no
                                                  AND z.renew_no = x.renew_no)                                                
                          GROUP BY x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no
                            HAVING SUM (y.balance_amt_due) > 0 or SUM (y.balance_amt_due) < 0) m,                       --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                         (  SELECT /*+ INDEX(giac_aging_soa_details gagd_pk) */
                                  SUM (balance_amt_due) last_endt_amt,
                                   SUM (total_amount_due) last_endt_due,
                                   SUM (total_payments) last_endt_payt,
                                   x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy,
                                   x.pol_seq_no,
                                   x.renew_no
                               FROM gipi_polbasic x, giac_aging_soa_details y
                             WHERE     1 = 1
                                   AND x.policy_id = y.policy_id 
                                 --  AND x.iss_cd = y.iss_cd                                                             --removed by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > 0  or y.total_amount_due < 0) /*added by VJ 020309*/       --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND (y.total_amount_due > y.total_payments or y.total_amount_due < y.total_payments)  --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   /*added by VJ 020409*/
                                   AND (y.balance_amt_due > 0 or y.balance_amt_due < 0) /*added by VJ 020509*/          --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND x.endt_seq_no IN
                                          (SELECT MAX (endt_seq_no)
                                             FROM gipi_polbasic z
                                            WHERE     z.line_cd = x.line_cd
                                                  AND z.subline_cd =
                                                         x.subline_cd
                                                  AND z.iss_cd = x.iss_cd
                                                  AND z.issue_yy = x.issue_yy 
                                                  AND z.pol_seq_no =
                                                         x.pol_seq_no
                                                  AND z.renew_no = x.renew_no
                                                  AND z.endt_seq_no > 0)                                                --added by pjsantos 10/26/2016 for optimization GENQA 5753
                                   AND x.cancelled_endt_id IS NULL
                                   AND x.endt_seq_no > 0                                                                --added by pjsantos 10/26/2016 for optimization GENQA 5753
                          GROUP BY x.line_cd,
                                   x.subline_cd,
                                   x.iss_cd,
                                   x.issue_yy, 
                                   x.pol_seq_no,
                                   x.renew_no
                            HAVING SUM (y.balance_amt_due) > 0 or SUM (y.balance_amt_due) < 0) n --modified by pjsantos 10/26/2016 for optimization GENQA 5753
                   WHERE     m.line_cd = n.line_cd
                         AND m.subline_cd = n.subline_cd
                         AND m.iss_cd = n.iss_cd
                         AND m.issue_yy = n.issue_yy
                         AND m.pol_seq_no = n.pol_seq_no
                         AND m.renew_no = n.renew_no
                         AND m.line_cd = a.line_cd
                         AND m.subline_cd = a.subline_cd
                         AND m.iss_cd = a.iss_cd
                         AND m.issue_yy = a.issue_yy
                         AND m.pol_seq_no = a.pol_seq_no
                         AND m.renew_no = a.renew_no
                         AND m.balance + n.last_endt_amt = 0
                         AND (m.total_due - m.payt) + (n.last_endt_due - n.last_endt_payt) = 0)
          AND a.endt_seq_no = 0
          AND a.pol_flag <> '4';

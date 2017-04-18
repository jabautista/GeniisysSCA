DROP PROCEDURE CPI.LOSS_RATIO_EXT_BY_SUBLINE2;

CREATE OR REPLACE PROCEDURE CPI.Loss_Ratio_Ext_By_Subline2 (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
                       p_loss_date          gipi_polbasic.issue_date%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_counter       OUT  NUMBER) AS
  v_curr_recovery      gipi_itmperil.prem_amt%TYPE;
  v_prev_recovery      gipi_itmperil.prem_amt%TYPE;
  v_curr_prem          gipi_itmperil.prem_amt%TYPE;
  v_prev_prem          gipi_itmperil.prem_amt%TYPE;
  v_curr_loss          gipi_itmperil.prem_amt%TYPE;
  v_prev_loss          gipi_itmperil.prem_amt%TYPE;
  v_curr_exp           gipi_itmperil.prem_amt%TYPE;
  v_prev_exp           gipi_itmperil.prem_amt%TYPE;
  v_paid_amt           gipi_itmperil.prem_amt%TYPE;
  v_curr1_date         gipi_polbasic.issue_date%TYPE;
  v_curr2_date         gipi_polbasic.issue_date%TYPE;
  v_prev_date          gipi_polbasic.issue_date%TYPE;
  v_prev_year          VARCHAR2(4);
/*BETH 01/29/2002
**     this procedure extract amounts to be used in loss ratio(per line/subline) reports
**     parameters for line, subline, iss_cd are available
**     parameter for policy date(p_date_param) will have the following values
**                1 -   issue date
**                2 -   effectivity date
**                3 -   accounting entry date
**                4 -   booking month
**     ===this procedure is for the extraction of data if date parameter is acct entry date
**     parameter for policy date(p_issue_param) will have the following values
**                1 -  issue code of policy
**                2 -  issue code of claim record
*/
BEGIN
  --initialize dates
  --current dates are from beginning of the year for p_loss_date and
  --until the given loss date (p_loss_date)
  --previous dates are the whole of the previous year of loss date
  --(if loss date is January 23, 1999, prev. year will be the whole of 1999)
  v_curr1_date     := TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY');
  v_curr2_date     := TRUNC(p_loss_date);
  v_prev_year      := TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1);
  v_prev_date      := TO_DATE('12-31-'||v_prev_year,'MM-DD-YYYY');
  --initialize counter
  p_counter        := 0;
  --delete records in extract table for the current user
  DELETE gicl_loss_ratio_ext
  WHERE user_id = USER;
  -- retrieve current premium
  FOR curr_prem IN(
    SELECT d.subline_cd
      FROM gipi_polbasic d,
           gipi_itmperil c
     WHERE d.policy_id = c.policy_id
       AND d.line_cd = p_line_cd
       AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
       AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
       AND ((TRUNC(d.acct_ent_date) >= v_curr1_date
           AND TRUNC(d.acct_ent_date) <= v_curr2_date)
           OR (TRUNC(d.spld_acct_ent_date) >= v_curr1_date
           AND TRUNC(d.spld_acct_ent_date) <= v_curr2_date))
   GROUP BY d.subline_cd)
  LOOP
    --increment value of counter
    p_counter   := p_counter + 1;
    --initialize variables for amounts to 0
    v_curr_prem := 0;
    FOR curr_prem1 IN (
      SELECT NVL(SUM(c.prem_amt),0) prem_amt
      FROM gipi_polbasic d,
           gipi_itmperil c
     WHERE d.policy_id = c.policy_id
       AND d.line_cd = p_line_cd
       AND d.subline_cd = curr_prem.subline_cd
       AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
       AND TRUNC(d.acct_ent_date) >= v_curr1_date
       AND TRUNC(d.acct_ent_date) <= v_curr2_date)
    LOOP
      v_curr_prem := curr_prem1.prem_amt;
    END LOOP;
    FOR curr_prem2 IN (
      SELECT NVL(SUM(c.prem_amt),0) prem_amt
      FROM gipi_polbasic d,
           gipi_itmperil c
     WHERE d.policy_id = c.policy_id
       AND d.line_cd = p_line_cd
       AND d.subline_cd = curr_prem.subline_cd
       AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
       AND TRUNC(d.spld_acct_ent_date) >= v_curr1_date
       AND TRUNC(d.spld_acct_ent_date) <= v_curr2_date)
    LOOP
      v_curr_prem := v_curr_prem - curr_prem2.prem_amt;
    END LOOP;
    v_prev_prem := 0;
    v_curr_loss := 0;
    v_prev_loss := 0;
    v_curr_exp  := 0;
    v_prev_exp  := 0;
    v_paid_amt  := 0;
    FOR prev_prem1 IN (
      SELECT NVL(SUM(c.prem_amt),0) prem_amt
        FROM gipi_polbasic d,
             gipi_itmperil c
       WHERE d.policy_id = c.policy_id
         AND d.line_cd = p_line_cd
         AND d.subline_cd = curr_prem.subline_cd
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND TO_CHAR(d.acct_ent_date,'YYYY') = v_prev_year)
    LOOP
       v_prev_prem  := prev_prem1.prem_amt;
    END LOOP;
    FOR prev_prem2 IN (
      SELECT NVL(SUM(c.prem_amt),0) prem_amt
        FROM gipi_polbasic d,
             gipi_itmperil c
       WHERE d.policy_id = c.policy_id
         AND d.line_cd = p_line_cd
         AND d.subline_cd = curr_prem.subline_cd
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = v_prev_year)
    LOOP
       v_prev_prem  := v_prev_prem - prev_prem2.prem_amt;
    END LOOP;
    --get current loss reserve amount
    FOR curr_loss IN (
      SELECT NVL(SUM(NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)),0) loss
        FROM gicl_clm_res_hist a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date, v_curr2_date +365))
                      > TRUNC(v_curr2_date) ) b,
                  (SELECT claim_id, item_no, peril_cd,
                          SUM(losses_paid) losses_paid,
                          SUM(expenses_paid) exp_paid
                     FROM gicl_clm_res_hist
                    WHERE 1 = 1
                      AND tran_id IS NOT NULL
                      AND NVL(cancel_tag,'N') = 'N'
                      AND TRUNC(date_paid) <= TRUNC(v_curr2_date)
                  GROUP BY claim_id, item_no, peril_cd ) c,
                  gicl_claims d
            WHERE 1 = 1
              AND d.line_cd = p_line_cd
              AND d.subline_cd = curr_prem.subline_cd
              AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
                  = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
              AND a.claim_id = d.claim_id
              AND a.claim_id = b.claim_id
              AND a.clm_res_hist_id = b.clm_res_hist_id
              AND b.claim_id = c.claim_id (+)
              AND b.item_no = c.item_no (+)
              AND b.peril_cd = c.peril_cd (+)
              AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
              AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                         FROM gicl_clm_res_hist a2
                                        WHERE a2.claim_id =a.claim_id
                                          AND a2.item_no =a.item_no
                                          AND a2.peril_cd =a.peril_cd
                                          AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                              TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                              <= TRUNC(v_curr2_date)
                                          AND tran_id IS NULL)
              AND TRUNC(NVL(close_date, v_curr2_date +365)) > v_curr2_date)
    LOOP
      v_curr_loss  := curr_loss.loss;
    END LOOP;
    --get current expense reserve amount
    FOR curr_exp IN (
      SELECT NVL(SUM(NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)),0) expense
        FROM gicl_clm_res_hist a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date, v_curr2_date +365))
                      > TRUNC(v_curr2_date) ) b,
                  (SELECT claim_id, item_no, peril_cd,
                          SUM(losses_paid) losses_paid,
                          SUM(expenses_paid) exp_paid
                     FROM gicl_clm_res_hist
                    WHERE 1 = 1
                      AND tran_id IS NOT NULL
                      AND NVL(cancel_tag,'N') = 'N'
                      AND TRUNC(date_paid) <= TRUNC(v_curr2_date)
                  GROUP BY claim_id, item_no, peril_cd ) c,
                  gicl_claims d
            WHERE 1 = 1
              AND d.line_cd = p_line_cd
              AND d.subline_cd = curr_prem.subline_cd
              AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
                  = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
              AND a.claim_id = d.claim_id
              AND a.claim_id = b.claim_id
              AND a.clm_res_hist_id = b.clm_res_hist_id
              AND b.claim_id = c.claim_id (+)
              AND b.item_no = c.item_no (+)
              AND b.peril_cd = c.peril_cd (+)
              AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
              AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                         FROM gicl_clm_res_hist a2
                                        WHERE a2.claim_id =a.claim_id
                                          AND a2.item_no =a.item_no
                                          AND a2.peril_cd =a.peril_cd
                                          AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                              TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                              <= TRUNC(v_curr2_date)
                                          AND tran_id IS NULL)
              AND TRUNC(NVL(close_date, v_curr2_date +365)) > v_curr2_date)
    LOOP
      v_curr_exp  := curr_exp.expense;
    END LOOP;
    --get previous loss reserve amount
    FOR prev_loss IN (
       SELECT NVL(SUM(NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)),0) loss
         FROM gicl_clm_res_hist a,
              (SELECT b1.claim_id, b1.clm_res_hist_id,
                      b1.item_no, b1.peril_cd
                 FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                 WHERE tran_id IS NULL
                   AND b2.claim_id = b1.claim_id
                   AND b2.item_no  = b1.item_no
                   AND b2.peril_cd = b1.peril_cd
                   AND TO_CHAR(NVL(b2.close_date, v_curr2_date + 365),'YYYY')
                       > v_prev_year) b,
                   (SELECT claim_id, item_no, peril_cd,
                           SUM(losses_paid) losses_paid,
                           SUM(expenses_paid) exp_paid
                      FROM gicl_clm_res_hist
                     WHERE 1 = 1
                       AND tran_id IS NOT NULL
                       AND NVL(cancel_tag,'N') = 'N'
                       AND TRUNC(date_paid) <= v_prev_date
                   GROUP BY claim_id, item_no, peril_cd ) c,
                   gicl_claims d
             WHERE 1 = 1
               AND d.line_cd = p_line_cd
               AND d.subline_cd = curr_prem.subline_cd
               AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
                   = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
               AND a.claim_id = d.claim_id
               AND a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.claim_id = c.claim_id (+)
               AND b.item_no = c.item_no (+)
               AND b.peril_cd = c.peril_cd (+)
               AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
               AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                          FROM gicl_clm_res_hist a2
                                         WHERE a2.claim_id =a.claim_id
                                           AND a2.item_no =a.item_no
                                           AND a2.peril_cd =a.peril_cd
                                           AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                               <= TO_NUMBER(v_prev_year)
                                           AND tran_id IS NULL)
               AND TO_CHAR(NVL(d.close_date, v_curr2_date + 365),'YYYY')
                       > v_prev_year)
    LOOP
      v_prev_loss  := prev_loss.loss;
    END LOOP;
    --get previous expense reserve amount
    FOR prev_exp IN (
       SELECT NVL(SUM(NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)),0) expense
         FROM gicl_clm_res_hist a,
              (SELECT b1.claim_id, b1.clm_res_hist_id,
                      b1.item_no, b1.peril_cd
                 FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                 WHERE tran_id IS NULL
                   AND b2.claim_id = b1.claim_id
                   AND b2.item_no  = b1.item_no
                   AND b2.peril_cd = b1.peril_cd
                   AND TO_CHAR(NVL(b2.close_date, v_curr2_date +365),'YYYY')
                       > v_prev_year) b,
                   (SELECT claim_id, item_no, peril_cd,
                           SUM(losses_paid) losses_paid,
                           SUM(expenses_paid) exp_paid
                      FROM gicl_clm_res_hist
                     WHERE 1 = 1
                       AND tran_id IS NOT NULL
                       AND NVL(cancel_tag,'N') = 'N'
                       AND TRUNC(date_paid) <= v_prev_date
                   GROUP BY claim_id, item_no, peril_cd ) c,
                   gicl_claims d
             WHERE 1 = 1
               AND d.line_cd = p_line_cd
               AND d.subline_cd = curr_prem.subline_cd
               AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
                   = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
               AND a.claim_id = d.claim_id
               AND a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.claim_id = c.claim_id (+)
               AND b.item_no = c.item_no (+)
               AND b.peril_cd = c.peril_cd (+)
               AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
               AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                          FROM gicl_clm_res_hist a2
                                         WHERE a2.claim_id =a.claim_id
                                           AND a2.item_no =a.item_no
                                           AND a2.peril_cd =a.peril_cd
                                           AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                               <= TO_NUMBER(v_prev_year)
                                           AND tran_id IS NULL)
               AND TO_CHAR(NVL(d.close_date, v_curr2_date + 365),'YYYY')
                       > v_prev_year)
    LOOP
      v_prev_exp  := prev_exp.expense;
    END LOOP;
    --get loss paid amount
    FOR paid_loss IN(
      SELECT NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
        FROM gicl_clm_res_hist a, gicl_claims b
       WHERE 1 = 1
         AND b.line_cd = p_line_cd
         AND b.subline_cd = curr_prem.subline_cd
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND a.claim_id = b.claim_id
         AND tran_id IS NOT NULL
         AND NVL(cancel_tag,'N') = 'N'
         AND TRUNC(date_paid) >= v_curr1_date
         AND TRUNC(date_paid) <= v_curr2_date)
    LOOP
      v_paid_amt        := paid_loss.loss_paid;
    END LOOP;
    --get previous year recovery amount
    FOR prev_recovery IN(
      SELECT NVL(SUM(recovered_amt),0) recovered_amt
        FROM gicl_recovery_payt a, gicl_claims b
       WHERE 1 = 1
         AND b.line_cd = p_line_cd
         AND b.subline_cd = curr_prem.subline_cd
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND a.claim_id = b.claim_id
         AND NVL(cancel_tag,'N') = 'N'
         AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(v_prev_year))
    LOOP
      v_prev_recovery   := prev_recovery.recovered_amt;
    END LOOP;
    --get current year recovery amount
    FOR curr_recovery IN(
      SELECT NVL(SUM(recovered_amt),0) recovered_amt
       FROM gicl_recovery_payt a, gicl_claims b
        WHERE 1 = 1
         AND b.line_cd = p_line_cd
         AND b.subline_cd = curr_prem.subline_cd
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND a.claim_id = b.claim_id
         AND NVL(cancel_tag,'N') = 'N'
         AND TRUNC(tran_date) >= v_curr1_date
         AND TRUNC(tran_date)<= v_curr2_date)
    LOOP
      v_curr_recovery   := curr_recovery.recovered_amt;
    END LOOP;
    --insert record in table gicl_loss_ratio_ext
    INSERT INTO gicl_loss_ratio_ext
           (session_id,    line_cd,	        subline_cd,
            iss_cd,        loss_ratio_date,
			curr_prem_amt, prev_prem_amt, 	loss_paid_amt,
  	        curr_loss_res, prev_loss_res,	user_id)
    VALUES (p_session_id,       p_line_cd,          curr_prem.subline_cd,
            p_iss_cd,           p_loss_date,
            NVL(v_curr_prem,0), NVL(v_prev_prem,0), NVL(v_paid_amt,0),
            NVL(v_curr_loss,0) + NVL(v_curr_exp,0) - NVL(v_curr_recovery,0),
            NVL(v_prev_loss,0) + NVL(v_prev_exp,0) - NVL(v_prev_recovery,0),  USER);
  END LOOP;
  COMMIT;
END;
/



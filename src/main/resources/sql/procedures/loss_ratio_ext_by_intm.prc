DROP PROCEDURE CPI.LOSS_RATIO_EXT_BY_INTM;

CREATE OR REPLACE PROCEDURE CPI.Loss_Ratio_Ext_By_Intm (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
                       p_session_id         GICL_LOSS_RATIO_EXT.session_id%TYPE,
                       p_loss_date          gipi_polbasic.issue_date%TYPE,
                       p_intm_no            GICL_LOSS_RATIO_EXT.intm_no%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_counter       OUT  NUMBER) AS
  v_curr_recovery      gipi_itmperil.prem_amt%TYPE;
  v_prev_recovery      gipi_itmperil.prem_amt%TYPE;
  v_curr_prem          gipi_itmperil.prem_amt%TYPE;
  v_prev_prem          gipi_itmperil.prem_amt%TYPE;
  v_curr_loss           gipi_itmperil.prem_amt%TYPE;
  v_prev_loss           gipi_itmperil.prem_amt%TYPE;
  v_curr_exp           gipi_itmperil.prem_amt%TYPE;
  v_prev_exp           gipi_itmperil.prem_amt%TYPE;
  v_paid_amt           gipi_itmperil.prem_amt%TYPE;
  v_curr1_date         gipi_polbasic.issue_date%TYPE;
  v_curr2_date         gipi_polbasic.issue_date%TYPE;
  v_prev_date          gipi_polbasic.issue_date%TYPE;
  v_prev_year          VARCHAR2(4);
/*BETH 01/29/2002
**     this procedure extract amounts to be used in loss ratio(per intermediary) reports
**     parameters for line, subline, iss_cd,intm_no are available
**     parameter for policy date(p_date_param) will have the following values
**                1 -   issue date
**                2 -   effectivity date
**                3 -   accounting entry date
**                4 -   booking month
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
  DELETE GICL_LOSS_RATIO_EXT
  WHERE user_id = USER;
  -- retrieve current premium
  FOR CURR_PREM IN (
    SELECT c.intrmdry_intm_no intm_no,
           SUM(NVL(c.premium_amt,0)) prem_amt
      FROM gipi_polbasic d,
           gipi_comm_inv_peril c
     WHERE d.policy_id = c.policy_id
       AND d.line_cd = NVL(p_line_cd, d.line_cd)
       AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
       AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
       AND TRUNC(DECODE(p_date_param, 1, d.issue_date,
                                      2, d.eff_date,
                                      4, LAST_DAY(TO_DATE(UPPER(d.booking_mth)||' 1,'||TO_CHAR(d.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                       >= v_curr1_date
       AND TRUNC(DECODE(p_date_param, 1, d.issue_date,
                                      2, d.eff_date,
                                      4, LAST_DAY(TO_DATE(UPPER(d.booking_mth)||' 1,'||TO_CHAR(d.booking_year),'FMMONTH DD,YYYY')),SYSDATE))
                                      <= v_curr2_date
       AND c.intrmdry_intm_no   = NVL(p_intm_no, c.intrmdry_intm_no)
       AND d.pol_flag IN ('1','2','3','4','X')
   GROUP BY c.intrmdry_intm_no)
  LOOP
    --increment value of counter
    p_counter   := p_counter + 1;
    --initialize variables for amounts to 0
    v_curr_prem := 0;
    v_prev_prem := 0;
    v_curr_loss := 0;
    v_prev_loss := 0;
    v_curr_exp  := 0;
    v_prev_exp  := 0;
    v_paid_amt  := 0;
    v_curr_prem := curr_prem.prem_amt;
    --get previous premium
    FOR PREV_PREM IN (
      SELECT SUM(NVL(c.premium_amt,0)) prem_amt
        FROM gipi_polbasic d,
             gipi_comm_inv_peril c
       WHERE d.policy_id = c.policy_id
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND DECODE(p_date_param, 1, TO_CHAR(d.issue_date,'YYYY'),
                                  2, TO_CHAR(d.eff_date,'YYYY'),
                                  4, TO_CHAR(d.booking_year), TO_CHAR(SYSDATE,'YYYY'))
                                     = v_prev_year
         AND c.intrmdry_intm_no   = curr_prem.intm_no
         AND d.pol_flag IN ('1','2','3','4','X'))
    LOOP
       v_prev_prem  := prev_prem.prem_amt;
    END LOOP;
    --get current loss reserve
    FOR CURR_LOSS IN (
      SELECT SUM((NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss
        FROM GICL_CLM_RES_HIST a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date, v_curr2_date +365))
                      > TRUNC(v_curr2_date) ) b,
                  (SELECT claim_id, item_no, peril_cd,
                          SUM(losses_paid) losses_paid,
                          SUM(expenses_paid) exp_paid
                     FROM GICL_CLM_RES_HIST
                    WHERE 1 = 1
                      AND tran_id IS NOT NULL
                      AND NVL(cancel_tag,'N') = 'N'
                      AND TRUNC(date_paid) <= TRUNC(v_curr2_date)
                  GROUP BY claim_id, item_no, peril_cd ) c,
                  GICL_CLAIMS d,
                  GICL_INTM_ITMPERIL e
            WHERE 1 = 1
              AND d.line_cd = NVL(p_line_cd, d.line_cd)
              AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
              AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd) =
                  NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
              AND a.claim_id = d.claim_id
              AND a.claim_id = b.claim_id
              AND a.clm_res_hist_id = b.clm_res_hist_id
              AND b.claim_id = c.claim_id (+)
              AND b.item_no = c.item_no (+)
              AND b.peril_cd = c.peril_cd (+)
              AND d.claim_id = e.claim_id
              AND b.item_no  = e.item_no
              AND b.peril_cd = e.peril_cd
              AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
              AND e.intm_no  = curr_prem.intm_no
              AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                         FROM GICL_CLM_RES_HIST a2
                                        WHERE a2.claim_id =a.claim_id
                                          AND a2.item_no =a.item_no
                                          AND a2.peril_cd =a.peril_cd
                                          AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'fmMONTH')) ||' 01, '||
                                              TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'fmMONTH DD, YYYY')
                                              <= TRUNC(v_curr2_date)
                                          AND tran_id IS NULL)
              AND TRUNC(NVL(close_date, v_curr2_date +365)) > v_curr2_date)
    LOOP
      v_curr_loss  := curr_loss.loss;
    END LOOP;
    --get current expense reserve
    FOR CURR_EXP IN (
      SELECT SUM((NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) expense
        FROM GICL_CLM_RES_HIST a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date, v_curr2_date +365))
                      > TRUNC(v_curr2_date) ) b,
                  (SELECT claim_id, item_no, peril_cd,
                          SUM(losses_paid) losses_paid,
                          SUM(expenses_paid) exp_paid
                     FROM GICL_CLM_RES_HIST
                    WHERE 1 = 1
                      AND tran_id IS NOT NULL
                      AND NVL(cancel_tag,'N') = 'N'
                      AND TRUNC(date_paid) <= TRUNC(v_curr2_date)
                  GROUP BY claim_id, item_no, peril_cd ) c,
                  GICL_CLAIMS d,
                  GICL_INTM_ITMPERIL e
            WHERE 1 = 1
              AND d.line_cd = NVL(p_line_cd, d.line_cd)
              AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
              AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd) =
                  NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
              AND a.claim_id = d.claim_id
              AND a.claim_id = b.claim_id
              AND a.clm_res_hist_id = b.clm_res_hist_id
              AND b.claim_id = c.claim_id (+)
              AND b.item_no = c.item_no (+)
              AND b.peril_cd = c.peril_cd (+)
              AND d.claim_id = e.claim_id
              AND b.item_no  = e.item_no
              AND b.peril_cd = e.peril_cd
              AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
              AND e.intm_no  = curr_prem.intm_no
              AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                         FROM GICL_CLM_RES_HIST a2
                                        WHERE a2.claim_id =a.claim_id
                                          AND a2.item_no =a.item_no
                                          AND a2.peril_cd =a.peril_cd
                                          AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'fmMONTH')) ||' 01, '||
                                              TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'fmMONTH DD, YYYY')
                                              <= TRUNC(v_curr2_date)
                                          AND tran_id IS NULL)
              AND TRUNC(NVL(close_date, v_curr2_date +365)) > v_curr2_date)
    LOOP
      v_curr_exp  := curr_exp.expense;
    END LOOP;
    -- get previous loss reserve
    FOR PREV_LOSS IN (
       SELECT SUM((NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss
         FROM GICL_CLM_RES_HIST a,
              (SELECT b1.claim_id, b1.clm_res_hist_id,
                      b1.item_no, b1.peril_cd
                 FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
                 WHERE tran_id IS NULL
                   AND b2.claim_id = b1.claim_id
                   AND b2.item_no  = b1.item_no
                   AND b2.peril_cd = b1.peril_cd
                   AND TO_CHAR(NVL(b2.close_date, v_curr2_date + 365),'YYYY')
                       > v_prev_year) b,
                   (SELECT claim_id, item_no, peril_cd,
                           SUM(losses_paid) losses_paid,
                           SUM(expenses_paid) exp_paid
                      FROM GICL_CLM_RES_HIST
                     WHERE 1 = 1
                       AND tran_id IS NOT NULL
                       AND NVL(cancel_tag,'N') = 'N'
                       AND TRUNC(date_paid) <= v_prev_date
                   GROUP BY claim_id, item_no, peril_cd ) c,
                   GICL_CLAIMS d,
                   GICL_INTM_ITMPERIL e
             WHERE 1 = 1
               AND d.line_cd = NVL(p_line_cd,d.line_cd)
               AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
               AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd) =
                   NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
               AND a.claim_id = d.claim_id
               AND a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.claim_id = c.claim_id (+)
               AND b.item_no = c.item_no (+)
               AND b.peril_cd = c.peril_cd (+)
               AND d.claim_id = e.claim_id
               AND b.item_no  = e.item_no
               AND b.peril_cd = e.peril_cd
               AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
               AND e.intm_no  = curr_prem.intm_no
               AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                          FROM GICL_CLM_RES_HIST a2
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
    -- get previous expense reserve
    FOR PREV_EXP IN (
       SELECT SUM((NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) EXPENSE
         FROM GICL_CLM_RES_HIST a,
              (SELECT b1.claim_id, b1.clm_res_hist_id,
                      b1.item_no, b1.peril_cd
                 FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
                 WHERE tran_id IS NULL
                   AND b2.claim_id = b1.claim_id
                   AND b2.item_no  = b1.item_no
                   AND b2.peril_cd = b1.peril_cd
                   AND TO_CHAR(NVL(b2.close_date, v_curr2_date + 365),'YYYY')
                       > v_prev_year) b,
                   (SELECT claim_id, item_no, peril_cd,
                           SUM(losses_paid) losses_paid,
                           SUM(expenses_paid) exp_paid
                      FROM GICL_CLM_RES_HIST
                     WHERE 1 = 1
                       AND tran_id IS NOT NULL
                       AND NVL(cancel_tag,'N') = 'N'
                       AND TRUNC(date_paid) <= v_prev_date
                   GROUP BY claim_id, item_no, peril_cd ) c,
                   GICL_CLAIMS d,
                   GICL_INTM_ITMPERIL e
             WHERE 1 = 1
               AND d.line_cd = NVL(p_line_cd,d.line_cd)
               AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
               AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd) =
                   NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
               AND a.claim_id = d.claim_id
               AND a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.claim_id = c.claim_id (+)
               AND b.item_no = c.item_no (+)
               AND b.peril_cd = c.peril_cd (+)
               AND d.claim_id = e.claim_id
               AND b.item_no  = e.item_no
               AND b.peril_cd = e.peril_cd
               AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
               AND e.intm_no  = curr_prem.intm_no
               AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                          FROM GICL_CLM_RES_HIST a2
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
    -- get losses paid amount
    FOR PAID_LOSS IN
      (SELECT SUM((NVL(losses_paid,0)+ NVL(expenses_paid,0)) * (c.shr_intm_pct/100)) loss_paid
         FROM GICL_CLM_RES_HIST a, GICL_CLAIMS b,
              GICL_INTM_ITMPERIL c
        WHERE 1 = 1
         AND b.line_cd           = NVL(p_line_cd, b.line_cd)
         AND b.subline_cd        = NVL(p_subline_cd, b.subline_cd)
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd) =
             NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND a.claim_id          = b.claim_id
         AND tran_id IS NOT NULL
         AND NVL(cancel_tag,'N') = 'N'
         AND a.claim_id          = c.claim_id
         AND a.item_no           = c.item_no
         AND a.peril_cd          = c.peril_cd
         AND TRUNC(date_paid)   >= v_curr1_date
         AND TRUNC(date_paid)   <= v_curr2_date
         AND c.intm_no           = curr_prem.intm_no)
    LOOP
      v_paid_amt        := paid_loss.loss_paid;
    END LOOP;
    FOR prev_recovery IN(
      SELECT SUM(NVL(recovered_amt,0) * (NVL(c.premium_amt,0) / get_intm_prem(c.claim_id) ))recovered_amt
        FROM gicl_recovery_payt a,
             gicl_intm_itmperil c,
	     gicl_claims        b
       WHERE 1 = 1
         AND a.claim_id   = b.claim_id
         AND b.claim_id   = c.claim_id
	 AND c.intm_no    = p_intm_no
         AND b.line_cd    = NVL(p_line_cd, b.line_cd)
         AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd) =
             NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND NVL(a.cancel_tag,'N') = 'N'
         AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(v_prev_year))
    LOOP
      v_prev_recovery := prev_recovery.recovered_amt;
    END LOOP;
    FOR curr_recovery IN(
    SELECT SUM(NVL(recovered_amt,0) * (NVL(c.premium_amt,0) / get_intm_prem(c.claim_id) ))recovered_amt
        FROM gicl_recovery_payt a,
             gicl_intm_itmperil c,
	     gicl_claims        b
       WHERE 1 = 1
         AND a.claim_id   = b.claim_id
         AND b.claim_id   = c.claim_id
	 AND c.intm_no    = p_intm_no
         AND b.line_cd           = NVL(p_line_cd, b.line_cd)
         AND b.subline_cd        = NVL(p_subline_cd, b.subline_cd)
         AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd) =
             NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
         AND NVL(a.cancel_tag,'N') = 'N'
         AND TRUNC(tran_date) >= v_curr1_date
         AND TRUNC(tran_date)<= v_curr2_date)
    LOOP
      v_curr_recovery := curr_recovery.recovered_amt;
    END LOOP;
    --insert record in table gicl_loss_ratio_ext
    INSERT INTO GICL_LOSS_RATIO_EXT
           (session_id,    line_cd,	      subline_cd,
            iss_cd,        intm_no,       loss_ratio_date,
  	        curr_prem_amt, prev_prem_amt, loss_paid_amt,
  	        curr_loss_res, prev_loss_res, user_id)
    VALUES (p_session_id,       p_line_cd,          p_subline_cd,
            p_iss_cd,           curr_prem.intm_no,  p_loss_date,
            NVL(v_curr_prem,0), NVL(v_prev_prem,0), NVL(v_paid_amt,0),
            NVL(v_curr_loss,0) + NVL(v_curr_exp,0) - NVL(v_curr_recovery,0),
            NVL(v_prev_loss,0) + NVL(v_prev_exp,0) - NVL(v_prev_recovery,0),  USER);
  END LOOP;
  COMMIT;
END;
/



DROP FUNCTION CPI.GET_CURR_RES_RATIO;

CREATE OR REPLACE FUNCTION CPI.get_curr_res_ratio(p_loss_date DATE,
	    		   					p_line_cd VARCHAR2,
									p_subline_cd VARCHAR2,
									p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_curr_loss_res  NUMBER;

BEGIN
  FOR curr IN (
  SELECT SUM(NVL(curr_loss,0)) + SUM(NVL(curr_exp,0)) - SUM(NVL(curr_recov,0)) curr_loss_res
    FROM (
    SELECT NVL(SUM(NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)),0) curr_loss,
		   0 curr_exp,
		   0 curr_recov
      FROM gicl_clm_res_hist a,
           (SELECT b1.claim_id,
	   		       b1.clm_res_hist_id,
                   b1.item_no,
			   	   b1.peril_cd
              FROM gicl_clm_res_hist b1 ,
		  	   	   gicl_item_peril b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
               AND b2.item_no  = b1.item_no
               AND b2.peril_cd = b1.peril_cd
		       AND b2.claim_id > 0
               AND TRUNC(NVL(b2.close_date, p_loss_date + 365))
                   > p_loss_date) b,
           (SELECT claim_id,
	   	 	   	   item_no,
			   	   peril_cd,
               	   SUM(losses_paid) losses_paid,
               	   SUM(expenses_paid) exp_paid
              FROM gicl_clm_res_hist a
             WHERE 1 = 1
               AND tran_id IS NOT NULL
           	   AND NVL(cancel_tag,'N') = 'N'
           	   AND TRUNC(date_paid) <= p_loss_date
		   	   AND claim_id> 0
             GROUP BY claim_id,
		 	   	   item_no,
			   	   peril_cd) c,
           gicl_claims d
     WHERE 1 = 1
       AND d.line_cd = p_line_cd
   	   AND d.subline_cd = p_subline_cd
   	   AND d.iss_cd = p_iss_cd
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
                                       <= p_loss_date
                                   AND tran_id IS NULL)
       AND TRUNC(NVL(close_date, p_loss_date +365)) > p_loss_date
    UNION
    --CURR EXP_RES
	SELECT 0 curr_loss,
		   NVL(SUM(NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)),0) curr_exp,
		   0 curr_recov
      FROM gicl_clm_res_hist a,
           (SELECT b1.claim_id,
	   		       b1.clm_res_hist_id,
               	   b1.item_no,
			   	   b1.peril_cd
              FROM gicl_clm_res_hist b1 ,
		  	   	   gicl_item_peril b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
           	   AND b2.item_no  = b1.item_no
           	   AND b2.peril_cd = b1.peril_cd
           	   AND TRUNC(NVL(b2.close_date, p_loss_date +365))
               	   > p_loss_date) b,
          (SELECT claim_id,
	   		   item_no,
			   peril_cd,
               SUM(losses_paid) losses_paid,
               SUM(expenses_paid) exp_paid
          FROM gicl_clm_res_hist
         WHERE 1 = 1
           AND tran_id IS NOT NULL
           AND NVL(cancel_tag,'N') = 'N'
           AND TRUNC(date_paid) <= p_loss_date
         GROUP BY claim_id, item_no, peril_cd ) c,
               gicl_claims d
     WHERE 1 = 1
       AND d.line_cd = p_line_cd
       AND d.subline_cd = p_subline_cd
   	   AND d.iss_cd = p_iss_cd
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
                                   	   <= p_loss_date
                                   AND tran_id IS NULL)
       AND TRUNC(NVL(close_date, p_loss_date +365)) > p_loss_date
    UNION
    SELECT 0 curr_loss,
		   0 curr_exp,
		   NVL(SUM(recovered_amt),0) curr_recov
      FROM gicl_recovery_payt a,
  	   	   gicl_claims b
     WHERE 1 = 1
       AND b.line_cd = p_line_cd
   	   AND b.subline_cd = p_subline_cd
   	   AND b.iss_cd= p_iss_cd
   	   AND a.claim_id = b.claim_id
   	   AND NVL(cancel_tag,'N') = 'N'
   	   AND TRUNC(tran_date) >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
   	   AND TRUNC(tran_date)<= p_loss_date))
  LOOP
    v_curr_loss_res := curr.curr_loss_res;
  END LOOP;

  RETURN (v_curr_loss_res);

END;
/



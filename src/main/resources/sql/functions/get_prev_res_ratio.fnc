DROP FUNCTION CPI.GET_PREV_RES_RATIO;

CREATE OR REPLACE FUNCTION CPI.get_prev_res_ratio(p_loss_date DATE,
	    		   					p_line_cd VARCHAR2,
									p_subline_cd VARCHAR2,
									p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_prev_loss_res  NUMBER;

BEGIN
  FOR prev IN (
    SELECT SUM(NVL(prev_loss,0)) + SUM(NVL(prev_exp,0)) - SUM(NVL(prev_recov,0)) prev_loss_res
    FROM (SELECT NVL(SUM(NVL(a.loss_reserve,0) - NVL(c.losses_paid,0)),0) prev_loss,
		 		 0 prev_exp,
				 0 prev_recov
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
                   	 AND TO_CHAR(NVL(b2.close_date, TRUNC(p_loss_date) + 365),'YYYY')
                       > TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)) b,
                 (SELECT claim_id,
				 		 item_no,
						 peril_cd,
                         SUM(losses_paid) losses_paid,
                         SUM(expenses_paid) exp_paid
                    FROM gicl_clm_res_hist
                   WHERE 1 = 1
                     AND tran_id IS NOT NULL
                     AND NVL(cancel_tag,'N') = 'N'
                     AND TRUNC(date_paid) <= TO_DATE('12-31-'||TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1),'MM-DD-YYYY')
                   GROUP BY claim_id,
				   		 item_no,
						 peril_cd ) c,
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
                                         AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                             <= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1))
                                         AND tran_id IS NULL)
             AND TO_CHAR(NVL(d.close_date, TRUNC(p_loss_date) + 365),'YYYY')
                 > TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)
    UNION
    --prev EXP_RES
	SELECT 0 prev_loss,
		   NVL(SUM(NVL(a.expense_reserve,0) - NVL(c.exp_paid,0)),0) prev_exp,
		   0 prev_recov
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
           	   AND TO_CHAR(NVL(b2.close_date, TRUNC(p_loss_date) + 365),'YYYY')
                       > TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)) b,
           (SELECT claim_id,
	   		   	   item_no,
			   	   peril_cd,
               	   SUM(losses_paid) losses_paid,
               	   SUM(expenses_paid) exp_paid
              FROM gicl_clm_res_hist
             WHERE 1 = 1
               AND tran_id IS NOT NULL
           	   AND NVL(cancel_tag,'N') = 'N'
           	   AND TRUNC(date_paid) <= TO_DATE('12-31-'||TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1),'MM-DD-YYYY')
             GROUP BY claim_id,
			 	   item_no,
				   peril_cd ) c,
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
                               	   AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                       <= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1))
                                   AND tran_id IS NULL)
       AND TO_CHAR(NVL(d.close_date, TRUNC(p_loss_date) + 365),'YYYY')
                 > TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)
    UNION
    SELECT 0 prev_loss,
		   0 prev_exp,
		   NVL(SUM(recovered_amt),0) prev_recov
      FROM gicl_recovery_payt a,
  	   	   gicl_claims b
     WHERE 1 = 1
       AND b.line_cd = p_line_cd
   	   AND b.subline_cd = p_subline_cd
   	   AND b.iss_cd= p_iss_cd
   	   AND a.claim_id = b.claim_id
   	   AND NVL(cancel_tag,'N') = 'N'
   	   AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1))))
  LOOP
    v_prev_loss_res := prev.prev_loss_res;
  END LOOP;

  RETURN (v_prev_loss_res);

END;
/



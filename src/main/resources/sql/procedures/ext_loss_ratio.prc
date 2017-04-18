DROP PROCEDURE CPI.EXT_LOSS_RATIO;

CREATE OR REPLACE PROCEDURE CPI.Ext_Loss_Ratio IS

/** Created by : Lhen Valderrama
    Date Created/Modified: 09/16/03
	This procedure will extract data for the Loss Ratio table (eim_loss_rat) per Line,
	per subline and per branch to be use for the GenIISys Dashboard.
	This procedure is based on Acct_ent_date only.
**/

v_prod_date		 DATE;
v_prod_prem		 NUMBER(20,2);
v_curr_prem		 NUMBER(20,2);
v_prev_prem		 NUMBER(20,2);
v_curr_loss_res	 NUMBER(20,2);
v_prev_loss_res	 NUMBER(20,2);
v_loss_paid		 NUMBER(20,2);
v_line			 VARCHAR2(2);
v_subline		 VARCHAR2(7);
v_branch		 VARCHAR2(2);

BEGIN

DELETE eim_loss_rat
 WHERE user_id = USER;

FOR prod IN (
  --for production data as parameters to below 'for-loop' to get following amounts
  SELECT prod_date,
	     SUM(NVL(prod_prem,0)) prod_prem,
		 line,
		 subline,
		 branch
    FROM (SELECT TRUNC(a.acct_ent_date) prod_date,
                 SUM(ROUND(c.premium_amt*d.currency_rt,2)) prod_prem,
	   			 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
       			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f
           WHERE 1 = 1
             AND e.line_cd     = f.line_cd
             AND f.line_cd     = a.line_cd(+)
             AND f.subline_cd  = a.subline_cd(+)
             AND a.par_id      = b.par_id
             AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id+0
  			 AND c.iss_cd      = d.iss_cd
   			 AND c.prem_seq_no = d.prem_seq_no
   			 AND a.policy_id > -1
   			 AND b.par_id > -1
   			 AND NVL(e.sc_tag,'N') <> 'Y'
   			 AND NVL(f.op_flag, 'N') <> 'Y'
   			 AND e.line_cd > '%'
   			 AND c.iss_cd > '%'
   			 AND c.prem_seq_no > -10
  			 AND a.acct_ent_date IS NOT NULL
           GROUP BY TRUNC(a.acct_ent_date),
 	   	   		 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd
          UNION
		  SELECT TRUNC(a.spld_acct_ent_date) prod_date,
       	  		 SUM(ROUND(c.premium_amt*d.currency_rt,2) * -1) prod_prem,
	   			 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
       			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f
           WHERE 1 = 1
             AND f.line_cd     = e.line_cd
   			 AND f.line_cd     = a.line_cd(+)
  			 AND f.subline_cd  = a.subline_cd(+)
   			 AND a.par_id      = b.par_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id+0
   			 AND c.iss_cd      = d.iss_cd
   			 AND c.prem_seq_no = d.prem_seq_no
   			 AND a.policy_id > -1
   			 AND b.par_id > -1
   			 AND NVL(e.sc_tag,'N') <> 'Y'
   			 AND NVL(f.op_flag, 'N') <> 'Y'
   			 AND e.line_cd > '%'
   			 AND c.iss_cd > '%'
   			 AND c.prem_seq_no > -10
  			 AND a.spld_acct_ent_date IS NOT NULL
           GROUP BY TRUNC(a.spld_acct_ent_date),
  	  	    	 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd)
   GROUP BY prod_date,
   		 line,
		 subline,
		 branch)

LOOP

v_prod_date := prod.prod_date;
v_prod_prem	:= prod.prod_prem;
v_line		:= prod.line;
v_subline	:= prod.subline;
v_branch	:= prod.branch;

--for current prem
  FOR curr IN (
    SELECT SUM(NVL(curr_prem,0)) curr_prem
	  FROM (
        SELECT NVL(SUM(c.prem_amt),0) curr_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = v_line
           AND d.subline_cd = v_subline
           AND d.iss_cd = v_branch
           AND d.acct_ent_date >= TO_DATE ('01-01-'||TO_CHAR(v_prod_date, 'YYYY'),'MM-DD-YYYY')
           AND d.acct_ent_date <= v_prod_date
        UNION
		SELECT (NVL(SUM(c.prem_amt),0) *-1) curr_prem
          FROM gipi_polbasic d,
       	  	   gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = v_line
           AND d.subline_cd = v_subline
           AND d.iss_cd = v_branch
           AND TRUNC(d.spld_acct_ent_date) >= TO_DATE ('01-01-'||TO_CHAR(v_prod_date, 'YYYY'),'MM-DD-YYYY')
           AND TRUNC(d.spld_acct_ent_date) <= v_prod_date))
  LOOP
    v_curr_prem := curr.curr_prem;
  END LOOP;

--for previous prem
  FOR prev IN (
    SELECT SUM(NVL(prev_prem,0)) prev_prem
	  FROM (
        SELECT NVL(SUM(c.prem_amt),0) prev_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = v_line
           AND d.subline_cd = v_subline
           AND d.iss_cd = v_branch
           AND TO_CHAR(d.acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)
        UNION
	    SELECT NVL(SUM(c.prem_amt),0)* -1 prev_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = v_line
           AND d.subline_cd = v_subline
           AND d.iss_cd = v_branch
           AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)))
  LOOP
    v_prev_prem := prev.prev_prem;
  END LOOP;

--for current reserve_amt
  FOR curr IN (
  SELECT SUM(NVL(curr_loss,0)) + SUM(NVL(curr_exp,0)) - SUM(NVL(curr_recov,0)) curr_loss_res
    FROM (
	--for current loss_amt
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
               AND TRUNC(NVL(b2.close_date, v_prod_date + 365))
                   > v_prod_date) b,
           (SELECT claim_id,
	   	 	   	   item_no,
			   	   peril_cd,
               	   SUM(losses_paid) losses_paid,
               	   SUM(expenses_paid) exp_paid
              FROM gicl_clm_res_hist a
             WHERE 1 = 1
               AND tran_id IS NOT NULL
           	   AND NVL(cancel_tag,'N') = 'N'
           	   AND TRUNC(date_paid) <= v_prod_date
		   	   AND claim_id> 0
             GROUP BY claim_id,
		 	   	   item_no,
			   	   peril_cd) c,
           gicl_claims d
     WHERE 1 = 1
       AND d.line_cd = v_line
   	   AND d.subline_cd = v_subline
   	   AND d.iss_cd = v_branch
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
                                       <= v_prod_date
                                   AND tran_id IS NULL)
       AND TRUNC(NVL(close_date, v_prod_date +365)) > v_prod_date
    UNION
    --cuurent expense_amt
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
           	   AND TRUNC(NVL(b2.close_date, v_prod_date +365))
               	   > v_prod_date) b,
          (SELECT claim_id,
	   		   	  item_no,
			   	  peril_cd,
               	  SUM(losses_paid) losses_paid,
               	  SUM(expenses_paid) exp_paid
             FROM gicl_clm_res_hist
            WHERE 1 = 1
              AND tran_id IS NOT NULL
              AND NVL(cancel_tag,'N') = 'N'
              AND TRUNC(date_paid) <= v_prod_date
            GROUP BY claim_id, item_no, peril_cd ) c,
           gicl_claims d
     WHERE 1 = 1
       AND d.line_cd = v_line
       AND d.subline_cd = v_subline
   	   AND d.iss_cd = v_branch
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
                                   	   <= v_prod_date
                                   AND tran_id IS NULL)
       AND TRUNC(NVL(close_date, v_prod_date +365)) > v_prod_date
    UNION
	--current recoveries_amt
    SELECT 0 curr_loss,
		   0 curr_exp,
		   NVL(SUM(recovered_amt),0) curr_recov
      FROM gicl_recovery_payt a,
  	   	   gicl_claims b
     WHERE 1 = 1
       AND b.line_cd = v_line
   	   AND b.subline_cd = v_subline
   	   AND b.iss_cd= v_branch
   	   AND a.claim_id = b.claim_id
   	   AND NVL(cancel_tag,'N') = 'N'
   	   AND TRUNC(tran_date) >= TO_DATE ('01-01-'||TO_CHAR(v_prod_date, 'YYYY'),'MM-DD-YYYY')
   	   AND TRUNC(tran_date)<= v_prod_date))
  LOOP
    v_curr_loss_res := curr.curr_loss_res;
  END LOOP;

--for previous reserve_amt
  FOR prev IN (
  --for previous loss_amt
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
                   	 AND TO_CHAR(NVL(b2.close_date, v_prod_date + 365),'YYYY')
                       > TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)) b,
                 (SELECT claim_id,
				 		 item_no,
						 peril_cd,
                         SUM(losses_paid) losses_paid,
                         SUM(expenses_paid) exp_paid
                    FROM gicl_clm_res_hist
                   WHERE 1 = 1
                     AND tran_id IS NOT NULL
                     AND NVL(cancel_tag,'N') = 'N'
                     AND TRUNC(date_paid) <= TO_DATE('12-31-'||TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1),'MM-DD-YYYY')
                   GROUP BY claim_id,
				   		 item_no,
						 peril_cd ) c,
                 gicl_claims d
           WHERE 1 = 1
             AND d.line_cd = v_line
             AND d.subline_cd = v_subline
             AND d.iss_cd = v_branch
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
                                             <= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1))
                                         AND tran_id IS NULL)
             AND TO_CHAR(NVL(d.close_date, v_prod_date + 365),'YYYY')
                 > TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)
    UNION
    --previous expense_amt
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
           	   AND TO_CHAR(NVL(b2.close_date, v_prod_date + 365),'YYYY')
                       > TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)) b,
           (SELECT claim_id,
	   		   	   item_no,
			   	   peril_cd,
               	   SUM(losses_paid) losses_paid,
               	   SUM(expenses_paid) exp_paid
              FROM gicl_clm_res_hist
             WHERE 1 = 1
               AND tran_id IS NOT NULL
           	   AND NVL(cancel_tag,'N') = 'N'
           	   AND TRUNC(date_paid) <= TO_DATE('12-31-'||TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1),'MM-DD-YYYY')
             GROUP BY claim_id,
			 	   item_no,
				   peril_cd ) c,
           gicl_claims d
     WHERE 1 = 1
       AND d.line_cd = v_line
       AND d.subline_cd = v_subline
   	   AND d.iss_cd = v_branch
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
                                       <= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1))
                                   AND tran_id IS NULL)
       AND TO_CHAR(NVL(d.close_date, v_prod_date + 365),'YYYY')
                 > TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1)
    UNION
	--for previous recoveries
    SELECT 0 prev_loss,
		   0 prev_exp,
		   NVL(SUM(recovered_amt),0) prev_recov
      FROM gicl_recovery_payt a,
  	   	   gicl_claims b
     WHERE 1 = 1
       AND b.line_cd = v_line
   	   AND b.subline_cd = v_subline
   	   AND b.iss_cd= v_branch
   	   AND a.claim_id = b.claim_id
   	   AND NVL(cancel_tag,'N') = 'N'
   	   AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(TO_CHAR(TO_NUMBER(TO_CHAR(v_prod_date, 'YYYY')) - 1))))
  LOOP
    v_prev_loss_res := prev.prev_loss_res;
  END LOOP;

--for losses paid
  FOR paid IN (
  SELECT NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
     FROM gicl_clm_res_hist a,
	 	  gicl_claims b
    WHERE 1 = 1
      AND b.line_cd = v_line
      AND b.subline_cd = v_subline
      AND b.iss_cd = v_branch
      AND a.claim_id = b.claim_id
      AND tran_id IS NOT NULL
      AND NVL(cancel_tag,'N') = 'N'
      AND TRUNC(date_paid) >= TO_DATE('01-01-'||TO_CHAR(v_prod_date, 'YYYY'),'MM-DD-YYYY')
      AND TRUNC(date_paid) <= v_prod_date)
  LOOP
    v_loss_paid := paid.loss_paid;
  END LOOP;

  INSERT INTO eim_loss_rat
  	 (acct_loss_date,	line_cd,
	  subline_cd,		branch_cd,
	  curr_prem, 	    prod_prem,
	  prev_prem, 	    curr_loss_res,
	  prev_loss_res,	loss_paid,
	  prem_earned,		loss_incurred,
	  line_name,		subline_name,
	  branch_name,      extraction_date,
	  user_id)
  VALUES
     (v_prod_date,		       v_line,
	  v_subline,			   v_branch,
	  v_curr_prem, 	    	   v_prod_prem,
	  v_prev_prem, 	    	   v_curr_loss_res,
	  v_prev_loss_res,	       v_loss_paid,
	  v_curr_prem + (v_prev_prem*.4 - v_curr_prem*.4),
	  v_loss_paid + (v_curr_loss_res - v_prev_loss_res),
	  Get_Line_Name(v_line),   Get_Subline_Name(v_subline),
	  Get_Iss_Name(v_branch),  TRUNC(SYSDATE),
	  NULL);

END LOOP;
COMMIT;
END;
/

DROP PROCEDURE CPI.EXT_LOSS_RATIO;

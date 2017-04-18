DROP FUNCTION CPI.GET_LOSS_PAID;

CREATE OR REPLACE FUNCTION CPI.get_loss_paid(p_loss_date DATE,
	    		   					     p_line_cd VARCHAR2,
									     p_subline_cd VARCHAR2,
									     p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_loss_paid  NUMBER;

BEGIN

  FOR paid IN (
  SELECT NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
     FROM gicl_clm_res_hist a,
	 	  gicl_claims b
    WHERE 1 = 1
      AND b.line_cd = p_line_cd
      AND b.subline_cd = p_subline_cd
      AND b.iss_cd = p_iss_cd
      AND a.claim_id = b.claim_id
      AND tran_id IS NOT NULL
      AND NVL(cancel_tag,'N') = 'N'
      AND TRUNC(date_paid) >= TO_DATE('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
      AND TRUNC(date_paid) <= TRUNC(p_loss_date))
  LOOP
    v_loss_paid := paid.loss_paid;
  END LOOP;

  RETURN (v_loss_paid);

END;
/



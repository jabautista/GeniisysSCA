DROP FUNCTION CPI.GET_CURR_PREM;

CREATE OR REPLACE FUNCTION CPI.get_curr_prem(p_loss_date DATE,
	    		   					     p_line_cd VARCHAR2,
									     p_subline_cd VARCHAR2,
									     p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_curr_prem  NUMBER;

BEGIN

  FOR curr IN (
    SELECT SUM(NVL(curr_prem,0)) curr_prem
	  FROM (
        SELECT NVL(SUM(c.prem_amt),0) curr_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND d.acct_ent_date >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
           AND d.acct_ent_date <= TRUNC(p_loss_date)
        UNION
		SELECT (NVL(SUM(c.prem_amt),0) *-1) curr_prem
          FROM gipi_polbasic d,
       	  	   gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND TRUNC(d.spld_acct_ent_date) >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
           AND TRUNC(d.spld_acct_ent_date) <= TRUNC(p_loss_date)))
  LOOP
    v_curr_prem := curr.curr_prem;
  END LOOP;

  RETURN (v_curr_prem);

END;
/



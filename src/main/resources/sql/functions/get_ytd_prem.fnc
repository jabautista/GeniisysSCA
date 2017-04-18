DROP FUNCTION CPI.GET_YTD_PREM;

CREATE OR REPLACE FUNCTION CPI.get_ytd_prem(p_loss_date DATE,
	    		   					     p_line_cd VARCHAR2,
									     p_subline_cd VARCHAR2,
									     p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_ytd_prem  NUMBER;

BEGIN

  FOR ytd IN (
    SELECT SUM(NVL(ytd_prem,0)) ytd_prem
	  FROM (
        SELECT NVL(SUM(c.prem_amt),0) ytd_prem
          FROM gipi_polbasic d,
               gipi_itmperil c,
			   gipi_comm_invoice b,
			   gipi_parlist a
         WHERE 1=1
		   AND d.policy_id = c.policy_id
		   AND d.policy_id = b.policy_id
		   AND d.par_id = a.par_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND d.acct_ent_date >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
           AND d.acct_ent_date <= p_loss_date
        UNION
		SELECT (NVL(SUM(c.prem_amt),0) *-1) ytd_prem
          FROM gipi_polbasic d,
       	  	   gipi_itmperil c,
			   gipi_comm_invoice b,
			   gipi_parlist a
         WHERE 1=1
		   AND d.policy_id = c.policy_id
		   AND d.policy_id = b.policy_id
		   AND d.par_id = a.par_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND TRUNC(d.spld_acct_ent_date) >= TO_DATE ('01-01-'||TO_CHAR(p_loss_date, 'YYYY'),'MM-DD-YYYY')
           AND TRUNC(d.spld_acct_ent_date) <= p_loss_date))
  LOOP
    v_ytd_prem := ytd.ytd_prem;
  END LOOP;

  RETURN (v_ytd_prem);

END;
/



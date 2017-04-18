DROP FUNCTION CPI.GET_PREV_PREM;

CREATE OR REPLACE FUNCTION CPI.get_prev_prem(p_loss_date DATE,
	    		   					     p_line_cd VARCHAR2,
									     p_subline_cd VARCHAR2,
									     p_iss_cd VARCHAR2)
RETURN NUMBER AS
  v_prev_prem  NUMBER;

BEGIN

  FOR prev IN (
    SELECT SUM(NVL(prev_prem,0)) prev_prem
	  FROM (
        SELECT NVL(SUM(c.prem_amt),0) prev_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND TO_CHAR(d.acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)
        UNION
	    SELECT NVL(SUM(c.prem_amt),0)* -1 prev_prem
          FROM gipi_polbasic d,
               gipi_itmperil c
         WHERE d.policy_id = c.policy_id
           AND d.line_cd = p_line_cd
           AND d.subline_cd = p_subline_cd
           AND d.iss_cd = p_iss_cd
           AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)))
  LOOP
    v_prev_prem := prev.prev_prem  * .4;
  END LOOP;

  RETURN (v_prev_prem);

END;
/



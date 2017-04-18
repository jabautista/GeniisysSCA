DROP FUNCTION CPI.GET_PROD_PREV2;

CREATE OR REPLACE FUNCTION CPI.get_prod_prev2(p_loss_date DATE,
	    		   					     p_line_cd 	 VARCHAR2,
									     p_intm_no   NUMBER)
RETURN NUMBER AS
  v_prod_prev  NUMBER;

BEGIN

  FOR prev IN (
    SELECT SUM(NVL(prem,0)) prev_prem
	  FROM (
      SELECT SUM(ROUND(c.premium_amt*d.currency_rt,2)) prem
       	FROM gipi_parlist b,
       	 	 gipi_polbasic a,
       	 	 gipi_comm_invoice c,
       	 	 gipi_invoice d,
       	 	 giis_line e,
       	 	 giis_subline f
       WHERE 1 = 1
         AND e.line_cd     =a.line_cd
   	 	 AND e.line_cd     = f.line_cd
   	 	 AND f.subline_cd  = a.subline_cd
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
		 AND a.line_cd = p_line_cd
		 AND c.intrmdry_intm_no = p_intm_no
		 AND TO_CHAR(a.acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)
        UNION
	    SELECT SUM(ROUND(c.premium_amt*d.currency_rt,2)*-1) prem
       	  FROM gipi_parlist b,
       	 	   gipi_polbasic a,
       	 	   gipi_comm_invoice c,
       	 	   gipi_invoice d,
       	 	   giis_line e,
       	 	   giis_subline f
         WHERE 1 = 1
           AND e.line_cd     =a.line_cd
   	 	   AND e.line_cd     = f.line_cd
   	 	   AND f.subline_cd  = a.subline_cd
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
		   AND a.line_cd = p_line_cd
		   AND c.intrmdry_intm_no = p_intm_no
		   AND TO_CHAR(a.spld_acct_ent_date,'YYYY') = TO_CHAR(TO_NUMBER(TO_CHAR(p_loss_date, 'YYYY')) - 1)))
  LOOP
    v_prod_prev := prev.prev_prem;
  END LOOP;

  RETURN (v_prod_prev);

END;
/



DROP FUNCTION CPI.GET_UNRENEWED_TSI_AMT;

CREATE OR REPLACE FUNCTION CPI.get_unrenewed_tsi_amt (p_line_cd VARCHAR2,
                                                   p_subline_cd VARCHAR2,
												   p_iss_cd VARCHAR2,
												   p_issue_yy NUMBER,
												   p_pol_seq_no NUMBER,
												   p_renew_no NUMBER,
												   p_renewals_nop NUMBER,
												   p_renewable_nop NUMBER,
												   p_late_nop NUMBER)
RETURN NUMBER AS

CURSOR c1 (p_line_cd VARCHAR2,
            p_subline_cd VARCHAR2,
			p_iss_cd VARCHAR2,
			p_issue_yy NUMBER,
			p_pol_seq_no NUMBER,
			p_renew_no NUMBER) IS

        SELECT SUM(ROUND(a.tsi_amt*d.currency_rt,2)) tsi
		FROM gipi_polbasic a,
			 gipi_comm_invoice c,
			 gipi_invoice d
		WHERE 1 = 1
		  AND a.line_cd = p_line_cd
		  AND a.subline_cd = p_subline_cd
		  AND a.iss_cd = p_iss_cd
		  AND a.issue_yy = p_issue_yy
		  AND a.pol_seq_no = p_pol_seq_no
		  AND a.renew_no = p_renew_no
		  AND a.policy_id   = c.policy_id
		  AND a.policy_id   = c.policy_id
		  AND a.policy_id   = c.policy_id+0
		  AND c.iss_cd      = d.iss_cd
		  AND c.prem_seq_no = d.prem_seq_no
		  AND NVL(a.endt_type, 'A') = 'A';

  p_unrenewed_tsi NUMBER;

 BEGIN
   OPEN c1 (p_line_cd, p_subline_cd, p_iss_cd,
            p_issue_yy, p_pol_seq_no, p_renew_no);
   FETCH c1 INTO p_unrenewed_tsi;
   CLOSE c1;
   IF (p_renewable_nop <> 0 AND (p_renewals_nop <> 0 OR p_late_nop <> 0)) THEN
    BEGIN
	  p_unrenewed_tsi := 0;
	  RETURN p_unrenewed_tsi;
	END;
   ELSIF (p_renewable_nop = 0) THEN
    BEGIN
	  p_unrenewed_tsi := 0;
	  RETURN p_unrenewed_tsi;
	END;
   ELSE
     RETURN p_unrenewed_tsi;
   END IF;
 END;
/



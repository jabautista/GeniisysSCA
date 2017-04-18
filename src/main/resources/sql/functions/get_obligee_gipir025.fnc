DROP FUNCTION CPI.GET_OBLIGEE_GIPIR025;

CREATE OR REPLACE FUNCTION CPI.GET_OBLIGEE_GIPIR025 (
    p_policy_id     GIPI_POLBASIC.policy_id%TYPE
) RETURN VARCHAR2 IS
v_obligee       VARCHAR2(200);
BEGIN
    FOR POL IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                  FROM GIPI_POLBASIC
                 WHERE POLICY_id = p_policy_id)
       LOOP
                     
       FOR Y IN( SELECT b.obligee_no ob_no, c.obligee_name ob_name
                     FROM GIPI_POLBASIC a, gipi_bond_basic b, giis_obligee c
                    WHERE a.line_cd = pol.line_cd
                      AND a.subline_cd = pol.subline_cd
                      AND a.iss_cd = pol.iss_cd
                      AND a.issue_yy = pol.issue_yy
                      AND a.pol_seq_no = pol.pol_seq_no
                      AND a.renew_no = pol.renew_no
                      AND a.policy_id = b.policy_id
                      AND b.obligee_no = c.obligee_no
                     -- AND b.obligee_no IS NOT NULL
                    ORDER BY eff_date DESC)
           LOOP   
           v_obligee := Y.ob_name;
		   END LOOP;   
END LOOP;
	 RETURN(v_obligee);
END GET_OBLIGEE_GIPIR025;
/



DROP FUNCTION CPI.CHECK_PAID_POLICY;

CREATE OR REPLACE FUNCTION CPI.check_paid_policy(
    p_line_cd           gipi_wpolbas.line_cd%TYPE,
    p_subline_cd        gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd            gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy          gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no        gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no          gipi_wpolbas.renew_no%TYPE
) RETURN VARCHAR2

IS
    v_message           VARCHAR2(100);
BEGIN
    FOR a IN (SELECT SUM(c.total_payments) paid_amt
                FROM gipi_polbasic a, gipi_invoice b, giac_aging_soa_details c
               WHERE a.line_cd      = p_line_cd
                 AND a.subline_cd   = p_subline_cd
                 AND a.iss_cd       = p_iss_cd
                 AND a.issue_yy     = p_issue_yy
                 AND a.pol_seq_no   = p_pol_seq_no
                 AND a.renew_no     = p_renew_no
                 AND a.pol_flag IN ('1', '2', '3', 'X')
                 AND a.policy_id = b.policy_id
                 AND b.iss_cd = c.iss_cd
                 AND b.prem_seq_no = c.prem_seq_no)
    LOOP
        --IF a.paid_amt IS NULL OR a.paid_amt = 0 THEN
        IF a.paid_amt <> 0 THEN
            v_message := 'N';
        ELSE
            v_message := 'Y';
        END IF;
    END LOOP;
    RETURN (v_message);
END;
/



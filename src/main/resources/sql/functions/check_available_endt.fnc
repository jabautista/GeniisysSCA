DROP FUNCTION CPI.CHECK_AVAILABLE_ENDT;

CREATE OR REPLACE FUNCTION CPI.check_available_endt(
    p_line_cd               gipi_wpolbas.line_cd%TYPE,
    p_subline_cd            gipi_wpolbas.subline_cd%TYPE,
    p_iss_cd                gipi_wpolbas.iss_cd%TYPE,
    p_issue_yy              gipi_wpolbas.issue_yy%TYPE,
    p_pol_seq_no            gipi_wpolbas.pol_seq_no%TYPE,
    p_renew_no              gipi_wpolbas.renew_no%TYPE
) RETURN NUMBER

IS
    v_exist            NUMBER(2);
BEGIN
    FOR A IN (SELECT  DISTINCT '1'
                                                  FROM     GIPI_POLBASIC a, GIPI_ITMPERIL b
                                                 WHERE a.policy_id = b.policy_id
                                                   AND a.line_cd = b.line_cd
                                                   AND (NVL (b.tsi_amt, 0) <> 0 OR NVL (b.prem_amt, 0) <> 0)      
                                                   AND NOT EXISTS (SELECT '1'
                                                                              FROM GIAC_DIRECT_PREM_COLLNS y, GIPI_INVOICE z
                                                                    WHERE     y.b140_iss_cd = z.iss_cd
                                                                      AND y.b140_prem_seq_no = z.prem_seq_no
                                                                      AND z.policy_id = a.policy_id)    
                                                   AND a.pol_flag IN ('1', '2', '3')
                                                   AND NVL(a.endt_seq_no,0) > 0 
                                                   AND a.endt_type = 'A'
                                                   AND a.line_cd = p_line_cd
                                                   AND a.subline_cd = p_subline_cd
                                                   AND a.iss_cd = p_iss_cd
                                                   AND a.issue_yy = p_issue_yy
                                                   AND a.pol_seq_no = p_pol_seq_no
                                                   AND a.renew_no = p_renew_no
   												AND a.cancelled_endt_id IS NULL
   												AND NOT EXISTS (
   															SELECT 	'1'
   	   	   											FROM 		gipi_polbasic
		   													WHERE 	a.policy_id = cancelled_endt_id
		   													AND pol_flag IN ('1', '2', '3'))--vj 020909
		   							-- mark jm 01.27.09 modified the query above to check for available endorsement ends here
		   							)
    LOOP
        v_exist := 1;
        EXIT;
    END LOOP;
    IF v_exist IS NULL THEN
        v_exist := 0;
    END IF;
    RETURN (v_exist);
END;
/



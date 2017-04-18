DROP FUNCTION CPI.CHECK_GEN_RN_NO_GIEXS006;

CREATE OR REPLACE FUNCTION CPI.check_gen_rn_no_giexs006
	( p_line_cd  gipi_polbasic.line_cd%TYPE,
	 p_subline_cd gipi_polbasic.subline_cd%TYPE,
	 p_iss_cd  gipi_polbasic.iss_cd%TYPE,
	 p_intm_no  giex_expiry.intm_no%TYPE,
	 p_line_cd2  gipi_polbasic.line_cd%TYPE,
	 p_subline_cd2 gipi_polbasic.subline_cd%TYPE,
	 p_iss_cd2  gipi_polbasic.iss_cd%TYPE,
	 p_issue_yy  gipi_polbasic.issue_yy%TYPE,
	 p_pol_seq_no gipi_polbasic.pol_seq_no%TYPE,
	 p_renew_no  gipi_polbasic.renew_no%TYPE,
	 p_fr_date  DATE,
	 p_to_date  DATE )
RETURN NUMBER
IS
	v_count NUMBER;
BEGIN
	SELECT COUNT(a.policy_id)
      INTO v_count
	  FROM giex_expiry a
	 WHERE NOT EXISTS (SELECT '1'
	                     FROM giex_rn_no b
						WHERE b.policy_id = a.policy_id)
	   AND a.line_cd = NVL(p_line_cd,NVL(p_line_cd2,a.line_cd))
       AND a.subline_cd = NVL(p_subline_cd,NVL(p_subline_cd2,a.subline_cd))
       AND a.iss_cd   = NVL(p_iss_cd,NVL(p_iss_cd2,a.iss_cd))
       AND a.issue_yy  = NVL(p_issue_yy,a.issue_yy)
       AND a.pol_seq_no  = NVL(p_pol_seq_no,a.pol_seq_no)
       AND a.renew_no  = NVL(p_renew_no,a.renew_no)
       AND NVL(a.intm_no,0)  = NVL(p_intm_no,NVL(a.intm_no,0))
       AND TRUNC(a.expiry_date) >= NVL(p_fr_date,TRUNC(a.expiry_date))
       AND TRUNC(a.expiry_date) <= NVL(p_to_date,TRUNC(a.expiry_date))
       AND a.renew_flag  = '2'
       AND NVL(a.PACK_POLICY_ID,0) = 0;
	RETURN v_count;
END;
/



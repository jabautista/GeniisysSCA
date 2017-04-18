DROP FUNCTION CPI.GET_REQD_DOC_CHAR;

CREATE OR REPLACE FUNCTION CPI.get_reqd_doc_char (p_clm_doc_cd VARCHAR2, p_line_cd VARCHAR2, p_subline_cd VARCHAR2, p_claim_id NUMBER, p_case NUMBER)
RETURN VARCHAR2 AS
  v_char  VARCHAR2(100);
BEGIN
  FOR rec IN (SELECT rcvd_by, frwd_fr
		FROM gicl_reqd_docs
	       WHERE clm_doc_cd = p_clm_doc_cd
		 AND subline_cd = p_subline_cd
		 AND line_cd    = p_line_cd
                 AND claim_id   = p_claim_id)
  LOOP
    IF p_case = 1 THEN
       v_char := rec.rcvd_by;
    ELSIF p_case = 2 THEN
       v_char := rec.frwd_fr;
    END IF;
    EXIT;
  END LOOP;
  RETURN(v_char);
END;
/



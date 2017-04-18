DROP FUNCTION CPI.GET_REQD_DOC_DATE;

CREATE OR REPLACE FUNCTION CPI.get_reqd_doc_date (p_clm_doc_cd VARCHAR2, p_line_cd VARCHAR2, p_subline_cd VARCHAR2, p_claim_id NUMBER, p_case NUMBER)
RETURN DATE AS
  v_date  DATE;
BEGIN
  FOR rec IN (SELECT doc_sbmttd_dt, doc_cmpltd_dt
		FROM gicl_reqd_docs
	       WHERE clm_doc_cd = p_clm_doc_cd
		 AND subline_cd = p_subline_cd
		 AND line_cd    = p_line_cd
                 AND claim_id   = p_claim_id)
  LOOP
    IF p_case = 1 THEN
       v_date := rec.doc_sbmttd_dt;
    ELSIF p_case = 2 THEN
       v_date := rec.doc_cmpltd_dt;
    END IF;
    EXIT;
  END LOOP;
  RETURN(v_date);
END;
/



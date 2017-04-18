DROP FUNCTION CPI.GET_CLM_NO;

CREATE OR REPLACE FUNCTION CPI.get_clm_no (p_claim_id VARCHAR2)
RETURN VARCHAR AS
  v_clm_no  VARCHAR2(50);
BEGIN
  FOR rec IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy, '09'))||'-'||LTRIM(TO_CHAR(clm_seq_no, '0000009')) claim
                FROM gicl_claims
               WHERE claim_id = p_claim_id)
  LOOP
    v_clm_no := rec.claim;
    EXIT;
  END LOOP;
  RETURN (v_clm_no);
END;
/



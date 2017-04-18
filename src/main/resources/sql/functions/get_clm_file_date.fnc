DROP FUNCTION CPI.GET_CLM_FILE_DATE;

CREATE OR REPLACE FUNCTION CPI.get_clm_file_date (p_claim_id VARCHAR2)
RETURN DATE AS
  v_file_date  gicl_claims.clm_file_date%TYPE;
BEGIN
  FOR rec IN (SELECT clm_file_date
                FROM gicl_claims
               WHERE claim_id = p_claim_id)
  LOOP
    v_file_date := rec.clm_file_date;
    EXIT;
  END LOOP;
  RETURN (v_file_date);
END;
/



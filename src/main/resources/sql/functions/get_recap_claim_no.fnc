DROP FUNCTION CPI.GET_RECAP_CLAIM_NO;

CREATE OR REPLACE FUNCTION CPI.get_recap_claim_no(
   p_claim_id gicl_claims.claim_id%type) RETURN CHAR AS
   v_claim_no VARCHAR2(50);
   v_exs BOOLEAN := FALSE;
BEGIN
   FOR c IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||clm_yy||'-'||clm_seq_no claim_no
               FROM GICL_CLAIMS
              WHERE claim_id = p_claim_id)
   LOOP
      v_claim_no := c.claim_no;
      v_exs := TRUE;
      EXIT;
   END LOOP;
   IF v_exs = TRUE THEN
      RETURN(v_claim_no);
   ELSE
      RETURN(null);
   END IF;
END;
/



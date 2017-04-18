DROP FUNCTION CPI.GET_CLAIM_NUMBER;

CREATE OR REPLACE FUNCTION CPI.Get_Claim_Number
(
  p_claim_id GICL_CLAIMS.claim_id%TYPE
) RETURN CHAR 
AS
  v_claim_no VARCHAR2(50);
  v_exs BOOLEAN := FALSE;
BEGIN
  FOR c IN (SELECT UPPER(line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy,'09'))||'-'||LTRIM(TO_CHAR(clm_seq_no,'0000009'))) claim_no
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
     RETURN(NULL);
  END IF;
END;
/



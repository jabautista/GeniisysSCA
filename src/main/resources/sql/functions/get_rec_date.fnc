DROP FUNCTION CPI.GET_REC_DATE;

CREATE OR REPLACE FUNCTION CPI.get_rec_date (p_rec_id VARCHAR2)
RETURN DATE AS
  v_date  gicl_claims.dsp_loss_date%TYPE;
BEGIN
  FOR clm IN (SELECT claim_id
               FROM gicl_clm_recovery b
              WHERE recovery_id = p_rec_id)
  LOOP
    FOR rec IN (SELECT dsp_loss_date
                  FROM gicl_claims
                 WHERE claim_id = clm.claim_id)
    LOOP
      v_date := rec.dsp_loss_date;
      EXIT;
    END LOOP;
  END LOOP;
  RETURN (v_date);
END;
/



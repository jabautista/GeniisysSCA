DROP FUNCTION CPI.GET_REC_AMT;

CREATE OR REPLACE FUNCTION CPI.get_rec_amt (p_recovery_id    gicl_clm_recovery_dtl.recovery_id%TYPE)
  RETURN NUMBER IS
  v_total_rec        NUMBER;
BEGIN
  FOR rec IN (SELECT NVL(SUM(recoverable_amt),0) rec_amt
                     FROM gicl_clm_recovery_dtl
                    WHERE recovery_id = p_recovery_id)
  LOOP
    IF rec.rec_amt <> 0 THEN
       v_total_rec := rec.rec_amt;
    ELSE
       v_total_rec := 1;
    END IF;
    EXIT;
  END LOOP;
  RETURN v_total_rec;
END;
/



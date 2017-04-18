DROP FUNCTION CPI.GET_HIST_SEQ_NO;

CREATE OR REPLACE FUNCTION CPI.get_hist_seq_no (p_claim_id NUMBER, p_clm_loss_id NUMBER)
RETURN VARCHAR2 AS
  v_hist_seq_no  gicl_clm_loss_exp.hist_seq_no%TYPE;
BEGIN
  FOR rec IN (SELECT hist_seq_no
                FROM gicl_clm_loss_exp
               WHERE claim_id = p_claim_id
                 AND clm_loss_id = p_clm_loss_id)
  LOOP
    v_hist_seq_no := rec.hist_seq_no;
    EXIT;
  END LOOP;
  RETURN (v_hist_seq_no);
END;
/



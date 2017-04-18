DROP FUNCTION CPI.GET_PREM_EARNED;

CREATE OR REPLACE FUNCTION CPI.get_prem_earned(p_session_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2, p_iss_cd VARCHAR2, p_intm_no NUMBER, p_assd_no NUMBER)
RETURN NUMBER AS
  v_prem  NUMBER;
BEGIN
  FOR rec IN (SELECT (NVL(curr_prem_amt,0) + (NVL(prev_prem_amt,0) * .4) - (NVL(curr_prem_amt,0) * .4)) premiums_earned
                FROM gicl_loss_ratio_ext
               WHERE NVL(session_id,-1)= NVL(p_session_id,NVL(session_id,-1))
                 AND NVL(line_cd,'**')= NVL(p_line_cd,NVL(line_cd,'**'))
                 AND NVL(subline_cd,'**')= NVL(p_subline_cd,NVL(subline_cd,'**'))
                 AND NVL(iss_cd,'**')= NVL(p_iss_cd,NVL(iss_cd,'**'))
                 AND NVL(intm_no,-1)= NVL(p_intm_no,NVL(intm_no,-1))
                 AND NVL(assd_no,-1)= NVL(p_assd_no,NVL(assd_no,-1)))
  LOOP
    v_prem := rec.premiums_earned;
    EXIT;
  END LOOP;
  RETURN (v_prem);
END;
/



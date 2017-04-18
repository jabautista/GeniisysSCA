DROP FUNCTION CPI.GET_LOSS_RATIO;

CREATE OR REPLACE FUNCTION CPI.Get_Loss_Ratio(p_session_id NUMBER, p_line_cd VARCHAR2, p_subline_cd VARCHAR2, p_iss_cd VARCHAR2, p_peril_cd NUMBER, p_intm_no NUMBER, p_assd_no NUMBER)
RETURN NUMBER AS
  v_loss  NUMBER;
BEGIN
  FOR rec IN (SELECT (NVL(curr_prem_amt,0) + (NVL(prev_prem_amt,0) * .4) - (NVL(curr_prem_amt,0) * .4))premiums_earned ,(NVL(loss_paid_amt,0) + NVL(curr_loss_res,0) - NVL(prev_loss_res,0)) losses_incurred
                FROM gicl_loss_ratio_ext
               WHERE NVL(session_id,-1)= NVL(p_session_id,NVL(session_id,-1))
                 AND NVL(line_cd,'**')= NVL(p_line_cd,NVL(line_cd,'**'))
                 AND NVL(subline_cd,'**')= NVL(p_subline_cd,NVL(subline_cd,'**'))
                 AND NVL(iss_cd,'**')= NVL(p_iss_cd,NVL(iss_cd,'**'))
                 AND NVL(peril_cd,-1)= NVL(p_peril_cd,NVL(peril_cd,-1))
                 AND NVL(intm_no,-1)= NVL(p_intm_no,NVL(intm_no,-1))
                 AND NVL(assd_no,-1)= NVL(p_assd_no,NVL(assd_no,-1)))
  LOOP
    IF NVL(rec.premiums_earned,0) != 0 THEN
       v_loss := (rec.losses_incurred/rec.premiums_earned);
       EXIT;
    ELSE
       v_loss := 0;
       EXIT;
    END IF;
  END LOOP;
  RETURN (v_loss);
END;
/



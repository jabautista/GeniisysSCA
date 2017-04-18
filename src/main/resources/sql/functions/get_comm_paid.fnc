DROP FUNCTION CPI.GET_COMM_PAID;

CREATE OR REPLACE FUNCTION CPI.get_comm_paid(p_intm_no      NUMBER,
                                         p_iss_cd       VARCHAR2,
										 p_prem_seq_no  NUMBER)
RETURN NUMBER IS
  v_comm_amt NUMBER(10,2);
BEGIN
  SELECT SUM(NVL(x.comm_amt,0) - NVL(x.wtax_amt,0) + NVL(x.input_vat_amt,0))
    INTO v_comm_amt
   FROM giac_comm_payts x,
        giac_acctrans   b
  WHERE NOT EXISTS(SELECT 'X'
                      FROM giac_reversals c,
                          giac_acctrans  d
                    WHERE c.reversing_tran_id = d.tran_id
                      AND d.tran_flag != 'D'
                      AND c.gacc_tran_id = x.gacc_tran_id)
    AND x.gacc_tran_id = b.tran_id
    AND b.tran_flag   != 'D'
    AND x.prem_seq_no  = p_prem_seq_no
    AND x.iss_cd       = p_iss_cd
    AND x.intm_no      = p_intm_no
    AND x.gacc_tran_id >= 0;
  RETURN NVL(v_comm_amt,0);
END get_comm_paid;
/



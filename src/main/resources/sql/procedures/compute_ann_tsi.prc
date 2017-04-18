DROP PROCEDURE CPI.COMPUTE_ANN_TSI;

CREATE OR REPLACE PROCEDURE CPI.compute_ann_tsi (p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                             p_item_no      IN gipi_fireitem.item_no%TYPE,
                             p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
                             v_ann_tsi_amt  OUT gipi_polbasic.ann_tsi_amt%TYPE) IS
  BEGIN
    v_ann_tsi_amt := 0;
    SELECT SUM((NVL(c.tsi_amt,0) * NVL(b.currency_rt,0))) ann_tsi
      INTO v_ann_tsi_amt
      FROM gipi_itmperil c,
           gipi_item     b,
           gipi_polbasic a
     WHERE 1=1
       AND a.line_cd      = p_line_cd
       AND a.subline_cd   = p_subline_cd
       AND a.iss_cd       = p_iss_cd
       AND a.issue_yy     = p_issue_yy
       AND a.pol_seq_no   = p_pol_seq_no
       AND a.renew_no     = p_renew_no
       AND a.policy_id    = b.policy_id
       AND b.item_no      = p_item_no
       AND b.policy_id    = c.policy_id
       AND c.item_no      = p_item_no
       AND c.line_cd      = a.line_cd
       AND c.peril_cd     = p_peril_cd;
  END;
/



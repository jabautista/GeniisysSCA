DROP FUNCTION CPI.GET_CLM_ITEMPERIL_TSI;

CREATE OR REPLACE FUNCTION CPI.get_clm_itemperil_tsi
    (p_line_cd         VARCHAR2,
     p_subline_cd      VARCHAR2,
     p_iss_cd          VARCHAR2,
     p_issue_yy        NUMBER,
     p_pol_seq_no      NUMBER,
     p_renew_no        NUMBER,
  p_item_no         NUMBER,
     p_peril_cd         NUMBER,
     p_loss_date       DATE,
     p_clm_eff_date       DATE,
     p_clm_expiry_date      DATE)
/* beth 03202003
**      this procedure extract latest TSI amount per item and peril
**      depending on claim's loss date
*/
RETURN NUMBER IS
  v_item_ann_tsi   gipi_item.ann_tsi_amt%TYPE := 0;
BEGIN
  FOR tsi IN (SELECT SUM(Z.tsi_amt) tsi_amt
                FROM gipi_polbasic x,
               gipi_item     y,
      gipi_itmperil z
               WHERE 1=1
                AND x.policy_id  = y.policy_id
                AND y.policy_id  = z.policy_id
              AND y.item_no    = z.item_no
              AND y.item_no    = p_item_no
     AND z.peril_cd    = p_peril_cd
                 AND x.line_cd    = p_line_cd
                 AND x.subline_cd = p_subline_cd
                 AND x.iss_cd     = p_iss_cd
                 AND x.issue_yy   = p_issue_yy
                 AND x.pol_seq_no = p_pol_seq_no
                 AND x.renew_no   = p_renew_no
     AND x.pol_flag IN ('1','2','3','X')
                 AND TRUNC(DECODE(TRUNC(NVL(y.from_date,x.eff_date)),TRUNC(x.incept_date), NVL(y.from_date,p_clm_eff_date), NVL(y.from_date,x.eff_date))) <= p_loss_date
                 AND TRUNC(DECODE(NVL(y.TO_DATE,NVL(x.endt_expiry_date, x.expiry_date)), x.expiry_date,NVL(y.TO_DATE,p_clm_expiry_date), NVL(y.TO_DATE,x.endt_expiry_date)))
                                  >= p_loss_date)
  LOOP
    v_item_ann_tsi := tsi.tsi_amt;
 EXIT;
  END LOOP;
  RETURN(v_item_ann_tsi);
END;
/



DROP PROCEDURE CPI.EXTRACT_LATEST_PERIL_GRP;

CREATE OR REPLACE PROCEDURE CPI.Extract_Latest_Peril_Grp (p_expiry_date      gicl_claims.expiry_date%TYPE,
                        p_incept_date      gicl_claims.expiry_date%TYPE,
                        p_loss_date        gicl_claims.loss_date%TYPE,
                        p_clm_endt_seq_no  gicl_claims.max_endt_seq_no%TYPE,
                        p_line_cd          gicl_claims.line_cd%TYPE,
                        p_subline_cd       gicl_claims.subline_cd%TYPE,
                        p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
                        p_issue_yy         gicl_claims.issue_yy%TYPE,
                        p_pol_seq_no       gicl_claims.pol_seq_no%TYPE,
                        p_renew_no     gicl_claims.renew_no%TYPE,
                        p_claim_id         gicl_claims.claim_id%TYPE,
                        p_item_no          gicl_clm_item.item_no%TYPE,
                        p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,      
      p_grouped_item_no  GICL_ITEM_PERIL.GROUPED_ITEM_NO%TYPE)
/** Created by : Jimmy Fajarito
    Date Created : 01/31/06
**/
IS
  v_tsi_amt        NUMBER;
  v_allow_tsi_amt   NUMBER;
  v_agg_sw        VARCHAR2(1);
  v_no_of_units  NUMBER;
  v_no_of_days   NUMBER:=0;
  v_paid_amt    NUMBER;
  v_base_amt    NUMBER;
  v_init    NUMBER:= 1;
BEGIN
  FOR d IN (SELECT SUM(NVL(B.tsi_amt,0)) amt 
              FROM gipi_polbasic c, GIPI_ITMPERIL_GROUPED b
             WHERE 1=1
      AND B.peril_cd = p_peril_cd            
               AND b.item_no = p_item_no
               AND c.line_cd = p_line_cd
               AND c.subline_cd = p_subline_cd
               AND c.iss_cd = p_pol_iss_cd
               AND c.issue_yy = p_issue_yy
               AND c.pol_seq_no = p_pol_seq_no
               AND c.renew_no = p_renew_no
               AND c.pol_flag IN ('1','2','3','X')               
      AND c.POLICY_ID = b.policy_id      
      AND b.grouped_item_no = p_grouped_item_no
               AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date),
                   p_incept_date, c.eff_date))
                   <= p_loss_date
               AND DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                   c.expiry_date, p_expiry_date, c.endt_expiry_date)
                   >= p_loss_date)
  LOOP
    v_tsi_amt := d.amt; 
  END LOOP;
  FOR j IN (SELECT NVL(b.aggregate_sw,'N') sw, NVL(b.no_of_days,0) nod, NVL(b.BASE_AMT,0) ba
              FROM gipi_polbasic c, GIPI_ITMPERIL_GROUPED b
             WHERE B.peril_cd = p_peril_cd      
               AND b.item_no = p_item_no
               AND c.line_cd = p_line_cd
               AND c.subline_cd = p_subline_cd
               AND c.iss_cd = p_pol_iss_cd
               AND c.issue_yy = p_issue_yy
               AND c.pol_seq_no = p_pol_seq_no
               AND c.renew_no = p_renew_no
               AND c.pol_flag IN ('1','2','3','X')               
      AND c.POLICY_ID = b.policy_id
      AND b.grouped_item_no = p_grouped_item_no
               AND TRUNC(DECODE(TRUNC(c.eff_date),TRUNC(c.incept_date),
                   p_incept_date, c.eff_date))
                   <= p_loss_date
               AND DECODE(NVL(c.endt_expiry_date, c.expiry_date),
                   c.expiry_date, p_expiry_date, c.endt_expiry_date)
                   >= p_loss_date
    ORDER BY c.endt_seq_no)
  LOOP
  IF v_init = 1 THEN
   v_base_amt   := j.ba;
  END IF;
  v_init       := v_init + 1;
  v_agg_sw     := j.sw;
  v_no_of_days := v_no_of_days + j.nod;
  END LOOP;
  IF v_agg_sw = 'Y' AND v_no_of_days <> 0 THEN
   SELECT NVL(SUM(A.no_of_units),0)
    INTO v_no_of_units 
   FROM GICL_LOSS_EXP_DTL A, GICL_CLM_LOSS_EXP b
  WHERE A.CLAIM_ID = b.claim_id
    AND b.CLM_LOSS_ID = A.clm_loss_id
    AND b.ITEM_NO = p_item_no
    AND b.PERIL_CD = p_peril_cd
    AND A.line_cd = p_line_cd
    AND b.GROUPED_ITEM_NO = p_grouped_item_no
    AND NVL(b.cancel_sw,'N') = 'N'
    AND NVL(b.DIST_SW,'N')='Y'
    AND b.claim_id = p_claim_id;    
   v_tsi_amt := v_tsi_amt - (v_base_amt * (v_no_of_days - v_no_of_units));
  ELSIF v_agg_sw = 'Y' AND v_no_of_days = 0 THEN
   SELECT NVL(SUM(paid_amt),0)
   INTO v_paid_amt
   FROM GICL_CLM_LOSS_EXP
  WHERE claim_id = p_claim_id
    AND item_no = p_item_no
    AND grouped_item_no = p_grouped_item_no
    AND peril_cd = p_peril_cd;
 v_tsi_amt := v_tsi_amt - (v_paid_amt);   
  END IF;           
  
  UPDATE GICL_ITEM_PERIL
     SET ann_tsi_amt = NVL(v_tsi_amt,ann_tsi_amt),
      allow_tsi_amt = NVL(v_tsi_amt,allow_tsi_amt), 
      base_amt = v_base_amt,
   no_of_days = v_no_of_days
   WHERE claim_id = p_claim_id
     AND item_no = p_item_no
  AND grouped_item_no = p_grouped_item_no
     AND peril_cd = p_peril_cd;
END;
/



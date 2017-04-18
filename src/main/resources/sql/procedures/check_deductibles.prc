DROP PROCEDURE CPI.CHECK_DEDUCTIBLES;

CREATE OR REPLACE PROCEDURE CPI.CHECK_DEDUCTIBLES
(p_claim_id        IN   GICL_CLAIMS.claim_id%TYPE,
 p_clm_loss_id     IN   GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
 p_item_no         IN   GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd        IN   GICL_ITEM_PERIL.peril_cd%TYPE,
 p_grouped_item_no IN   GICL_ITEM_PERIL.grouped_item_no%TYPE,
 p_loss_exp_cd     IN   GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
 p_nbt_ded_agg_sw  IN   VARCHAR2,
 p_dtl_amt         IN   GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_nbt_deduct_type IN   VARCHAR2,
 p_payee_type      IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
 p_line_cd         IN   GICL_CLAIMS.line_cd%TYPE,
 p_subline_cd      IN   GICL_CLAIMS.subline_cd%TYPE,
 p_pol_iss_cd      IN   GICL_CLAIMS.pol_iss_cd%TYPE,
 p_issue_yy        IN   GICL_CLAIMS.issue_yy%TYPE,
 p_pol_seq_no      IN   GICL_CLAIMS.pol_seq_no%TYPE,
 p_renew_no        IN   GICL_CLAIMS.renew_no%TYPE,
 p_loss_date       IN   GICL_CLAIMS.loss_date%TYPE,
 p_pol_eff_date    IN   GICL_CLAIMS.pol_eff_date%TYPE,
 p_expiry_date     IN   GICL_CLAIMS.expiry_date%TYPE,
 p_ceiling_sw      OUT  GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
 p_agg_sw          OUT  GIPI_DEDUCTIBLES.aggregate_sw%TYPE,
 p_v_sumDedA       OUT  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_v_sumDedC       OUT  GICL_LOSS_EXP_DTL.dtl_amt%TYPE,
 p_msg_alert       OUT  VARCHAR2) AS
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.01.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes CHECKDEDUCTIBLES Program unit in GICLS030 that
 **                  check if deductible amounts do not exceed ceiling amount
 */

 v_total_ded     GICL_LOSS_EXP_DTL.dtl_amt%TYPE;
 v_alert         VARCHAR2(1):='N';
 v_dedcd         VARCHAR2(5);
 v_dedcd2        VARCHAR2(5);
 v_ceil          VARCHAR2(1) := 'N';
 v_ceil2         VARCHAR2(1) := 'N'; 
 v_agg2          VARCHAR2(1) := 'N';   
 v_agg           VARCHAR2(1) := 'N';


BEGIN
    FOR x IN (SELECT  NVL(a.deductible_amt, 0) dedAmt, b.deductible_cd dedcd, 
                      a.ceiling_sw,  a.aggregate_sw
                FROM GIPI_DEDUCTIBLES a, 
                     GIIS_DEDUCTIBLE_DESC b, 
                     GIPI_POLBASIC c, 
                     GIIS_LOSS_EXP e, 
                     CG_REF_CODES f
               WHERE a.ded_line_cd = b.line_cd
                 AND a.ded_subline_cd = b.subline_cd
                 AND a.ded_deductible_cd = b.deductible_cd
                 AND a.ded_line_cd = c.line_cd 
                 AND a.ded_subline_cd = c.subline_cd 
                 AND a.policy_id = c.policy_id 
                 AND e.line_cd = c.line_cd 
                 AND e.line_cd = a.ded_line_cd 
                 AND e.subline_cd = a.ded_subline_cd 
                 AND e.loss_exp_cd = a.ded_deductible_cd 
                 AND e.loss_exp_type = p_payee_type
                 AND a.ded_line_cd = p_line_cd
                 AND a.ded_subline_cd = p_subline_cd
                 AND c.iss_cd = p_pol_iss_cd
                 AND c.issue_yy = p_issue_yy
                 AND c.pol_seq_no = p_pol_seq_no
                 AND c.renew_no = p_renew_no
                 AND c.expiry_date >= p_loss_date
                 AND c.pol_flag IN ('1','2','3','X')
                 AND a.item_no IN (p_item_no,0) 
                 AND a.peril_cd IN (p_peril_cd, 0)
                 AND a.ded_deductible_cd = p_loss_exp_cd
                 AND f.rv_domain = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
                 AND f.rv_low_value = b.ded_type
                 AND TRUNC(DECODE(TRUNC(c.eff_date), TRUNC(c.incept_date),
                     p_pol_eff_date, c.eff_date )) <= TRUNC(p_loss_date)
                 AND TRUNC(DECODE(NVL(c.endt_expiry_date,c.expiry_date),c.expiry_date,
                     p_expiry_date,c.endt_expiry_date)) >= TRUNC(p_loss_date)
                 AND EXISTS (SELECT 'X' 
                              FROM GIIS_LOSS_EXP d
                             WHERE d.loss_exp_cd = a.ded_deductible_cd
                               AND d.line_cd = b.line_cd
                               AND d.subline_cd = a.ded_subline_cd))

     LOOP
          v_total_Ded  := x.dedAmt;
          v_dedcd      := x.dedcd;
          v_ceil       := x.ceiling_sw;
          v_agg        := x.aggregate_sw;
          p_ceiling_sw := v_ceil;
          p_agg_sw := v_agg;
     END LOOP;
  
  
    /** To retrieve the value of ceiling switch of the particular deductible*/
     FOR x in (SELECT NVL(ceiling_sw, 'N') ceiling_sw, NVL(aggregate_sw, 'N') aggregate_sw
                 FROM GICL_LOSS_EXP_DED_DTL
                WHERE claim_id    = p_claim_id
                  AND clm_loss_id = p_clm_loss_id
                  AND loss_exp_cd = p_loss_exp_cd)
     LOOP
        v_ceil2 := x.ceiling_sw;
        v_agg2  := x.aggregate_sw;
        p_ceiling_sw := v_ceil2;
        p_agg_sw := v_agg2;
     END LOOP;

  
    IF v_agg2 = 'Y' THEN
      
      CHECKAGGREGATE(p_loss_exp_cd, p_line_cd,        p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no, 
                     p_renew_no,    p_nbt_ded_agg_sw, p_agg_sw,     p_v_sumDedA,  p_msg_alert );
      
    END IF;    
     
    FOR x IN (SELECT SUM(ABS(dtl_amt)) ded_amt
                FROM GICL_LOSS_EXP_DTL A
               WHERE LOSS_EXP_CD = p_loss_exp_cd
                 AND a.claim_id  = p_claim_id
                 AND EXISTS (SELECT 1
                             FROM GICL_CLM_LOSS_EXP
                             WHERE claim_id = a.claim_id
                               AND NVL(dist_sw,'N') = 'Y' 
                               AND clm_loss_id = a.clm_loss_id
                               AND item_no = p_item_no
                               AND grouped_item_no = p_grouped_item_no
                               AND peril_cd = p_peril_cd))
    LOOP
        p_v_sumDedC := NVL(x.ded_amt,0);
    END LOOP;  
        
    IF ABS(NVL(p_v_sumDedC,0)) + ABS(NVL(p_dtl_amt,0)) > NVL(v_total_ded,0) 
       AND p_nbt_deduct_type = 'F' AND v_ceil2 = 'Y' THEN 
        v_alert := 'Y';
        v_dedcd2 := v_dedcd;
    END IF;

    
    IF v_alert = 'Y'  AND p_msg_alert IS NULL THEN
        p_msg_alert := 'Deductible '||v_dedcd||' cannot exceed allowable amount.  Please recreate this deductible.';
    END IF;
      
END;
/



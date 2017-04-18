DROP PROCEDURE CPI.CHECKCEILING;

CREATE OR REPLACE PROCEDURE CPI.CHECKCEILING
(p_nbt_ceiling_sw     IN    GIPI_DEDUCTIBLES.ceiling_sw%TYPE,
 p_claim_id           IN    GICL_CLAIMS.claim_id%TYPE,
 p_loss_exp_cd        IN    GICL_LOSS_EXP_DTL.loss_exp_cd%TYPE,
 p_item_no            IN    GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd           IN    GICL_ITEM_PERIL.peril_cd%TYPE,
 p_grouped_item_no    IN    GICL_ITEM_PERIL.grouped_item_no%TYPE,
 p_param_ded_amt      IN    NUMBER,
 p_v_sumDedC          OUT   NUMBER,
 p_v_allowable_ded    OUT   NUMBER,
 p_v_exhaust          OUT   VARCHAR2,
 p_msg_alert          OUT   VARCHAR2) IS
 
 /*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 03.19.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes CHECKCEILING Program unit in GICLS030
 **                  
 */ 

BEGIN

  p_v_exhaust := 'N';
  
  IF NVL(p_nbt_ceiling_sw,'N') = 'Y' THEN
     FOR x IN (SELECT SUM(ABS(dtl_amt)) ded_amt
                 FROM GICL_LOSS_EXP_DTL A
                WHERE loss_exp_cd = p_loss_exp_cd
                  AND a.claim_id =  p_claim_id
                  AND EXISTS (SELECT 1
                                FROM GICL_CLM_LOSS_EXP
                               WHERE claim_id = a.claim_id
                                 AND NVL(dist_sw,'N') = 'Y' 
                                 AND clm_loss_id = a.clm_loss_id
                                 AND item_no = p_item_no
                                 AND grouped_item_no = p_grouped_item_no
                                 AND peril_cd = p_peril_cd))
     LOOP
       p_v_sumDedc := NVL(x.ded_amt,0);
     END LOOP;
          
     p_v_allowable_ded := NVL(ABS(p_param_ded_amt),0) - NVL(p_v_sumDedc,0);  
     
     IF p_v_allowable_ded = 0 THEN
       p_v_exhaust := 'Y';    
     END IF;
     
     IF ABS(p_param_ded_amt) < p_v_sumDedc THEN
        p_msg_alert := 'Deductible cannot exceed ceiling amount: '||p_v_sumDedc||'.';
     END IF;
      
  END IF;
  
END;
/



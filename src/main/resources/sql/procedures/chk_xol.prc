DROP PROCEDURE CPI.CHK_XOL;

CREATE OR REPLACE PROCEDURE CPI.CHK_XOL 
( p_claim_id        IN      GICL_CLAIMS.claim_id%TYPE,
  p_clm_loss_id     IN      GICL_CLM_LOSS_EXP.clm_loss_id%TYPE,
  p_catastrophic_cd IN      GICL_CLAIMS.catastrophic_cd%TYPE, 
  v_exists          IN OUT  VARCHAR2,
  v_curr_xol        IN OUT  VARCHAR2  ) IS

/*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes CHK_XOL Program unit in GICLS030
 **                  
 */
  
  v_other_xol         VARCHAR2(1) := 'N';
  v_other_net         VARCHAR2(1) := 'N';
  v_curr_net          VARCHAR2(1) := 'N';
  v_xol_share_type    GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('XOL_TRTY_SHARE_TYPE'), 4);

BEGIN    
  FOR get_curr_xol IN(
      SELECT DISTINCT a.share_type share_type
        FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
       WHERE a.claim_id = b.claim_id
         AND a.clm_loss_id = b.clm_loss_id
         AND NVL(b.cancel_sw, 'N') = 'N'
         AND NVL(a.negate_tag, 'N') = 'N'
         AND a.share_type IN( v_xol_share_type, 1)
         AND a.claim_id = p_claim_id 
         AND a.clm_loss_id = p_clm_loss_id)
  LOOP
  
    IF get_curr_xol.share_type = 1 THEN
       v_curr_net := 'Y';                 
    END IF;
    
    IF get_curr_xol.share_type = v_xol_share_type THEN
          v_curr_xol := 'Y';                 
    END IF;                  
  END LOOP;
       
  IF p_catastrophic_cd IS NULL THEN
       FOR get_all_xol IN(
       SELECT DISTINCT a.share_type share_type
         FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b
        WHERE a.claim_id = b.claim_id
          AND a.clm_loss_id = b.clm_loss_id
          AND NVL(b.cancel_sw, 'N') = 'N'
          AND NVL(a.negate_tag, 'N') = 'N'
          AND a.claim_id = p_claim_id
          AND a.clm_loss_id <> p_clm_loss_id
          AND a.share_type IN( v_xol_share_type, 1))
     LOOP     
          IF get_all_xol.share_type = 1 THEN
             v_other_net := 'Y';                 
          END IF;
          
          IF get_all_xol.share_type = v_xol_share_type THEN
             v_other_xol := 'Y';                 
          END IF;             
     END LOOP;     
  ELSE
     FOR get_all_xol IN(
       SELECT DISTINCT a.share_type share_type
         FROM GICL_LOSS_EXP_DS a, GICL_CLM_LOSS_EXP b,
              GICL_CLAIMS c
        WHERE a.claim_id = b.claim_id
          AND a.clm_loss_id = b.clm_loss_id
          AND a.claim_id = c.claim_id
          AND NVL(b.cancel_sw, 'N') = 'N'
          AND NVL(a.negate_tag, 'N') = 'N'
          AND c.catastrophic_cd = p_catastrophic_cd
          AND a.share_type = v_xol_share_type
          AND (a.claim_id <> p_claim_id OR a.clm_loss_id <> p_clm_loss_id))
     LOOP     
        IF get_all_xol.share_type = 1 THEN
           v_other_net := 'Y';                 
        END IF;
        
        IF get_all_xol.share_type = v_xol_share_type THEN
           v_other_xol := 'Y';                 
        END IF;
                     
     END LOOP;              
  END IF;
     
  --if current item peril has an existing net retention and 
  --other record has an existing xol share then validate for xol 
  
  IF v_other_net = 'Y' AND v_curr_xol = 'Y' THEN
     v_exists := 'Y';
     
     --if current item peril has an existing xol share and 
     --other record has an existing net retention share then validate for xol       
  ELSIF v_curr_net = 'Y' and v_other_xol = 'Y' THEN
       v_exists := 'Y';
  ELSE                 
      v_exists := 'N';
  END IF;      

END CHK_XOL;
/



DROP PROCEDURE CPI.CHK_CAT_XOL_RES;

CREATE OR REPLACE PROCEDURE CPI.CHK_CAT_XOL_RES (p_exists             IN OUT    VARCHAR2,
                                                 p_curr_net           IN        VARCHAR2,
                                                 p_curr_xol           IN        VARCHAR2,
                                                 p_claim_id           IN        gicl_claims.claim_id%TYPE,
                                                 p_catastrophic_cd    IN        gicl_claims.catastrophic_cd%TYPE,
                                                 p_cat_payt_res_flag     OUT    VARCHAR2) 
IS
  /*
  **  Created by      : Christian Santos
  **  Date Created    : 10.25.2012
  **  Reference By    : (GICLS039 - Batch Claim Closing)      
  */        
  v_other_xol   VARCHAR2(1);
  v_other_net   VARCHAR2(1);
  v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
  
BEGIN    
    --if xol or net retention exist on item peril distribution
  --then check for the existence of xol or net retention share on
  --other claim or catastrophic event record
  FOR get_all_xol IN(SELECT DISTINCT a.share_type share_type
                                       FROM gicl_reserve_ds a, gicl_claims b
                                         WHERE a.claim_id = b.claim_id
                                         AND NVL(a.negate_tag, 'N') = 'N'
                                           AND b.catastrophic_cd = p_catastrophic_cd
                                           AND (a.claim_id <> p_claim_id)                
                                           AND a.share_type IN(v_xol_share_type, 1))
  LOOP     
    IF get_all_xol.share_type = 1 THEN
        v_other_net := 'Y';                 
       END IF;
    IF get_all_xol.share_type = v_xol_share_type THEN
        v_other_xol := 'Y';                 
    END IF;             
  END LOOP;              
  --if current item peril has an existing net retention and 
  --other record has an existing xol share then validate for xol 
  IF v_other_net = 'Y' and p_curr_xol = 'Y' THEN
    p_cat_payt_res_flag := 'Y';--TRUE;
    p_exists := 'Y';     
     --if current item peril has an existing xol share and 
     --other record has an existing net retention share then validate for xol       
  ELSIF p_curr_net = 'Y' and v_other_xol = 'Y' THEN
    p_cat_payt_res_flag := 'Y';--TRUE;     
    p_exists := 'Y';
  END IF;      
END;
/



DROP PROCEDURE CPI.CHK_XOL_RES;

CREATE OR REPLACE PROCEDURE CPI.CHK_XOL_RES (p_curr_net  IN OUT    VARCHAR2,
                                             p_curr_xol  IN OUT    VARCHAR2,
                                             p_claim_id  IN        gicl_claims.claim_id%TYPE) 
IS  
    /*
    **  Created by      : Christian Santos
    **  Date Created    : 10.25.2012
    **  Reference By    : (GICLS039 - Batch Claim Closing)      
    */                                                 
    v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
    
BEGIN    
    --check first if peril have net retention or XOL share
    FOR get_all_xol IN(SELECT DISTINCT a.share_type share_type
                         FROM gicl_reserve_ds a
                        WHERE NVL(a.negate_tag, 'N') = 'N'
                          AND claim_id = p_claim_id
                          AND a.share_type IN( v_xol_share_type, 1))
  LOOP     
    IF get_all_xol.share_type = 1 THEN
       p_curr_net := 'Y';                 
    END IF;
    IF get_all_xol.share_type = v_xol_share_type THEN
       p_curr_xol := 'Y';                 
    END IF;             
  END LOOP; 
  
END;
/



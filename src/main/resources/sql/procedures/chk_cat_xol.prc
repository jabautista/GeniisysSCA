DROP PROCEDURE CPI.CHK_CAT_XOL;

CREATE OR REPLACE PROCEDURE CPI.CHK_CAT_XOL(
    v_res_net   IN  OUT   VARCHAR2,
    v_res_xol   IN  OUT   VARCHAR2,
    v_payt_net  IN  OUT   VARCHAR2,
    v_payt_xol  IN  OUT   VARCHAR2,
    v_cat_cd    IN        gicl_cat_dtl.catastrophic_cd%TYPE,
    p_claim_id  IN        gicl_claims.claim_id%TYPE
    ) IS
  v_other_xol           VARCHAR2(1);
  v_other_net           VARCHAR2(1);
  v_xol_share_type      giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
BEGIN    
    --this procedure check for the existence of XOL share on claim's record distribution
    --if xol or net retention exist on item peril distribution
    --then check for the existence of xol or net retention share on
    --other claim or catastrophic event record
  FOR get_all_xol IN(
    SELECT DISTINCT a.share_type share_type
      FROM gicl_reserve_ds a, gicl_claims b
     WHERE a.claim_id = b.claim_id
       AND NVL(a.negate_tag, 'N') = 'N'
       AND b.catastrophic_cd = v_cat_cd
       AND (a.claim_id <> p_claim_id)                
       AND a.share_type IN(v_xol_share_type, 1))
  LOOP     
    IF get_all_xol.share_type = 1 THEN
       v_res_net := 'Y';                 
       END IF;
    IF get_all_xol.share_type = v_xol_share_type THEN
          v_res_xol := 'Y';                 
    END IF;             
  END LOOP;              
  --check for the existence of xol or net retention share on
  --other catastrophic event record
  FOR get_all_xol IN(
    SELECT DISTINCT a.share_type share_type
      FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b,
           gicl_claims c
     WHERE a.claim_id = b.claim_id
       AND a.clm_loss_id = b.clm_loss_id
       AND a.claim_id = c.claim_id
       AND NVL(b.cancel_sw, 'N') = 'N'
       AND NVL(a.negate_tag, 'N') = 'N'
       AND c.catastrophic_cd = v_cat_cd
       AND a.share_type = v_xol_share_type
       AND a.claim_id <> p_claim_id )
  LOOP     
    IF get_all_xol.share_type = 1 THEN
       v_payt_net := 'Y';                 
    END IF;
    IF get_all_xol.share_type = v_xol_share_type THEN
          v_payt_xol := 'Y';                 
    END IF;             
  END LOOP;       
END;
/



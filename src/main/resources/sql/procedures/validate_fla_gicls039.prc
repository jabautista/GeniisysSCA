DROP PROCEDURE CPI.VALIDATE_FLA_GICLS039;

CREATE OR REPLACE PROCEDURE CPI.VALIDATE_FLA_GICLS039(p_claim_id        IN      gicl_claims.claim_id%TYPE,
                                                      v_generate_all    OUT     VARCHAR2,
                                                      v_print_all       OUT     VARCHAR2) 

IS
  /*
  **  Created by      : Christian Santos
  **  Reference By    : (GICLS039 - Batch Claim Closing)      
  */
BEGIN  

  v_generate_all := 'N';
  v_print_all    := 'N';
  
  FOR get_payt IN(SELECT claim_id, clm_loss_id, item_no, peril_cd, dist_no, grouped_item_no
                                  FROM gicl_clm_res_hist
                                  WHERE claim_id = p_claim_id
                                  AND tran_id IS NOT NULL
                                    AND NVL(cancel_tag, 'N') = 'N')
  LOOP
    v_generate_all := 'N';
    FOR get_gen IN(SELECT '1'
                               FROM gicl_loss_exp_rids
                                 WHERE claim_id = get_payt.claim_id
                                   AND clm_loss_id = get_payt.clm_loss_id
                                   AND item_no  = get_payt.item_no
                                   AND nvl(grouped_item_no,0) = nvl(get_payt.grouped_item_no,0)
                                   AND peril_cd = get_payt.peril_cd
                                   AND clm_dist_no = get_payt.dist_no)
    LOOP       
      v_generate_all := 'Y';
      FOR get_print IN(SELECT DISTINCT NVL(print_sw,'N') print_switch 
                                        FROM gicl_loss_exp_rids a, gicl_advs_fla b, gicl_advice c, gicl_clm_loss_exp d
                                    WHERE a.claim_id = b.claim_id       
                                        AND  b.claim_id = c.claim_id
                                        AND  b.adv_fla_id = c.adv_fla_id 
                                        AND c.claim_id = d.claim_id
                                        AND c.advice_id = d.advice_id          
                                      AND d.claim_id = get_payt.claim_id
                                        AND d.clm_loss_id = get_payt.clm_loss_id
                                        AND a.clm_dist_no = get_payt.dist_no)
      LOOP
          v_generate_all := 'N';
          IF get_print.print_switch = 'N' THEN
               v_print_all := 'Y';
               EXIT;
          END IF;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/



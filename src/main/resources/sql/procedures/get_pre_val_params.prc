DROP PROCEDURE CPI.GET_PRE_VAL_PARAMS;

CREATE OR REPLACE PROCEDURE CPI.get_pre_val_params (
   p_claim_id                gicl_claims.claim_id%TYPE,
   p_item_no                 gicl_item_peril.item_no%TYPE,
   p_peril_cd                gicl_item_peril.peril_cd%TYPE,
   p_grouped_item_no         gicl_item_peril.grouped_item_no%TYPE,
   p_adv_lflag         OUT   VARCHAR2,
   p_adv_eflag         OUT   VARCHAR2,
   p_xol_share_type    OUT   VARCHAR2,
   p_curr_exists       OUT   VARCHAR2,
   p_xol_exists        OUT   VARCHAR2,
   p_cat_cd            OUT   NUMBER
)
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Procedure to retrieve the values needed for validation in updating the status 
   */

   v_other_xol   VARCHAR2 (1);
   v_other_net   VARCHAR2 (1);
   v_curr_xol    VARCHAR2 (1);
   v_curr_net    VARCHAR2 (1);
BEGIN
   FOR adv_flag IN (SELECT 'X'
                      FROM gicl_clm_loss_exp a, gicl_advice b
                     WHERE a.claim_id = b.claim_id
                       AND a.advice_id = b.advice_id
                       AND a.claim_id = p_claim_id
                       AND a.peril_cd = p_peril_cd
                       AND a.item_no = p_item_no
                       AND grouped_item_no = p_grouped_item_no                                             --added by gmi 02/28/06
                       AND a.payee_type = 'L'
                       AND b.advice_flag = 'Y')
   LOOP
      p_adv_lflag := 'TRUE';
      EXIT;
   END LOOP;

   FOR adv_flag IN (SELECT 'X'
                      FROM gicl_clm_loss_exp a, gicl_advice b
                     WHERE a.claim_id = b.claim_id
                       AND a.advice_id = b.advice_id
                       AND a.claim_id = p_claim_id
                       AND a.peril_cd = p_peril_cd
                       AND a.grouped_item_no = p_grouped_item_no                                           --added by gmi 02/28/06
                       AND a.item_no = p_item_no
                       AND a.payee_type = 'E'
                       AND b.advice_flag = 'Y')
   LOOP
      p_adv_eflag := 'TRUE';
      EXIT;
   END LOOP;

   p_xol_share_type := giacp.v ('XOL_TRTY_SHARE_TYPE');

   IF p_xol_share_type IS NULL
   THEN
      p_xol_share_type := 4;
   END IF;

   FOR get_all_xol IN (SELECT DISTINCT a.share_type share_type
                                  FROM gicl_reserve_ds a
                                 WHERE NVL (a.negate_tag, 'N') = 'N'
                                   AND claim_id = p_claim_id
                                   AND a.peril_cd = p_peril_cd
                                   AND a.item_no = p_item_no
                                   AND grouped_item_no = p_grouped_item_no                                 --added by gmi 02/28/06
                                   AND a.share_type IN (p_xol_share_type, 1))
   LOOP
      IF get_all_xol.share_type = 1
      THEN
         v_curr_net := 'Y';
      END IF;

      IF get_all_xol.share_type = p_xol_share_type
      THEN
         v_curr_xol := 'Y';
         p_curr_exists := 'Y';
      END IF;
   END LOOP;

   --if current item peril has an existing net retention and
    --other record has an existing xol share then validate for xol
   IF v_other_net = 'Y' AND v_curr_xol = 'Y'
   THEN
      p_xol_exists := 'Y';
   --if current item peril has an existing xol share and
   --other record has an existing net retention share then validate for xol
   ELSIF v_curr_net = 'Y' AND v_other_xol = 'Y'
   THEN
      p_xol_exists := 'Y';
   END IF;
   
   SELECT catastrophic_cd
     INTO p_cat_cd
     FROM gicl_claims
    WHERE claim_id = p_claim_id;
END;
/



DROP FUNCTION CPI.CHECK_CLAIM_WITH_RECOVERY;

CREATE OR REPLACE FUNCTION CPI.check_claim_with_recovery
(p_claim_id              gicl_claims.claim_id%TYPE)
  RETURN VARCHAR2 IS
  v_recovery_sw     gicl_claims.recovery_sw%TYPE;
BEGIN
/* created by JEROME.O 07132009
*/
  FOR x IN (SELECT DISTINCT a.recovery_sw
              FROM gicl_claims a, gicl_item_peril b, gicl_clm_reserve c
             WHERE a.claim_id = b.claim_id
               AND a.claim_id = c.claim_id
               AND a.recovery_sw = 'Y'
               AND (b.close_flag NOT IN ('WD','DN') OR b.close_flag2 NOT IN ('WD','DN'))
               AND (NVL(c.loss_reserve,0) + NVL(c.expense_reserve,0)) > 0
               AND a.claim_id = p_claim_id)
  LOOP
      v_recovery_sw := x.recovery_sw;
  END LOOP;
  RETURN(v_recovery_sw);
END;
/



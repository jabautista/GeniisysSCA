DROP PROCEDURE CPI.UPDATE_CLM_DIST_TAG;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_CLM_DIST_TAG(p_claim_id      gicl_casualty_dtl.claim_id%TYPE)IS
  v_exists VARCHAR2(1);

BEGIN

  BEGIN
    SELECT DISTINCT 'X'
      INTO v_exists
      FROM gicl_clm_res_hist
     WHERE dist_sw  = 'Y'
       AND claim_id = p_claim_id;
    UPDATE gicl_claims
       SET clm_dist_tag = 'N'
     WHERE claim_id     = p_claim_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      UPDATE gicl_claims
         SET clm_dist_tag = 'Y'
       WHERE claim_id     = p_claim_id;
  END;

END;
/



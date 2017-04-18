DROP FUNCTION CPI.GET_DFLT_PAYEE_TYPE;

CREATE OR REPLACE FUNCTION CPI.get_dflt_payee_type
(p_claim_id   IN    GICL_CLAIMS.claim_id%TYPE,
 p_item_no    IN    GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd   IN    GICL_ITEM_PERIL.peril_cd%TYPE)
 
RETURN VARCHAR2 AS

  /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.06.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Gets the default payee type for a certain gicl_item_peril record.
   */ 
  
  v_loss_reserve     GICL_CLM_RES_HIST.loss_reserve%TYPE;
  v_expense_reserve  GICL_CLM_RES_HIST.expense_reserve%TYPE;
  v_payee_type       VARCHAR2(1);

BEGIN
  FOR m IN
    (SELECT loss_reserve, expense_reserve
       FROM GICL_CLM_RES_HIST
      WHERE claim_id = p_claim_id
        AND dist_sw  = 'Y'
        AND item_no  = p_item_no
        AND peril_cd = p_peril_cd)
  LOOP
    v_loss_reserve := NVL(m.loss_reserve,0);
    v_expense_reserve := NVL(m.expense_reserve,0);
  END LOOP;

  IF v_expense_reserve = 0 and v_loss_reserve <> 0 THEN
     v_payee_type := 'L';
  ELSIF v_loss_reserve = 0 and v_expense_reserve <> 0 THEN
     v_payee_type := 'E';
  ELSIF v_loss_reserve <> 0 and v_expense_reserve <> 0 THEN
     v_payee_type := 'L';
  END IF;
  
  RETURN v_payee_type;

END get_dflt_payee_type;
/



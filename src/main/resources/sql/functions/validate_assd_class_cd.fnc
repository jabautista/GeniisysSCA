DROP FUNCTION CPI.VALIDATE_ASSD_CLASS_CD;

CREATE OR REPLACE FUNCTION CPI.validate_assd_class_cd
(p_claim_id       IN   GICL_CLAIMS.claim_id%TYPE,
 p_payee_type     IN   GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
 p_item_no        IN   GICL_ITEM_PERIL.item_no%TYPE,
 p_peril_cd       IN   GICL_ITEM_PERIL.peril_cd%TYPE,
 p_payee_class_cd IN   GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
 p_assd_no        IN   GICL_CLAIMS.assd_no%TYPE)
 
RETURN VARCHAR2 AS

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : 02.21.2012
**  Reference By  : GICLS030 - Loss/Expense History
**  Description   : Check if assured is the same as the previous assured payee
**                 if not disallow use of assured payee class code if there is still 
**                 valid loss expense payee record for the previous assured
*/

 v_msg_alert     VARCHAR2(500);

BEGIN
    FOR cancel_sw IN (SELECT '1'
                         FROM GICL_CLM_LOSS_EXP c
                     WHERE c.claim_id = p_claim_id
                       AND c.payee_type = p_payee_type
                       AND c.item_no = p_item_no
                       AND c.peril_cd = p_peril_cd
                       AND c.payee_class_cd = p_payee_class_cd
                       AND c.payee_cd <> p_assd_no                                                                            
                       AND NVL(c.cancel_sw,'N') <> 'Y')
    LOOP         
      v_msg_alert := 'All records for previous assured should be cancelled first before re-using the assured payee class code.';
      RETURN v_msg_alert;
    END LOOP;    

    FOR chk_assd IN (SELECT '1'
                     FROM GICL_LOSS_EXP_PAYEES c
                     WHERE c.claim_id = p_claim_id
                       AND c.payee_type = p_payee_type
                       AND c.item_no = p_item_no
                       AND c.peril_cd = p_peril_cd
                       AND c.payee_class_cd = p_payee_class_cd
                       AND c.payee_cd = p_assd_no)
    LOOP
       v_msg_alert := 'You can only use assured payee class once per item-peril and payee type.';    
       RETURN v_msg_alert;
    END LOOP;
    
    RETURN v_msg_alert;
END;
/



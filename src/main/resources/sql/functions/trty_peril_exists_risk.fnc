DROP FUNCTION CPI.TRTY_PERIL_EXISTS_RISK;

CREATE OR REPLACE FUNCTION CPI.trty_peril_exists_risk (
   v_line_cd     giis_trty_peril.line_cd%TYPE,
   v_peril_cd    giis_trty_peril.peril_cd%TYPE,
   v_loss_date   DATE,
   v_risk_cd     gipi_fireitem.risk_cd%TYPE
)
   RETURN BOOLEAN
IS
   /*
   **  Created by    : Andrew Robes
   **  Date Created  : 04.12.2012
   **  Reference By  : (GICLS024 - Claim Reserve)
   **  Description   : Converted procedure from GICLS024 - trty_peril_exists_risk program unit
   */

BEGIN
   FOR a IN (SELECT d.share_cd, d.line_cd, d.peril_cd
               FROM gipi_polbasic a, gipi_item b, gipi_fireitem b2, giuw_pol_dist c, giuw_itemperilds_dtl d, giis_dist_share e
              WHERE b2.policy_id = b.policy_id
                AND b2.item_no = b.item_no
                AND d.item_no = b.item_no
                AND d.dist_no = c.dist_no
                AND e.line_cd = d.line_cd
                AND e.share_cd = d.share_cd
                AND e.share_type = giacp.v ('TRTY_SHARE_TYPE')
                AND c.dist_flag = giisp.v ('DISTRIBUTED')
                AND c.policy_id = b.policy_id
                AND a.eff_date <= v_loss_date
                AND a.expiry_date >= v_loss_date
                AND b.policy_id = a.policy_id
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND risk_cd = v_risk_cd
                AND NOT EXISTS (SELECT 1
                                  FROM giis_trty_peril tp
                                 WHERE tp.trty_seq_no = d.share_cd AND tp.line_cd = v_line_cd AND tp.peril_cd = v_peril_cd))
   LOOP
      RETURN (FALSE);
   END LOOP;

   RETURN (TRUE);
END;
/



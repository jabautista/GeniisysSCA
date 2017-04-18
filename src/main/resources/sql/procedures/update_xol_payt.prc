DROP PROCEDURE CPI.UPDATE_XOL_PAYT;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_XOL_PAYT
 (p_line_cd   IN  GICL_CLAIMS.line_cd%TYPE) IS

/*
 **  Created by    : Veronica V. Raymundo
 **  Date Created  : 02.27.2012
 **  Reference By  : GICLS030 - Loss/Expense History
 **  Description   : Executes UPDATE_XOL_PAYT Program unit in GICLS030
 **                  
 */

v_xol_share_type      GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('XOL_TRTY_SHARE_TYPE'), 4);

BEGIN
  FOR update_xol_paid IN(
    SELECT SUM(NVL(a.shr_le_adv_amt,0)  * NVL(b.currency_rate,0)) ret_amt, grp_seq_no
      FROM GICL_LOSS_EXP_DS a,  GICL_CLM_LOSS_EXP b
     WHERE a.claim_id = b.claim_id
       AND a.clm_loss_id = b.clm_loss_id
       AND NVL(b.cancel_sw, 'N') = 'N'
       AND NVL(a.negate_tag, 'N') = 'N'
       AND a.share_type = v_xol_share_type
       AND a.line_cd = p_line_cd
  GROUP BY a.grp_seq_no)
  
  LOOP     
    UPDATE GIIS_DIST_SHARE 
       SET xol_allocated_amount = update_xol_paid.ret_amt
     WHERE share_cd = update_xol_paid.grp_seq_no
       AND line_cd = p_line_cd;
  END LOOP;
               
END;
/



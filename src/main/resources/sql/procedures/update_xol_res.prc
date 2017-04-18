DROP PROCEDURE CPI.UPDATE_XOL_RES;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_XOL_RES (v_line_cd giis_dist_share.line_cd%TYPE)IS
  /*
  **  Created by      : Christian Santos
  **  Date Created    : 10.25.2012
  **  Reference By    : (GICLS039 - Batch Claim Closing)      
  */
  v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
BEGIN
  FOR update_xol_res IN(SELECT SUM((NVL(a.shr_loss_res_amt,0)* b.convert_rate) +( NVL( shr_exp_res_amt,0)* b.convert_rate)) ret_amt,
                                                 a.grp_seq_no
                                            FROM gicl_reserve_ds a, gicl_clm_res_hist b, gicl_item_peril c
                                           WHERE NVL(a.negate_tag,'N') = 'N'
                                             AND a.claim_id = b.claim_id
                                             AND a.clm_res_hist_id = b.clm_res_hist_id
                                                AND a.claim_id = c.claim_id
                                                AND a.item_no = c.item_no
                                                AND nvl(a.grouped_item_no,0) = nvl(c.grouped_item_no,0)
                                               AND a.peril_cd = c.peril_cd                      
                                             AND NVL(c.close_flag, 'AP') IN ('AP','CC','CP')
                                             AND a.line_cd = v_line_cd
                                             AND a.share_type = v_xol_share_type
                                                GROUP BY a.grp_seq_no)
  LOOP     
    UPDATE giis_dist_share 
       SET xol_reserve_amount = update_xol_res.ret_amt
     WHERE share_cd = update_xol_res.grp_seq_no
       AND line_cd = v_line_cd;
 
  END LOOP; 
END;
/



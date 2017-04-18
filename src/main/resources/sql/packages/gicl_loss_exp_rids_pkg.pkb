CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_RIDS_PKG AS
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 01.19.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Gets the list of gicl_loss_exp_rids
   */ 
   
    FUNCTION get_gicl_loss_exp_rids(p_claim_id      GICL_LOSS_EXP_RIDS.claim_id%TYPE,
                                    p_clm_loss_id   GICL_LOSS_EXP_RIDS.clm_loss_id%TYPE,
                                    p_clm_dist_no   GICL_LOSS_EXP_RIDS.clm_dist_no%TYPE,
                                    p_grp_seq_no    GICL_LOSS_EXP_RIDS.grp_seq_no%TYPE )
                                    
      RETURN gicl_loss_exp_rids_tab PIPELINED AS
      
      v_girids      gicl_loss_exp_rids_type;
      
      BEGIN
      
        FOR i IN (SELECT a.claim_id,          a.clm_loss_id,       a.clm_dist_no,         
                         a.dist_year,         a.item_no,           a.peril_cd,         
                         a.payee_cd,          a.grp_seq_no,        a.ri_cd,
                         b.ri_sname,          a.line_cd,           a.user_id,              
                         a.last_update,       a.acct_trty_type,    a.shr_loss_exp_ri_pct, 
                         a.shr_le_ri_pd_amt,  a.shr_le_ri_adv_amt, a.shr_le_ri_net_amt,   
                         a.share_type  
                    FROM GICL_LOSS_EXP_RIDS a,
                         GIIS_REINSURER b
                    WHERE a.claim_id = p_claim_id  
                      AND a.clm_loss_id = p_clm_loss_id
                      AND a.clm_dist_no = p_clm_dist_no
                      AND a.grp_seq_no = p_grp_seq_no
                      AND a.ri_cd = b.ri_cd)
        
        LOOP
            v_girids.claim_id               :=  i.claim_id;                     
            v_girids.clm_loss_id            :=  i.clm_loss_id;         
            v_girids.clm_dist_no            :=  i.clm_dist_no;         
            v_girids.dist_year              :=  i.dist_year;         
            v_girids.item_no                :=  i.item_no;         
            v_girids.peril_cd               :=  i.peril_cd;         
            v_girids.payee_cd               :=  i.payee_cd;    
            v_girids.grp_seq_no             :=  i.grp_seq_no;     
            v_girids.ri_cd                  :=  i.ri_cd;     
            v_girids.dsp_ri_name            :=  i.ri_sname;     
            v_girids.line_cd                :=  i.line_cd;     
            v_girids.user_id                :=  i.user_id;     
            v_girids.last_update            :=  i.last_update;    
            v_girids.acct_trty_type         :=  i.acct_trty_type; 
            v_girids.shr_loss_exp_ri_pct    :=  to_char(i.shr_loss_exp_ri_pct,'fm990.00'); --added by robert 11.25.2013 
            v_girids.shr_le_ri_pd_amt       :=  i.shr_le_ri_pd_amt; 
            v_girids.shr_le_ri_adv_amt      :=  i.shr_le_ri_adv_amt; 
            v_girids.shr_le_ri_net_amt      :=  i.shr_le_ri_net_amt; 
            v_girids.share_type             :=  i.share_type;
            
            PIPE ROW(v_girids);
                          
        END LOOP;  
      
      
      END get_gicl_loss_exp_rids;         

END;
/


